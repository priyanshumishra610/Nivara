import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/route_names.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/screens/onboarding_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../features/therapist_booking/presentation/screens/therapist_booking_screen.dart';
import '../features/ai_chat/presentation/screens/ai_chat_screen.dart';
import '../features/ai_coach/presentation/screens/ai_coach_screen.dart';
import '../features/community/presentation/screens/community_screen.dart';
import '../features/gamification/presentation/screens/gamification_screen.dart';
import '../features/mood_tracker/presentation/screens/mood_tracker_screen.dart';
import '../features/wellness_analytics/presentation/screens/wellness_analytics_screen.dart';
import '../features/shop/presentation/screens/shop_screen.dart';
import '../features/vr_ar/presentation/screens/vr_meditation_screen.dart';
import '../features/crisis/presentation/screens/crisis_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/auth/presentation/providers/auth_provider.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteNames.splash,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      
      if (authState.isLoading) {
        return null;
      }
      
      final isAuthenticated = authState.isAuthenticated;
      final isAuthRoute = state.uri.path == RouteNames.login ||
                         state.uri.path == RouteNames.register ||
                         state.uri.path == RouteNames.onboarding ||
                         state.uri.path == RouteNames.splash;
      
      if (!isAuthenticated && !isAuthRoute) {
        return RouteNames.login;
      }
      
      if (isAuthenticated && isAuthRoute && state.uri.path != RouteNames.splash) {
        return RouteNames.home;
      }
      
      return null;
    },
    refreshListenable: _AuthRefreshNotifier(ref),
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RouteNames.dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: RouteNames.therapistBooking,
        builder: (context, state) => const TherapistBookingScreen(),
      ),
      GoRoute(
        path: RouteNames.aiChat,
        builder: (context, state) => const AiChatScreen(),
      ),
      GoRoute(
        path: RouteNames.aiCoach,
        builder: (context, state) => const AICoachScreen(),
      ),
      GoRoute(
        path: RouteNames.community,
        builder: (context, state) => const CommunityScreen(),
      ),
      GoRoute(
        path: RouteNames.gamification,
        builder: (context, state) => const GamificationScreen(),
      ),
      GoRoute(
        path: RouteNames.moodTracker,
        builder: (context, state) => const MoodTrackerScreen(),
      ),
      GoRoute(
        path: RouteNames.wellnessAnalytics,
        builder: (context, state) => const WellnessAnalyticsScreen(),
      ),
      GoRoute(
        path: RouteNames.shop,
        builder: (context, state) => const ShopScreen(),
      ),
      GoRoute(
        path: RouteNames.vrMeditation,
        builder: (context, state) => const VRMeditationScreen(),
      ),
      GoRoute(
        path: RouteNames.crisis,
        builder: (context, state) => const CrisisScreen(),
      ),
      GoRoute(
        path: RouteNames.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
});

final appRouter = appRouterProvider;

class _AuthRefreshNotifier extends ChangeNotifier {
  final Ref _ref;
  
  _AuthRefreshNotifier(this._ref) {
    _ref.listen(authProvider, (previous, next) {
      notifyListeners();
    });
  }
}

