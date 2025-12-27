import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import 'wellness_card.dart';

class PersonalizedCard extends StatelessWidget {
  final String title;
  final String description;
  final String? subtitle;
  final IconData icon;
  final Gradient? gradient;
  final VoidCallback? onTap;
  final Widget? trailing;
  
  const PersonalizedCard({
    required this.title,
    required this.description,
    this.subtitle,
    required this.icon,
    this.gradient,
    this.onTap,
    this.trailing,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    return WellnessCard(
      gradient: gradient ?? AppColors.calmGradient,
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (subtitle != null) ...[
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

