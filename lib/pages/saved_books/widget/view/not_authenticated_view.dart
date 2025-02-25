import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:my_books_to_read/core/router/app_router.dart';
import 'package:my_books_to_read/core/theme/theme_extension.dart';

class NotAuthenticatedView extends StatelessWidget {
  const NotAuthenticatedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline,
            size: 64,
            color: context.colorScheme.onSurface.withValues(alpha: .5),
          ),
          const SizedBox(height: 16),
          Text(
            'Login Required',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'You need to be logged in to view your saved books',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              AutoRouter.of(context).push(const AuthRoute());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colorScheme.primary,
              foregroundColor: context.colorScheme.onPrimary,
            ),
            child: const Text('Go to Login'),
          ),
        ],
      ),
    );
  }
}
