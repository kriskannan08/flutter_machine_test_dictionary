import 'dart:convert';

import 'package:machine_test_dictionary/modules/dictionary/data/datasources/search_history_local_datasource.dart';
import 'package:machine_test_dictionary/modules/dictionary/data/models/word_details_model.dart';
import 'package:web/web.dart' as web;

SearchHistoryLocalDataSource createPlatformSearchHistoryLocalDataSource() {
  return SearchHistoryWebLocalDataSource();
}

class SearchHistoryWebLocalDataSource implements SearchHistoryLocalDataSource {
  static const _historyKey = 'dictionary.search_history';
  static const _detailsPrefix = 'dictionary.word_details.';

  web.Storage get _storage => web.window.localStorage;

  @override
  Future<List<String>> getSearchHistory() async {
    final encodedHistory = _storage.getItem(_historyKey);
    if (encodedHistory == null) {
      return const [];
    }

    final decodedHistory = jsonDecode(encodedHistory);
    if (decodedHistory is! List) {
      return const [];
    }

    return decodedHistory
        .map((word) => word.toString())
        .where((word) => word.isNotEmpty)
        .toList();
  }

  @override
  Future<void> saveSearchHistory(List<String> words) async {
    final normalizedWords = words
        .map((word) => word.trim().toLowerCase())
        .where((word) => word.isNotEmpty)
        .toSet()
        .toList();

    _storage.setItem(_historyKey, jsonEncode(normalizedWords));
  }

  @override
  Future<WordDetailsModel?> getWordDetails(String word) async {
    final encodedDetails = _storage.getItem(_detailsKey(word));
    if (encodedDetails == null) {
      return null;
    }

    final decodedDetails = jsonDecode(encodedDetails);
    if (decodedDetails is! Map<String, dynamic>) {
      return null;
    }

    return WordDetailsModel.fromDatabase(decodedDetails);
  }

  @override
  Future<void> saveWordDetails(String word, WordDetailsModel details) async {
    final normalizedWord = word.trim().toLowerCase();
    if (normalizedWord.isEmpty) {
      return;
    }

    final values = {...details.toDatabaseMap(), 'word': normalizedWord};

    _storage.setItem(_detailsKey(normalizedWord), jsonEncode(values));
  }

  String _detailsKey(String word) {
    return '$_detailsPrefix${word.trim().toLowerCase()}';
  }
}
