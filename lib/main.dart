import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/app_config.dart';
import 'core/config/app_environment.dart';
import 'core/errors/global_exception_handler.dart';
import 'core/widgets/error_boundary.dart';
import 'core/widgets/offline_banner.dart';
import 'core/utils/app_lifecycle_manager.dart';
import 'core/theme/app_theme.dart';
import 'routing/app_router.dart';
import 'state/providers/app_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  AppConfig.initialize(env: AppEnvironment.dev);
  GlobalExceptionHandler.initialize();
  
  await _initializeServices();
  
  runApp(
    const ProviderScope(
      child: NivaraApp(),
    ),
  );
}

Future<void> _initializeServices() async {
  try {
    final container = ProviderContainer();
    final cacheService = container.read(cacheServiceProvider);
    await cacheService.init();
    
    final notificationService = container.read(notificationServiceProvider);
    await notificationService.initialize();
    
    final accessibilityService = container.read(accessibilityServiceProvider);
    await accessibilityService.initialize();
    
    container.dispose();
  } catch (e) {
    // Service initialization failure shouldn't block app startup
  }
}

class NivaraApp extends ConsumerWidget {
  const NivaraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final navigatorKey = ref.watch(navigatorKeyProvider);
    
    return AppLifecycleManager(
      child: ErrorBoundary(
        child: MaterialApp.router(
          navigatorKey: navigatorKey,
          title: AppConfig.appName,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          routerConfig: router,
          debugShowCheckedModeBanner: !AppConfig.environment.isProduction,
          builder: (context, child) {
            return Column(
              children: [
                const OfflineBanner(),
                Expanded(child: child ?? const SizedBox()),
              ],
            );
          },
        ),
      ),
    );
  }
}

