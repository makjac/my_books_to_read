import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:my_books_to_read/core/widgets/book_thumbnail.dart';
import 'package:my_books_to_read/pages/home/models/trending_books/trending_books.dart';
import 'package:my_books_to_read/pages/home/provider/trending_books_provider.dart';
import 'package:provider/provider.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Books')),
      body: const TrendingBooksGrid(),
    );
  }
}

class TrendingBooksGrid extends StatelessWidget {
  const TrendingBooksGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TrendingBooksProvider>();

    if (provider.books.isEmpty) {
      return TrendingBooksInitialState(provider: provider);
    }

    return TrendingBooksList(
      books: provider.books,
      isLoadingMore: provider.isLoading,
      onLoadMore: provider.fetchTrendingBooks,
    );
  }
}

class TrendingBooksInitialState extends StatelessWidget {
  const TrendingBooksInitialState({required this.provider, super.key});

  final TrendingBooksProvider provider;

  @override
  Widget build(BuildContext context) {
    return provider.isLoading
        ? const Center(child: CircularProgressIndicator())
        : const Center(child: Text('No books found'));
  }
}

class TrendingBooksList extends StatelessWidget {
  const TrendingBooksList({
    required this.books,
    required this.isLoadingMore,
    required this.onLoadMore,
    super.key,
  });

  final List<TrendingBook> books;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = (width / 280).clamp(1, 4).toInt();

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        final metrics = notification.metrics;
        if (metrics.pixels >= metrics.maxScrollExtent - 300 && !isLoadingMore) {
          onLoadMore();
        }
        return false;
      },
      child: GridView.builder(
        itemCount: books.length + (isLoadingMore ? 1 : 0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1.7,
        ),
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) {
          return index >= books.length
              ? const LoadingMoreIndicator()
              : BookThumbnail(book: books[index]);
        },
      ),
    );
  }
}

class LoadingMoreIndicator extends StatelessWidget {
  const LoadingMoreIndicator({super.key});

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
