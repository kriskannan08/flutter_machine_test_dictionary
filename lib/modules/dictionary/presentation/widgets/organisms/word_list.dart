import 'package:flutter/material.dart';
import 'package:machine_test_dictionary/app/theme/app_theme.dart';

class WordList extends StatefulWidget {
  const WordList({
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
  State<WordList> createState() => _WordListState();
}

class _WordListState extends State<WordList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.words.isEmpty && widget.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.words.isEmpty) {
      return const Center(
        child: Text(
          'No words available.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: widget.words.length + (widget.hasMore ? 1 : 0),
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey.withOpacity(0.1),
        height: 1,
      ),
      itemBuilder: (context, index) {
        if (index == widget.words.length) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final word = widget.words[index];
        return ListTile(
          title: Text(
            word,
            style: context.appTheme.bodyStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: context.appTheme.captionStyle.color,
          ),
          onTap: () => widget.onWordTap(word),
        );
      },
    );
  }
}
