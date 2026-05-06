import 'package:flutter/material.dart';
import 'package:machine_test_dictionary/app/theme/app_theme.dart';

class WordOfDayCard extends StatelessWidget {
  const WordOfDayCard({
    super.key,
    required this.word,
    required this.preview,
    required this.onTap,
  });

  final String word;
  final String preview;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: appTheme.primaryGradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: appTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              word,
              style: appTheme.headingStyle.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              preview,
              style: appTheme.bodyStyle.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'View Meaning',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(Icons.arrow_forward_rounded, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
