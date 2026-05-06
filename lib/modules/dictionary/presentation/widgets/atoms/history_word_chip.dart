import 'package:flutter/material.dart';

class HistoryWordChip extends StatelessWidget {
  const HistoryWordChip({super.key, required this.word, required this.onTap});

  final String word;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(word),
      avatar: const Icon(Icons.history_rounded, size: 18),
      backgroundColor: Colors.white,
      side: BorderSide(color: Colors.grey.shade200),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      onPressed: onTap,
    );
  }
}
