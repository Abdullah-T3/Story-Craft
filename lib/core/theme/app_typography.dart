import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Text roles: **Plus Jakarta Sans** (headlines & labels), **Be Vietnam Pro** (body).
abstract final class AppTypography {
  AppTypography._();

  static TextTheme textThemeLight(ColorScheme scheme) {
    final onSurface = scheme.onSurface;
    final vietnamBase = GoogleFonts.beVietnamProTextTheme().apply(
      bodyColor: onSurface,
      displayColor: onSurface,
    );
    final jakartaBase = GoogleFonts.plusJakartaSansTextTheme();

    return vietnamBase.copyWith(
      displayLarge: jakartaBase.displayLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: onSurface,
        letterSpacing: -0.5,
      ),
      displayMedium: jakartaBase.displayMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: onSurface,
      ),
      displaySmall: jakartaBase.displaySmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: onSurface,
      ),
      headlineLarge: jakartaBase.headlineLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: onSurface,
      ),
      headlineMedium: jakartaBase.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: onSurface,
      ),
      headlineSmall: jakartaBase.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
        color: onSurface,
      ),
      titleLarge: jakartaBase.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      titleMedium: jakartaBase.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      titleSmall: jakartaBase.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      labelLarge: jakartaBase.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      labelMedium: jakartaBase.labelMedium?.copyWith(
        fontWeight: FontWeight.w500,
        color: onSurface,
      ),
      labelSmall: jakartaBase.labelSmall?.copyWith(
        fontWeight: FontWeight.w500,
        color: onSurface,
      ),
    );
  }

  static TextTheme textThemeDark(ColorScheme scheme) {
    final onSurface = scheme.onSurface;
    final vietnamBase = GoogleFonts.beVietnamProTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    ).apply(bodyColor: onSurface, displayColor: onSurface);
    final jakartaBase = GoogleFonts.plusJakartaSansTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    );

    return vietnamBase.copyWith(
      displayLarge: jakartaBase.displayLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: onSurface,
        letterSpacing: -0.5,
      ),
      displayMedium: jakartaBase.displayMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: onSurface,
      ),
      displaySmall: jakartaBase.displaySmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: onSurface,
      ),
      headlineLarge: jakartaBase.headlineLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: onSurface,
      ),
      headlineMedium: jakartaBase.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: onSurface,
      ),
      headlineSmall: jakartaBase.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
        color: onSurface,
      ),
      titleLarge: jakartaBase.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      titleMedium: jakartaBase.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      titleSmall: jakartaBase.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      labelLarge: jakartaBase.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      labelMedium: jakartaBase.labelMedium?.copyWith(
        fontWeight: FontWeight.w500,
        color: onSurface,
      ),
      labelSmall: jakartaBase.labelSmall?.copyWith(
        fontWeight: FontWeight.w500,
        color: onSurface,
      ),
    );
  }
}
