import 'package:whether/screens/permissions_screen.dart';

import 'package:flutter/material.dart';

var kColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: const Color.fromRGBO(128, 192, 56, 1),
);
var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 5, 99, 125),
);
void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kDarkColorScheme.onPrimary,
          foregroundColor: kDarkColorScheme.onBackground,
        ),
        scaffoldBackgroundColor: kDarkColorScheme.background,
        textTheme: ThemeData().textTheme.copyWith(
          titleLarge: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
          titleMedium: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: TextStyle(
            color: kDarkColorScheme.onBackground,
          ),
          bodyMedium: TextStyle(
            color: kDarkColorScheme.onBackground,
          ),
          bodySmall: TextStyle(
            color: kDarkColorScheme.onBackground,
          ),
        ),
      ),
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.primary,
          foregroundColor: kColorScheme.onPrimary,
        ),
        textTheme: ThemeData().textTheme.copyWith(
          titleLarge: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
          titleMedium: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: TextStyle(
            color: kColorScheme.onBackground,
          ),
          bodyMedium: TextStyle(
            color: kColorScheme.onBackground,
          ),
          bodySmall: TextStyle(
            color: kColorScheme.onBackground,
          ),
        ),
      ),
      title: "Call Logs",
      home: const PermissionsScreen(),
    ),
  );
}