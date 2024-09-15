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
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.blueGrey, // Define a proper background color
    textTheme: ButtonTextTheme.primary, // Ensures button text is visible
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all<Color>(
          Colors.blueGrey[300]!), // Makes text readable in dark mode
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(Colors.blueAccent),
      foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
      elevation: WidgetStateProperty.all(5), // Adds shadow for better contrast
      overlayColor: WidgetStateProperty.all<Color>(Colors.blueAccent[100]!),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all<Color>(
          Colors.blueAccent), // Bright text color for good contrast
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(18.0), // Rounded corners for modern look
        ),
      ),
      side: WidgetStateProperty.all(
          const BorderSide(color: Colors.blueAccent)), // Border color
      overlayColor: WidgetStateProperty.all<Color>(Colors.blueAccent
          .withOpacity(0.1)), // Light overlay color when pressed/hovered
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.blueGrey,
    foregroundColor: Colors.white,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF1E1E1E),
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white70,
  ),
  dialogTheme: const DialogTheme(
    backgroundColor: Color(0xFF1E1E1E), // Dark background for dialogs
    titleTextStyle: const TextStyle(
        color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
    contentTextStyle: TextStyle(color: Colors.white70),
  ),
  colorScheme: const ColorScheme.dark(
    primary: Colors.blueAccent,
    onPrimary: Colors.white,
    secondary: Colors.blueGrey,
    onSecondary: Colors.white,
    surface: Color(0xFF1E1E1E),
    onSurface: Colors.white,
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
    toolbarTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
    ),
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ), // Ensures app bar title text is white
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
  radioTheme: RadioThemeData(
    fillColor: WidgetStateProperty.all<Color>(Colors.purple),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all<Color>(Colors.purple[400]!),
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
  colorScheme: ColorScheme.light(
    primary: Colors.purple[400]!,
    onPrimary: Colors.white,
    secondary: Colors.amber,
    onSecondary: Colors.black,
  ),
);
