import 'package:flutter_test/flutter_test.dart';
import 'package:my_books_to_read/core/api/api_config.dart';

class ApiConfigTest with ApiConfig {}

void main() {
  late ApiConfigTest apiConfig;

  setUp(() {
    apiConfig = ApiConfigTest();
  });

  group('ApiConfig', () {
    test('search builds correct URL', () {
      final url = apiConfig.search('flutter', offset: 5, limit: 20);
      expect(
        url,
        'https://openlibrary.org/search.json?q=flutter&limit=20&offset=5',
      );
    });

    test('search throws assertion error for empty query', () {
      expect(() => apiConfig.search(''), throwsA(isA<AssertionError>()));
    });

    test('trending builds correct URL', () {
      final url = apiConfig.trending(page: 2, limit: 15);
      expect(
        url,
        'https://openlibrary.org/trending/daily.json?page=2&limit=15',
      );
    });

    test('bookDetails builds correct URL', () {
      final url = apiConfig.bookDetails('OL12345W');
      expect(url, 'https://openlibrary.org/works/OL12345W.json');
    });
  });
}
