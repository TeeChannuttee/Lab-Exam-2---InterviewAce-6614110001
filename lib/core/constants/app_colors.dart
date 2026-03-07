import 'package:flutter/material.dart';

/// Enterprise Corporate Color Palette — White & Navy Premium
class AppColors {
  AppColors._();

  // Primary — Corporate Navy
  static const Color primary = Color(0xFF1B2A4A);
  static const Color primaryLight = Color(0xFF2D4A7A);
  static const Color primaryDark = Color(0xFF0F1B33);

  // Accent — Refined Gold
  static const Color accent = Color(0xFF8B7355);
  static const Color accentLight = Color(0xFFAA9070);
  static const Color accentDark = Color(0xFF6D5A42);

  // Status Colors — Muted & Professional
  static const Color success = Color(0xFF2D8B57);
  static const Color warning = Color(0xFFD4932A);
  static const Color error = Color(0xFFC5392F);
  static const Color info = Color(0xFF2E6EB5);

  // Dark Theme — Deep Corporate Dark
  static const Color darkBg = Color(0xFF0C111A);
  static const Color darkBgSecondary = Color(0xFF141B2B);
  static const Color darkCard = Color(0xFF1A2238);
  static const Color darkCardLight = Color(0xFF222D45);
  static const Color darkText = Color(0xFFE8ECF1);
  static const Color darkTextSecondary = Color(0xFF8896AB);
  static const Color darkBorder = Color(0xFF2A3650);

  // Light Theme — Clean White Corporate
  static const Color lightBg = Color(0xFFF9FAFB);
  static const Color lightBgSecondary = Color(0xFFF3F4F6);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF111827);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightBorder = Color(0xFFE5E7EB);

  // Gradient — Corporate Navy
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, Color(0xFF2D4A7A)],
  );

  static const LinearGradient darkBgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [darkBg, darkBgSecondary],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, Color(0xFF6D5A42)],
  );

  // Score Colors
  static Color getScoreColor(double score) {
    if (score >= 80) return success;
    if (score >= 60) return warning;
    return error;
  }
}
