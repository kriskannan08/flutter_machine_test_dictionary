import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machine_test_dictionary/app/router/app_router.dart';
import 'package:machine_test_dictionary/app/router/navigation_helper.dart';
import 'package:machine_test_dictionary/modules/dictionary/presentation/providers/dictionary_providers.dart';
import 'package:machine_test_dictionary/modules/dictionary/presentation/widgets/organisms/word_details_sheet.dart';
import 'package:machine_test_dictionary/modules/dictionary/presentation/widgets/templates/home_template.dart';
import 'package:machine_test_dictionary/modules/dictionary/presentation/widgets/templates/words_template.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showWordDetails(String word) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.6,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return WordDetailsSheet(
            word: word,
            scrollController: scrollController,
          );
        },
      ),
    );
  }

  void _handleSearchSubmitted(String value) {
    final word = value.trim();
    if (word.isNotEmpty) {
      ref.read(searchHistoryProvider.notifier).add(word);
      _showWordDetails(word);
    }
  }

  void _handleHistoryWordTap(String word) {
    _searchController.text = word;
    ref.read(searchHistoryProvider.notifier).add(word);
    _showWordDetails(word);
  }

  void _clearSearch() {
    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _HomeTab(
            searchController: _searchController,
            onSearchSubmitted: _handleSearchSubmitted,
            onSearchClear: _clearSearch,
            onHistoryWordTap: _handleHistoryWordTap,
            showWordDetails: _showWordDetails,
          ),
          _WordsTab(showWordDetails: _showWordDetails),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'Words',
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends ConsumerWidget {
  const _HomeTab({
    required this.searchController,
    required this.onSearchSubmitted,
    required this.onSearchClear,
    required this.onHistoryWordTap,
    required this.showWordDetails,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onSearchSubmitted;
  final VoidCallback onSearchClear;
  final ValueChanged<String> onHistoryWordTap;
  final ValueChanged<String> showWordDetails;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchHistory = ref.watch(searchHistoryProvider);
    final wordOfTheDay = _DailyWord.today();

    return HomeTemplate(
      searchController: searchController,
      wordOfTheDay: wordOfTheDay.word,
      wordPreview: wordOfTheDay.preview,
      onSearchSubmitted: onSearchSubmitted,
      onSearchChanged: (_) {},
      onSearchClear: onSearchClear,
      onWordOfDayTap: () {
        ref.read(searchHistoryProvider.notifier).add(wordOfTheDay.word);
        showWordDetails(wordOfTheDay.word);
      },
      searchHistory: searchHistory,
      onHistoryWordTap: onHistoryWordTap,
      onViewAll: () => context.pushTo(AppRoute.history),
    );
  }
}

class _WordsTab extends ConsumerWidget {
  const _WordsTab({required this.showWordDetails});

  final ValueChanged<String> showWordDetails;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordsListState = ref.watch(wordsListProvider);

    return WordsTemplate(
      words: wordsListState.words,
      isLoading: wordsListState.isLoading,
      hasMore: wordsListState.hasMore,
      onLoadMore: () => ref.read(wordsListProvider.notifier).loadMore(),
      onWordTap: (word) {
        ref.read(searchHistoryProvider.notifier).add(word);
        showWordDetails(word);
      },
    );
  }
}

class _DailyWord {
  const _DailyWord({required this.word, required this.preview});

  final String word;
  final String preview;

  static _DailyWord today() {
    final now = DateTime.now();
    final daySeed = DateTime(
      now.year,
      now.month,
      now.day,
    ).difference(DateTime(2024)).inDays;

    return _words[daySeed % _words.length];
  }

  static const List<_DailyWord> _words = [
    _DailyWord(
      word: 'Serendipity',
      preview: 'The chance discovery of something pleasant or valuable.',
    ),
    _DailyWord(
      word: 'Eloquent',
      preview: 'Fluent, expressive, and persuasive in speech or writing.',
    ),
    _DailyWord(
      word: 'Resilient',
      preview: 'Able to recover quickly from difficulty or change.',
    ),
    _DailyWord(word: 'Ephemeral', preview: 'Lasting for only a short time.'),
    _DailyWord(
      word: 'Luminous',
      preview: 'Full of light, clarity, or brightness.',
    ),
    _DailyWord(
      word: 'Mellifluous',
      preview: 'Smooth, sweet, and pleasant to hear.',
    ),
    _DailyWord(
      word: 'Pragmatic',
      preview: 'Focused on practical results and sensible action.',
    ),
    _DailyWord(
      word: 'Quintessential',
      preview: 'Representing the most perfect or typical example.',
    ),
    _DailyWord(
      word: 'Tenacious',
      preview: 'Persistent and determined, even when things are difficult.',
    ),
    _DailyWord(
      word: 'Ubiquitous',
      preview: 'Present, appearing, or found everywhere.',
    ),
    _DailyWord(
      word: 'Vivid',
      preview: 'Producing strong, clear images or impressions.',
    ),
    _DailyWord(
      word: 'Zealous',
      preview: 'Filled with energetic enthusiasm for a cause or goal.',
    ),
  ];
}
