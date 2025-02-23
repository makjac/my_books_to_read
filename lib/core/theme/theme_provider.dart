import 'package:flutter/material.dart';
import 'package:my_books_to_read/core/theme/theme.dart';
import 'package:my_books_to_read/core/utils/logger.dart';
import 'package:my_books_to_read/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeProvider() : _theme = const MaterialTheme() {
    _init();
  }

  final MaterialTheme _theme;

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  ThemeData get lightTheme => _theme.light();
  ThemeData get darkTheme => _theme.dark();

  set themeMode(ThemeMode themeMode) {
    locator<SharedPreferences>().setString('themeMode', themeMode.toString());
    _themeMode = themeMode;

    Logger.showLog('Theme mode changed: $themeMode', 'ThemeProvider');
    notifyListeners();
  }

  void _init() {
    final themeMode = locator<SharedPreferences>().getString('themeMode');
    if (themeMode != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (e) => e.toString() == themeMode,
      );
    }
  }
}
