import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_books_to_read/pages/home/models/book_match/book_match.dart';
import 'package:my_books_to_read/pages/saved_books/models/saved_book.dart';

abstract class SavedBooksRepository {
  Future<QuerySnapshot<Map<String, dynamic>>> fetchSavedBooks({
    int limit,
    DocumentSnapshot? startAfterDocument,
  });
  Future<void> saveBook(SavedBook book);
  Future<void> updateBookTimestamp(String bookId);
  Future<bool> bookExists(String bookId);
  Future<void> removeBook(String bookId);
  SavedBook createSavedBookFromBookMatch(BookMatch book);
}

class SavedBooksRepositoryImpl implements SavedBooksRepository {
  SavedBooksRepositoryImpl({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> _getSavedBooksCollection() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('savedBooks');
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> fetchSavedBooks({
    int limit = 10,
    DocumentSnapshot? startAfterDocument,
  }) async {
    var query = _getSavedBooksCollection()
        .orderBy('savedAt', descending: true)
        .limit(limit);

    if (startAfterDocument != null) {
      query = query.startAfterDocument(startAfterDocument);
    }

    return query.get();
  }

  @override
  Future<void> saveBook(SavedBook book) async {
    await _getSavedBooksCollection().doc(book.id).set(book.toFirestore());
  }

  @override
  Future<void> updateBookTimestamp(String bookId) async {
    await _getSavedBooksCollection().doc(bookId).update({
      'savedAt': Timestamp.now(),
    });
  }

  @override
  Future<bool> bookExists(String bookId) async {
    final user = _auth.currentUser;
    if (user == null) {
      return false;
    }

    final doc = await _getSavedBooksCollection().doc(bookId).get();
    return doc.exists;
  }

  @override
  Future<void> removeBook(String bookId) async {
    await _getSavedBooksCollection().doc(bookId).delete();
  }

  @override
  SavedBook createSavedBookFromBookMatch(BookMatch book) {
    return SavedBook.fromBookMatch(book);
  }
}
