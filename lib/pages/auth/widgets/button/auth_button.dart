import 'package:flutter/material.dart';
import 'package:my_books_to_read/core/auth/auth_provider.dart';
import 'package:provider/provider.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({required this.text, required this.onPressed, super.key});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: authProvider.isLoading ? null : onPressed,
        child:
            authProvider.isLoading
                ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : Text(text),
      ),
    );
  }
}
