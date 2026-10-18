
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Keep the existing values for compatibility with code that checks
/// Lang == 'Ar' or Lang == 'En'.
String ? lang = 'Ar';

const String defaultLanguage = 'Ar';

/// Load the saved language before runApp().
Future<void> checklanguage() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  final String? savedLanguage = prefs.getString('Lang');
  final String normalizedLanguage =
      (savedLanguage ?? defaultLanguage).trim().toLowerCase();

  lang = normalizedLanguage == 'en' ? 'En' : 'Ar';

  // Migrate older values such as "ar" and "en" to the canonical values.
  await prefs.setString('Lang', lang!);

  debugPrint('Loaded language: $lang');
  debugPrint('Flutter locale code: ${lang?.toLowerCase()}');
}

class languageViewmodel extends ChangeNotifier {
  Future<void> Arbic() async {
    await _setLanguage('Ar');
  }

  Future<void> English() async {
    await _setLanguage('En');
  }

  Future<void> _setLanguage(String language) async {
    if (lang == language) return;

    lang = language;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('Lang', language);

    notifyListeners();
  }
}
