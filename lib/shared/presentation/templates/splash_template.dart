import 'package:flutter/material.dart';
import 'package:machine_test_dictionary/app/theme/app_theme.dart';
import 'package:machine_test_dictionary/shared/presentation/atoms/floating_letter.dart';
import 'package:machine_test_dictionary/shared/presentation/organisms/splash_brand_panel.dart';

class SplashTemplate extends StatelessWidget {
  const SplashTemplate({
    super.key,
    required this.logoScale,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.statusText,
  });

  final Animation<double> logoScale;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final String statusText;

  static const _letters = ['A', 'B', 'C', 'D'];
  static const _positions = [
    Offset(40, 100),
    Offset(300, 160),
    Offset(80, 650),
    Offset(320, 720),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: context.appTheme.primaryGradient,
      ),
      child: SafeArea(
        child: Stack(
          children: [
            for (var index = 0; index < _letters.length; index++)
              FloatingLetter(
                letter: _letters[index],
                position: _positions[index],
                opacity: fadeAnimation,
              ),
            SplashBrandPanel(
              logoScale: logoScale,
              fadeAnimation: fadeAnimation,
              slideAnimation: slideAnimation,
              statusText: statusText,
            ),
          ],
        ),
      ),
    );
  }
}
