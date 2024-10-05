import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static final SharedPreferencesHelper _instance =
  SharedPreferencesHelper._internal();

  factory SharedPreferencesHelper() {
    return _instance;
  }

  SharedPreferencesHelper._internal();

  // Get instance of SharedPreferences
  Future<SharedPreferences> _getPreferences() async {
    return await SharedPreferences.getInstance();
  }

  // Save a string value
  Future<void> saveString(String key, String value) async {
    final prefs = await _getPreferences();
    await prefs.setString(key, value);
  }

  // Save an integer value
  Future<void> saveInt(String key, int value) async {
    final prefs = await _getPreferences();
    await prefs.setInt(key, value);
  }

  // Save a boolean value
  Future<void> saveBool(String key, bool value) async {
    final prefs = await _getPreferences();
    await prefs.setBool(key, value);
  }

  // Retrieve a string value
  Future<String?> getString(String key) async {
    final prefs = await _getPreferences();
    return prefs.getString(key);
  }

  // Retrieve an integer value
  Future<int?> getInt(String key) async {
    final prefs = await _getPreferences();
    return prefs.getInt(key);
  }

  // Retrieve a boolean value
  Future<bool?> getBool(String key) async {
    final prefs = await _getPreferences();
    return prefs.getBool(key);
  }

  // Remove a key
  Future<void> remove(String key) async {
    final prefs = await _getPreferences();
    await prefs.remove(key);
  }

  // Clear all keys
  Future<void> clear() async {
    final prefs = await _getPreferences();
    await prefs.clear();
  }
}
