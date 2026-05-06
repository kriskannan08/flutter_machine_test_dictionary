import 'package:flutter/material.dart';
import 'package:machine_test_dictionary/app/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machine_test_dictionary/app/router/navigation_helper.dart';
import 'package:machine_test_dictionary/modules/dictionary/presentation/providers/dictionary_providers.dart';
import 'package:machine_test_dictionary/modules/dictionary/presentation/widgets/organisms/word_details_sheet.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  void _showWordDetails(BuildContext context, String word) {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(searchHistoryProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Search History',
          style: context.appTheme.headingStyle,
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => context.popRoute(),
        ),
      ),
      body: history.isEmpty
          ? const Center(
              child: Text(
                'No history yet.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: history.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey.withOpacity(0.1),
                height: 1,
              ),
              itemBuilder: (context, index) {
                final word = history[index];
                return ListTile(
                  title: Text(
                    word,
                    style: context.appTheme.bodyStyle.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: context.appTheme.captionStyle.color,
                  ),
                  onTap: () => _showWordDetails(context, word),
                );
              },
            ),
    );
  }
}
