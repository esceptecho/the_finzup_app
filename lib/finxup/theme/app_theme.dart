import 'package:flutter/material.dart';


class AppTheme {
  // --- Colores Originales ---
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color primaryWine = Color(0xFF720917);
  static const Color accentGold = Color(0xFFD4AF37);
  static const Color incomeGreen = Color(0xFF48C9B0);
  static const Color expenseRed = Color(0xFFA21B2E);
  static const Color textWhite = Color(0xFFF5F5F7);

  // --- Nuevas Variaciones ---

  // Variaciones de Wine (Primario)
  static const Color primaryWineDark = Color(0xFF4A060E);
  static const Color primaryWineLight = Color(0xFF9B1B2B);

  // Variaciones de Gold (Acento)
  static const Color accentGoldMuted = Color(0xFFAA8C2C);
  static const Color accentGoldBright = Color(0xFFFFD700);

  // Variaciones de Superficie/Fondo
  static const Color surfaceLighter = Color(0xFF2C2C2C);
  static const Color backgroundDeep = Color(0xFF0A0A0A);

  // Variaciones de Estado (Income/Expense)
  static const Color incomeGreenDark = Color(0xFF349280);
  static const Color incomeGreenLight = Color(0xFF76D7C4);
  static const Color expenseRedDark = Color(0xFF7A1423);
  static const Color expenseRedLight = Color(0xFFC63D4F);

  // Variaciones de Texto
  static const Color textGrey = Color(0xFFA0A0A0);
  static const Color textDisabled = Color(0xFF6E6E6E);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primaryWine,
      // Usamos colorScheme para una implementación más moderna en Flutter
      colorScheme: const ColorScheme.dark(
        primary: primaryWine,
        secondary: accentGold,
        surface: surface,
        error: expenseRed,
        onPrimary: textWhite,
        onSurface: textWhite,
      ),
      cardColor: surface,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textWhite),
        bodyMedium: TextStyle(color: textGrey), // Usando la nueva variación grey
        displayLarge: TextStyle(color: accentGold, fontWeight: FontWeight.bold),
      ),
    );
  }
}
// class AppTheme {
//   static const Color background = Color(0xFF121212);
//   static const Color surface = Color(0xFF1E1E1E);
//   static const Color primaryWine = Color(0xFF720917);
//   static const Color accentGold = Color(0xFFD4AF37);
//   static const Color incomeGreen = Color(0xFF48C9B0);
//   static const Color expenseRed = Color(0xFFA21B2E);
//   static const Color textWhite = Color(0xFFF5F5F7);

//   static ThemeData get darkTheme {
//     return ThemeData(
//       brightness: Brightness.dark,
//       scaffoldBackgroundColor: background,
//       primaryColor: primaryWine,
//       cardColor: surface,
//       textTheme: const TextTheme(
//         bodyLarge: TextStyle(color: textWhite),
//         bodyMedium: TextStyle(color: Colors.white70),
//       ),
//     );
//   }
// }