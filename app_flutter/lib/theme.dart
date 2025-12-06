import 'package:flutter/material.dart';

const Color bananGreen = Color(0xFF008A4A);
const Color bananBg = Color(0xFFF7F3E8);
const Color bananDark = Color(0xFF1F2933);

ThemeData buildBananTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: bananGreen,
      primary: bananGreen,
      background: bananBg,
    ),
    scaffoldBackgroundColor: bananBg,
    appBarTheme: const AppBarTheme(
      backgroundColor: bananBg,
      foregroundColor: bananDark,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: bananGreen,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: bananGreen, width: 1.5),
      ),
    ),
  );
}
