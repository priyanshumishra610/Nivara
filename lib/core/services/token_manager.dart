import 'dart:convert';
import 'dart:async';
import '../errors/app_exceptions.dart';
import '../utils/logger.dart';
import '../config/app_config.dart';
import 'secure_storage_service.dart';
import 'storage_service.dart';

class TokenData {
  final String accessToken;
  final String? refreshToken;
  final DateTime expiresAt;
  
  TokenData({
    required this.accessToken,
    this.refreshToken,
    required this.expiresAt,
  });
  
  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get shouldRefresh => DateTime.now().add(AppConfig.tokenRefreshThreshold).isAfter(expiresAt);
  
  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'refreshToken': refreshToken,
    'expiresAt': expiresAt.toIso8601String(),
  };
  
  factory TokenData.fromJson(Map<String, dynamic> json) => TokenData(
    accessToken: json['accessToken'] as String,
    refreshToken: json['refreshToken'] as String?,
    expiresAt: DateTime.parse(json['expiresAt'] as String),
  );
}

typedef TokenRefreshCallback = Future<Map<String, dynamic>?> Function(String refreshToken);

abstract class TokenManager {
  Future<TokenData?> getToken();
  Future<void> saveToken(TokenData token);
  Future<void> clearToken();
  Future<bool> isTokenValid();
  Future<String?> getAccessToken();
  Future<String?> refreshTokenIfNeeded();
  Future<TokenData?> refreshToken();
  void setRefreshCallback(TokenRefreshCallback callback);
}

class TokenManagerImpl implements TokenManager {
  static const String _tokenKey = 'auth_token_data';
  
  final SecureStorageService _secureStorage;
  final StorageService _storage;
  TokenRefreshCallback? _refreshCallback;
  
  Completer<TokenData?>? _refreshCompleter;
  bool _isRefreshing = false;
  
  TokenManagerImpl(
    this._secureStorage,
    this._storage,
  );
  
  @override
  void setRefreshCallback(TokenRefreshCallback callback) {
    _refreshCallback = callback;
  }
  
  @override
  Future<TokenData?> getToken() async {
    try {
      final tokenJson = await _secureStorage.read(_tokenKey);
      if (tokenJson == null) return null;
      
      final json = jsonDecode(tokenJson) as Map<String, dynamic>;
      return TokenData.fromJson(json);
    } catch (e) {
      AppLogger.e('Failed to get token', e);
      return null;
    }
  }
  
  @override
  Future<void> saveToken(TokenData token) async {
    try {
      final json = jsonEncode(token.toJson());
      await _secureStorage.write(_tokenKey, json);
    } catch (e) {
      AppLogger.e('Failed to save token', e);
      throw CacheException('Failed to save authentication token');
    }
  }
  
  @override
  Future<void> clearToken() async {
    try {
      await _secureStorage.delete(_tokenKey);
      _refreshCompleter = null;
      _isRefreshing = false;
    } catch (e) {
      AppLogger.e('Failed to clear token', e);
    }
  }
  
  @override
  Future<bool> isTokenValid() async {
    final token = await getToken();
    if (token == null) return false;
    return !token.isExpired;
  }
  
  @override
  Future<String?> getAccessToken() async {
    final token = await getToken();
    if (token == null) return null;
    
    if (token.isExpired) {
      if (token.refreshToken != null) {
        try {
          final refreshed = await refreshTokenIfNeeded();
          return refreshed;
        } catch (e) {
          AppLogger.e('Failed to refresh expired token', e);
          return null;
        }
      }
      return null;
    }
    
    return token.accessToken;
  }
  
  @override
  Future<String?> refreshTokenIfNeeded() async {
    final token = await getToken();
    if (token == null) return null;
    
    if (!token.shouldRefresh && !token.isExpired) {
      return token.accessToken;
    }
    
    if (token.refreshToken == null) {
      AppLogger.w('Token should refresh but no refresh token available');
      if (token.isExpired) {
        await clearToken();
        throw AuthenticationException('Token expired and no refresh token available');
      }
      return token.accessToken;
    }
    
    if (_isRefreshing && _refreshCompleter != null) {
      final refreshed = await _refreshCompleter!.future;
      return refreshed?.accessToken;
    }
    
    AppLogger.i('Token refresh needed, refreshing...');
    
    try {
      final newToken = await refreshToken();
      if (newToken != null) {
        await saveToken(newToken);
        return newToken.accessToken;
      }
    } catch (e) {
      AppLogger.e('Failed to refresh token', e);
      if (token.isExpired) {
        await clearToken();
        throw AuthenticationException('Token expired and refresh failed');
      }
    }
    
    return token.accessToken;
  }
  
  @override
  Future<TokenData?> refreshToken() async {
    if (_isRefreshing && _refreshCompleter != null) {
      return await _refreshCompleter!.future;
    }
    
    _isRefreshing = true;
    _refreshCompleter = Completer<TokenData?>();
    
    try {
      final token = await getToken();
      if (token?.refreshToken == null) {
        _refreshCompleter!.complete(null);
        _isRefreshing = false;
        return null;
      }
      
      if (_refreshCallback == null) {
        AppLogger.w('Token refresh callback not set');
        _refreshCompleter!.complete(null);
        _isRefreshing = false;
        return null;
      }
      
      AppLogger.i('Performing token refresh');
      
      final data = await _refreshCallback!(token!.refreshToken!);
      
      if (data == null) {
        AppLogger.e('Token refresh returned null');
        _refreshCompleter!.complete(null);
        _isRefreshing = false;
        throw AuthenticationException('Token refresh failed');
      }
      
      final newAccessToken = data['accessToken'] as String?;
      if (newAccessToken == null) {
        AppLogger.e('Token refresh response missing accessToken');
        _refreshCompleter!.complete(null);
        _isRefreshing = false;
        throw AuthenticationException('Invalid token refresh response');
      }
      
      final newRefreshToken = data['refreshToken'] as String? ?? token.refreshToken;
      final expiresIn = data['expiresIn'] as int? ?? 3600;
      final expiresAt = DateTime.now().add(Duration(seconds: expiresIn));
      
      final newToken = TokenData(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
        expiresAt: expiresAt,
      );
      
      _refreshCompleter!.complete(newToken);
      _isRefreshing = false;
      return newToken;
    } catch (e) {
      _isRefreshing = false;
      if (_refreshCompleter != null && !_refreshCompleter!.isCompleted) {
        _refreshCompleter!.complete(null);
      }
      rethrow;
    }
  }
}

