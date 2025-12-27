import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/models/dashboard_model.dart';
import '../providers/dashboard_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardDataProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emotional Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(dashboardDataProvider),
          ),
        ],
      ),
      body: dashboardAsync.when(
        data: (data) => _buildDashboard(context, data),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: AppSpacing.md),
              Text('Failed to load dashboard'),
              const SizedBox(height: AppSpacing.md),
              ElevatedButton(
                onPressed: () => ref.refresh(dashboardDataProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildDashboard(BuildContext context, DashboardData data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStreakCard(context, data.currentStreak),
          const SizedBox(height: AppSpacing.md),
          _buildMoodChart(context, data.moodHistory),
          const SizedBox(height: AppSpacing.md),
          _buildMetricsGrid(context, data.metrics),
          const SizedBox(height: AppSpacing.md),
          _buildAchievementsSection(context, data.recentAchievements),
        ],
      ),
    );
  }
  
  Widget _buildStreakCard(BuildContext context, int streak) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.local_fire_department,
                color: AppColors.primary,
                size: 32,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$streak',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    'Day Streak',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMoodChart(BuildContext context, List<MoodDataPoint> history) {
    if (history.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Center(
            child: Text(
              'No mood data available',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
      );
    }
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mood Trend',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: history.asMap().entries.map((e) {
                        return FlSpot(
                          e.key.toDouble(),
                          e.value.moodValue,
                        );
                      }).toList(),
                      isCurved: true,
                      color: AppColors.primary,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppColors.primary.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMetricsGrid(BuildContext context, List<WellnessMetric> metrics) {
    if (metrics.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Wellness Metrics',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                childAspectRatio: 1.5,
              ),
              itemCount: metrics.length,
              itemBuilder: (context, index) {
                final metric = metrics[index];
                return _buildMetricCard(context, metric);
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMetricCard(BuildContext context, WellnessMetric metric) {
    final progress = metric.target != null && metric.target! > 0
        ? (metric.value / metric.target!).clamp(0.0, 1.0)
        : 0.0;
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            metric.name,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${metric.value.toStringAsFixed(1)} ${metric.unit}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (metric.target != null) ...[
            const SizedBox(height: AppSpacing.xs),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildAchievementsSection(BuildContext context, List<String> achievements) {
    if (achievements.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Achievements',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            ...achievements.map((achievement) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  const Icon(
                    Icons.emoji_events,
                    color: AppColors.moodHappy,
                    size: 24,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      achievement,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

