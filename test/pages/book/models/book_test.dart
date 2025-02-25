import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_books_to_read/pages/book/models/book.dart' as book_m;

void main() {
  group('Book model tests', () {
    test('Book fromJson and toJson', () {
      const jsonString = '''
      {
        "description": {"type": "/type/text", "value": "A great book"},
        "title": "Book Title",
        "key": "/books/OL123M",
        "authors": [{"author": {"key": "/authors/OL1A"}, "type": {"key": "/type/author_role"}}],
        "covers": [12345],
        "first_publish_date": "2021-01-01"
      }
      ''';

      final book = book_m.bookFromJson(jsonString);

      expect(book.title, 'Book Title');
      expect(book.key, '/books/OL123M');
      expect(book.authors?.first.author?.key, '/authors/OL1A');
      expect(book.covers?.first, 12345);
      expect(book.firstPublishDate, '2021-01-01');
      expect(book.descriptionText, 'A great book');

      final jsonOutput = book_m.bookToJson(book);
      expect(jsonOutput, isNotNull);
    });

    test('Book coverUrl', () {
      const book = book_m.Book(covers: [12345]);
      expect(book.coverUrl, 'https://covers.openlibrary.org/b/id/12345-M.jpg');

      const bookWithoutCovers = book_m.Book();
      expect(bookWithoutCovers.coverUrl, '');
    });

    test('Book descriptionText', () {
      const bookWithDescription = book_m.Book(
        description: book_m.Description(
          type: '/type/text',
          value: 'A great book',
        ),
      );
      expect(bookWithDescription.descriptionText, 'A great book');

      const bookWithoutDescription = book_m.Book();
      expect(bookWithoutDescription.descriptionText, '');
    });
  });

  group('AuthorElement model tests', () {
    test('AuthorElement fromJson and toJson', () {
      const jsonString = '''
      {
        "author": {"key": "/authors/OL1A"},
        "type": {"key": "/type/author_role"}
      }
      ''';

      final authorElement = book_m.AuthorElement.fromJson(
        json.decode(jsonString) as Map<String, dynamic>,
      );

      expect(authorElement.author?.key, '/authors/OL1A');
      expect(authorElement.type?.key, '/type/author_role');

      final jsonOutput = authorElement.toJson();
      expect(jsonOutput, isNotNull);
    });
  });

  group('TypeClass model tests', () {
    test('TypeClass fromJson and toJson', () {
      const jsonString = '{"key": "/type/author_role"}';

      final typeClass = book_m.TypeClass.fromJson(
        json.decode(jsonString) as Map<String, dynamic>,
      );

      expect(typeClass.key, '/type/author_role');

      final jsonOutput = typeClass.toJson();
      expect(jsonOutput, isNotNull);
    });
  });

  group('Description model tests', () {
    test('Description fromJson and toJson', () {
      const jsonString = '{"type": "/type/text", "value": "A great book"}';

      final description = book_m.Description.fromJson(
        json.decode(jsonString) as Map<String, dynamic>,
      );

      expect(description.type, '/type/text');
      expect(description.value, 'A great book');

      final jsonOutput = description.toJson();
      expect(jsonOutput, isNotNull);
    });
  });
}
