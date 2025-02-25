import 'package:flutter/material.dart';
import 'package:my_books_to_read/core/auth/auth_provider.dart';
import 'package:my_books_to_read/core/theme/theme_extension.dart';
import 'package:my_books_to_read/core/utils/snackbar_utils.dart';
import 'package:my_books_to_read/injection_container.dart';
import 'package:my_books_to_read/pages/home/models/book_match/book_match.dart';
import 'package:my_books_to_read/pages/saved_books/provider/saved_books_provider.dart';
import 'package:my_books_to_read/pages/saved_books/repository/saved_books_repository.dart';
import 'package:provider/provider.dart';

class BookmarkButton extends StatefulWidget {
  const BookmarkButton({required this.book, super.key});

  final BookMatch book;

  @override
  State<BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton> {
  bool? _isBookSaved;
  bool _isLoading = false;
  bool? _lastAuthStatus;
  SavedBooksProvider? _savedBooksProvider;

  Future<bool> isBookSaved(BookMatch book) async {
    _isLoading = true;
    try {
      final bookId = book.key?.replaceAll('/works/', '') ?? '';
      return locator<SavedBooksRepository>().bookExists(bookId);
    } finally {
      _isLoading = false;
    }
  }

  Future<void> _loadBookState() async {
    setState(() {
      _isLoading = true;
    });
    final exists = await isBookSaved(widget.book);
    if (mounted) {
      setState(() {
        _isBookSaved = exists;
        _isLoading = false;
      });
    }
  }

  void _onSavedBooksChanged() {
    if (context.read<AuthProvider>().isAuthenticated) {
      _loadBookState();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentAuth = context.read<AuthProvider>().isAuthenticated;
    if (_lastAuthStatus == null || _lastAuthStatus != currentAuth) {
      _lastAuthStatus = currentAuth;
      if (currentAuth) {
        _loadBookState();
      } else {
        setState(() {
          _isBookSaved = false;
        });
      }
    }

    final newProvider = Provider.of<SavedBooksProvider>(context, listen: false);
    if (_savedBooksProvider != newProvider) {
      _savedBooksProvider?.removeListener(_onSavedBooksChanged);
      _savedBooksProvider = newProvider;
      _savedBooksProvider!.addListener(_onSavedBooksChanged);
    }
  }

  @override
  void dispose() {
    _savedBooksProvider?.removeListener(_onSavedBooksChanged);
    super.dispose();
  }

  Future<void> toggleIcon() async {
    final bookId = widget.book.key?.replaceAll('/works/', '') ?? '';
    if (_isBookSaved ?? false) {
      await context.read<SavedBooksProvider>().removeBook(bookId);
      if (mounted) {
        setState(() {
          _isBookSaved = false;
        });
        SnackbarUtils.showSnackBar(
          context,
          message: 'Book removed from must-read list',
        );
      }
    } else {
      await context.read<SavedBooksProvider>().saveBook(widget.book);
      if (mounted) {
        setState(() {
          _isBookSaved = true;
        });
        SnackbarUtils.showSnackBar(
          context,
          message: 'Book added to must-read list',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = context.select<AuthProvider, bool>(
      (provider) => provider.isAuthenticated,
    );

    if (!isAuthenticated) {
      return IconButton(
        icon: Icon(
          Icons.star_border,
          color: context.colorScheme.onSurface.withValues(alpha: .5),
        ),
        iconSize: 20,
        onPressed: () {
          SnackbarUtils.showSnackBar(
            context,
            message: 'You need to be logged in to save books',
            isError: true,
          );
        },
      );
    }

    if (_isLoading) {
      return const IconButton(icon: Icon(Icons.star_border), onPressed: null);
    }

    final isBookSaved = _isBookSaved ?? false;

    return IconButton(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder:
            (child, animation) =>
                ScaleTransition(scale: animation, child: child),
        child: Icon(
          isBookSaved ? Icons.star : Icons.star_border,
          key: ValueKey<bool>(isBookSaved),
          color:
              isBookSaved
                  ? context.colorScheme.primary
                  : context.colorScheme.onSurface,
        ),
      ),
      style: IconButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
      tooltip:
          isBookSaved ? 'Remove from must-read list' : 'Add to must-read list',
      iconSize: 20,
      onPressed: toggleIcon,
    );
  }
}
