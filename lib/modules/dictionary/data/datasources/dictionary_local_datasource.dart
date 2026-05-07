import 'package:machine_test_dictionary/core/utils/database_helper.dart';
import 'package:machine_test_dictionary/modules/dictionary/data/models/word_details_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class DictionaryLocalDataSource {
  Future<WordDetailsModel?> getWordDetails(String word);
  Future<List<String>> getAllWords({int limit = 50, int offset = 0});
  Future<void> saveWordDetails(String word, WordDetailsModel details);
}

class DictionaryLocalDataSourceImpl implements DictionaryLocalDataSource {
  Database? _database;
  final Map<String, WordDetailsModel> _cache = {};

  Future<Database> get _db async {
    if (_database != null) return _database!;
    _database = await DatabaseHelper.openDictionaryDatabase();
    return _database!;
  }

  @override
  Future<WordDetailsModel?> getWordDetails(String word) async {
    final normalizedWord = word.trim().toLowerCase();

    // Check cache first
    if (_cache.containsKey(normalizedWord)) {
      return _cache[normalizedWord];
    }

    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(
      'dictionary',
      where: 'word = ?',
      whereArgs: [normalizedWord],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      final model = WordDetailsModel.fromDatabase(maps.first);
      _cache[normalizedWord] = model;
      return model;
    }
    return null;
  }

  @override
  Future<List<String>> getAllWords({int limit = 50, int offset = 0}) async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(
      'dictionary',
      columns: ['word'],
      orderBy: 'word ASC',
      limit: limit,
      offset: offset,
    );

    return maps.map((map) => map['word'] as String).toList();
  }

  @override
  Future<void> saveWordDetails(String word, WordDetailsModel details) async {
    final normalizedWord = word.trim().toLowerCase();
    _cache[normalizedWord] = details;

    final db = await _db;
    await db.insert(
      'dictionary',
      details.toDatabaseMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
