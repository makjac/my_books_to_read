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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({required this.onTap, super.key});

  final void Function() onTap;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController repeatPasswordController;
  bool _isLoading = false;
  bool _acceptTerms = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    repeatPasswordController = TextEditingController();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptTerms) {
      SnackbarUtils.showSnackBar(
        context,
        message: 'Please accept the Terms and Conditions',
        isError: true,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await context.read<AuthProvider>().signUp(
        emailController.text,
        passwordController.text,
      );

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
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onTermsChanged(bool? value) {
    setState(() {
      _acceptTerms = value ?? false;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Create Account',
      children: [
        const SizedBox(height: 8),
        _RegisterIntroText(),
        const SizedBox(height: 32),
        _RegisterForm(
          formKey: _formKey,
          emailController: emailController,
          passwordController: passwordController,
          repeatPasswordController: repeatPasswordController,
          isLoading: _isLoading,
          acceptTerms: _acceptTerms,
          onTermsChanged: _onTermsChanged,
          onSignUp: _handleSignUp,
          onSwitchToLogin: widget.onTap,
        ),
      ],
    );
  }
}

class _RegisterIntroText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Start your reading journey',
      textAlign: TextAlign.center,
      style: context.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w500,
        color: context.theme.hintColor,
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  const _RegisterForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.repeatPasswordController,
    required this.isLoading,
    required this.acceptTerms,
    required this.onTermsChanged,
    required this.onSignUp,
    required this.onSwitchToLogin,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController repeatPasswordController;
  final bool isLoading;
  final bool acceptTerms;
  final ValueChanged<bool?> onTermsChanged;
  final VoidCallback onSignUp;
  final VoidCallback onSwitchToLogin;

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
          const SizedBox(height: 16),
          AuthTextField(
            controller: passwordController,
            label: 'Password',
            icon: Icons.lock_outline,
            obscureText: true,
            validator: Validators.validatePassword,
          ),
          const SizedBox(height: 16),
          AuthTextField(
            controller: repeatPasswordController,
            label: 'Confirm Password',
            icon: Icons.lock_reset_outlined,
            obscureText: true,
            validator:
                (value) => Validators.validateRepeatPassword(
                  passwordController.text,
                  value,
                ),
          ),
          const SizedBox(height: 30),
          AuthButton(
            text: 'Create Account',
            onPressed: onSignUp,
            isLoading: isLoading,
          ),
          const SizedBox(height: 30),
          AuthToggleLink(
            question: 'Already have an account?',
            actionText: 'Sign In',
            onTap: onSwitchToLogin,
          ),
        ],
      ),
    );
  }
}
