import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:my_books_to_read/pages/book/models/book.dart';
import 'package:my_books_to_read/pages/book/provider/books_details_provider.dart';
import 'package:my_books_to_read/pages/book/widgets/book_widgets.dart';
import 'package:provider/provider.dart';

@RoutePage()
class BookPage extends StatefulWidget {
  const BookPage({@PathParam('bookId') required this.bookId, super.key});

  final String bookId;

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<BooksDetailsProvider>().fetchBook(widget.bookId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Details'), elevation: 0),
      body: SafeArea(
        child: Consumer<BooksDetailsProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final book = provider.book;

            if (book == null) {
              return const Center(
                child: Text('Book not found', style: TextStyle(fontSize: 18)),
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BookHeader(book: book),
                  if (book.descriptionText.isNotEmpty)
                    BookDescription(description: book.descriptionText),
                  BookDetailsCard(book: book),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
