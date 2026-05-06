import 'package:flutter/material.dart';
import 'package:machine_test_dictionary/modules/dictionary/presentation/widgets/atoms/history_word_chip.dart';
import 'package:machine_test_dictionary/modules/dictionary/presentation/widgets/atoms/section_title.dart';

class SearchHistoryList extends StatelessWidget {
  const SearchHistoryList({
    super.key,
    required this.words,
    required this.onWordTap,
    required this.onViewAll,
  });

  final List<String> words;
  final ValueChanged<String> onWordTap;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    if (words.isEmpty) {
      return const SizedBox.shrink();
    }

    // Only show up to 10 words in the horizontal list
    final displayWords = words.take(10).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SectionTitle(title: 'History'),
            if (words.isNotEmpty)
              TextButton(
                onPressed: onViewAll,
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: Color(0xFF4F46E5),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: displayWords.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final word = displayWords[index];

              return HistoryWordChip(word: word, onTap: () => onWordTap(word));
            },
          ),
        ),
      ],
    );
  }
}
