import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF080B10);
  static const Color surface = Color(0xFF0E131F);
  static const Color surfaceElevated = Color(0xFF151C2C);
  
  // Champagne Metallic Gold
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFF3E5AB);
  static const Color goldDark = Color(0xFFAA820A);
  
  static const Color textPrimary = Color(0xFFEAE6DF);
  static const Color textSecondary = Color(0xFF9E9AA7);
  static const Color textMuted = Color(0xFF6B6675);
  
  static const Color borderGold = Color(0x3FD4AF37);
  static const Color borderSubtle = Color(0x1FFFFFFF);
  
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFDF78), Color(0xFFD4AF37), Color(0xFFAA820A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassCardGradient = LinearGradient(
    colors: [
      Color(0x221E293B),
      Color(0x100E131F),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.gold,
      cardColor: AppColors.surface,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.gold,
        surface: AppColors.surface,
        background: AppColors.background,
        error: AppColors.error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceElevated,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
        ),
      ),
    );
  }
}
