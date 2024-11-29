import 'package:flutter/material.dart';
import 'package:shiplan_service/temp_lib/constants/colors.dart';

final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: darkMoodColor,
    fontFamily: 'Manrope');
final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    fontFamily: 'Manrope');

class ThemeProvider extends ChangeNotifier {
  ThemeData _selectedTheme;
  bool _isDarkMode;

  ThemeProvider({bool isDarkMode = false})
      : _isDarkMode = isDarkMode,
        _selectedTheme = isDarkMode ? darkTheme : lightTheme;

  ThemeData get getTheme => _selectedTheme;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    if (_isDarkMode) {
      _selectedTheme = lightTheme;
      _isDarkMode = false;
    } else {
      _selectedTheme = darkTheme;
      _isDarkMode = true;
    }
    notifyListeners();
  }
}
