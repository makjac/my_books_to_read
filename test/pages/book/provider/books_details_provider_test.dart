import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_books_to_read/pages/book/api/book_details_api.dart';
import 'package:my_books_to_read/pages/book/models/book.dart';
import 'package:my_books_to_read/pages/book/provider/books_details_provider.dart';

import 'books_details_provider_test.mocks.dart';

@GenerateMocks([BookDetailsApi])
void main() {
  group('BooksDetailsProvider', () {
    late BooksDetailsProvider provider;
    late MockBookDetailsApi mockApi;

    setUp(() {
      mockApi = MockBookDetailsApi();
      provider = BooksDetailsProvider(api: mockApi);
    });

    test('initial values are correct', () {
      expect(provider.book, isNull);
      expect(provider.isLoading, isFalse);
      expect(provider.error, isNull);
    });

    test('fetchBook sets book on success', () async {
      const book = Book(key: '1', title: 'Test Book');
      when(mockApi.call('1')).thenAnswer((_) async => book);

      await provider.fetchBook('1');

      expect(provider.book, equals(book));
      expect(provider.isLoading, isFalse);
      expect(provider.error, isNull);
    });

    test('fetchBook sets error on failure', () async {
      when(mockApi.call('1')).thenThrow(Exception('Failed to load book'));

      await provider.fetchBook('1');

      expect(provider.book, isNull);
      expect(provider.isLoading, isFalse);
      expect(provider.error, equals('Exception: Failed to load book'));
    });

    test('clearState resets state', () {
      provider.clearState();

      expect(provider.book, isNull);
      expect(provider.error, isNull);
    });
  });
}
