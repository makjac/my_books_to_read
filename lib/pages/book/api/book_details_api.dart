import 'package:dio/dio.dart';
import 'package:my_books_to_read/core/api/api_config.dart';
import 'package:my_books_to_read/pages/book/models/book.dart';

abstract class BookDetailsApi {
  Future<Book> call(String id);
}

class BookDetailsApiImpl with ApiConfig implements BookDetailsApi {
  BookDetailsApiImpl({Dio? dio}) : dio = dio ?? Dio();

  final Dio dio;

  @override
  Future<Book> call(String id) async {
    final response = await dio.get<Map<String, dynamic>>(bookDetails(id));

    if (response.statusCode == 200) {
      return Book.fromJson(response.data ?? {});
    } else {
      throw Exception('Failed to load book details');
    }
  }
}
