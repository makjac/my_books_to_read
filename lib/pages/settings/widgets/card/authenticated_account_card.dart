import 'package:flutter/material.dart';
import 'package:my_books_to_read/core/auth/auth_provider.dart';
import 'package:my_books_to_read/core/theme/theme_extension.dart';

class AuthenticatedAccountCard extends StatelessWidget {
  const AuthenticatedAccountCard({
    required this.authProvider,
    required this.onSignOut,
    super.key,
  });

  final AuthProvider authProvider;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: context.colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authProvider.user?.displayName ?? 'User',
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        authProvider.user?.email ?? '',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Status: Active',
              style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Divider(height: 24),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: context.colorScheme.errorContainer,
                child: Icon(Icons.logout, color: context.colorScheme.error),
              ),
              title: const Text('Logout'),
              subtitle: const Text('Sign out from your account'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: onSignOut,
            ),
          ],
        ),
      ),
    );
  }
}
