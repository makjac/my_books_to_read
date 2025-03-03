import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:my_books_to_read/core/theme/theme_extension.dart';
import 'package:my_books_to_read/core/widgets/book_thumbnail.dart';
import 'package:my_books_to_read/core/widgets/books_grid.dart';
import 'package:my_books_to_read/pages/home/models/book_match/book_match.dart';
import 'package:my_books_to_read/pages/home/provider/search_books_provider.dart';
import 'package:my_books_to_read/pages/home/provider/trending_books_provider.dart';
import 'package:my_books_to_read/pages/home/widgets/home_widgets.dart';
import 'package:provider/provider.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          final metrics = notification.metrics;
          if (metrics.pixels >= metrics.maxScrollExtent - 300) {
            final searchProvider = context.read<SearchBooksProvider>();
            final trendingProvider = context.read<TrendingBooksProvider>();

            if (searchProvider.query.isEmpty) {
              if (!trendingProvider.isLoading &&
                  trendingProvider.books.isNotEmpty) {
                trendingProvider.fetchTrendingBooks();
              }
            } else {
              if (!searchProvider.isLoading &&
                  searchProvider.books.isNotEmpty) {
                searchProvider.searchMoreBooks();
              }
            }
          }
          return false;
        },
        child: CustomScrollView(
          slivers: [_buildHomeAppBar(context), _buildBooksGrid()],
        ),
      ),
    );
  }

  SliverAppBar _buildHomeAppBar(BuildContext context) {
    return SliverAppBar(
      title: const Padding(
        padding: EdgeInsets.only(left: 4),
        child: Text('My Books to Read'),
      ),
      pinned: true,
      floating: true,
      automaticallyImplyLeading: false,
      centerTitle: false,
      expandedHeight: 120,
      bottom: HomeSearchbar(
        onChanged: (query) {
          context.read<SearchBooksProvider>().searchBooks(query);
        },
      ),
    );
  }

  Consumer<SearchBooksProvider> _buildBooksGrid() {
    return Consumer<SearchBooksProvider>(
      builder: (context, searchProvider, _) {
        if (searchProvider.query.isEmpty) {
          return BooksConsumer<TrendingBooksProvider>(
            getBooks: (provider) => provider.books,
            getIsLoading: (provider) => provider.isLoading,
          );
        } else {
          return BooksConsumer<SearchBooksProvider>(
            getBooks: (provider) => provider.books,
            getIsLoading: (provider) => provider.isLoading,
          );
        }
      },
    );
  }
}

class BooksConsumer<T extends ChangeNotifier> extends StatelessWidget {
  const BooksConsumer({
    required this.getBooks,
    required this.getIsLoading,
    super.key,
  });

  final List<BookMatch> Function(T) getBooks;
  final bool Function(T) getIsLoading;

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, provider, _) {
        final books = getBooks(provider);
        final isLoading = getIsLoading(provider);
        if (books.isEmpty) {
          return SliverFillRemaining(
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : const _EmptyBookList(),
          );
        }

        return BooksGrid(
          books: books,
          isLoading: isLoading,
          itemBuilder:
              (context, index, book) => BookThumbnail<BookMatch>(
                item: book,
                getBookId: (b) => b.bookId,
                getCoverImageUrl: (b) => b.coverImageUrl,
                getTitle: (b) => b.title ?? 'Unknown title',
                getAuthorNames: (b) => b.authorName ?? [],
                getFirstPublishYear: (b) => b.firstPublishYear,
                actionBuilder: (context, book) => BookmarkButton(book: book),
              ),
        );
      },
    );
  }
}

class _EmptyBookList extends StatelessWidget {
  const _EmptyBookList();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: context.colorScheme.onSurface.withValues(alpha: .5),
          ),
          const SizedBox(height: 16),
          Text(
            'No books found',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
