import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LangController with ChangeNotifier {
  Locale? _locale;
  int selectedLang = 1;
  bool isArabic = false; // Boolean to check if the language is Arabic

  Locale? get locale => _locale;

  Future<void> setLocale(String languageCode, int selectedLang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Store selected language code and selectedLang value
    await prefs.setString('selected_language', languageCode);
    await prefs.setInt('number_of_selectedLang', selectedLang);
    
    // Set the locale
    _locale = Locale(languageCode, '');

    // Update the boolean based on the selected language
    if (languageCode == 'ar') {
      isArabic = true;
    } else {
      isArabic = false;
    }
    
    await prefs.setBool('is_arabic', isArabic); // Store the boolean in SharedPreferences

    notifyListeners();
  }

  Future<void> loadLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    String? languageCode = prefs.getString('selected_language');
    if (prefs.getInt('number_of_selectedLang') != null) {
      selectedLang = prefs.getInt('number_of_selectedLang')!;
    } else {
      selectedLang = 1;
    }

    // If languageCode is not null, set it, otherwise default to English
    if (languageCode != null) {
      _locale = Locale(languageCode, '');
    } else {
      _locale = const Locale('en', ''); // Default to English
    }

    // Load the boolean value for checking if the language is Arabic
    isArabic = prefs.getBool('is_arabic') ?? false;

    notifyListeners();
  }
}
