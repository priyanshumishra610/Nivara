import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../core/theme/app_colors.dart';

class CustomRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  
  const CustomRefreshIndicator({
    required this.child,
    required this.onRefresh,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      strokeWidth: 3,
      displacement: 40,
      child: child,
    );
  }
}

