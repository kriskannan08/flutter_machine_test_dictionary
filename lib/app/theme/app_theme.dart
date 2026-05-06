import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF4F46E5),
        primary: const Color(0xFF4F46E5),
        surface: const Color(0xFFF8FAFC),
      ),
      extensions: [
        AppThemeExtension.light,
      ],
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6366F1),
        primary: const Color(0xFF6366F1),
        brightness: Brightness.dark,
        surface: const Color(0xFF0F172A),
      ),
      extensions: [
        AppThemeExtension.dark,
      ],
    );
  }
}

@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.primaryGradient,
    required this.cardShadow,
    required this.headingStyle,
    required this.bodyStyle,
    required this.captionStyle,
  });

  final LinearGradient primaryGradient;
  final List<BoxShadow> cardShadow;
  final TextStyle headingStyle;
  final TextStyle bodyStyle;
  final TextStyle captionStyle;

  @override
  ThemeExtension<AppThemeExtension> copyWith({
    LinearGradient? primaryGradient,
    List<BoxShadow>? cardShadow,
    TextStyle? headingStyle,
    TextStyle? bodyStyle,
    TextStyle? captionStyle,
  }) {
    return AppThemeExtension(
      primaryGradient: primaryGradient ?? this.primaryGradient,
      cardShadow: cardShadow ?? this.cardShadow,
      headingStyle: headingStyle ?? this.headingStyle,
      bodyStyle: bodyStyle ?? this.bodyStyle,
      captionStyle: captionStyle ?? this.captionStyle,
    );
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(
    covariant ThemeExtension<AppThemeExtension>? other,
    double t,
  ) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      primaryGradient: LinearGradient.lerp(primaryGradient, other.primaryGradient, t)!,
      cardShadow: BoxShadow.lerpList(cardShadow, other.cardShadow, t)!,
      headingStyle: TextStyle.lerp(headingStyle, other.headingStyle, t)!,
      bodyStyle: TextStyle.lerp(bodyStyle, other.bodyStyle, t)!,
      captionStyle: TextStyle.lerp(captionStyle, other.captionStyle, t)!,
    );
  }

  static final light = AppThemeExtension(
    primaryGradient: const LinearGradient(
      colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    cardShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
    headingStyle: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Color(0xFF1E293B),
    ),
    bodyStyle: const TextStyle(
      fontSize: 16,
      color: Color(0xFF475569),
    ),
    captionStyle: const TextStyle(
      fontSize: 14,
      color: Color(0xFF94A3B8),
    ),
  );

  static final dark = AppThemeExtension(
    primaryGradient: const LinearGradient(
      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    cardShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: 15,
        offset: const Offset(0, 6),
      ),
    ],
    headingStyle: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Color(0xFFF8FAFC),
    ),
    bodyStyle: const TextStyle(
      fontSize: 16,
      color: Color(0xFFCBD5E1),
    ),
    captionStyle: const TextStyle(
      fontSize: 14,
      color: Color(0xFF64748B),
    ),
  );
}

extension AppThemeX on BuildContext {
  AppThemeExtension get appTheme => Theme.of(this).extension<AppThemeExtension>()!;
}
