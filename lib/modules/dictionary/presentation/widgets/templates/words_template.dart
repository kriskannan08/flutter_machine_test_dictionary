import 'package:flutter/material.dart';
import 'package:machine_test_dictionary/app/theme/app_theme.dart';
import 'package:machine_test_dictionary/modules/dictionary/presentation/widgets/atoms/section_title.dart';
import 'package:machine_test_dictionary/modules/dictionary/presentation/widgets/organisms/word_list.dart';

class WordsTemplate extends StatelessWidget {
  const WordsTemplate({
    super.key,
    required this.words,
    required this.onWordTap,
    required this.onLoadMore,
    required this.hasMore,
    required this.isLoading,
  });

  final List<String> words;
  final ValueChanged<String> onWordTap;
  final VoidCallback onLoadMore;
  final bool hasMore;
  final bool isLoading;

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
              'DICTIONARY',
              style: appTheme.headingStyle.copyWith(
                fontSize: 30,
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Explore the complete vocabulary',
              style: appTheme.bodyStyle,
            ),
            const SizedBox(height: 32),
            const SectionTitle(title: 'All Words'),
            const SizedBox(height: 12),
            Expanded(
              child: WordList(
                words: words,
                onWordTap: onWordTap,
                onLoadMore: onLoadMore,
                hasMore: hasMore,
                isLoading: isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
