import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class VRMeditationScreen extends StatelessWidget {
  const VRMeditationScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VR Meditation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.vr_off,
              size: 80,
              color: AppColors.primary.withOpacity(0.5),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'VR/AR Experiences',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Text(
                'Immersive meditation and motivational experiences coming soon. This feature will integrate with VR/AR headsets for enhanced wellness experiences.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    const Icon(Icons.construction, size: 48),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Placeholder for VR/AR Integration',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Ready for ARCore/ARKit integration',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
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
}

