import 'package:flutter/material.dart';
import 'package:my_books_to_read/core/auth/auth_provider.dart';
import 'package:my_books_to_read/core/utils/snackbar_utils.dart';
import 'package:my_books_to_read/pages/saved_books/provider/saved_books_provider.dart';
import 'package:my_books_to_read/pages/settings/widgets/card/authenticated_account_card.dart';
import 'package:my_books_to_read/pages/settings/widgets/header/section_header.dart';
import 'package:my_books_to_read/pages/settings/widgets/tile/login_tile.dart';
import 'package:provider/provider.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({super.key});

  Future<void> _handleSignOut(BuildContext context) async {
    final success = await context.read<AuthProvider>().signOut();

    if (success && context.mounted) {
      SnackbarUtils.showSnackBar(context, message: 'Logged out successfully');
      await context.read<SavedBooksProvider>().clearState();
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
    final authProvider = context.watch<AuthProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Account'),
        const SizedBox(height: 8),
        if (authProvider.isAuthenticated)
          AuthenticatedAccountCard(
            authProvider: authProvider,
            onSignOut: () => _handleSignOut(context),
          )
        else
          const LoginTile(),
      ],
    );
  }
}
