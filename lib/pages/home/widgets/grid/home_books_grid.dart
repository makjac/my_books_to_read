import 'package:flutter/material.dart';
import 'package:my_books_to_read/pages/home/models/book_match/book_match.dart';
import 'package:my_books_to_read/pages/home/widgets/thumbnail/book_thumbnail.dart';

class HomeBooksGrid extends StatelessWidget {
  const HomeBooksGrid({
    required this.books,
    required this.isLoading,
    super.key,
  });

  final List<BookMatch> books;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = (width / 280).clamp(1, 4).toInt();

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 16),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          if (index >= books.length) {
            return const _LoadingMoreIndicator();
          }
          return BookThumbnail(book: books[index]);
          // ignore: require_trailing_commas
        }, childCount: books.length + (isLoading ? 1 : 0)),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 2,
        ),
      ),
    );
  }
}

class _LoadingMoreIndicator extends StatelessWidget {
  const _LoadingMoreIndicator();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: CircularProgressIndicator(),
      ),
    );
  }
}
