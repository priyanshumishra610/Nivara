import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class WellnessAnalyticsScreen extends ConsumerWidget {
  const WellnessAnalyticsScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wellness Analytics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context,
              'Mood Trends',
              Icons.trending_up,
              'Track your emotional patterns over time',
            ),
            const SizedBox(height: AppSpacing.md),
            _buildSection(
              context,
              'Therapy Effectiveness',
              Icons.psychology,
              'See how therapy sessions impact your wellness',
            ),
            const SizedBox(height: AppSpacing.md),
            _buildSection(
              context,
              'App Usage',
              Icons.analytics,
              'Understand your engagement patterns',
            ),
            const SizedBox(height: AppSpacing.md),
            _buildSection(
              context,
              'Insights',
              Icons.lightbulb,
              'AI-powered wellness recommendations',
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSection(
    BuildContext context,
    String title,
    IconData icon,
    String description,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

