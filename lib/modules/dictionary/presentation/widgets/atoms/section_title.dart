import 'package:flutter/material.dart';
import 'package:machine_test_dictionary/app/theme/app_theme.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.appTheme.headingStyle.copyWith(fontSize: 22),
    );
  }
}
