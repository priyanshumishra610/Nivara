import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/secure_storage_service.dart';
import '../../core/services/api_service.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/services/cache_service.dart';
import '../../core/services/token_manager.dart';
import '../../core/services/toast_service.dart';
import '../../core/services/analytics_service.dart';
import '../../core/services/offline_queue_service.dart';
import '../../core/services/sync_service.dart';
import '../../core/services/notification_service.dart';
import '../../core/services/accessibility_service.dart';
import '../../core/services/content_service.dart';
import '../../core/config/app_config.dart';
import '../../data/sources/auth_remote_source.dart';
import '../../data/repositories/auth_repository.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';

final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((ref) {
  return GlobalKey<NavigatorState>();
});

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return FlutterSecureStorageServiceImpl();
});

final storageServiceProvider = Provider<StorageService>((ref) {
  return SharedPreferencesStorageService();
});

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityServiceImpl();
});

final cacheServiceProvider = Provider<CacheService>((ref) {
  return HiveCacheService();
});

final tokenManagerProvider = Provider<TokenManager>((ref) {
  final tokenManager = TokenManagerImpl(
    ref.read(secureStorageServiceProvider),
    ref.read(storageServiceProvider),
  );
  
  tokenManager.setRefreshCallback((refreshToken) async {
    final apiService = ref.read(apiServiceProvider);
    final result = await apiService.post(
      AppConfig.refreshTokenEndpoint,
      data: {'refreshToken': refreshToken},
    );
    
    if (result.isFailure) {
      return null;
    }
    
    final response = result.dataOrNull!;
    return response.data as Map<String, dynamic>?;
  });
  
  return tokenManager;
});

final apiServiceProvider = Provider<ApiService>((ref) {
  return DioApiService(
    ref.read(connectivityServiceProvider),
    ref.read(tokenManagerProvider),
  );
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthServiceImpl(
    ref.read(storageServiceProvider),
    ref.read(tokenManagerProvider),
  );
});

final toastServiceProvider = Provider<ToastService>((ref) {
  return ToastServiceImpl(ref.read(navigatorKeyProvider));
});

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsServiceImpl();
});

final offlineQueueServiceProvider = Provider<OfflineQueueService>((ref) {
  return OfflineQueueServiceImpl(ref.read(storageServiceProvider));
});

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncServiceImpl(
    ref.read(apiServiceProvider),
    ref.read(offlineQueueServiceProvider),
    ref.read(connectivityServiceProvider),
  );
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationServiceImpl();
});

final accessibilityServiceProvider = Provider<AccessibilityService>((ref) {
  return AccessibilityServiceImpl();
});

final contentServiceProvider = Provider<ContentService>((ref) {
  return ContentServiceImpl(
    ref.read(apiServiceProvider),
    ref.read(cacheServiceProvider),
  );
});

final authRemoteSourceProvider = Provider<AuthRemoteSource>((ref) {
  return AuthRemoteSourceImpl(ref.read(apiServiceProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.read(authRemoteSourceProvider),
    ref.read(authServiceProvider),
  );
});
