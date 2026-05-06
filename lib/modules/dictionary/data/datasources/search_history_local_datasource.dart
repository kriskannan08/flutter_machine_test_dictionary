import 'package:machine_test_dictionary/modules/dictionary/data/models/word_details_model.dart';

abstract class SearchHistoryLocalDataSource {
  Future<List<String>> getSearchHistory();

  Future<void> saveSearchHistory(List<String> words);

  Future<WordDetailsModel?> getWordDetails(String word);

  Future<void> saveWordDetails(String word, WordDetailsModel details);
}
