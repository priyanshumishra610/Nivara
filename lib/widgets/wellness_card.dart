import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';

class WellnessCard extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final bool showShadow;
  final double borderRadius;
  
  const WellnessCard({
    required this.child,
    this.gradient,
    this.backgroundColor,
    this.padding,
    this.onTap,
    this.showShadow = true,
    this.borderRadius = 20,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      decoration: BoxDecoration(
        gradient: gradient,
        color: backgroundColor ?? AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: showShadow ? [AppColors.cardShadow] : null,
      ),
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      child: child,
    );
    
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: card,
      );
    }
    
    return card;
  }
}

