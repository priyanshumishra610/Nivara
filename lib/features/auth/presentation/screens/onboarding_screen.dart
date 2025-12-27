import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../state/providers/app_providers.dart';
import '../../../../widgets/animated_button.dart';
import '../../../../widgets/wellness_card.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      gradient: AppColors.primaryGradient,
      icon: Icons.psychology_outlined,
      title: 'Professional Support',
      description: 'Connect with licensed therapists and mental health professionals who understand your journey',
    ),
    OnboardingPage(
      gradient: AppColors.wellnessGradient,
      icon: Icons.chat_bubble_outline,
      title: 'AI Emotional Support',
      description: 'Get empathetic, always-available support from our AI companion, designed to listen and guide',
    ),
    OnboardingPage(
      gradient: AppColors.calmGradient,
      icon: Icons.people_outline,
      title: 'Safe Community',
      description: 'Join a supportive community of individuals on their wellness journey, sharing experiences and growth',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final authService = ref.read(authServiceProvider);
    await authService.setOnboardingCompleted(true);
    
    if (!mounted) return;
    
    final isAuthenticated = await authService.isAuthenticated();
    if (mounted) {
      context.go(isAuthenticated ? RouteNames.home : RouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (_currentPage < _pages.length - 1)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: _completeOnboarding,
                    child: Text(
                      'Skip',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _pages[index];
                },
              ),
            ),
            _buildPageIndicator(context),
            const SizedBox(height: AppSpacing.lg),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: AnimatedButton(
                label: _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                icon: _currentPage == _pages.length - 1 ? Icons.check : Icons.arrow_forward,
                gradient: AppColors.primaryGradient,
                onPressed: _currentPage == _pages.length - 1
                    ? _completeOnboarding
                    : () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                width: double.infinity,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPageIndicator(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 32 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? AppColors.primary
                : AppColors.border,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final Gradient gradient;
  final IconData icon;
  final String title;
  final String description;

  const OnboardingPage({
    super.key,
    required this.gradient,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WellnessCard(
            gradient: gradient,
            padding: const EdgeInsets.all(AppSpacing.xl),
            borderRadius: 30,
            child: Icon(
              icon,
              size: 100,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
