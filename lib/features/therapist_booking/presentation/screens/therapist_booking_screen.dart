import 'package:flutter/material.dart';
import '../../../core/utils/extensions.dart';

class TherapistBookingScreen extends StatelessWidget {
  const TherapistBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Therapist'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.psychology_outlined,
              size: 80,
              color: context.colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Therapist Booking',
              style: context.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Connect with licensed professionals',
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

