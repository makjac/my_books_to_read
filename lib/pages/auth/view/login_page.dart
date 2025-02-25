import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:my_books_to_read/core/auth/auth_provider.dart';
import 'package:my_books_to_read/core/router/app_router.dart';
import 'package:my_books_to_read/core/theme/theme_extension.dart';
import 'package:my_books_to_read/core/utils/snackbar_utils.dart';
import 'package:my_books_to_read/core/utils/validators.dart';
import 'package:my_books_to_read/pages/auth/widgets/auth_widgets.dart';
import 'package:my_books_to_read/pages/saved_books/provider/saved_books_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({required this.onTap, super.key});

  final void Function() onTap;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await context.read<AuthProvider>().signIn(
        emailController.text,
        passwordController.text,
      );

      if (success && mounted) {
        SnackbarUtils.showSnackBar(context, message: 'Logged in successfully');
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
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
      title: 'Sign In',
      children: [
        const SizedBox(height: 8),
        _WelcomeText(),
        const SizedBox(height: 40),
        _LoginForm(
          formKey: _formKey,
          emailController: emailController,
          passwordController: passwordController,
          isLoading: _isLoading,
          onSignIn: _handleSignIn,
          onSwitchToRegister: widget.onTap,
        ),
      ],
    );
  }
}

class _WelcomeText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Welcome back!',
      textAlign: TextAlign.center,
      style: context.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w500,
        color: context.theme.hintColor,
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.onSignIn,
    required this.onSwitchToRegister,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final VoidCallback onSignIn;
  final VoidCallback onSwitchToRegister;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          AuthTextField(
            controller: emailController,
            label: 'Email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
          ),
          const SizedBox(height: 20),
          AuthTextField(
            controller: passwordController,
            label: 'Password',
            icon: Icons.lock_outline,
            obscureText: true,
            validator: Validators.validatePassword,
          ),
          const SizedBox(height: 30),
          AuthButton(
            text: 'Sign In',
            onPressed: onSignIn,
            isLoading: isLoading,
          ),
          const SizedBox(height: 30),
          AuthToggleLink(
            question: "Don't have an account?",
            actionText: 'Register',
            onTap: onSwitchToRegister,
          ),
        ],
      ),
    );
  }
}
