import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_books_to_read/pages/home/models/book_match/book_match.dart';

part 'search_books_response.freezed.dart';
part 'search_books_response.g.dart';

SearchBooksResponse searchBooksResponseFromJson(String str) =>
    SearchBooksResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String searchBooksResponseToJson(SearchBooksResponse data) =>
    json.encode(data.toJson());

@freezed
class SearchBooksResponse with _$SearchBooksResponse {
  const factory SearchBooksResponse({
    @JsonKey(name: 'numFound') int? numFound,
    @JsonKey(name: 'start') int? start,
    @JsonKey(name: 'numFoundExact') bool? numFoundExact,
    @JsonKey(name: 'num_found') int? searchBooksResponseNumFound,
    @JsonKey(name: 'q') String? q,
    @JsonKey(name: 'offset') int? offset,
    @Default([]) @JsonKey(name: 'docs') List<BookMatch> docs,
  }) = _SearchBooksResponse;

  factory SearchBooksResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchBooksResponseFromJson(json);
}
