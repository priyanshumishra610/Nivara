import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/models/gamification_model.dart';
import '../../data/repositories/gamification_repository.dart';
import '../../../../core/state/providers/app_providers.dart';
import '../../../../core/utils/result.dart';

final gamificationRepositoryProvider = Provider<GamificationRepository>((ref) {
  return GamificationRepositoryImpl(
    ref.read(apiServiceProvider),
    ref.read(cacheServiceProvider),
  );
});

final gamificationStatsProvider = FutureProvider<GamificationStats>((ref) async {
  final repository = ref.read(gamificationRepositoryProvider);
  final result = await repository.getStats();
  return result.fold(
    onSuccess: (stats) => stats,
    onFailure: (error) => throw error,
  );
});

final badgesProvider = FutureProvider<List<Badge>>((ref) async {
  final repository = ref.read(gamificationRepositoryProvider);
  final result = await repository.getBadges();
  return result.fold(
    onSuccess: (badges) => badges,
    onFailure: (error) => throw error,
  );
});

final challengesProvider = FutureProvider<List<Challenge>>((ref) async {
  final repository = ref.read(gamificationRepositoryProvider);
  final result = await repository.getActiveChallenges();
  return result.fold(
    onSuccess: (challenges) => challenges,
    onFailure: (error) => throw error,
  );
});

final leaderboardProvider = FutureProvider<List<LeaderboardEntry>>((ref) async {
  final repository = ref.read(gamificationRepositoryProvider);
  final result = await repository.getLeaderboard();
  return result.fold(
    onSuccess: (entries) => entries,
    onFailure: (error) => throw error,
  );
});

class GamificationScreen extends ConsumerWidget {
  const GamificationScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Achievements'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Stats'),
              Tab(text: 'Badges'),
              Tab(text: 'Challenges'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildStatsTab(context, ref),
            _buildBadgesTab(context, ref),
            _buildChallengesTab(context, ref),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatsTab(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(gamificationStatsProvider);
    final leaderboardAsync = ref.watch(leaderboardProvider);
    
    return RefreshIndicator(
      onRefresh: () => Future.wait([
        ref.refresh(gamificationStatsProvider.future),
        ref.refresh(leaderboardProvider.future),
      ]),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            statsAsync.when(
              data: (stats) => _buildStatsCards(context, stats),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Text('Failed to load stats'),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Leaderboard',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            leaderboardAsync.when(
              data: (entries) => _buildLeaderboard(context, entries),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Text('Failed to load leaderboard'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatsCards(BuildContext context, GamificationStats stats) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                'Total Points',
                '${stats.totalPoints}',
                Icons.stars,
                AppColors.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildStatCard(
                context,
                'Current Streak',
                '${stats.currentStreak}',
                Icons.local_fire_department,
                AppColors.moodHappy,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                'Badges',
                '${stats.badgesUnlocked}',
                Icons.emoji_events,
                AppColors.moodCalm,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildStatCard(
                context,
                'Rank',
                '#${stats.rank}',
                Icons.leaderboard,
                AppColors.secondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: AppSpacing.sm),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLeaderboard(BuildContext context, List<LeaderboardEntry> entries) {
    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: entries.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final entry = entries[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: entry.rank <= 3
                  ? AppColors.moodHappy
                  : AppColors.surface,
              child: Text(
                '${entry.rank}',
                style: TextStyle(
                  color: entry.rank <= 3 ? Colors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(entry.userName),
            trailing: Text(
              '${entry.points} pts',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildBadgesTab(BuildContext context, WidgetRef ref) {
    final badgesAsync = ref.watch(badgesProvider);
    
    return RefreshIndicator(
      onRefresh: () => ref.refresh(badgesProvider.future),
      child: badgesAsync.when(
        data: (badges) => GridView.builder(
          padding: const EdgeInsets.all(AppSpacing.md),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: 0.9,
          ),
          itemCount: badges.length,
          itemBuilder: (context, index) {
            final badge = badges[index];
            return _buildBadgeCard(context, badge);
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Failed to load badges')),
      ),
    );
  }
  
  Widget _buildBadgeCard(BuildContext context, Badge badge) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events,
              size: 48,
              color: badge.isUnlocked
                  ? AppColors.moodHappy
                  : AppColors.textTertiary,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              badge.name,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              badge.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (badge.isUnlocked && badge.unlockedAt != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Unlocked ${_formatDate(badge.unlockedAt!)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.primary,
                  fontSize: 10,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildChallengesTab(BuildContext context, WidgetRef ref) {
    final challengesAsync = ref.watch(challengesProvider);
    
    return RefreshIndicator(
      onRefresh: () => ref.refresh(challengesProvider.future),
      child: challengesAsync.when(
        data: (challenges) => challenges.isEmpty
            ? Center(
                child: Text(
                  'No active challenges',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: challenges.length,
                itemBuilder: (context, index) {
                  return _buildChallengeCard(context, challenges[index]);
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Failed to load challenges')),
      ),
    );
  }
  
  Widget _buildChallengeCard(BuildContext context, Challenge challenge) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    challenge.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (challenge.isCompleted)
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              challenge.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            LinearProgressIndicator(
              value: challenge.progress,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(
                challenge.isCompleted ? AppColors.success : AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${challenge.currentValue} / ${challenge.targetValue}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

