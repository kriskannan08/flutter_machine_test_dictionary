import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:machine_test_dictionary/main.dart';
import 'package:machine_test_dictionary/modules/dictionary/data/datasources/search_history_local_datasource.dart';
import 'package:machine_test_dictionary/modules/dictionary/data/models/word_details_model.dart';
import 'package:machine_test_dictionary/modules/dictionary/presentation/providers/dictionary_providers.dart';

void main() {
  testWidgets('Dictionary app shows splash screen', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          searchHistoryLocalDataSourceProvider.overrideWithValue(
            _FakeSearchHistoryLocalDataSource(),
          ),
        ],
        child: const MyApp(),
      ),
    );

    expect(find.text('WORDWISE'), findsOneWidget);
    expect(find.text('Preparing...'), findsOneWidget);

    await tester.pump(const Duration(seconds: 6));
  });
}

class _FakeSearchHistoryLocalDataSource
    implements SearchHistoryLocalDataSource {
  const _FakeSearchHistoryLocalDataSource();

  @override
  Future<List<String>> getSearchHistory() async {
    return const [];
  }

  @override
  Future<void> saveSearchHistory(List<String> words) async {}

  @override
  Future<WordDetailsModel?> getWordDetails(String word) async {
    return null;
  }

  @override
  Future<void> saveWordDetails(String word, WordDetailsModel details) async {}
}
