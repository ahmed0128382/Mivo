import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/Usermodel.dart';

class SessionManager {
  static const String _tokenKey = 'token';
  static const String _userDataKey = 'UserData';
  static const String _uuidKey = 'uuid';

  static bool isValidToken(String? token) {
    return token != null && token.isNotEmpty && token != 'null';
  }

  static Future<void> saveSession({
    required String token,
    required usermodel user,
  }) async {
    if (!isValidToken(token)) {
      throw ArgumentError('Invalid session token');
    }

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _tokenKey,
      token,
    );

    await prefs.setString(
      _userDataKey,
      jsonEncode(user),
    );
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<usermodel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    final raw = prefs.getString(_userDataKey);

    if (raw == null || raw.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(raw);

      if (decoded is! Map) {
        return null;
      }

      return usermodel.fromJson(
        Map<String, dynamic>.from(decoded),
      );
    } catch (e) {
      print(
        'SESSION: invalid UserData: $e',
      );

      return null;
    }
  }

  static Future<bool> hasSession() async {
    final token = await getToken();

    if (!isValidToken(token)) {
      return false;
    }

    final user = await getUser();

    return user != null && user.id != null;
  }

  static Future<void> updateUser(
    usermodel user,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _userDataKey,
      jsonEncode(user),
    );
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_tokenKey);
    await prefs.remove(_userDataKey);
    await prefs.remove(_uuidKey);
  }
}
