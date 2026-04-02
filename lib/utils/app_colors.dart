import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFFFF4B2B); // Vibrant Red/Orange
  static const Color secondary = Color(0xFFFFB703); // Sunny Yellow
  static const Color accent = Color(0xFF0984E3);
  static const Color success = Color(0xFF00B894);

  // Light Theme Colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Colors.white;
  static const Color textMain = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);

  // Dark Theme Colors
  static const Color backgroundDark = Color(0xFF18191A);
  static const Color surfaceDark = Color(0xFF242526);
  static const Color textMainDark = Color(0xFFE4E6EB);
  static const Color textSecondaryDark = Color(0xFFB0B3B8);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF482B), Color(0xFFFF8E53)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
