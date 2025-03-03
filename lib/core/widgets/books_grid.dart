import 'package:flutter/material.dart';

class BooksGrid<T> extends StatelessWidget {
  const BooksGrid({
    required this.books,
    required this.isLoading,
    required this.itemBuilder,
    super.key,
  });

  final List<T> books;
  final bool isLoading;
  final Widget Function(BuildContext context, int index, T item) itemBuilder;

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
          return itemBuilder(context, index, books[index]);
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
