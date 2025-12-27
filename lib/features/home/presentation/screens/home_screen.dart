import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../widgets/mood_ring.dart';
import '../../../../widgets/streak_indicator.dart';
import '../../../../widgets/personalized_card.dart';
import '../../../../widgets/wellness_card.dart';
import '../../../../widgets/floating_ai_coach.dart';
import '../../../../widgets/custom_refresh_indicator.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomRefreshIndicator(
        onRefresh: _onRefresh,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGreeting(context),
                    const SizedBox(height: AppSpacing.lg),
                    _buildMoodSection(context),
                    const SizedBox(height: AppSpacing.lg),
                    _buildStreaksSection(context),
                    const SizedBox(height: AppSpacing.lg),
                    _buildPersonalizedRecommendations(context),
                    const SizedBox(height: AppSpacing.lg),
                    _buildQuickActions(context),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            const FloatingAICoach(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildGreeting(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'How are you feeling today?',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
  
  Widget _buildMoodSection(BuildContext context) {
    return WellnessCard(
      gradient: AppColors.calmGradient,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          const MoodRing(
            moodValue: 7.5,
            size: 100,
            label: 'Today',
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Mood Today',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'You\'re feeling calm and balanced. Keep up the great work!',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AnimatedButton(
                  label: 'Track Mood',
                  icon: Icons.add,
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0.2),
                    ],
                  ),
                  backgroundColor: Colors.white.withOpacity(0.2),
                  onPressed: () => context.push(RouteNames.moodTracker),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStreaksSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StreakIndicator(
            streak: 7,
            label: 'Day Streak',
            icon: Icons.local_fire_department,
            color: AppColors.moodHappy,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: StreakIndicator(
            streak: 12,
            label: 'Mood Entries',
            icon: Icons.mood,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
  
  Widget _buildPersonalizedRecommendations(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'For You',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('See All'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        PersonalizedCard(
          subtitle: 'AI Recommendation',
          title: 'Guided Meditation',
          description: 'A 10-minute session to help you find calm',
          icon: Icons.self_improvement,
          gradient: AppColors.wellnessGradient,
          onTap: () => context.push(RouteNames.aiCoach),
        ),
        const SizedBox(height: AppSpacing.md),
        PersonalizedCard(
          subtitle: 'Therapist Suggestion',
          title: 'Schedule a Session',
          description: 'Your therapist has availability this week',
          icon: Icons.psychology,
          gradient: AppColors.primaryGradient,
          onTap: () => context.push(RouteNames.therapistBooking),
        ),
        const SizedBox(height: AppSpacing.md),
        PersonalizedCard(
          subtitle: 'Community',
          title: 'Join a Support Group',
          description: 'Connect with others on similar journeys',
          icon: Icons.people,
          gradient: AppColors.energyGradient,
          onTap: () => context.push(RouteNames.community),
        ),
      ],
    );
  }
  
  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
          childAspectRatio: 1.2,
          children: [
            _QuickActionCard(
              icon: Icons.chat_bubble_outline,
              title: 'AI Chat',
              gradient: AppColors.wellnessGradient,
              onTap: () => context.push(RouteNames.aiChat),
            ),
            _QuickActionCard(
              icon: Icons.psychology,
              title: 'Therapist',
              gradient: AppColors.primaryGradient,
              onTap: () => context.push(RouteNames.therapistBooking),
            ),
            _QuickActionCard(
              icon: Icons.people_outline,
              title: 'Community',
              gradient: AppColors.energyGradient,
              onTap: () => context.push(RouteNames.community),
            ),
            _QuickActionCard(
              icon: Icons.shopping_bag_outlined,
              title: 'Shop',
              gradient: AppColors.calmGradient,
              onTap: () => context.push(RouteNames.shop),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Gradient gradient;
  final VoidCallback onTap;
  
  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.gradient,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return WellnessCard(
      gradient: gradient,
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
