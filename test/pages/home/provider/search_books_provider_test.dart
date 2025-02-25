import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_books_to_read/pages/home/api/search_books_api.dart';
import 'package:my_books_to_read/pages/home/models/book_match/book_match.dart';
import 'package:my_books_to_read/pages/home/models/search_books_response/search_books_response.dart';
import 'package:my_books_to_read/pages/home/provider/search_books_provider.dart';

import 'search_books_provider_test.mocks.dart';

@GenerateMocks([SearchBooksApi])
void main() {
  late SearchBooksProvider provider;
  late MockSearchBooksApi mockApi;

  setUp(() {
    mockApi = MockSearchBooksApi();
    provider = SearchBooksProvider(searchApi: mockApi);
  });

  group('SearchBooksProvider', () {
    test('initial values are correct', () {
      expect(provider.books, <BookMatch>[]);
      expect(provider.founded, 0);
      expect(provider.query, '');
      expect(provider.isLoading, false);
    });

    test('searchBooks sets loading state and calls API', () async {
      final books = [const BookMatch(title: 'Test Book')];
      when(
        mockApi.call(
          query: anyNamed('query'),
          offset: anyNamed('offset'),
          cancelToken: anyNamed('cancelToken'),
        ),
      ).thenAnswer((_) async => SearchBooksResponse(docs: books, numFound: 1));

      await provider.searchBooks('Test');

      expect(provider.isLoading, false);
      expect(provider.books, books);
      expect(provider.founded, 1);
      expect(provider.query, 'Test');
    });

    test('searchBooks handles empty query', () async {
      await provider.searchBooks('');

      expect(provider.books, <BookMatch>[]);
      expect(provider.founded, 0);
      expect(provider.query, '');
      expect(provider.isLoading, false);
    });

    test('searchMoreBooks appends results', () async {
      final books = [const BookMatch(title: 'Test Book')];
      when(
        mockApi.call(
          query: anyNamed('query'),
          offset: anyNamed('offset'),
          cancelToken: anyNamed('cancelToken'),
        ),
      ).thenAnswer((_) async => SearchBooksResponse(docs: books, numFound: 2));

      await provider.searchBooks('Test');
      await provider.searchMoreBooks();

      expect(provider.books.length, 2);
      expect(provider.founded, 2);
      expect(provider.isLoading, false);
    });

    test('clearState resets provider state', () {
      provider.clearState();

      expect(provider.books, <BookMatch>[]);
      expect(provider.founded, 0);
      expect(provider.query, '');
      expect(provider.isLoading, false);
    });
  });
}
