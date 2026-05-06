import 'package:flutter/material.dart';
import 'package:machine_test_dictionary/app/theme/app_theme.dart';
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
    final appTheme = context.appTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              'WORDWISE',
              style: appTheme.headingStyle.copyWith(
                fontSize: 30,
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Discover meanings instantly',
              style: appTheme.bodyStyle,
            ),
            const SizedBox(height: 32),
            DictionarySearchField(
              controller: searchController,
              onSubmitted: onSearchSubmitted,
              onChanged: onSearchChanged,
              onClear: onSearchClear,
            ),
            const SizedBox(height: 36),
            SectionTitle(title: 'Word of the Day'),
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
