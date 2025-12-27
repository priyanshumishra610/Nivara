import '../constants/app_constants.dart';
import 'storage_service.dart';
import 'token_manager.dart';
import '../utils/logger.dart';

abstract class AuthService {
  Future<bool> isAuthenticated();
  Future<String?> getToken();
  Future<void> saveToken(String token, {String? refreshToken, DateTime? expiresAt});
  Future<void> saveUserId(String userId);
  Future<String?> getUserId();
  Future<void> logout();
  Future<bool> hasCompletedOnboarding();
  Future<void> setOnboardingCompleted(bool completed);
}

class AuthServiceImpl implements AuthService {
  final StorageService _storageService;
  final TokenManager _tokenManager;
  
  AuthServiceImpl(this._storageService, this._tokenManager);
  
  @override
  Future<bool> isAuthenticated() async {
    try {
      return await _tokenManager.isTokenValid();
    } catch (e) {
      AppLogger.e('Error checking authentication status', e);
      return false;
    }
  }
  
  @override
  Future<String?> getToken() async {
    return await _tokenManager.getAccessToken();
  }
  
  @override
  Future<void> saveToken(String token, {String? refreshToken, DateTime? expiresAt}) async {
    final expires = expiresAt ?? DateTime.now().add(const Duration(hours: 24));
    final tokenData = TokenData(
      accessToken: token,
      refreshToken: refreshToken,
      expiresAt: expires,
    );
    await _tokenManager.saveToken(tokenData);
  }
  
  @override
  Future<void> saveUserId(String userId) async {
    await _storageService.setString(AppConstants.userIdKey, userId);
  }
  
  @override
  Future<String?> getUserId() async {
    return await _storageService.getString(AppConstants.userIdKey);
  }
  
  @override
  Future<void> logout() async {
    await _tokenManager.clearToken();
    await _storageService.remove(AppConstants.userIdKey);
  }
  
  @override
  Future<bool> hasCompletedOnboarding() async {
    return await _storageService.getBool(AppConstants.onboardingCompletedKey) ?? false;
  }
  
  @override
  Future<void> setOnboardingCompleted(bool completed) async {
    await _storageService.setBool(AppConstants.onboardingCompletedKey, completed);
  }
}

