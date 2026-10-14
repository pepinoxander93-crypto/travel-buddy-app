import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const blue = Color(0xFF29ABE2);
  static const blueDark = Color(0xFF1a8bbd);
  static const coral = Color(0xFFFF6B35);
  static const coralDark = Color(0xFFe55a2b);
  static const gold = Color(0xFFFFD166);
  static const purple = Color(0xFF6d5fbc);
  static const purpleDark = Color(0xFF4a3fb5);
  static const ink = Color(0xFF2C3E50);
  static const muted = Color(0xFF7f8c8d);
  static const bgTop = Color(0xFF1a8bbd);
  static const bgMid = Color(0xFF6d5fbc);
  static const bgBottom = Color(0xFFff8b6b);
}

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.bgTop,
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.blue,
          primary: AppColors.blue,
          secondary: AppColors.coral,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.coral,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            textStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
      );

  static BoxDecoration get bgGradient => const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.bgTop, AppColors.bgMid, AppColors.bgBottom],
        ),
      );
}