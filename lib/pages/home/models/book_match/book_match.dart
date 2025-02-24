import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_match.freezed.dart';
part 'book_match.g.dart';

SearchBooksresponse searchBooksresponseFromJson(String str) =>
    SearchBooksresponse.fromJson(json.decode(str) as Map<String, dynamic>);

String searchBooksresponseToJson(SearchBooksresponse data) =>
    json.encode(data.toJson());

BookMatch bookMatchFromJson(String str) =>
    BookMatch.fromJson(json.decode(str) as Map<String, dynamic>);

String bookMatchToJson(BookMatch data) => json.encode(data.toJson());

@freezed
class SearchBooksresponse with _$SearchBooksresponse {
  const factory SearchBooksresponse({
    @JsonKey(name: 'numFound') int? numFound,
    @JsonKey(name: 'start') int? start,
    @JsonKey(name: 'numFoundExact') bool? numFoundExact,
    @JsonKey(name: 'num_found') int? searchBooksresponseNumFound,
    @JsonKey(name: 'q') String? q,
    @JsonKey(name: 'offset') int? offset,
    @JsonKey(name: 'docs') List<BookMatch>? docs,
  }) = _SearchBooksresponse;

  factory SearchBooksresponse.fromJson(Map<String, dynamic> json) =>
      _$SearchBooksresponseFromJson(json);
}

@freezed
class BookMatch with _$BookMatch {
  const factory BookMatch({
    @JsonKey(name: 'author_key') List<String>? authorKey,
    @JsonKey(name: 'author_name') List<String>? authorName,
    @JsonKey(name: 'cover_edition_key') String? coverEditionKey,
    @JsonKey(name: 'cover_i') int? coverI,
    @JsonKey(name: 'first_publish_year') int? firstPublishYear,
    @JsonKey(name: 'key') String? key,
    @JsonKey(name: 'lending_edition_s') String? lendingEditionS,
    @JsonKey(name: 'title') String? title,
  }) = _BookMatch;

  factory BookMatch.fromJson(Map<String, dynamic> json) =>
      _$BookMatchFromJson(json);
}
