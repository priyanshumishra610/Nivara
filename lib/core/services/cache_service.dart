import 'package:hive_flutter/hive_flutter.dart';
import '../errors/app_exceptions.dart';
import '../utils/logger.dart';
import '../config/app_config.dart';

abstract class CacheService {
  Future<void> init();
  Future<void> put<T>(String key, T value, {Duration? expiration});
  Future<T?> get<T>(String key);
  Future<void> delete(String key);
  Future<void> clear();
  Future<bool> containsKey(String key);
}

class CacheEntry<T> {
  final T value;
  final DateTime expiresAt;
  
  CacheEntry(this.value, {DateTime? expiresAt})
      : expiresAt = expiresAt ?? DateTime.now().add(AppConfig.cacheExpiration);
  
  bool get isExpired => DateTime.now().isAfter(expiresAt);
  
  Map<String, dynamic> toJson() => {
    'value': value,
    'expiresAt': expiresAt.toIso8601String(),
  };
  
  factory CacheEntry.fromJson(Map<String, dynamic> json) => CacheEntry(
    json['value'] as T,
    expiresAt: DateTime.parse(json['expiresAt'] as String),
  );
}

class HiveCacheService implements CacheService {
  static const String _boxName = 'app_cache';
  Box? _box;
  
  @override
  Future<void> init() async {
    try {
      await Hive.initFlutter();
      _box = await Hive.openBox(_boxName);
      _cleanExpiredEntries();
    } catch (e) {
      AppLogger.e('Failed to initialize cache', e);
      throw CacheException('Failed to initialize cache service');
    }
  }
  
  void _cleanExpiredEntries() {
    if (_box == null) return;
    
    final keysToDelete = <String>[];
    for (final key in _box!.keys) {
      try {
        final entry = _box!.get(key) as Map<String, dynamic>?;
        if (entry != null) {
          final expiresAt = DateTime.parse(entry['expiresAt'] as String);
          if (DateTime.now().isAfter(expiresAt)) {
            keysToDelete.add(key.toString());
          }
        }
      } catch (e) {
        keysToDelete.add(key.toString());
      }
    }
    
    for (final key in keysToDelete) {
      _box!.delete(key);
    }
  }
  
  @override
  Future<void> put<T>(String key, T value, {Duration? expiration}) async {
    if (_box == null) {
      throw CacheException('Cache not initialized');
    }
    
    try {
      final expiresAt = expiration != null
          ? DateTime.now().add(expiration)
          : DateTime.now().add(AppConfig.cacheExpiration);
      
      final entry = {
        'value': value,
        'expiresAt': expiresAt.toIso8601String(),
      };
      
      await _box!.put(key, entry);
    } catch (e) {
      AppLogger.e('Failed to cache value for key: $key', e);
      throw CacheException('Failed to cache data');
    }
  }
  
  @override
  Future<T?> get<T>(String key) async {
    if (_box == null) {
      return null;
    }
    
    try {
      final entry = _box!.get(key) as Map<String, dynamic>?;
      if (entry == null) return null;
      
      final expiresAt = DateTime.parse(entry['expiresAt'] as String);
      if (DateTime.now().isAfter(expiresAt)) {
        await _box!.delete(key);
        return null;
      }
      
      return entry['value'] as T?;
    } catch (e) {
      AppLogger.e('Failed to get cached value for key: $key', e);
      return null;
    }
  }
  
  @override
  Future<void> delete(String key) async {
    if (_box == null) return;
    
    try {
      await _box!.delete(key);
    } catch (e) {
      AppLogger.e('Failed to delete cached value for key: $key', e);
    }
  }
  
  @override
  Future<void> clear() async {
    if (_box == null) return;
    
    try {
      await _box!.clear();
    } catch (e) {
      AppLogger.e('Failed to clear cache', e);
      throw CacheException('Failed to clear cache');
    }
  }
  
  @override
  Future<bool> containsKey(String key) async {
    if (_box == null) return false;
    
    try {
      return _box!.containsKey(key);
    } catch (e) {
      AppLogger.e('Failed to check key in cache: $key', e);
      return false;
    }
  }
  
  Future<void> clearExpired() async {
    _cleanExpiredEntries();
  }
  
  Future<int> getSize() async {
    if (_box == null) return 0;
    return _box!.length;
  }
}

