import 'package:flutter/material.dart';

class ColorManager {
  // Primary brand colors
  static const primaryOrange = Color(0xFFFFAA00);
  static const primaryOrangeGradientEnd = Color(0xFFF07500);
  static const placeholderGray = Color(0xFFD5D7E3);
  static const textfieldFill = Color(0x1AFFFFFF); // with 10% opacity
  static const primaryMaroon = Color(0xFF50042C);
}

class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ColorManager.primaryOrange,
        primary: ColorManager.primaryOrange,
        secondary: ColorManager.primaryMaroon,
      ),
      scaffoldBackgroundColor: Colors.white,
    );
  }
}
