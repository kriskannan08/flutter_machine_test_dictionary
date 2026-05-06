import 'package:machine_test_dictionary/modules/dictionary/data/datasources/dictionary_local_datasource.dart';
import 'package:machine_test_dictionary/modules/dictionary/data/datasources/dictionary_remote_datasource.dart';
import 'package:machine_test_dictionary/modules/dictionary/data/datasources/search_history_local_datasource.dart';
import 'package:machine_test_dictionary/modules/dictionary/domain/entities/word_details.dart';
import 'package:machine_test_dictionary/modules/dictionary/domain/repositories/dictionary_repository.dart';

class DictionaryRepositoryImpl implements DictionaryRepository {
  const DictionaryRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._offlineDataSource,
  );

  final DictionaryRemoteDataSource _remoteDataSource;
  final SearchHistoryLocalDataSource _localDataSource;
  final DictionaryLocalDataSource _offlineDataSource;

  @override
  Future<WordDetails> getWordDetails(String word) async {
    // 1. Check search history cache (already searched/cached)
    final savedDetails = await _localDataSource.getWordDetails(word);
    if (savedDetails != null && savedDetails.definition.isNotEmpty) {
      return savedDetails;
    }

    // 2. Check pre-populated offline dictionary database
    final offlineDetails = await _offlineDataSource.getWordDetails(word);
    if (offlineDetails != null && offlineDetails.definition.isNotEmpty) {
      // Save to cache for history
      await _localDataSource.saveWordDetails(word, offlineDetails);
      return offlineDetails;
    }

    // 3. Fetch from remote API if not found locally
    final remoteDetails = await _remoteDataSource.getWordDetails(word);
    await _localDataSource.saveWordDetails(word, remoteDetails);
    await _offlineDataSource.saveWordDetails(word, remoteDetails);

    return remoteDetails;
  }

  @override
  Future<List<String>> getWords({int limit = 50, int offset = 0}) async {
    return _offlineDataSource.getAllWords(
      limit: limit,
      offset: offset,
    );
  }
}
