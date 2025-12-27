import 'package:flutter/material.dart';
import '../../../core/utils/extensions.dart';

class CrisisScreen extends StatelessWidget {
  const CrisisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crisis Support'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emergency_outlined,
              size: 80,
              color: context.colorScheme.error,
            ),
            const SizedBox(height: 24),
            Text(
              'Crisis Support',
              style: context.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Immediate help and resources',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

