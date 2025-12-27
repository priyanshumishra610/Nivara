import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nivara/core/services/storage_service.dart';
import 'package:nivara/core/services/secure_storage_service.dart';
import 'package:nivara/core/services/api_service.dart';
import 'package:nivara/core/services/token_manager.dart';
import 'package:nivara/core/services/connectivity_service.dart';
import 'package:nivara/core/services/cache_service.dart';
import 'package:nivara/core/services/auth_service.dart';
import 'package:nivara/core/services/analytics_service.dart';
import 'package:nivara/core/services/toast_service.dart';
import 'package:nivara/core/services/offline_queue_service.dart';
import 'package:nivara/core/services/sync_service.dart';

class MockStorageService extends Mock implements StorageService {}
class MockSecureStorageService extends Mock implements SecureStorageService {}
class MockApiService extends Mock implements ApiService {}
class MockTokenManager extends Mock implements TokenManager {}
class MockConnectivityService extends Mock implements ConnectivityService {}
class MockCacheService extends Mock implements CacheService {}
class MockAuthService extends Mock implements AuthService {}
class MockAnalyticsService extends Mock implements AnalyticsService {}
class MockToastService extends Mock implements ToastService {}
class MockOfflineQueueService extends Mock implements OfflineQueueService {}
class MockSyncService extends Mock implements SyncService {}

