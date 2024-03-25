import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  void toggleDarkMode() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
