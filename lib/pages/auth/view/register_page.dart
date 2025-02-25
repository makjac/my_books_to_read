import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:my_books_to_read/core/auth/auth_provider.dart';
import 'package:my_books_to_read/core/router/app_router.dart';
import 'package:my_books_to_read/core/utils/snackbar_utils.dart';
import 'package:my_books_to_read/pages/auth/widgets/auth_widgets.dart';
import 'package:my_books_to_read/pages/saved_books/provider/saved_books_provider.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({required this.onTap, super.key});

  final void Function() onTap;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  Future<void> _handleSignUp() async {
    final email = emailController.text;
    final password = passwordController.text;

    final success = await context.read<AuthProvider>().signUp(email, password);

    if (success && mounted) {
      SnackbarUtils.showSnackBar(context, message: 'Registered successfully');
      unawaited(context.router.replaceAll([const DashboardRoute()]));
      await context.read<SavedBooksProvider>().loadSavedBooks();
    } else if (mounted) {
      final errorMessage = context.read<AuthProvider>().errorMessage;
      SnackbarUtils.showSnackBar(
        context,
        message: errorMessage ?? 'An error occurred',
        isError: true,
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Register',
      children: [
        const Text(
          'Create new account',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 40),
        AuthTextField(
          controller: emailController,
          label: 'Email',
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),
        AuthTextField(
          controller: passwordController,
          label: 'Password',
          icon: Icons.lock,
          obscureText: true,
        ),
        const SizedBox(height: 30),
        AuthButton(text: 'Register', onPressed: _handleSignUp),
        const SizedBox(height: 20),
        AuthToggleLink(
          question: 'Already have an account?',
          actionText: 'Sign in',
          onTap: widget.onTap,
        ),
      ],
    );
  }
}
