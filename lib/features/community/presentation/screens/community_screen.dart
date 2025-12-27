import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../widgets/wellness_card.dart';
import '../../../../widgets/custom_refresh_indicator.dart';
import '../../../../widgets/animated_button.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});
  
  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomRefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            _buildWelcomeCard(context),
            const SizedBox(height: AppSpacing.md),
            _buildPostCard(
              context,
              userName: 'Sarah M.',
              userAvatar: '👩',
              timeAgo: '2h ago',
              content: 'Just completed my first week of daily meditation! Feeling so much more centered and calm. This community has been incredibly supportive. 🙏',
              likes: 24,
              comments: 8,
              hasBadge: true,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildPostCard(
              context,
              userName: 'Michael T.',
              userAvatar: '👨',
              timeAgo: '5h ago',
              content: 'Grateful for this safe space to share. Today was challenging, but I\'m learning to be kinder to myself. Progress, not perfection. 💚',
              likes: 42,
              comments: 15,
              hasBadge: false,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildPostCard(
              context,
              userName: 'Emma L.',
              userAvatar: '👩‍🦰',
              timeAgo: '1d ago',
              content: 'Started journaling again after months. The prompts here are so helpful. Thank you to everyone sharing their journey! ✨',
              likes: 18,
              comments: 6,
              hasBadge: true,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.edit, color: Colors.white),
        label: const Text(
          'Share',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
  
  Widget _buildWelcomeCard(BuildContext context) {
    return WellnessCard(
      gradient: AppColors.wellnessGradient,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.people,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to the Community',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'A safe space to share and grow together',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AnimatedButton(
            label: 'Join a Group',
            icon: Icons.group_add,
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.3),
                Colors.white.withOpacity(0.2),
              ],
            ),
            backgroundColor: Colors.white.withOpacity(0.2),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
  
  Widget _buildPostCard(
    BuildContext context, {
    required String userName,
    required String userAvatar,
    required String timeAgo,
    required String content,
    required int likes,
    required int comments,
    required bool hasBadge,
  }) {
    return WellnessCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  userAvatar,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          userName,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (hasBadge) ...[
                          const SizedBox(width: AppSpacing.xs),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.moodHappy,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.verified,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      timeAgo,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _buildReactionButton(
                context,
                Icons.favorite_outline,
                '$likes',
                AppColors.moodAnxious,
              ),
              const SizedBox(width: AppSpacing.md),
              _buildReactionButton(
                context,
                Icons.chat_bubble_outline,
                '$comments',
                AppColors.textSecondary,
              ),
              const Spacer(),
              _buildReactionButton(
                context,
                Icons.share_outlined,
                'Share',
                AppColors.textSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildReactionButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
