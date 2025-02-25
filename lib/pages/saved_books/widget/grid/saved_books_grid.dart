import 'package:flutter/material.dart';
import 'package:my_books_to_read/pages/saved_books/models/saved_book.dart';
import 'package:my_books_to_read/pages/saved_books/provider/saved_books_provider.dart';
import 'package:my_books_to_read/pages/saved_books/widget/Thumbnail/saved_book_thumbnail.dart';
import 'package:my_books_to_read/pages/saved_books/widget/dialog/remove_book_dialog.dart';

class SavedBooksGrid extends StatelessWidget {
  const SavedBooksGrid({
    required this.provider,
    required this.scrollController,
    super.key,
  });

  final SavedBooksProvider provider;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: provider.loadSavedBooks,
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 2,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final savedBook = provider.savedBooks[index];
                return SavedBookThumbnail(
                  savedBook: savedBook,
                  onRemove: () {
                    _showRemoveDialog(context, savedBook);
                  },
                );
                // ignore: require_trailing_commas
              }, childCount: provider.savedBooks.length),
            ),
          ),
          if (provider.isLoading && provider.savedBooks.isNotEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }

  void _showRemoveDialog(BuildContext context, SavedBook book) {
    showDialog<void>(
      context: context,
      builder: (context) => RemoveBookDialog(book: book),
    );
  }
}
