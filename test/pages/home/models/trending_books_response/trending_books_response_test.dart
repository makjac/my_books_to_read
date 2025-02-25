import 'package:flutter_test/flutter_test.dart';
import 'package:my_books_to_read/pages/home/models/book_match/book_match.dart';
import 'package:my_books_to_read/pages/home/models/trending_books_response/trending_books_response.dart';

void main() {
  group('TrendingBooksResponse', () {
    test('fromJson should return a valid model', () {
      final json = {
        'query': 'test query',
        'works': [
          {'title': 'Book Title', 'author': 'Author Name'},
        ],
        'days': 7,
        'hours': 5,
      };

      final response = TrendingBooksResponse.fromJson(json);

      expect(response.query, 'test query');
      expect(response.works.length, 1);
      expect(response.works.first.title, 'Book Title');
      expect(response.days, 7);
      expect(response.hours, 5);
    });

    test('toJson should return a valid json', () {
      const response = TrendingBooksResponse(
        query: 'test query',
        works: [BookMatch(title: 'Book Title')],
        days: 7,
        hours: 5,
      );

      final json = response.toJson();

      expect(json['query'], 'test query');
      expect((json['works'] as List<BookMatch>).length, 1);
      expect(json['days'], 7);
      expect(json['hours'], 5);
    });
  });
}
