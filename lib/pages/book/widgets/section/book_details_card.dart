import 'package:flutter/material.dart';
import 'package:my_books_to_read/pages/book/models/book.dart';

class BookDetailsCard extends StatelessWidget {
  const BookDetailsCard({required this.book, super.key});

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
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Details', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              _InfoRow(
                label: 'Book ID',
                value: book.key?.split('/').last ?? 'Unknown',
              ),
              const Divider(),
              _InfoRow(
                label: 'First Published',
                value: book.firstPublishDate ?? 'Unknown',
              ),
              if (book.authors != null && book.authors!.isNotEmpty) ...[
                const Divider(),
                _InfoRow(
                  label: 'Authors',
                  value: _formatAuthors(book.authors!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
