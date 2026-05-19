import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF2A9D8F);
  static const Color primaryDark = Color(0xFF1F7A6F);
  static const Color background = Color(0xFFEAF4F4);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFB300);
  static const Color error = Color(0xFFE53935);
  static const Color textPrimary = Color(0xFF1A2E35);
  static const Color textSecondary = Color(0xFF607D8B);
  static const Color divider = Color(0xFFE0E7E9);
  static const Color cardShadow = Color(0x0F000000);

  static const Color accentBlue = Color(0xFF5B6FE0);
  static const Color accentOrange = Color(0xFFF59F40);
  static const Color accentPurple = Color(0xFF8E7BD8);

  static Color scoreColor(double percent) {
    if (percent >= 70) return success;
    if (percent >= 40) return warning;
    return error;
  }
}
