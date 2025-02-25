import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_books_to_read/pages/home/models/book_match/book_match.dart';
import 'package:my_books_to_read/pages/saved_books/models/saved_book.dart';

void main() {
  group('SavedBook', () {
    test('fromJson creates a SavedBook from JSON', () {
      final json = {
        'id': '1',
        'title': 'Test Book',
        'authorNames': ['Author 1', 'Author 2'],
        'coverImageUrl': 'http://example.com/cover.jpg',
        'firstPublishYear': 2020,
        'savedAt': '19459200',
      };

      final savedBook = SavedBook.fromJson(json);

      expect(savedBook.id, '1');
      expect(savedBook.title, 'Test Book');
      expect(savedBook.authorNames, ['Author 1', 'Author 2']);
      expect(savedBook.coverImageUrl, 'http://example.com/cover.jpg');
      expect(savedBook.firstPublishYear, 2020);
      expect(savedBook.savedAt, DateTime(1952, 07, 31));
    });

    test('fromBookMatch creates a SavedBook from BookMatch', () {
      const bookMatch = BookMatch(
        key: '/works/1',
        title: 'Test Book',
        authorName: ['Author 1', 'Author 2'],
        coverI: 1234543,
        firstPublishYear: 2020,
      );

      final savedBook = SavedBook.fromBookMatch(bookMatch);

      expect(savedBook.id, '1');
      expect(savedBook.title, 'Test Book');
      expect(savedBook.authorNames, ['Author 1', 'Author 2']);
      expect(
        savedBook.coverImageUrl,
        'https://covers.openlibrary.org/b/id/${bookMatch.coverI}-M.jpg',
      );
      expect(savedBook.firstPublishYear, 2020);
      expect(savedBook.savedAt.isBefore(DateTime.now()), true);
    });

    test('toFirestore converts a SavedBook to Firestore map', () {
      final savedBook = SavedBook(
        id: '1',
        title: 'Test Book',
        authorNames: ['Author 1', 'Author 2'],
        coverImageUrl: 'http://example.com/cover.jpg',
        firstPublishYear: 2020,
        savedAt: DateTime(2021),
      );

      final firestoreMap = savedBook.toFirestore();

      expect(firestoreMap['title'], 'Test Book');
      expect(firestoreMap['authorNames'], ['Author 1', 'Author 2']);
      expect(firestoreMap['coverImageUrl'], 'http://example.com/cover.jpg');
      expect(firestoreMap['firstPublishYear'], 2020);
      expect((firestoreMap['savedAt'] as Timestamp).toDate(), DateTime(2021));
    });
  });
}
