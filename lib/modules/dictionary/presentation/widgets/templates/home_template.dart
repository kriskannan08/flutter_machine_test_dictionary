import 'package:flutter/material.dart';
import 'package:machine_test_dictionary/modules/dictionary/presentation/widgets/atoms/section_title.dart';
import 'package:machine_test_dictionary/modules/dictionary/presentation/widgets/molecules/dictionary_search_field.dart';
import 'package:machine_test_dictionary/modules/dictionary/presentation/widgets/organisms/search_history_list.dart';
import 'package:machine_test_dictionary/modules/dictionary/presentation/widgets/organisms/word_of_day_card.dart';

class HomeTemplate extends StatelessWidget {
  const HomeTemplate({
    super.key,
    required this.searchController,
    required this.wordOfTheDay,
    required this.wordPreview,
    required this.onSearchSubmitted,
    required this.onSearchChanged,
    required this.onSearchClear,
    required this.onWordOfDayTap,
    required this.searchHistory,
    required this.onHistoryWordTap,
    required this.onViewAll,
  });

  final TextEditingController searchController;
  final String wordOfTheDay;
  final String wordPreview;
  final ValueChanged<String> onSearchSubmitted;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchClear;
  final VoidCallback onWordOfDayTap;
  final List<String> searchHistory;
  final ValueChanged<String> onHistoryWordTap;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            const Text(
              'WORDWISE',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4F46E5),
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Discover meanings instantly',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            DictionarySearchField(
              controller: searchController,
              onSubmitted: onSearchSubmitted,
              onChanged: onSearchChanged,
              onClear: onSearchClear,
            ),
            const SizedBox(height: 36),
            const SectionTitle(title: 'Word of the Day'),
            const SizedBox(height: 18),
            WordOfDayCard(
              word: wordOfTheDay,
              preview: wordPreview,
              onTap: onWordOfDayTap,
            ),
            const SizedBox(height: 32),
            SearchHistoryList(
              words: searchHistory,
              onWordTap: onHistoryWordTap,
              onViewAll: onViewAll,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
