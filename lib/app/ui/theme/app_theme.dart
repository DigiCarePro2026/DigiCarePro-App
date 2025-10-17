import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_dimens.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: AppColors.primaryLight,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryLight,
      secondary: AppColors.secondaryLight,
      brightness: Brightness.light,
      outline: AppColors.outlineLight,
      surface: AppColors.bottomNavBarBackgroundLight,
      onSurface: AppColors.textPrimaryLight,
    ),
    scaffoldBackgroundColor: AppColors.backgroundLight,
    appBarTheme: AppBarThemeData(
      backgroundColor: AppColors.appbarBackgroundLight,
      titleTextStyle: TextStyle(
        color: AppColors.textPrimaryLight,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontFamily: 'NotoSans',
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.bottomNavBarBackgroundLight,
      indicatorColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(color: AppColors.primaryLight, fontSize: 12);
        }
        return TextStyle(color: AppColors.textPrimaryLight, fontSize: 12);
      }),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
    hintColor: AppColors.hintLight,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 18, color: AppColors.textPrimaryLight, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(fontSize: 16, color: AppColors.textPrimaryLight, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(fontSize: 14, color: AppColors.textPrimaryLight, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontSize: 16, color: AppColors.textPrimaryLight),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.textPrimaryLight),
      bodySmall: TextStyle(fontSize: 12, color: AppColors.textPrimaryLight),
      labelLarge: TextStyle(fontSize: 16, color: AppColors.textPrimaryLight),
      labelMedium: TextStyle(fontSize: 14, color: AppColors.textPrimaryLight),
      labelSmall: TextStyle(fontSize: 12, color: AppColors.textPrimaryLight),
      titleLarge: TextStyle(fontSize: 16, color: AppColors.textSecondaryLight),
      titleMedium: TextStyle(fontSize: 14, color: AppColors.textSecondaryLight),
      titleSmall: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: AppColors.textOnPrimaryPrimaryLight,
        padding: const EdgeInsets.symmetric(vertical: 14),
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ElevatedButton.styleFrom(
        // backgroundColor: AppColors.primaryLight,
        // foregroundColor: AppColors.textOnPrimaryPrimaryLight,
        padding: const EdgeInsets.symmetric(vertical: 14),
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),
    disabledColor: AppColors.disabledLight,
    dividerColor: AppColors.dividerLight,
    fontFamily: 'NotoSans',
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(primary: AppColors.primaryDark, secondary: AppColors.secondaryDark),
  );
}
