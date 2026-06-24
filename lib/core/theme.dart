import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTheme {
  static const _emojiFallback = ['NotoEmoji'];

  static TextStyle _poppins({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = AppColors.textDark,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    ).copyWith(fontFamilyFallback: _emojiFallback);
  }

  // ── Light Theme ──────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.cardLight,
      ),
      textTheme: TextTheme(
        displayLarge: _poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark),
        displayMedium: _poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark),
        bodyLarge: _poppins(
            fontSize: 16,
            color: AppColors.textDark),
        bodyMedium: _poppins(
            fontSize: 14,
            color: AppColors.textGrey),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textLight,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textLight,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: _poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textLight),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardLight,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: AppColors.lightAccent.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: AppColors.lightAccent.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          const BorderSide(color: AppColors.accent, width: 2),
        ),
      ),
    );
  }

  // ── Dark Theme ───────────────────────────────────
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      primaryColor: AppColors.accent,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        secondary: AppColors.lightAccent,
        surface: AppColors.darkCard,
      ),
      textTheme: TextTheme(
        displayLarge: _poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textLight),
        displayMedium: _poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textLight),
        bodyLarge: _poppins(
            fontSize: 16,
            color: AppColors.textLight),
        bodyMedium: _poppins(
            fontSize: 14,
            color: AppColors.lightAccent),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkNav,
        foregroundColor: AppColors.textLight,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.textLight,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: _poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textLight),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkInput,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 16),
        labelStyle: const TextStyle(color: AppColors.lightAccent),
        hintStyle: TextStyle(
            color: AppColors.lightAccent.withValues(alpha: 0.5)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: AppColors.lightAccent.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: AppColors.lightAccent.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          const BorderSide(color: AppColors.accent, width: 2),
        ),
      ),
      cardColor: AppColors.darkCard,
      dividerColor: AppColors.darkDivider,
    );
  }
}