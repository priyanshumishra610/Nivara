import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/constants/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../state/providers/app_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );
    
    _controller.forward();
    _navigateToNext();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  Future<void> _navigateToNext() async {
    await Future.delayed(AppConfig.splashDuration);
    
    if (!mounted) return;
    
    final authService = ref.read(authServiceProvider);
    final isAuthenticated = await authService.isAuthenticated();
    final hasCompletedOnboarding = await authService.hasCompletedOnboarding();
    
    if (!mounted) return;
    
    if (!hasCompletedOnboarding) {
      context.go(RouteNames.onboarding);
    } else if (isAuthenticated) {
      context.go(RouteNames.home);
    } else {
      context.go(RouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.wellnessGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: [AppColors.floatingShadow],
                  ),
                  child: const Icon(
                    Icons.self_improvement,
                    size: 72,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    Text(
                      'Nivara',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Your Safe Space for Healing',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
