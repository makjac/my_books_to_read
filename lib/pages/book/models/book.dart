import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'book.freezed.dart';
part 'book.g.dart';

Book bookFromJson(String str) =>
    Book.fromJson(json.decode(str) as Map<String, dynamic>);

String bookToJson(Book data) => json.encode(data.toJson());

@freezed
class Book with _$Book {
  const factory Book({
    @JsonKey(name: 'description', fromJson: _parseDescription)
    dynamic description,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'key') String? key,
    @JsonKey(name: 'authors') List<AuthorElement>? authors,
    @JsonKey(name: 'covers') List<int>? covers,
    @JsonKey(name: 'first_publish_date') String? firstPublishDate,
  }) = _Book;

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
}

dynamic _parseDescription(dynamic description) {
  if (description == null) {
    return null;
  }

  if (description is String) {
    return Description(type: '/type/text', value: description);
  } else if (description is Map) {
    return Description.fromJson(description as Map<String, dynamic>);
  }

  return null;
}

extension BookExtension on Book {
  String get coverUrl =>
      covers != null && covers!.isNotEmpty
          ? 'http://covers.openlibrary.org/b/id/${covers?.first}-L.jpg'
          : '';

  String get descriptionText {
    if (description == null) {
      return '';
    }

    if (description is Description) {
      return (description as Description).value ?? '';
    }

    return '';
  }
}

@freezed
class AuthorElement with _$AuthorElement {
  const factory AuthorElement({
    @JsonKey(name: 'author') TypeClass? author,
    @JsonKey(name: 'type') TypeClass? type,
  }) = _AuthorElement;

  factory AuthorElement.fromJson(Map<String, dynamic> json) =>
      _$AuthorElementFromJson(json);
}

@freezed
class TypeClass with _$TypeClass {
  const factory TypeClass({@JsonKey(name: 'key') String? key}) = _TypeClass;

  factory TypeClass.fromJson(Map<String, dynamic> json) =>
      _$TypeClassFromJson(json);
}

@freezed
class Description with _$Description {
  const factory Description({
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'value') String? value,
  }) = _Description;

  factory Description.fromJson(Map<String, dynamic> json) =>
      _$DescriptionFromJson(json);
}
