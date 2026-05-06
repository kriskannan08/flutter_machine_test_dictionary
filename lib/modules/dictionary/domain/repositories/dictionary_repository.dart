import 'package:machine_test_dictionary/modules/dictionary/domain/entities/word_details.dart';

abstract class DictionaryRepository {
  Future<WordDetails> getWordDetails(String word);
  Future<List<String>> getWords({int limit = 50, int offset = 0});
}
