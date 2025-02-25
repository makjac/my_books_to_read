import 'package:flutter_test/flutter_test.dart';
import 'package:my_books_to_read/core/api/api_config.dart';
import 'package:my_books_to_read/pages/home/models/book_match/book_match.dart';

class TestApiConfig with ApiConfig {}

void main() {
  group('BookMatch Tests', () {
    test('fromJson() parses JSON correctly', () {
      final json = {
        'author_key': ['OL123A'],
        'author_name': ['Test Author'],
        'cover_edition_key': 'OL456M',
        'cover_i': 12345,
        'first_publish_year': 2023,
        'key': '/works/OL789W',
        'lending_edition_s': 'OL101L',
        'title': 'Test Book',
      };

      final bookMatch = BookMatch.fromJson(json);

      expect(bookMatch.authorKey, ['OL123A']);
      expect(bookMatch.authorName, ['Test Author']);
      expect(bookMatch.coverEditionKey, 'OL456M');
      expect(bookMatch.coverI, 12345);
      expect(bookMatch.firstPublishYear, 2023);
      expect(bookMatch.key, '/works/OL789W');
      expect(bookMatch.lendingEditionS, 'OL101L');
      expect(bookMatch.title, 'Test Book');
    });

    test('BookMatchX extension methods work correctly', () {
      const bookMatch = BookMatch(key: '/works/OL789W', coverI: 12345);

      expect(
        bookMatch.coverImageUrl,
        'https://covers.openlibrary.org/b/id/12345-M.jpg',
      );
      expect(bookMatch.bookId, 'OL789W');
    });

    test('bookId returns empty string when key is null', () {
      const bookMatch = BookMatch(coverI: 12345);

      expect(bookMatch.bookId, '');
    });
  });
}
