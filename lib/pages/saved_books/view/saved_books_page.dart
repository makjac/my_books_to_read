import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:my_books_to_read/core/auth/auth_provider.dart';
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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<AuthProvider>().isAuthenticated) {
        context.read<SavedBooksProvider>().loadSavedBooks();
      }
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<SavedBooksProvider>().loadMoreSavedBooks();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved books')),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          if (!authProvider.isAuthenticated) {
            return const NotAuthenticatedView();
          }

          return Consumer<SavedBooksProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading && provider.savedBooks.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!provider.isLoading && provider.savedBooks.isEmpty) {
                return const EmptySavedBooksView();
              }

              return SavedBooksGrid(
                provider: provider,
                scrollController: _scrollController,
              );
            },
          );
        },
      ),
    );
  }
}
