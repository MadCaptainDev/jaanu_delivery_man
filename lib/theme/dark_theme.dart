import 'package:flutter/material.dart';

ThemeData dark = ThemeData(
  fontFamily: 'Roboto',
  primaryColor: const Color(0xFF7878f0),
  secondaryHeaderColor: const Color(0xFF7878f0),
  disabledColor: const Color(0xFF6f7275),
  errorColor: const Color(0xFFdd3135),
  brightness: Brightness.dark,
  hintColor: const Color(0xFFbebebe),
  cardColor: Colors.black,
  colorScheme: const ColorScheme.dark(primary: Color(0xFF7878f0), secondary: Color(0xFF7878f0)),
  textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(primary: const Color(0xFF7878f0))),
);
