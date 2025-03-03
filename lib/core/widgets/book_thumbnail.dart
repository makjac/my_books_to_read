import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_books_to_read/core/router/app_router.dart';
import 'package:my_books_to_read/core/theme/theme_extension.dart';

class BookThumbnail<T> extends StatelessWidget {
  const BookThumbnail({
    required this.item,
    required this.getBookId,
    required this.getCoverImageUrl,
    required this.getTitle,
    required this.getAuthorNames,
    required this.getFirstPublishYear,
    required this.actionBuilder,
    this.getSavedAt,
    super.key,
  });

  final T item;
  final String Function(T) getBookId;
  final String? Function(T) getCoverImageUrl;
  final String Function(T) getTitle;
  final List<String> Function(T) getAuthorNames;
  final int? Function(T) getFirstPublishYear;
  final DateTime? Function(T)? getSavedAt;
  final Widget Function(BuildContext context, T item) actionBuilder;

  @override
  Widget build(BuildContext context) {
    final bookId = getBookId(item);
    final coverImageUrl = getCoverImageUrl(item);
    final title = getTitle(item);
    final authorNames = getAuthorNames(item);
    final firstPublishYear = getFirstPublishYear(item);
    final savedAt = getSavedAt?.call(item);

    return GestureDetector(
      onTap: () => context.pushRoute(BookRoute(bookId: bookId)),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BookCover(coverImageUrl: coverImageUrl),
              const SizedBox(width: 16),
              _BookDetails(
                title: title,
                authorNames: authorNames,
                firstPublishYear: firstPublishYear,
                savedAt: savedAt,
              ),
              actionBuilder(context, item),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookCover extends StatelessWidget {
  const _BookCover({this.coverImageUrl});

  final String? coverImageUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: double.infinity,
      child:
          coverImageUrl != null
              ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: coverImageUrl!,
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

class _BookDetails extends StatelessWidget {
  const _BookDetails({
    required this.title,
    required this.authorNames,
    this.firstPublishYear,
    this.savedAt,
  });

  final String title;
  final List<String> authorNames;
  final int? firstPublishYear;
  final DateTime? savedAt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            maxLines: 2,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          if (authorNames.isNotEmpty)
            Text(
              authorNames.first,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.secondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(height: 4),
          if (firstPublishYear != null)
            Text(
              'Publication year: $firstPublishYear',
              style: theme.textTheme.bodySmall,
            ),
          if (savedAt != null) ...[
            const Spacer(),
            Text(
              'Saved at: ${_formatDate(savedAt!.toLocal())}',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-${date.year}';
  }
}
