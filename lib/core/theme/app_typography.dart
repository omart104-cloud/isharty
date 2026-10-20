import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  static const String fontName = 'Cairo';

  static TextStyle get regular => GoogleFonts.cairo(
        fontWeight: FontWeight.w400,
        color: AppColors.primaryText,
        height: 1.45,
      );

  static TextStyle get medium => GoogleFonts.cairo(
        fontWeight: FontWeight.w500,
        color: AppColors.primaryText,
        height: 1.4,
      );

  static TextStyle get semiBold => GoogleFonts.cairo(
        fontWeight: FontWeight.w600,
        color: AppColors.primaryText,
        height: 1.35,
      );

  static TextStyle get bold => GoogleFonts.cairo(
        fontWeight: FontWeight.w700,
        color: AppColors.primaryText,
        height: 1.3,
      );

  static TextStyle get extraBold => GoogleFonts.cairo(
        fontWeight: FontWeight.w800,
        color: AppColors.primaryText,
        height: 1.25,
      );

  // Scaled Styles
  static TextStyle displayLarge = extraBold.copyWith(
    fontSize: 28,
    letterSpacing: -0.5,
  );

  static TextStyle displayMedium = bold.copyWith(
    fontSize: 24,
    letterSpacing: -0.3,
  );

  static TextStyle headlineLarge = bold.copyWith(
    fontSize: 20,
    letterSpacing: -0.2,
  );

  static TextStyle headlineMedium = semiBold.copyWith(
    fontSize: 18,
  );

  static TextStyle titleMedium = semiBold.copyWith(
    fontSize: 16,
  );

  static TextStyle bodyLarge = regular.copyWith(
    fontSize: 15,
  );

  static TextStyle bodyMedium = regular.copyWith(
    fontSize: 14,
  );

  static TextStyle bodySmall = regular.copyWith(
    fontSize: 12,
    color: AppColors.secondaryText,
  );

  static TextStyle labelLarge = semiBold.copyWith(
    fontSize: 14,
  );

  static TextStyle labelSmall = medium.copyWith(
    fontSize: 11,
    letterSpacing: 0.1,
  );
}
