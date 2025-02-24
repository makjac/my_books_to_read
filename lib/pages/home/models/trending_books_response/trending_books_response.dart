import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_books_to_read/pages/home/models/book_match/book_match.dart';

part 'trending_books_response.freezed.dart';
part 'trending_books_response.g.dart';

TrendingBooksResponse trendingBooksResponseFromJson(String str) =>
    TrendingBooksResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String trendingBooksResponseToJson(TrendingBooksResponse data) =>
    json.encode(data.toJson());

@freezed
class TrendingBooksResponse with _$TrendingBooksResponse {
  const factory TrendingBooksResponse({
    @JsonKey(name: 'query') String? query,
    @Default([]) @JsonKey(name: 'works') List<BookMatch> works,
    @JsonKey(name: 'days') int? days,
    @JsonKey(name: 'hours') int? hours,
  }) = _TrendingBooksResponse;

  factory TrendingBooksResponse.fromJson(Map<String, dynamic> json) =>
      _$TrendingBooksResponseFromJson(json);
}
