import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_books_to_read/pages/home/api/search_books_api.dart';
import 'package:my_books_to_read/pages/home/models/search_books_response/search_books_response.dart';

import 'search_books_api_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late SearchBooksApiImpl searchBooksApi;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    searchBooksApi = SearchBooksApiImpl(dio: mockDio);
  });

  group('SearchBooksApi', () {
    test('returns SearchBooksResponse when the call is successful', () async {
      const query = 'test';
      const offset = 1;
      final responseData = {
        'books': [
          {'title': 'Test Book', 'author': 'Test Author'},
        ],
      };

      when(
        mockDio.get<Map<String, dynamic>>(
          any,
          cancelToken: anyNamed('cancelToken'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );

      final result = await searchBooksApi.call(query: query, offset: offset);

      expect(result, isA<SearchBooksResponse>());
    });

    test('returns null when the call is unsuccessful', () async {
      const query = 'test';
      const offset = 0;

      when(
        mockDio.get<Map<String, dynamic>>(
          any,
          cancelToken: anyNamed('cancelToken'),
        ),
      ).thenAnswer(
        (_) async =>
            Response(statusCode: 404, requestOptions: RequestOptions()),
      );

      final result = await searchBooksApi.call(query: query, offset: offset);

      expect(result, isNull);
    });
  });
}
