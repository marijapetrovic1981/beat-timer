import 'package:flutter/material.dart';

class AppTheme {
  // Base colors - Neumorphic palette
  static const Color background = Color(0xFF1E293B);     // Base Slate - main background
  static const Color shadowLight = Color(0xFF27374D);    // Top-left light shadow
  static const Color shadowDark = Color(0xFF151D2A);     // Bottom-right dark shadow
  
  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF);    // Pure white - contrast 12.6:1
  static const Color textSecondary = Color(0xFFCBD5E1);  // Light slate - contrast 8.7:1
  
  // Status colors
  static const Color colorWork = Color(0xFF34D399);      // Emerald glow - contrast 7.8:1
  static const Color colorRest = Color(0xFF38BDF8);      // Cyan glow - contrast 7.3:1
  
  // Legacy aliases for compatibility
  static const Color surface = Color(0xFF1E293B);
  static const Color surfaceLight = Color(0xFF27374D);
  static const Color primary = Color(0xFF34D399);
  static const Color secondary = Color(0xFF34D399);      // Work phase
  static const Color tertiary = Color(0xFF38BDF8);       // Rest phase
  static const Color error = Color(0xFFEF4444);

  // Neumorphic shadow values
  static const double shadowOffset = 8.0;
  static const double shadowBlur = 16.0;
  static const double shadowOffsetSmall = 6.0;
  static const double shadowBlurSmall = 12.0;

  // Neumorphic box decoration - raised effect
  static BoxDecoration get neumorphicRaised => BoxDecoration(
    color: background,
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      // Bottom-right dark shadow
      BoxShadow(
        color: shadowDark,
        offset: const Offset(shadowOffset, shadowOffset),
        blurRadius: shadowBlur,
      ),
      // Top-left light shadow
      BoxShadow(
        color: shadowLight,
        offset: const Offset(-shadowOffset, -shadowOffset),
        blurRadius: shadowBlur,
      ),
    ],
  );

  // Neumorphic box decoration - pressed/inset effect
  static BoxDecoration get neumorphicPressed => BoxDecoration(
    color: background,
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      // Inset dark shadow
      BoxShadow(
        color: shadowDark,
        offset: const Offset(shadowOffsetSmall, shadowOffsetSmall),
        blurRadius: shadowBlurSmall,
        // Note: Flutter doesn't support inset shadows directly,
        // we'll handle this with a custom painter or inner container
      ),
    ],
  );

  // Neumorphic circular decoration - for buttons
  static BoxDecoration neumorphicCircle({bool isPressed = false}) => BoxDecoration(
    color: background,
    shape: BoxShape.circle,
    boxShadow: isPressed ? [] : [
      BoxShadow(
        color: shadowDark,
        offset: const Offset(shadowOffsetSmall, shadowOffsetSmall),
        blurRadius: shadowBlurSmall,
      ),
      BoxShadow(
        color: shadowLight,
        offset: const Offset(-shadowOffsetSmall, -shadowOffsetSmall),
        blurRadius: shadowBlurSmall,
      ),
    ],
  );

  // Timer ring decoration with glow
  static BoxDecoration timerRing({Color glowColor = colorWork}) => BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(color: glowColor, width: 3),
    boxShadow: [
      // Neon glow effect
      BoxShadow(
        color: glowColor.withValues(alpha: 0.3),
        blurRadius: 15,
        spreadRadius: 0,
      ),
      // Neumorphic shadows
      BoxShadow(
        color: shadowDark,
        offset: const Offset(shadowOffsetSmall, shadowOffsetSmall),
        blurRadius: shadowBlurSmall,
      ),
      BoxShadow(
        color: shadowLight,
        offset: const Offset(-shadowOffsetSmall, -shadowOffsetSmall),
        blurRadius: shadowBlurSmall,
      ),
    ],
  );

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        tertiary: tertiary,
        surface: surface,
        error: error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      cardTheme: CardThemeData(
        color: background,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: textPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: background,
        indicatorColor: primary.withValues(alpha: 0.2),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primary);
          }
          return const IconThemeData(color: textSecondary);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(color: primary, fontSize: 12);
          }
          return const TextStyle(color: textSecondary, fontSize: 12);
        }),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 72,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          letterSpacing: -2,
        ),
        displayMedium: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: textSecondary,
        ),
      ),
    );
  }
}
