import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';

class StreakIndicator extends StatelessWidget {
  final int streak;
  final String label;
  final IconData icon;
  final Color? color;
  
  const StreakIndicator({
    required this.streak,
    required this.label,
    this.icon = Icons.local_fire_department,
    this.color,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    final streakColor = color ?? AppColors.moodHappy;
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            streakColor.withOpacity(0.2),
            streakColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: streakColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: streakColor,
            size: 24,
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$streak',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: streakColor,
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
        ],
      ),
    );
  }
}

