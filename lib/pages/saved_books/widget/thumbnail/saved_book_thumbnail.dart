import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_books_to_read/core/theme/theme_extension.dart';
import 'package:my_books_to_read/pages/saved_books/models/saved_book.dart';

class SavedBookThumbnail extends StatelessWidget {
  const SavedBookThumbnail({
    required this.savedBook,
    required this.onRemove,
    super.key,
  });

  final SavedBook savedBook;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookCover(book: savedBook),
            const SizedBox(width: 16),
            BookDetails(book: savedBook),
            RemoveBook(onRemove: onRemove),
          ],
        ),
      ),
    );
  }
}

class BookCover extends StatelessWidget {
  const BookCover({required this.book, super.key});

  final SavedBook book;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: book.coverImageUrl,
          fit: BoxFit.cover,
          placeholder:
              (context, url) =>
                  const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => _buildCoverPlaceholder(context),
        ),
      ),
    );
  }

  Widget _buildCoverPlaceholder(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Icon(
          Icons.book,
          size: 48,
          color: context.colorScheme.primary.withValues(alpha: .6),
        ),
      ),
    );
  }
}

class BookDetails extends StatelessWidget {
  const BookDetails({required this.book, super.key});

  final SavedBook book;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            book.title,
            maxLines: 2,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          if (book.authorNames.isNotEmpty)
            Text(
              book.authorNames.first,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.secondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(height: 4),
          if (book.firstPublishYear != null)
            Text(
              'Publication year: ${book.firstPublishYear}',
              style: theme.textTheme.bodySmall,
            ),
          const Spacer(),
          Text(
            'Saved at: ${formatDate(book.savedAt.toLocal())}',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-${date.year}';
  }
}

class RemoveBook extends StatelessWidget {
  const RemoveBook({required this.onRemove, super.key});

  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete_outline),
      onPressed: onRemove,
      tooltip: 'Add to must-read list',
      iconSize: 20,
    );
  }
}
