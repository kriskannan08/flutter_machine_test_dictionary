import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machine_test_dictionary/modules/dictionary/domain/entities/word_details.dart';
import 'package:machine_test_dictionary/modules/dictionary/presentation/providers/dictionary_providers.dart';

class WordDetailsSheet extends ConsumerWidget {
  const WordDetailsSheet({
    super.key,
    required this.word,
    required this.scrollController,
  });

  final String word;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordDetails = ref.watch(wordDetailsProvider(word));

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: wordDetails.when(
        data: (details) => _WordDetailsContent(
          details: details,
          scrollController: scrollController,
        ),
        loading: () => const _SheetMessage(
          icon: Icons.search,
          title: 'Searching...',
          message: 'Fetching word details',
        ),
        error: (error, stackTrace) => _SheetMessage(
          icon: Icons.error_outline,
          title: 'No result found',
          message: error.toString().replaceFirst('Exception: ', ''),
        ),
      ),
    );
  }
}

class _WordDetailsContent extends StatelessWidget {
  const _WordDetailsContent({
    required this.details,
    required this.scrollController,
  });

  final WordDetails details;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: ListView(
        controller: scrollController,
        children: [
          const _SheetHandle(),
          const SizedBox(height: 24),
          Text(
            details.word,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4F46E5),
            ),
          ),
          if (details.phonetic.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              details.phonetic,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
          const SizedBox(height: 24),
          _DetailSection(
            title: 'Definition',
            body: details.definition.isEmpty
                ? 'No definition available.'
                : details.definition,
          ),
          if (details.example.isNotEmpty) ...[
            const SizedBox(height: 24),
            _DetailSection(
              title: 'Example',
              body: '"${details.example}"',
              isItalic: true,
            ),
          ],
          if (details.synonyms.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Text(
              'Synonyms',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final synonym in details.synonyms)
                  Chip(label: Text(synonym)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _SheetMessage extends StatelessWidget {
  const _SheetMessage({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 42, color: const Color(0xFF4F46E5)),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 50,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({
    required this.title,
    required this.body,
    this.isItalic = false,
  });

  final String title;
  final String body;
  final bool isItalic;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          body,
          style: TextStyle(
            fontSize: 16,
            fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
            height: 1.6,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
