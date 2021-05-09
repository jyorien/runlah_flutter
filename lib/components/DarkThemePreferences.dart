import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkThemePreferences with ChangeNotifier {
  static const THEME_STATUS = "status";
  bool _isDark = false;


  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_STATUS) ?? false;
  }
}

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreferences darkThemePreferences = DarkThemePreferences();
  bool _isDark = false;

  bool get isDark => _isDark;

  set isDark(bool value) {
    _isDark = value;
    darkThemePreferences.setDarkTheme(value);
    notifyListeners();
  }
}

class Styles {
  static ThemeData themeData(bool isDark, BuildContext context) {
    if (isDark)
      return darkThemeData(context);
    else
      return lightThemeData(context);
  }
  static ThemeData lightThemeData(BuildContext context) {
    return ThemeData.light().copyWith(
        primaryColor: Colors.deepPurple,
        accentColor: Colors.green,
        bottomNavigationBarTheme: BottomNavigationBarThemeData());
  }

  static ThemeData darkThemeData(BuildContext context) {
    return ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black87,
        accentColor: Colors.black54,
        bottomNavigationBarTheme: BottomNavigationBarThemeData());
  }
}