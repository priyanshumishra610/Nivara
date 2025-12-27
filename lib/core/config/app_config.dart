import 'app_environment.dart';

class AppConfig {
  static AppEnvironment _environment = AppEnvironment.dev;
  static bool _initialized = false;
  
  static AppEnvironment get environment {
    if (!_initialized) {
      throw StateError('AppConfig not initialized. Call AppConfig.initialize() first.');
    }
    return _environment;
  }
  
  static void initialize({AppEnvironment? env}) {
    _environment = env ?? _getEnvironmentFromEnv();
    _initialized = true;
  }
  
  static AppEnvironment _getEnvironmentFromEnv() {
    const env = String.fromEnvironment('ENV', defaultValue: 'dev');
    return AppEnvironment.fromString(env);
  }
  
  static String get appName => 'Nivara';
  static String get appVersion => '1.0.0';
  static String get appVersionCode => '1';
  
  static String get baseUrl {
    switch (_environment) {
      case AppEnvironment.dev:
        return 'https://api-dev.nivara.com';
      case AppEnvironment.staging:
        return 'https://api-staging.nivara.com';
      case AppEnvironment.production:
        return 'https://api.nivara.com';
    }
  }
  
  static String get apiVersion => 'v1';
  static String get apiBasePath => '/api/$apiVersion';
  
  static Duration get apiTimeout => const Duration(seconds: 30);
  static Duration get apiConnectTimeout => const Duration(seconds: 15);
  static Duration get apiReceiveTimeout => const Duration(seconds: 30);
  
  static int get maxRetries => 3;
  static Duration get retryDelay => const Duration(seconds: 1);
  static Duration get retryBackoffMultiplier => const Duration(milliseconds: 500);
  
  static bool get enableLogging => !_environment.isProduction;
  static bool get enableCrashReporting => _environment.isProduction;
  static bool get enableNetworkLogging => _environment.isDev;
  static bool get enablePerformanceMonitoring => _environment.isProduction;
  static bool get enableAnalytics => true;
  
  static Duration get splashDuration => const Duration(seconds: 2);
  static Duration get tokenRefreshThreshold => const Duration(minutes: 5);
  static Duration get cacheExpiration => const Duration(hours: 24);
  static Duration get offlineCacheExpiration => const Duration(days: 7);
  
  static int get maxCacheSize => 50 * 1024 * 1024;
  static int get maxOfflineQueueSize => 100;
  
  static bool get enableDeepLinking => true;
  static bool get enablePushNotifications => true;
  
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-App-Version': appVersion,
    'X-Platform': 'mobile',
  };
  
  static String get refreshTokenEndpoint => '$apiBasePath/auth/refresh';
  static String get loginEndpoint => '$apiBasePath/auth/login';
  static String get logoutEndpoint => '$apiBasePath/auth/logout';
}
