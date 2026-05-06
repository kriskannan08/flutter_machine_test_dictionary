import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:universal_io/io.dart';

class DatabaseHelper {
  static const String _databaseName = 'offline_dictionary.db';
  static const String _wordListUrl = 'https://raw.githubusercontent.com/first20hours/google-10000-english/master/google-10000-english.txt';

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
    
    // Ensure table and index exist
    await db.execute('CREATE TABLE IF NOT EXISTS dictionary (word TEXT PRIMARY KEY, definition TEXT, example TEXT, pronunciation TEXT)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_word ON dictionary(word)');

    // Check if we need to seed
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM dictionary'));
    if (count != null && count < 1000) {
      // Start seeding in background to not block app launch
      _seedDatabaseInBackground(db);
    } else {
      await db.close();
    }
  }

  static Future<void> _seedDatabaseInBackground(Database db) async {
    try {
      print('Fetching large word list for seeding...');
      final dio = Dio();
      final response = await dio.get(_wordListUrl);
      
      if (response.statusCode == 200) {
        final words = (response.data as String)
            .split('\n')
            .map((w) => w.trim().toLowerCase())
            .where((w) {
              // Filter out invalid words:
              // - Too short (less than 3 chars, unless it's a common short word)
              // - Contains non-alphabetical characters
              final commonShortWords = {
                'a', 'i', 'an', 'to', 'at', 'by', 'do', 'go', 'if', 'in', 'is', 'it', 
                'me', 'my', 'no', 'of', 'on', 'or', 'so', 'up', 'us', 'we', 'am', 'as', 'be', 'he'
              };
              if (w.length < 3 && !commonShortWords.contains(w)) return false;
              if (RegExp(r'[^a-z]').hasMatch(w)) return false;
              
              // Remove nonsense like "aaa", "bbb", "abc"
              if (w == 'aaa' || w == 'bbb' || w == 'ccc' || w == 'abc') return false;
              
              return true;
            })
            .toList();

        print('Seeding ${words.length} words...');
        
        await db.transaction((txn) async {
          // Cleanup existing invalid words first
          await txn.rawDelete(
            "DELETE FROM dictionary WHERE length(word) < 3 AND word NOT IN ('a', 'i', 'an', 'to', 'at', 'by', 'do', 'go', 'if', 'in', 'is', 'it', 'me', 'my', 'no', 'of', 'on', 'or', 'so', 'up', 'us', 'we', 'am', 'as', 'be', 'he')"
          );
          await txn.rawDelete("DELETE FROM dictionary WHERE word IN ('aaa', 'bbb', 'ccc', 'abc')");
          await txn.rawDelete("DELETE FROM dictionary WHERE word GLOB '*[^a-z]*'");

          final batch = txn.batch();
          for (final word in words) {
            batch.insert(
              'dictionary',
              {'word': word},
              conflictAlgorithm: ConflictAlgorithm.ignore,
            );
          }
          await batch.commit(noResult: true);
        });
        print('Database seeding completed.');
      }
    } catch (e) {
      print('Error seeding database: $e');
    } finally {
      await db.close();
    }
  }

  static Future<Database> openDictionaryDatabase() async {
    if (kIsWeb) {
      return await openDatabase(_databaseName);
    }
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);
    return await openDatabase(path, readOnly: false);
  }
}
