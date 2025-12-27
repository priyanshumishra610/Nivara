import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/connectivity_service.dart';
import '../state/providers/app_providers.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

final connectivityStreamProvider = StreamProvider<bool>((ref) {
  final connectivityService = ref.watch(connectivityServiceProvider);
  return connectivityService.connectivityStream;
});

class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityAsync = ref.watch(connectivityStreamProvider);
    final isConnected = connectivityAsync.value ?? true;
    
    if (isConnected) {
      return const SizedBox.shrink();
    }
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      color: AppColors.warning,
      child: Row(
        children: [
          const Icon(
            Icons.wifi_off,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'No internet connection',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

