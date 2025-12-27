import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/extensions.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/constants/route_names.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: context.colorScheme.primaryContainer,
                    child: Text(
                      authState.user?.name?.substring(0, 1).toUpperCase() ?? 
                      authState.user?.email.substring(0, 1).toUpperCase() ?? 'U',
                      style: TextStyle(
                        fontSize: 32,
                        color: context.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    authState.user?.name ?? 'User',
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    authState.user?.email ?? '',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Support'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: context.colorScheme.error),
            title: Text(
              'Logout',
              style: TextStyle(color: context.colorScheme.error),
            ),
            onTap: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                context.go(RouteNames.login);
              }
            },
          ),
        ],
      ),
    );
  }
}

