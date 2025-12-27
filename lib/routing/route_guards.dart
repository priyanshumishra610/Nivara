import 'package:go_router/go_router.dart';
import '../../core/services/auth_service.dart';
import '../../core/constants/route_names.dart';
import '../../core/state/providers/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RouteGuards {
  static Future<String?> requireAuth(
    BuildContext context,
    GoRouterState state,
    WidgetRef ref,
  ) async {
    final authService = ref.read(authServiceProvider);
    final isAuthenticated = await authService.isAuthenticated();
    
    if (!isAuthenticated) {
      return RouteNames.login;
    }
    
    return null;
  }
  
  static Future<String?> requireGuest(
    BuildContext context,
    GoRouterState state,
    WidgetRef ref,
  ) async {
    final authService = ref.read(authServiceProvider);
    final isAuthenticated = await authService.isAuthenticated();
    
    if (isAuthenticated) {
      return RouteNames.home;
    }
    
    return null;
  }
  
  static Future<String?> requireOnboarding(
    BuildContext context,
    GoRouterState state,
    WidgetRef ref,
  ) async {
    final authService = ref.read(authServiceProvider);
    final hasCompletedOnboarding = await authService.hasCompletedOnboarding();
    
    if (!hasCompletedOnboarding) {
      return RouteNames.onboarding;
    }
    
    return null;
  }
  
  static String? requireRole(
    BuildContext context,
    GoRouterState state,
    WidgetRef ref,
    List<String> allowedRoles,
  ) {
    return null;
  }
}

