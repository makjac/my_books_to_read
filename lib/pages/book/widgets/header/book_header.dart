import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_books_to_read/pages/book/models/book.dart';

class BookHeader extends StatelessWidget {
  const BookHeader({required this.book, super.key});

  final Book book;

  String _formatAuthors(List<AuthorElement> authors) {
    final authorKeys =
        authors
            .map(
              (author) =>
                  author.author?.key?.split('/').last ?? 'Unknown Author',
            )
            .toList();
    if (authorKeys.isEmpty) return 'Unknown Author';
    if (authorKeys.length == 1) return authorKeys.first;
    return authorKeys.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Column(
        children: [
          const SizedBox(height: 20),
          _BookCover(coverUrl: book.coverUrl),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              book.title ?? 'Unknown Title',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          if (book.authors != null && book.authors!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                _formatAuthors(book.authors!),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onPrimaryContainer.withValues(alpha: .7),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 4),
          if (book.firstPublishDate != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'First published: ${book.firstPublishDate}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onPrimaryContainer.withValues(alpha: .6),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _BookCover extends StatelessWidget {
  const _BookCover({required this.coverUrl});

  final String coverUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child:
            coverUrl.isNotEmpty
                ? CachedNetworkImage(
                  imageUrl: coverUrl,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                  errorWidget:
                      (context, url, error) =>
                          const Icon(Icons.book, size: 50, color: Colors.grey),
                )
                : const Icon(Icons.book, size: 50, color: Colors.grey),
      ),
    );
  }
}
