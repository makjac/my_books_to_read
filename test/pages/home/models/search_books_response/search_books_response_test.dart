import 'package:flutter_test/flutter_test.dart';
import 'package:my_books_to_read/pages/home/models/book_match/book_match.dart';
import 'package:my_books_to_read/pages/home/models/search_books_response/search_books_response.dart';

void main() {
  group('SearchBooksResponse', () {
    test('fromJson should return a valid model', () {
      final json = {
        'numFound': 10,
        'start': 0,
        'numFoundExact': true,
        'num_found': 10,
        'q': 'test query',
        'offset': 0,
        'docs': [
          {
            'title': 'Test Book',
            'author_name': ['Test Author'],
            'first_publish_year': 2020,
          },
        ],
      };

      final response = SearchBooksResponse.fromJson(json);

      expect(response.numFound, 10);
      expect(response.start, 0);
      expect(response.numFoundExact, true);
      expect(response.searchBooksResponseNumFound, 10);
      expect(response.q, 'test query');
      expect(response.offset, 0);
      expect(response.docs.length, 1);
      expect(response.docs.first.title, 'Test Book');
    });

    test('toJson should return a valid json', () {
      const response = SearchBooksResponse(
        numFound: 10,
        start: 0,
        numFoundExact: true,
        searchBooksResponseNumFound: 10,
        q: 'test query',
        offset: 0,
        docs: [
          BookMatch(
            title: 'Test Book',
            authorName: ['Test Author'],
            firstPublishYear: 2020,
          ),
        ],
      );

      final json = response.toJson();

      expect(json['numFound'], 10);
      expect(json['start'], 0);
      expect(json['numFoundExact'], true);
      expect(json['num_found'], 10);
      expect(json['q'], 'test query');
      expect(json['offset'], 0);
      expect((json['docs'] as List<BookMatch>).length, 1);
    });
  });
}
