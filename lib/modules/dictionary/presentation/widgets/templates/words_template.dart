import 'package:flutter/material.dart';
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            const Text(
              'DICTIONARY',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4F46E5),
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Explore the complete vocabulary',
              style: TextStyle(fontSize: 16, color: Colors.grey),
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
