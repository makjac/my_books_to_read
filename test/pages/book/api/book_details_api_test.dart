import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_books_to_read/pages/book/api/book_details_api.dart';

import 'book_details_api_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late MockDio mockDio;
  late BookDetailsApiImpl bookDetailsApi;

  setUp(() {
    mockDio = MockDio();
    bookDetailsApi = BookDetailsApiImpl(dio: mockDio);
  });

  group('BookDetailsApi', () {
    test('returns a Book if the http call completes successfully', () async {
      const bookId = '1';
      final bookJson = {'key': bookId, 'title': 'Test Book'};

      when(mockDio.get<Map<String, dynamic>>(any)).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          data: bookJson,
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );

      final book = await bookDetailsApi.call(bookId);

      expect(book.key, bookId);
      expect(book.title, 'Test Book');
    });

    test('throws an exception if the http call completes with an error', () {
      const bookId = '1';

      when(mockDio.get<Map<String, dynamic>>(any)).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          statusCode: 404,
          requestOptions: RequestOptions(),
        ),
      );

      expect(bookDetailsApi.call(bookId), throwsException);
    });
  });
}
