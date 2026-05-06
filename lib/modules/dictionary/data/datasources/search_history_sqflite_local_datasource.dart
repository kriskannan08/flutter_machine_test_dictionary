import 'package:path/path.dart' as path;
import 'package:machine_test_dictionary/modules/dictionary/data/datasources/search_history_local_datasource.dart';
import 'package:machine_test_dictionary/modules/dictionary/data/models/word_details_model.dart';
import 'package:sqflite/sqflite.dart';

SearchHistoryLocalDataSource createPlatformSearchHistoryLocalDataSource() {
  return SearchHistorySqfliteLocalDataSource();
}

class SearchHistorySqfliteLocalDataSource
    implements SearchHistoryLocalDataSource {
  SearchHistorySqfliteLocalDataSource() : _database = _openDatabase();

  static const _databaseName = 'dictionary.db';
  static const _databaseVersion = 2;
  static const _tableName = 'search_history';
  static const _wordColumn = 'word';
  static const _phoneticColumn = 'phonetic';
  static const _definitionColumn = 'definition';
  static const _exampleColumn = 'example';
  static const _synonymsColumn = 'synonyms';
  static const _searchedAtColumn = 'searched_at';

  final Future<Database> _database;

  @override
  Future<List<String>> getSearchHistory() async {
    final database = await _database;
    final rows = await database.query(
      _tableName,
      columns: [_wordColumn],
      orderBy: '$_searchedAtColumn DESC',
    );

    return rows
        .map((row) => row[_wordColumn]?.toString() ?? '')
        .where((word) => word.isNotEmpty)
        .toList();
  }

  @override
  Future<void> saveSearchHistory(List<String> words) async {
    final database = await _database;
    final now = DateTime.now().millisecondsSinceEpoch;

    await database.transaction((transaction) async {
      for (var index = 0; index < words.length; index++) {
        final word = words[index].trim().toLowerCase();
        if (word.isEmpty) {
          continue;
        }

        final rowsUpdated = await transaction.update(
          _tableName,
          {_searchedAtColumn: now - index},
          where: '$_wordColumn = ?',
          whereArgs: [word],
        );

        if (rowsUpdated == 0) {
          await transaction.insert(_tableName, {
            _wordColumn: word,
            _searchedAtColumn: now - index,
          });
        }
      }
    });
  }

  @override
  Future<WordDetailsModel?> getWordDetails(String word) async {
    final database = await _database;
    final normalizedWord = word.trim().toLowerCase();
    final rows = await database.query(
      _tableName,
      where: '$_wordColumn = ? AND $_definitionColumn IS NOT NULL',
      whereArgs: [normalizedWord],
      limit: 1,
    );

    if (rows.isEmpty) {
      return null;
    }

    return WordDetailsModel.fromDatabase(rows.first);
  }

  @override
  Future<void> saveWordDetails(String word, WordDetailsModel details) async {
    final database = await _database;
    final normalizedWord = word.trim().toLowerCase();
    if (normalizedWord.isEmpty) {
      return;
    }

    final values = {
      ...details.toDatabaseMap(),
      _wordColumn: normalizedWord,
      _searchedAtColumn: DateTime.now().millisecondsSinceEpoch,
    };

    await database.insert(
      _tableName,
      values,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<Database> _openDatabase() async {
    final databasesPath = await getDatabasesPath();
    final databasePath = path.join(databasesPath, _databaseName);

    return openDatabase(
      databasePath,
      version: _databaseVersion,
      onCreate: (database, version) {
        return _createSearchHistoryTable(database);
      },
      onUpgrade: (database, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await database.execute(
            'ALTER TABLE $_tableName ADD COLUMN $_phoneticColumn TEXT',
          );
          await database.execute(
            'ALTER TABLE $_tableName ADD COLUMN $_definitionColumn TEXT',
          );
          await database.execute(
            'ALTER TABLE $_tableName ADD COLUMN $_exampleColumn TEXT',
          );
          await database.execute(
            'ALTER TABLE $_tableName ADD COLUMN $_synonymsColumn TEXT',
          );
        }
      },
    );
  }

  static Future<void> _createSearchHistoryTable(Database database) {
    return database.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            $_wordColumn TEXT UNIQUE NOT NULL,
            $_phoneticColumn TEXT,
            $_definitionColumn TEXT,
            $_exampleColumn TEXT,
            $_synonymsColumn TEXT,
            $_searchedAtColumn INTEGER NOT NULL
          )
        ''');
  }
}
