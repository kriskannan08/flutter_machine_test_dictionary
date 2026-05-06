import 'package:machine_test_dictionary/modules/dictionary/domain/entities/word_details.dart';
import 'package:machine_test_dictionary/modules/dictionary/domain/repositories/dictionary_repository.dart';

class GetWordDetails {
  const GetWordDetails(this._repository);

  final DictionaryRepository _repository;

  Future<WordDetails> call(String word) {
    return _repository.getWordDetails(word);
  }
}
