import 'package:shared_preferences/shared_preferences.dart';

abstract class StorageService {
  Future<void> setString(String key, String value);
  Future<String?> getString(String key);
  Future<void> setBool(String key, bool value);
  Future<bool?> getBool(String key);
  Future<void> setInt(String key, int value);
  Future<int?> getInt(String key);
  Future<void> remove(String key);
  Future<void> clear();
}

class SharedPreferencesStorageService implements StorageService {
  @override
  Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }
  
  @override
  Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
  
  @override
  Future<void> setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }
  
  @override
  Future<bool?> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }
  
  @override
  Future<void> setInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }
  
  @override
  Future<int?> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }
  
  @override
  Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
  
  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

