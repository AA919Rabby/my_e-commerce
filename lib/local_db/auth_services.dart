import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  static late SharedPreferences _prefs;

  /// Initialize once in main.dart
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ===================== KEYS =====================
  static const String _accessTokenKey = "access_token";
  static const String _forgetTokenKey = "forget_token";
  static const String _isLoggedInKey = "is_logged_in";
  static const String _userEmailKey = "user_email";

  // ===================== AUTH TOKEN METHODS =====================

  /// Save Access Token
  static Future<bool> setAccessToken(String token) async {
    return await _prefs.setString(_accessTokenKey, token);
  }

  /// Get Access Token
  static String? getAccessToken() {
    return _prefs.getString(_accessTokenKey);
  }

  /// Save Forget Password Token
  static Future<bool> setForgetToken(String token) async {
    return await _prefs.setString(_forgetTokenKey, token);
  }

  /// Get Forget Password Token
  static String? getForgetToken() {
    return _prefs.getString(_forgetTokenKey);
  }

  /// Save Login Status
  static Future<bool> setIsLoggedIn(bool isLoggedIn) async {
    return await _prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  /// Check Login Status
  static bool isLoggedIn() {
    return _prefs.getBool(_isLoggedInKey) ?? false;
  }

  /// Save User Email
  static Future<bool> setUserEmail(String email) async {
    return await _prefs.setString(_userEmailKey, email);
  }

  /// Get User Email
  static String? getUserEmail() {
    return _prefs.getString(_userEmailKey);
  }

  // ===================== GENERIC METHODS (SAVE ANYTHING) =====================

  /// Save String
  static Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  /// Get String
  static String? getString(String key) {
    return _prefs.getString(key);
  }

  /// Save Bool
  static Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  /// Get Bool
  static bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  /// Save Int
  static Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  /// Get Int
  static int? getInt(String key) {
    return _prefs.getInt(key);
  }

  /// Save Double
  static Future<bool> setDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  /// Get Double
  static double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  // ===================== REMOVE & CLEAR =====================

  /// Remove a specific key
  static Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  /// Clear everything (Call on Logout)
  static Future<bool> clearAll() async {
    return await _prefs.clear();
  }
}