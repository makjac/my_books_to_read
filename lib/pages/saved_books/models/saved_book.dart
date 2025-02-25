import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_books_to_read/pages/home/models/book_match/book_match.dart';

part 'saved_book.freezed.dart';
part 'saved_book.g.dart';

@freezed
class SavedBook with _$SavedBook {
  const factory SavedBook({
    required String id,
    required String title,
    required List<String> authorNames,
    required String coverImageUrl,
    required DateTime savedAt,
    int? firstPublishYear,
  }) = _SavedBook;

  const SavedBook._();

  factory SavedBook.fromJson(Map<String, dynamic> json) =>
      _$SavedBookFromJson(json);

  factory SavedBook.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;

    return SavedBook(
      id: doc.id,
      title: data['title'] as String? ?? '',
      authorNames: List<String>.from(
        data['authorNames'] as Iterable<dynamic>? ?? [],
      ),
      coverImageUrl: data['coverImageUrl'] as String? ?? '',
      firstPublishYear: data['firstPublishYear'] as int?,
      savedAt: (data['savedAt'] as Timestamp).toDate(),
    );
  }

  factory SavedBook.fromBookMatch(BookMatch book) {
    return SavedBook(
      id: book.bookId,
      title: book.title ?? 'Unknown Title',
      authorNames: book.authorName ?? [],
      coverImageUrl: book.coverI != null ? book.coverImageUrl : '',
      firstPublishYear: book.firstPublishYear,
      savedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'authorNames': authorNames,
      'coverImageUrl': coverImageUrl,
      'firstPublishYear': firstPublishYear,
      'savedAt': Timestamp.fromDate(savedAt),
    };
  }
}
