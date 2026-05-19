import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_dimens.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final TextTheme baseText = GoogleFonts.sourceSans3TextTheme().apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    );
    final TextStyle headingFont = GoogleFonts.nunito(
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
    );

    final TextTheme textTheme = baseText.copyWith(
      displayLarge: headingFont.copyWith(fontSize: 32),
      displayMedium: headingFont.copyWith(fontSize: 28),
      headlineLarge: headingFont.copyWith(fontSize: 26),
      headlineMedium: headingFont.copyWith(fontSize: 22),
      headlineSmall: headingFont.copyWith(fontSize: 18),
      titleLarge: headingFont.copyWith(fontSize: 18),
      titleMedium: headingFont.copyWith(fontSize: 16),
      titleSmall: headingFont.copyWith(fontSize: 14),
      bodyLarge: baseText.bodyLarge?.copyWith(fontSize: 16),
      bodyMedium: baseText.bodyMedium?.copyWith(fontSize: 14),
      bodySmall: baseText.bodySmall?.copyWith(
        fontSize: 12,
        color: AppColors.textSecondary,
      ),
      labelLarge: headingFont.copyWith(fontSize: 14),
    );

    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      surface: AppColors.surface,
      error: AppColors.error,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: textTheme,
      splashFactory: InkRipple.splashFactory,
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: AppDimens.elevationCard,
        shadowColor: AppColors.cardShadow,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: textTheme.headlineMedium,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(AppDimens.minTapTarget),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusPill),
          ),
          textStyle: headingFont.copyWith(fontSize: 15),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.2),
          minimumSize: const Size.fromHeight(AppDimens.minTapTarget),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusPill),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceLg,
          vertical: AppDimens.spaceLg,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.divider, thickness: 1),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.divider,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.accentOrange,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        elevation: 8,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: TextStyle(color: Colors.white),
      ),
    );
  }
}
