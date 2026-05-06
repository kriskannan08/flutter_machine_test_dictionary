import 'package:flutter_test/flutter_test.dart';
import 'package:machine_test_dictionary/modules/dictionary/data/datasources/dictionary_remote_datasource.dart';
import 'package:machine_test_dictionary/modules/dictionary/data/datasources/search_history_local_datasource.dart';
import 'package:machine_test_dictionary/modules/dictionary/data/datasources/dictionary_local_datasource.dart';
import 'package:machine_test_dictionary/modules/dictionary/data/models/word_details_model.dart';
import 'package:machine_test_dictionary/modules/dictionary/data/repositories/dictionary_repository_impl.dart';

void main() {
  group('DictionaryRepositoryImpl', () {
    test(
      'returns cached word details without calling the remote datasource',
      () async {
        final localDataSource = _FakeSearchHistoryLocalDataSource(
          cachedDetails: const WordDetailsModel(
            word: 'serendipity',
            phonetic: '/ser-en-dip-i-tee/',
            definition: 'A happy accident.',
            example: '',
            synonyms: ['chance'],
          ),
        );
        final remoteDataSource = _FakeDictionaryRemoteDataSource();
        final offlineDataSource = _FakeDictionaryLocalDataSource();
        final repository = DictionaryRepositoryImpl(
          remoteDataSource,
          localDataSource,
          offlineDataSource,
        );

        final details = await repository.getWordDetails('Serendipity');

        expect(details.definition, 'A happy accident.');
        expect(remoteDataSource.callCount, 0);
      },
    );

    test(
      'saves fetched details using the searched history word as cache key',
      () async {
        final localDataSource = _FakeSearchHistoryLocalDataSource();
        final remoteDataSource = _FakeDictionaryRemoteDataSource(
          details: const WordDetailsModel(
            word: 'Canonical Word',
            phonetic: '',
            definition: 'Fetched from the API.',
            example: '',
            synonyms: [],
          ),
        );
        final offlineDataSource = _FakeDictionaryLocalDataSource();
        final repository = DictionaryRepositoryImpl(
          remoteDataSource,
          localDataSource,
          offlineDataSource,
        );

        await repository.getWordDetails('History Word');

        expect(localDataSource.savedWord, 'History Word');
        expect(remoteDataSource.callCount, 1);
      },
    );
  });
}

class _FakeDictionaryRemoteDataSource implements DictionaryRemoteDataSource {
  _FakeDictionaryRemoteDataSource({this.details});

  final WordDetailsModel? details;
  int callCount = 0;

  @override
  Future<WordDetailsModel> getWordDetails(String word) async {
    callCount++;
    return details ??
        const WordDetailsModel(
          word: 'remote',
          phonetic: '',
          definition: 'Remote definition.',
          example: '',
          synonyms: [],
        );
  }
}

class _FakeSearchHistoryLocalDataSource
    implements SearchHistoryLocalDataSource {
  _FakeSearchHistoryLocalDataSource({this.cachedDetails});

  final WordDetailsModel? cachedDetails;
  String? savedWord;

  @override
  Future<List<String>> getSearchHistory() async {
    return const [];
  }

  @override
  Future<void> saveSearchHistory(List<String> words) async {}

  @override
  Future<WordDetailsModel?> getWordDetails(String word) async {
    return cachedDetails;
  }

  @override
  Future<void> saveWordDetails(String word, WordDetailsModel details) async {
    savedWord = word;
  }
}

class _FakeDictionaryLocalDataSource implements DictionaryLocalDataSource {
  @override
  Future<List<String>> getAllWords({int limit = 50, int offset = 0}) async {
    return const [];
  }

  @override
  Future<WordDetailsModel?> getWordDetails(String word) async {
    return null;
  }

  @override
  Future<void> saveWordDetails(String word, WordDetailsModel details) async {}
}
