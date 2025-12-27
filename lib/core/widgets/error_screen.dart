import 'package:flutter/material.dart';
import '../errors/app_exceptions.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class ErrorScreen extends StatelessWidget {
  final AppException error;
  final VoidCallback? onRetry;
  final String? title;
  
  const ErrorScreen({
    required this.error,
    this.onRetry,
    this.title,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getErrorIcon(),
                size: 64,
                color: AppColors.error,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                title ?? _getErrorTitle(),
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                error.message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: AppSpacing.xl),
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  IconData _getErrorIcon() {
    if (error is NetworkException) {
      return Icons.wifi_off;
    } else if (error is AuthenticationException) {
      return Icons.lock_outline;
    } else if (error is AuthorizationException) {
      return Icons.block;
    } else if (error is ServerException) {
      return Icons.cloud_off;
    } else {
      return Icons.error_outline;
    }
  }
  
  String _getErrorTitle() {
    if (error is NetworkException) {
      return 'Connection Error';
    } else if (error is AuthenticationException) {
      return 'Authentication Failed';
    } else if (error is AuthorizationException) {
      return 'Access Denied';
    } else if (error is ServerException) {
      return 'Server Error';
    } else {
      return 'Something Went Wrong';
    }
  }
}

