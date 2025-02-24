import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
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
            final provider = context.read<TrendingBooksProvider>();
            if (!provider.isLoading && provider.books.isNotEmpty) {
              provider.fetchTrendingBooks();
            }
          }
          return false;
        },
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(
              title: Padding(
                padding: EdgeInsets.only(left: 4),
                child: Text('My Books to Read'),
              ),
              pinned: true,
              floating: true,
              automaticallyImplyLeading: false,
              centerTitle: false,
              expandedHeight: 120,
              bottom: HomeSearchbar(),
            ),
            Consumer<TrendingBooksProvider>(
              builder: (context, provider, _) {
                if (provider.books.isEmpty) {
                  return SliverFillRemaining(
                    child:
                        provider.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : const Center(child: Text('No books found')),
                  );
                }

                return HomeBooksGrid(
                  books: provider.books,
                  isLoading: provider.isLoading,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
