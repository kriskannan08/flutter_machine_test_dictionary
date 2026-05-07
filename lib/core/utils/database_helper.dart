import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:machine_test_dictionary/core/constants/app_constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DatabaseHelper {
  static Future<void> ensureDatabaseExists() async {
    if (kIsWeb) {
      databaseFactory = createDatabaseFactoryFfiWeb(
        options: SqfliteFfiWebOptions(
          sqlite3WasmUri: Uri.parse('sqlite3.wasm'),
          sharedWorkerUri: Uri.parse('sqflite_sw.js'),
        ),
      );
    }

    final db = await openDictionaryDatabase();

    // Ensure table and index exist with all required columns
    await db.execute('''
      CREATE TABLE IF NOT EXISTS dictionary (
        word TEXT PRIMARY KEY, 
        definition TEXT, 
        example TEXT, 
        phonetic TEXT,
        synonyms TEXT
      )
    ''');

    // Check if we need to seed
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM dictionary'),
    );
    if (count != null && count < 1000) {
      // Start seeding in background to not block app launch
      unawaited(_seedDatabaseInBackground(db));
    } else {
      await db.close();
    }
  }

  static final RegExp _nonAlphabeticPattern = RegExp(r'[^a-z]');

  static Future<void> _seedDatabaseInBackground(Database db) async {
    try {
      debugPrint('Fetching large word list for seeding...');
      final dio = Dio();
      final response = await dio.get(AppConstants.wordListUrl);

      if (response.statusCode == 200) {
        final words = (response.data as String)
            .split('\n')
            .map((w) => w.trim().toLowerCase())
            .where((w) {
              if (w.length < 3 && !AppConstants.commonShortWords.contains(w)) {
                return false;
              }
              if (_nonAlphabeticPattern.hasMatch(w)) return false;
              if (AppConstants.nonsenseWords.contains(w)) return false;
              return true;
            })
            .toList();

        debugPrint('Seeding ${words.length} words...');

        await db.transaction((txn) async {
          final batch = txn.batch();

          // 1. First, seed with enriched data from local JSON
          try {
            final String seedJson = await rootBundle.loadString(
              AppConstants.seedJsonPath,
            );
            final List<dynamic> seedData = jsonDecode(seedJson);
            for (final item in seedData) {
              batch.insert('dictionary', {
                'word': item['word'].toString().toLowerCase(),
                'definition': item['definition'],
                'example': item['example'],
                'phonetic': item['phonetic'],
                'synonyms': jsonEncode(item['synonyms'] ?? []),
              }, conflictAlgorithm: ConflictAlgorithm.replace);
            }
          } catch (e) {
            debugPrint('Local seeding skipped or failed: $e');
          }

          // 2. Then, populate the remaining words from the 10k list
          // Cleanup existing invalid words first
          await txn.rawDelete(
            "DELETE FROM dictionary WHERE length(word) < 3 AND word NOT IN (${AppConstants.commonShortWords.map((e) => "'$e'").join(',')})",
          );
          await txn.rawDelete(
            "DELETE FROM dictionary WHERE word IN (${AppConstants.nonsenseWords.map((e) => "'$e'").join(',')})",
          );
          await txn.rawDelete(
            "DELETE FROM dictionary WHERE word GLOB '*[^a-z]*'",
          );

          for (final word in words) {
            batch.insert('dictionary', {
              'word': word,
            }, conflictAlgorithm: ConflictAlgorithm.ignore);
          }
          await batch.commit(noResult: true);
        });
        debugPrint('Database seeding completed.');
      }
    } catch (e) {
      debugPrint('Error seeding database: $e');
    } finally {
      await db.close();
    }
  }

  static Future<Database> openDictionaryDatabase() async {
    if (kIsWeb) {
      return await openDatabase(AppConstants.databaseName);
    }
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, AppConstants.databaseName);
    return await openDatabase(path, readOnly: false);
  }
}
