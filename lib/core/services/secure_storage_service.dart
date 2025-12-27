import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../errors/app_exceptions.dart';
import '../utils/logger.dart';

abstract class SecureStorageService {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
  Future<void> deleteAll();
  Future<bool> containsKey(String key);
}

class FlutterSecureStorageServiceImpl implements SecureStorageService {
  static const _options = AndroidOptions(
    encryptedSharedPreferences: true,
  );
  
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: _options,
  );
  
  @override
  Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      AppLogger.e('Failed to write to secure storage: $key', e);
      throw CacheException('Failed to securely store data');
    }
  }
  
  @override
  Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      AppLogger.e('Failed to read from secure storage: $key', e);
      throw CacheException('Failed to read secure data');
    }
  }
  
  @override
  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      AppLogger.e('Failed to delete from secure storage: $key', e);
    }
  }
  
  @override
  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      AppLogger.e('Failed to delete all from secure storage', e);
    }
  }
  
  @override
  Future<bool> containsKey(String key) async {
    try {
      final value = await _storage.read(key: key);
      return value != null;
    } catch (e) {
      AppLogger.e('Failed to check key in secure storage: $key', e);
      return false;
    }
  }
}

