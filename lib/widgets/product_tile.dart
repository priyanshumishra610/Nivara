import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import 'wellness_card.dart';

class ProductTile extends StatelessWidget {
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final bool isRecommended;
  final String? aiReason;
  final VoidCallback? onTap;
  
  const ProductTile({
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    this.isRecommended = false,
    this.aiReason,
    this.onTap,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    return WellnessCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      borderRadius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: imageUrl!,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: double.infinity,
                          height: 180,
                          color: AppColors.surface,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        height: 180,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                        ),
                        child: const Icon(
                          Icons.image,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
              ),
              if (isRecommended)
                Positioned(
                  top: AppSpacing.sm,
                  right: AppSpacing.sm,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.energyGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.auto_awesome,
                          size: 14,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'AI',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (aiReason != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.lightbulb_outline,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            aiReason!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.primary,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

