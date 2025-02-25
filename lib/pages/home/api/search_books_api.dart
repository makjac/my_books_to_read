import 'package:dio/dio.dart';
import 'package:my_books_to_read/core/api/api_config.dart';
import 'package:my_books_to_read/pages/home/models/search_books_response/search_books_response.dart';

abstract class SearchBooksApi {
  Future<SearchBooksResponse?> call({
    required String query,
    required int offset,
    int limit,
    CancelToken? cancelToken,
  });
}

class SearchBooksApiImpl with ApiConfig implements SearchBooksApi {
  SearchBooksApiImpl({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  @override
  Future<SearchBooksResponse?> call({
    required String query,
    required int offset,
    int limit = 10,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      search(query, offset: offset, limit: limit),
      cancelToken: cancelToken,
    );

    if (response.statusCode == 200) {
      return SearchBooksResponse.fromJson(response.data ?? {});
    }

    return null;
  }
}
