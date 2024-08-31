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
  primarySwatch: Colors.blueGrey,
  primaryColor: Colors.blueGrey[900],
  scaffoldBackgroundColor: const Color(0xFF121212),
  cardColor: const Color(0xFF1E1E1E),
  dividerColor: Colors.grey[800],
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Colors.white70),
    headlineMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    headlineSmall: TextStyle(color: Colors.white70),
    // Add other text styles as needed
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.blueGrey,
    textTheme: ButtonTextTheme.primary,
  ),
  iconTheme: const IconThemeData(
    color: Colors.white70,
  ),
  appBarTheme: const AppBarTheme(
    color: Color(0xFF1E1E1E),
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(color: Colors.white),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.blueGrey,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(Colors.blueGrey[700]!),
      foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      ),
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF1E1E1E),
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white70,
  ),
);

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.purple,
  primaryColor: Colors.purple[400],
  scaffoldBackgroundColor: const Color(0xFFF5F5F5),
  cardColor: const Color(0xFFEDE7F6),
  dividerColor: Colors.grey[300],
  textTheme: TextTheme(
    bodyMedium: const TextStyle(color: Colors.black87),
    bodySmall: const TextStyle(color: Colors.black54),
    headlineMedium:
        const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
    headlineSmall: TextStyle(color: Colors.purple[300]),
    // Add other text styles as needed
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.purple,
    textTheme: ButtonTextTheme.primary,
  ),
  iconTheme: const IconThemeData(
    color: Colors.black54,
  ),
  appBarTheme: AppBarTheme(
    color: Colors.purple[700],
    elevation: 0,
    iconTheme: const IconThemeData(color: Colors.white),
    titleTextStyle: const TextStyle(color: Colors.white),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.purple,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(Colors.purple[400]!),
      foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      ),
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.purple[50],
    selectedItemColor: Colors.purple[400],
    unselectedItemColor: Colors.black54,
  ),
);
