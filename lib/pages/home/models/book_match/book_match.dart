import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_match.freezed.dart';
part 'book_match.g.dart';

BookMatch bookMatchFromJson(String str) =>
    BookMatch.fromJson(json.decode(str) as Map<String, dynamic>);

String bookMatchToJson(BookMatch data) => json.encode(data.toJson());

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

extension BookMatchX on BookMatch {
  String get coverImageUrl =>
      'https://covers.openlibrary.org/b/id/${coverI}-M.jpg';
}
