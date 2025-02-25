import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_books_to_read/core/theme/theme_extension.dart';
import 'package:my_books_to_read/pages/home/models/book_match/book_match.dart';

class BookThumbnail extends StatelessWidget {
  const BookThumbnail({required this.book, super.key});

  final BookMatch book;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookCover(book: book),
            const SizedBox(width: 16),
            BookDetails(book: book),
            const BookmarkButton(),
          ],
        ),
      ),
    );
  }
}

class BookCover extends StatelessWidget {
  const BookCover({required this.book, super.key});
  final BookMatch book;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: double.infinity,
      child:
          book.coverI != null
              ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: book.coverImageUrl,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                  errorWidget:
                      (context, url, error) => _buildCoverPlaceholder(context),
                ),
              )
              : _buildCoverPlaceholder(context),
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

  final BookMatch book;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            book.title ?? 'Unknown title',
            maxLines: 2,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          if (book.authorName != null && book.authorName!.isNotEmpty)
            Text(
              book.authorName!.first,
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
        ],
      ),
    );
  }
}

class BookmarkButton extends StatelessWidget {
  const BookmarkButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.bookmark_border),
      onPressed: () {},
      tooltip: 'Add to must-read list',
      iconSize: 20,
    );
  }
}
