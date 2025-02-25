import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_books_to_read/pages/home/api/trending_books_api.dart';
import 'package:my_books_to_read/pages/home/models/book_match/book_match.dart';
import 'package:my_books_to_read/pages/home/models/trending_books_response/trending_books_response.dart';
import 'package:my_books_to_read/pages/home/provider/trending_books_provider.dart';

import 'trending_books_provider_test.mocks.dart';

@GenerateMocks([TrendingBooksApi])
void main() {
  late TrendingBooksProvider provider;
  late MockTrendingBooksApi mockApi;

  setUp(() {
    mockApi = MockTrendingBooksApi();
    provider = TrendingBooksProvider(trendingBooksApi: mockApi);
  });

  group('TrendingBooksProvider', () {
    test('initial values are correct', () {
      expect(provider.page, 1);
      expect(provider.isLoading, false);
      expect(provider.books, <BookMatch>[]);
    });

    test('fetchTrendingBooks updates books and page on success', () async {
      final mockBooks = [const BookMatch(key: '1', title: 'Test Book')];
      when(
        mockApi.call(page: anyNamed('page')),
      ).thenAnswer((_) async => TrendingBooksResponse(works: mockBooks));

      await provider.fetchTrendingBooks();

      expect(provider.books, mockBooks);
      expect(provider.page, 2);
      expect(provider.isLoading, false);
    });

    test('fetchTrendingBooks sets isLoading correctly', () async {
      when(
        mockApi.call(page: anyNamed('page')),
      ).thenAnswer((_) async => const TrendingBooksResponse());

      final future = provider.fetchTrendingBooks();

      expect(provider.isLoading, true);

      await future;

      expect(provider.isLoading, false);
    });

    test('fetchTrendingBooks handles errors gracefully', () async {
      when(
        mockApi.call(page: anyNamed('page')),
      ).thenThrow(Exception('API error'));

      await provider.fetchTrendingBooks();

      expect(provider.books, <BookMatch>[]);
      expect(provider.page, 1);
      expect(provider.isLoading, false);
    });
  });
}
