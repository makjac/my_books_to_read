import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:my_books_to_read/core/auth/auth_provider.dart';
import 'package:my_books_to_read/core/router/app_router.dart';
import 'package:my_books_to_read/core/widgets/book_thumbnail.dart';
import 'package:my_books_to_read/core/widgets/books_grid.dart';
import 'package:my_books_to_read/pages/saved_books/models/saved_book.dart';
import 'package:my_books_to_read/pages/saved_books/provider/saved_books_provider.dart';
import 'package:my_books_to_read/pages/saved_books/widget/saved_books_widget.dart';
import 'package:provider/provider.dart';

@RoutePage()
class SavedBooksPage extends StatefulWidget {
  const SavedBooksPage({super.key});

  @override
  State<SavedBooksPage> createState() => _SavedBooksPageState();
}

class _SavedBooksPageState extends State<SavedBooksPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<AuthProvider>().isAuthenticated) {
        context.read<SavedBooksProvider>().loadSavedBooks();
      }
    });
  }

  void _showRemoveDialog(BuildContext context, SavedBook book) {
    showDialog<void>(
      context: context,
      builder: (context) => RemoveBookDialog(book: book),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        final metrics = notification.metrics;
        if (metrics.pixels >= metrics.maxScrollExtent - 300) {
          context.read<SavedBooksProvider>().loadMoreSavedBooks();
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Saved books')),
        body: Selector<AuthProvider, bool>(
          selector: (_, provider) => provider.isAuthenticated,
          builder: (_, isAuthenticated, _) {
            if (!isAuthenticated) return const _NotAuthenticatedView();

            return Consumer<SavedBooksProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.savedBooks.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!provider.isLoading && provider.savedBooks.isEmpty) {
                  return const _EmptySavedBooksView();
                }

                return RefreshIndicator(
                  onRefresh: provider.loadSavedBooks,
                  child: CustomScrollView(
                    slivers: [
                      BooksGrid(
                        books: provider.savedBooks,
                        isLoading: provider.isLoading,
                        itemBuilder:
                            (context, index, book) => BookThumbnail<SavedBook>(
                              item: book,
                              getBookId: (b) => b.id,
                              getCoverImageUrl: (b) => b.coverImageUrl,
                              getTitle: (b) => b.title,
                              getAuthorNames: (b) => b.authorNames,
                              getFirstPublishYear: (b) => b.firstPublishYear,
                              getSavedAt: (b) => b.savedAt,
                              actionBuilder:
                                  (context, savedBook) => SavedBookButton(
                                    onRemove:
                                        () => _showRemoveDialog(
                                          context,
                                          savedBook,
                                        ),
                                  ),
                            ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _NotAuthenticatedView extends StatelessWidget {
  const _NotAuthenticatedView();

  @override
  Widget build(BuildContext context) {
    return EmptyStateView(
      icon: Icons.lock_outline,
      title: 'Login Required',
      description: 'You need to be logged in to view your saved books',
      buttonText: 'Go to Login',
      onPressed: () => AutoRouter.of(context).push(const AuthRoute()),
    );
  }
}

class _EmptySavedBooksView extends StatelessWidget {
  const _EmptySavedBooksView();

  @override
  Widget build(BuildContext context) {
    return EmptyStateView(
      icon: Icons.book_outlined,
      title: 'No saved books',
      description: 'Save books you want to read in the future',
      buttonText: 'Find books',
      onPressed: () => AutoRouter.of(context).replaceAll([const HomeRoute()]),
    );
  }
}
