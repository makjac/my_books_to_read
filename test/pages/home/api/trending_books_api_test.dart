import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_books_to_read/core/api/api_config.dart';
import 'package:my_books_to_read/pages/home/api/trending_books_api.dart';
import 'package:my_books_to_read/pages/home/models/trending_books_response/trending_books_response.dart';

import 'trending_books_api_test.mocks.dart';

@GenerateMocks([Dio])
class TestApiConfig with ApiConfig {}

void main() {
  group('ApiConfig Tests', () {
    late TestApiConfig apiConfig;

    setUp(() {
      apiConfig = TestApiConfig();
    });

    test('search method returns correct URL', () {
      const query = 'Harry';
      const limit = 20;
      const offset = 5;

      final url = apiConfig.search(query, limit: limit, offset: offset);

      expect(
        url,
        'https://openlibrary.org/search.json?q=Harry&limit=20&offset=5',
      );
    });

    test('search method throws assertion error on empty query', () {
      expect(() => apiConfig.search(''), throwsAssertionError);
    });

    test('search method throws assertion error on invalid limit', () {
      expect(() => apiConfig.search('test', limit: 0), throwsAssertionError);
    });

    test('search method throws assertion error on invalid offset', () {
      expect(() => apiConfig.search('test', offset: -1), throwsAssertionError);
    });

    test('trending method returns correct URL', () {
      const page = 2;
      const limit = 15;

      final url = apiConfig.trending(page: page, limit: limit);

      expect(
        url,
        'https://openlibrary.org/trending/daily.json?page=2&limit=15',
      );
    });

    test('trending method throws assertion error on invalid page', () {
      expect(() => apiConfig.trending(page: 0), throwsAssertionError);
    });

    test('trending method throws assertion error on invalid limit', () {
      expect(() => apiConfig.trending(limit: 0), throwsAssertionError);
    });

    test('bookDetails method returns correct URL', () {
      const id = 'OL123W';
      final url = apiConfig.bookDetails(id);
      expect(url, 'https://openlibrary.org/works/OL123W.json');
    });
  });

  group('TrendingBooksApi Tests', () {
    late MockDio mockDio;
    late TrendingBooksApiImpl trendingBooksApi;

    setUp(() {
      mockDio = MockDio();
      trendingBooksApi = TrendingBooksApiImpl(dio: mockDio);
    });

    test(
      'call() returns TrendingBooksResponse on successful API call',
      () async {
        final responseData = <String, dynamic>{
          'works': [
            {
              'key': '/works/OL123W',
              'title': 'Test Book',
              'cover_i': 12345,
              'author_name': ['Test Author'],
              'first_publish_year': 2023,
            },
          ],
          'query': '',
          'page': 1,
          'total': 100,
        };

        // Mock response
        when(mockDio.get<Map<String, dynamic>>(any)).thenAnswer(
          (_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(),
          ),
        );

        // Call the API
        final result = await trendingBooksApi.call(page: 1);

        // Verify
        expect(result, isA<TrendingBooksResponse>());
        expect(result?.works.length, 1);
        expect(result?.works[0].title, 'Test Book');
      },
    );

    test('call() returns null on API error', () async {
      // Mock error response
      when(mockDio.get<Map<String, dynamic>>(any)).thenAnswer(
        (_) async =>
            Response(statusCode: 404, requestOptions: RequestOptions()),
      );

      // Call the API
      final result = await trendingBooksApi.call(page: 1);

      // Verify
      expect(result, isNull);
    });
  });
}
