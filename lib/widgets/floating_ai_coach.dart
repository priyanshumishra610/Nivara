import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/constants/route_names.dart';

class FloatingAICoach extends StatefulWidget {
  const FloatingAICoach({super.key});
  
  @override
  State<FloatingAICoach> createState() => _FloatingAICoachState();
}

class _FloatingAICoachState extends State<FloatingAICoach>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  bool _isExpanded = false;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    _controller.repeat(reverse: true);
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.stop();
      } else {
        _controller.repeat(reverse: true);
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_isExpanded) _buildQuickActions(context),
          const SizedBox(height: AppSpacing.sm),
          GestureDetector(
            onTap: _toggleExpanded,
            child: RotationTransition(
              turns: _rotationAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: AppColors.wellnessGradient,
                    shape: BoxShape.circle,
                    boxShadow: [AppColors.floatingShadow],
                  ),
                  child: const Icon(
                    Icons.psychology,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuickActions(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppColors.cardShadow],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQuickAction(
            context,
            'Chat with AI',
            Icons.chat_bubble_outline,
            () {
              _toggleExpanded();
              context.push(RouteNames.aiCoach);
            },
          ),
          const Divider(height: 1),
          _buildQuickAction(
            context,
            'Quick Check-in',
            Icons.mood,
            () {
              _toggleExpanded();
              context.push(RouteNames.moodTracker);
            },
          ),
          const Divider(height: 1),
          _buildQuickAction(
            context,
            'Guided Session',
            Icons.headphones,
            () {
              _toggleExpanded();
              context.push(RouteNames.aiCoach);
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuickAction(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

