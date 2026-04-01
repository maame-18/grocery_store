import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFFF4B2B); // Vibrant Red/Orange
  static const Color secondary = Color(0xFFFFB703); // Sunny Yellow
  static const Color background = Color(0xFFF8F9FA); // Off-white
  static const Color surface = Colors.white;
  static const Color textMain = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color success = Color(0xFF00B894);
  static const Color accent = Color(0xFF0984E3);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF482B), Color(0xFFFF8E53)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
