import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier with WidgetsBindingObserver {
  late ThemeData _themeData;

  ThemeNotifier() {
    _themeData =
        WidgetsBinding.instance.window.platformBrightness == Brightness.dark
            ? darkTheme
            : lightTheme;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangePlatformBrightness() {
    _themeData =
        WidgetsBinding.instance.window.platformBrightness == Brightness.dark
            ? darkTheme
            : lightTheme;
    notifyListeners();
  }

  ThemeData getTheme() => _themeData;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.grey,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Colors.white70),
    // Add other text styles as needed
  ),
  // Add other theme properties as needed
);

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.black),
    bodySmall: TextStyle(color: Colors.black87),
    // Add other text styles as needed
  ),
  // Add other theme properties as needed
);
