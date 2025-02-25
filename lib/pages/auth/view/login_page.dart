import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:my_books_to_read/core/auth/auth_provider.dart';
import 'package:my_books_to_read/core/router/app_router.dart';
import 'package:my_books_to_read/pages/auth/widgets/auth_widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({required this.onTap, super.key});

  final void Function() onTap;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  Future<void> _handleSignIn() async {
    final email = emailController.text;
    final password = passwordController.text;

    final success = await context.read<AuthProvider>().signIn(email, password);

    if (success && mounted) {
      unawaited(context.router.replaceAll([const DashboardRoute()]));
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
      title: 'Sign in',
      children: [
        const Text(
          'Welcome back!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 40),
        AuthTextField(
          controller: emailController,
          label: 'Email',
          icon: Icons.email,
        ),
        const SizedBox(height: 20),
        AuthTextField(
          controller: passwordController,
          label: 'Password',
          icon: Icons.lock,
          obscureText: true,
        ),
        const SizedBox(height: 30),
        AuthButton(text: 'Sign in', onPressed: _handleSignIn),
        const SizedBox(height: 20),
        AuthToggleLink(
          question: "Don't have an account?",
          actionText: 'Register',
          onTap: widget.onTap,
        ),
      ],
    );
  }
}
