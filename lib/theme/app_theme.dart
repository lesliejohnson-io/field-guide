import 'package:flutter/material.dart';

const Color _warmNeutralBackground = Color(0xFFF5F0E8);

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF2E7D32),
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: _warmNeutralBackground,
  appBarTheme: const AppBarTheme(
    centerTitle: false,
  ),
  textTheme: const TextTheme(
    headlineMedium: TextStyle(fontWeight: FontWeight.bold),
  ),
);

