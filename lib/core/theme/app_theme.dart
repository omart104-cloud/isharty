import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_spacing.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.cairoTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryBlue,
      scaffoldBackgroundColor: AppColors.mainBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryBlue,
        secondary: AppColors.cyanAccent,
        tertiary: AppColors.emeraldGreen,
        surface: AppColors.surfaceWhite,
        error: AppColors.softCoral,
        onPrimary: Colors.white,
        onSecondary: AppColors.deepNavy,
        onSurface: AppColors.primaryText,
      ),
      textTheme: baseTextTheme.apply(
        bodyColor: AppColors.primaryText,
        displayColor: AppColors.primaryNavy,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: AppColors.primaryNavy),
        titleTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryNavy,
        ),
      ),
      actionIconTheme: ActionIconThemeData(
        backButtonIconBuilder: (BuildContext context) {
          final isRtl = Directionality.of(context) == TextDirection.rtl;
          final platform = Theme.of(context).platform;
          if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
            return Icon(
              isRtl ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: AppColors.primaryNavy,
            );
          }
          return Icon(
            isRtl ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded,
            size: 24,
            color: AppColors.primaryNavy,
          );
        },
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 66,
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: const Color(0x1E0E3264),
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.primaryBlue.withOpacity(0.12),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: AppColors.primaryBlue,
              size: 24,
            );
          }
          return const IconThemeData(
            color: AppColors.secondaryText,
            size: 24,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryBlue,
            );
          }
          return const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.secondaryText,
          );
        }),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.roundedCard,
          side: const BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceWhite,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: AppSpacing.roundedMedium,
          borderSide: const BorderSide(color: AppColors.cardBorder, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.roundedMedium,
          borderSide: const BorderSide(color: AppColors.cardBorder, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.roundedMedium,
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.8),
        ),
      ),
    );
  }
}
