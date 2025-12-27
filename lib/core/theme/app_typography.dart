import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class AppTypography {
  static const String _fontFamily = 'Roboto';
  
  static TextTheme textTheme = const TextTheme(
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        fontFamily: _fontFamily,
        height: 1.12,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        fontFamily: _fontFamily,
        height: 1.16,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        fontFamily: _fontFamily,
        height: 1.22,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        fontFamily: _fontFamily,
        height: 1.25,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        fontFamily: _fontFamily,
        height: 1.29,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        fontFamily: _fontFamily,
        height: 1.33,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        fontFamily: _fontFamily,
        height: 1.27,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        fontFamily: _fontFamily,
        height: 1.5,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        fontFamily: _fontFamily,
        height: 1.43,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        fontFamily: _fontFamily,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        fontFamily: _fontFamily,
        height: 1.43,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        fontFamily: _fontFamily,
        height: 1.33,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        fontFamily: _fontFamily,
        height: 1.43,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        fontFamily: _fontFamily,
        height: 1.33,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        fontFamily: _fontFamily,
        height: 1.45,
      ),
    );
  
  static TextTheme get textThemeScaled => textTheme.copyWith(
    displayLarge: textTheme.displayLarge?.copyWith(fontSize: 57 * 1.2),
    displayMedium: textTheme.displayMedium?.copyWith(fontSize: 45 * 1.2),
    displaySmall: textTheme.displaySmall?.copyWith(fontSize: 36 * 1.2),
    headlineLarge: textTheme.headlineLarge?.copyWith(fontSize: 32 * 1.2),
    headlineMedium: textTheme.headlineMedium?.copyWith(fontSize: 28 * 1.2),
    headlineSmall: textTheme.headlineSmall?.copyWith(fontSize: 24 * 1.2),
    titleLarge: textTheme.titleLarge?.copyWith(fontSize: 22 * 1.2),
    bodyLarge: textTheme.bodyLarge?.copyWith(fontSize: 16 * 1.2),
    bodyMedium: textTheme.bodyMedium?.copyWith(fontSize: 14 * 1.2),
  );
}

