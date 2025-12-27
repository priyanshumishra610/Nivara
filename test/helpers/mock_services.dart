import 'package:mocktail/mocktail.dart';
import '../../../lib/core/services/api_service.dart';
import '../../../lib/core/services/auth_service.dart';
import '../../../lib/core/services/cache_service.dart';
import '../../../lib/core/services/connectivity_service.dart';
import '../../../lib/core/services/storage_service.dart';
import '../../../lib/core/services/secure_storage_service.dart';
import '../../../lib/core/services/token_manager.dart';
import '../../../lib/core/services/analytics_service.dart';
import '../../../lib/core/services/toast_service.dart';
import '../../../lib/core/services/offline_queue_service.dart';
import '../../../lib/core/services/sync_service.dart';

class MockApiService extends Mock implements ApiService {}
class MockAuthService extends Mock implements AuthService {}
class MockCacheService extends Mock implements CacheService {}
class MockConnectivityService extends Mock implements ConnectivityService {}
class MockStorageService extends Mock implements StorageService {}
class MockSecureStorageService extends Mock implements SecureStorageService {}
class MockTokenManager extends Mock implements TokenManager {}
class MockAnalyticsService extends Mock implements AnalyticsService {}
class MockToastService extends Mock implements ToastService {}
class MockOfflineQueueService extends Mock implements OfflineQueueService {}
class MockSyncService extends Mock implements SyncService {}

