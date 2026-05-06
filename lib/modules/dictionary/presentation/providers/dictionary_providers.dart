import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:machine_test_dictionary/core/network/dio_provider.dart';
import 'package:machine_test_dictionary/modules/dictionary/data/datasources/dictionary_local_datasource.dart';
import 'package:machine_test_dictionary/modules/dictionary/data/datasources/dictionary_remote_datasource.dart';
import 'package:machine_test_dictionary/modules/dictionary/data/datasources/search_history_local_datasource.dart';
import 'package:machine_test_dictionary/modules/dictionary/data/datasources/search_history_local_datasource_factory.dart';
import 'package:machine_test_dictionary/modules/dictionary/data/repositories/dictionary_repository_impl.dart';
import 'package:machine_test_dictionary/modules/dictionary/domain/entities/word_details.dart';
import 'package:machine_test_dictionary/modules/dictionary/domain/repositories/dictionary_repository.dart';
import 'package:machine_test_dictionary/modules/dictionary/domain/usecases/get_word_details.dart';

final dictionaryRemoteDataSourceProvider = Provider<DictionaryRemoteDataSource>(
  (ref) {
    return DictionaryRemoteDataSourceImpl(ref.watch(dioClientProvider));
  },
);

final dictionaryLocalDataSourceProvider = Provider<DictionaryLocalDataSource>(
  (ref) {
    return DictionaryLocalDataSourceImpl();
  },
);

final dictionaryRepositoryProvider = Provider<DictionaryRepository>((ref) {
  return DictionaryRepositoryImpl(
    ref.watch(dictionaryRemoteDataSourceProvider),
    ref.watch(searchHistoryLocalDataSourceProvider),
    ref.watch(dictionaryLocalDataSourceProvider),
  );
});

final getWordDetailsProvider = Provider<GetWordDetails>((ref) {
  return GetWordDetails(ref.watch(dictionaryRepositoryProvider));
});

final wordDetailsProvider = FutureProvider.family<WordDetails, String>((
  ref,
  word,
) {
  return ref.watch(getWordDetailsProvider)(word);
});

class WordsListState {
  const WordsListState({
    this.words = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.offset = 0,
  });

  final List<String> words;
  final bool isLoading;
  final bool hasMore;
  final int offset;

  WordsListState copyWith({
    List<String>? words,
    bool? isLoading,
    bool? hasMore,
    int? offset,
  }) {
    return WordsListState(
      words: words ?? this.words,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      offset: offset ?? this.offset,
    );
  }
}

class WordsListController extends StateNotifier<WordsListState> {
  WordsListController(this._repository) : super(const WordsListState()) {
    loadMore();
  }

  final DictionaryRepository _repository;
  static const int _pageSize = 120;

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    try {
      final newWords = await _repository.getWords(
        limit: _pageSize,
        offset: state.offset,
      );

      state = state.copyWith(
        words: [...state.words, ...newWords],
        isLoading: false,
        hasMore: newWords.length == _pageSize,
        offset: state.offset + newWords.length,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void addWord(String word) {
    final normalized = word.trim().toLowerCase();
    if (state.words.contains(normalized)) return;

    final newWords = [...state.words, normalized]..sort();
    state = state.copyWith(words: newWords);
  }

  void refresh() {
    state = const WordsListState();
    loadMore();
  }
}

final StateNotifierProvider<WordsListController, WordsListState> wordsListProvider =
    StateNotifierProvider<WordsListController, WordsListState>((ref) {
      final repository = ref.watch(dictionaryRepositoryProvider);
      final controller = WordsListController(repository);

      // Listen to search history and add new words to the list dynamically
      // to avoid rebuilding the provider and resetting the scroll position.
      ref.listen(searchHistoryProvider, (previous, next) {
        if (next.isNotEmpty && (previous == null || next.length > previous.length)) {
          controller.addWord(next.first);
        }
      });

      return controller;
    });

final searchHistoryLocalDataSourceProvider =
    Provider<SearchHistoryLocalDataSource>(
      (ref) => createSearchHistoryLocalDataSource(),
    );

class SearchHistoryController extends StateNotifier<List<String>> {
  SearchHistoryController(this._localDataSource) : super(const []) {
    _loadFuture = _load();
  }

  final SearchHistoryLocalDataSource _localDataSource;
  late final Future<void> _loadFuture;

  void add(String word) {
    unawaited(_add(word));
  }

  Future<void> _load() async {
    state = await _localDataSource.getSearchHistory();
  }

  Future<void> _add(String word) async {
    await _loadFuture;

    final formattedWord = word.trim().toLowerCase();
    if (formattedWord.isEmpty) {
      return;
    }

    state = [
      formattedWord,
      ...state.where((historyWord) => historyWord != formattedWord),
    ];

    await _localDataSource.saveSearchHistory(state);
  }
}

final searchHistoryProvider =
    StateNotifierProvider<SearchHistoryController, List<String>>((ref) {
      return SearchHistoryController(
        ref.watch(searchHistoryLocalDataSourceProvider),
      );
    });
