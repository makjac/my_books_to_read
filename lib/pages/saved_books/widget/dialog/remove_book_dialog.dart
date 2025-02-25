import 'package:flutter/material.dart';
import 'package:my_books_to_read/core/theme/theme_extension.dart';
import 'package:my_books_to_read/core/utils/snackbar_utils.dart';
import 'package:my_books_to_read/pages/saved_books/models/saved_book.dart';
import 'package:my_books_to_read/pages/saved_books/provider/saved_books_provider.dart';
import 'package:provider/provider.dart';

class RemoveBookDialog extends StatelessWidget {
  const RemoveBookDialog({required this.book, super.key});

  final SavedBook book;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Remove book', style: context.textTheme.titleLarge),
      content: Text(
        'Are you sure you want to remove "${book.title}" from saved books?',
        style: context.textTheme.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: context.colorScheme.primary,
          ),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => _removeBook(context),
          style: TextButton.styleFrom(
            foregroundColor: context.colorScheme.error,
          ),
          child: const Text('Remove'),
        ),
      ],
    );
  }

  void _removeBook(BuildContext context) {
    Navigator.of(context).pop();
    context.read<SavedBooksProvider>().removeBook(book.id);
    _showUndoSnackBar(context);
  }

  void _showUndoSnackBar(BuildContext context) {
    SnackbarUtils.showSnackBar(
      context,
      message: 'Removed "${book.title}" from saved books',
    );
  }
}
