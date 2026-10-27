import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background = Color(0xFF080808);
  static const surface = Color(0xFF111111);
  static const surfaceRaised = Color(0xFF151515);
  static const gold = Color(0xFFD4AF37);
}

abstract final class AppTheme {
  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.gold,
      brightness: Brightness.dark,
      surface: AppColors.surface,
    );

    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: colorScheme.copyWith(surface: AppColors.background),
      scaffoldBackgroundColor: AppColors.background,
      dividerColor: Colors.white10,
      navigationBarTheme: NavigationBarThemeData(
        height: 68,
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.gold,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          return TextStyle(
            color: states.contains(WidgetState.selected)
                ? AppColors.gold
                : Colors.white54,
            fontSize: 11,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w800
                : FontWeight.w600,
          );
        }),
      ),
    );
  }
}
