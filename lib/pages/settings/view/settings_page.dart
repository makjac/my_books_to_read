import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:my_books_to_read/core/auth/auth_provider.dart';
import 'package:my_books_to_read/core/router/app_router.dart';
import 'package:my_books_to_read/core/utils/snackbar_utils.dart';
import 'package:provider/provider.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _handleSignOut(BuildContext context) async {
    final success = await context.read<AuthProvider>().signOut();

    if (success && context.mounted) {
      SnackbarUtils.showSnackBar(context, message: 'Logged out successfully');
      unawaited(context.router.replaceAll([const DashboardRoute()]));
    } else if (context.mounted) {
      final errorMessage = context.read<AuthProvider>().errorMessage;
      SnackbarUtils.showSnackBar(
        context,
        message: errorMessage ?? 'An error occurred',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Settings'),
            Text(context.watch<AuthProvider>().user?.email ?? ''),
            ElevatedButton(
              onPressed: () => context.pushRoute(const AuthRoute()),
              child: const Text('Go to Auth'),
            ),
            ElevatedButton(
              onPressed: () => _handleSignOut(context),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
