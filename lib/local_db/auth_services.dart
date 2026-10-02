import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static const String _accessTokenKey = "access_token";
  static const String _forgetTokenKey = "forget_token";
  static const String _isLoggedInKey = "is_logged_in";
  static const String _userEmailKey = "user_email";

  static Future<bool> setAccessToken(String token) async {
    return await _prefs.setString(_accessTokenKey, token);
  }

  static String? getAccessToken() {
    return _prefs.getString(_accessTokenKey);
  }

  static Future<bool> setForgetToken(String token) async {
    return await _prefs.setString(_forgetTokenKey, token);
  }

  static String? getForgetToken() {
    return _prefs.getString(_forgetTokenKey);
  }

  static Future<bool> setIsLoggedIn(bool isLoggedIn) async {
    return await _prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  static bool isLoggedIn() {
    return _prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<bool> setUserEmail(String email) async {
    return await _prefs.setString(_userEmailKey, email);
  }

  static String? getUserEmail() {
    return _prefs.getString(_userEmailKey);
  }

  static Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs.getString(key);
  }

  static Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  static Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  static int? getInt(String key) {
    return _prefs.getInt(key);
  }

  static Future<bool> setDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  static double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  static Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  static Future<bool> clearAll() async {
    return await _prefs.clear();
  }
}