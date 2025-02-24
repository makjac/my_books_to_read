import 'package:dio/dio.dart';
import 'package:my_books_to_read/core/api/api_config.dart';
import 'package:my_books_to_read/core/utils/logger.dart';
import 'package:my_books_to_read/pages/home/models/book_match/book_match.dart';
import 'package:my_books_to_read/pages/home/models/trending_books_response/trending_books_response.dart';

abstract class TrendingBooksApi {
  Future<List<BookMatch>> call({required int page, int limit});
}

class TrendingBooksApiImpl with ApiConfig implements TrendingBooksApi {
  TrendingBooksApiImpl({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  @override
  Future<List<BookMatch>> call({required int page, int limit = 10}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        trending(page: page, limit: limit),
      );

      if (response.statusCode == 200) {
        return TrendingBooksResponse.fromJson(response.data ?? {}).works;
      }
    } catch (e) {
      Logger.showLog(
        'Error calling trending books API: $e',
        'TrendingBooksApi',
      );
    }

    return [];
  }
}
