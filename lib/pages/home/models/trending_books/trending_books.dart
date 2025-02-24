import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'trending_books.freezed.dart';
part 'trending_books.g.dart';

TrendingBooksResponse trendingBooksResponseFromJson(String str) =>
    TrendingBooksResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String trendingBooksResponseToJson(TrendingBooksResponse data) =>
    json.encode(data.toJson());

TrendingBook trendingbookFromJson(String str) =>
    TrendingBook.fromJson(json.decode(str) as Map<String, dynamic>);

String trendingBookToJson(TrendingBook data) => json.encode(data.toJson());

@freezed
class TrendingBooksResponse with _$TrendingBooksResponse {
  const factory TrendingBooksResponse({
    @JsonKey(name: 'query') String? query,
    @Default([]) @JsonKey(name: 'works') List<TrendingBook> works,
    @JsonKey(name: 'days') int? days,
    @JsonKey(name: 'hours') int? hours,
  }) = _TrendingBooksResponse;

  factory TrendingBooksResponse.fromJson(Map<String, dynamic> json) =>
      _$TrendingBooksResponseFromJson(json);
}

@freezed
class TrendingBook with _$TrendingBook {
  const factory TrendingBook({
    @JsonKey(name: 'author_key') List<String>? authorKey,
    @JsonKey(name: 'author_name') List<String>? authorName,
    @JsonKey(name: 'cover_edition_key') String? coverEditionKey,
    @JsonKey(name: 'cover_i') int? coverI,
    @JsonKey(name: 'first_publish_year') int? firstPublishYear,
    @JsonKey(name: 'key') String? key,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'availability') Availability? availability,
  }) = _TrendingBook;

  factory TrendingBook.fromJson(Map<String, dynamic> json) =>
      _$TrendingBookFromJson(json);
}

extension TrendingBookX on TrendingBook {
  String get coverImageUrl =>
      'https://covers.openlibrary.org/b/id/$coverI-M.jpg';
}

@freezed
class Availability with _$Availability {
  const factory Availability({
    @JsonKey(name: 'openlibrary_work') String? openlibraryWork,
    @JsonKey(name: 'openlibrary_edition') String? openlibraryEdition,
  }) = _Availability;

  factory Availability.fromJson(Map<String, dynamic> json) =>
      _$AvailabilityFromJson(json);
}
