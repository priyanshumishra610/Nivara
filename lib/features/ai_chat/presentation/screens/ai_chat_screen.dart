import 'package:flutter/material.dart';
import '../../../core/utils/extensions.dart';

class AiChatScreen extends StatelessWidget {
  const AiChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Emotional Support'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 80,
              color: context.colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'AI Emotional Chat',
              style: context.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Get empathetic support anytime',
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

