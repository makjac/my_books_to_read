import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:my_books_to_read/core/router/app_router.dart';
import 'package:my_books_to_read/core/theme/theme_extension.dart';

class LoginTile extends StatelessWidget {
  const LoginTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: context.colorScheme.primaryContainer,
        child: Icon(Icons.login, color: context.colorScheme.primary),
      ),
      title: const Text('Login'),
      subtitle: const Text('Sign in to your account'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => context.router.push(const AuthRoute()),
    );
  }
}
