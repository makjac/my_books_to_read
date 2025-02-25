import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_books_to_read/core/utils/logger.dart';
import 'package:my_books_to_read/pages/home/models/book_match/book_match.dart';
import 'package:my_books_to_read/pages/saved_books/models/saved_book.dart';
import 'package:my_books_to_read/pages/saved_books/repository/saved_books_repository.dart';

class SavedBooksProvider with ChangeNotifier {
  SavedBooksProvider({SavedBooksRepository? repository})
    : _repository = repository ?? SavedBooksRepositoryImpl();

  final SavedBooksRepository _repository;

  List<SavedBook> _savedBooks = [];
  bool _isLoading = false;
  bool _hasMore = true;
  DocumentSnapshot? _lastDocument;
  final int _pageSize = 10;

  List<SavedBook> get savedBooks => _savedBooks;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  Future<void> loadSavedBooks() async {
    if (_isLoading) return;

    _isLoading = true;
    _savedBooks = [];
    _lastDocument = null;
    _hasMore = true;
    notifyListeners();

    try {
      final snapshot = await _repository.fetchSavedBooks(limit: _pageSize);

      if (snapshot.docs.isEmpty) {
        _hasMore = false;
      } else {
        _savedBooks = snapshot.docs.map(SavedBook.fromFirestore).toList();
        _lastDocument = snapshot.docs.last;
      }
    } catch (error) {
      Logger.showLog('Error loading saved books: $error', 'SavedBooksProvider');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreSavedBooks() async {
    if (_isLoading || !_hasMore || _lastDocument == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _repository.fetchSavedBooks(
        limit: _pageSize,
        startAfterDocument: _lastDocument,
      );

      if (snapshot.docs.isEmpty) {
        _hasMore = false;
      } else {
        final newBooks = snapshot.docs.map(SavedBook.fromFirestore).toList();
        _savedBooks.addAll(newBooks);
        _lastDocument = snapshot.docs.last;
      }
    } catch (error) {
      Logger.showLog(
        'Error loading more saved books: $error',
        'SavedBooksProvider',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveBook(BookMatch book) async {
    try {
      final exists = await _repository.bookExists(book.bookId);

      if (exists) {
        await _repository.updateBookTimestamp(book.bookId);
      } else {
        final savedBook = _repository.createSavedBookFromBookMatch(book);
        await _repository.saveBook(savedBook);

        _savedBooks.insert(0, savedBook);
      }

      notifyListeners();
    } catch (error) {
      Logger.showLog('Error saving book: $error', 'SavedBooksProvider');
      throw Exception('Failed to save book: $error');
    }
  }

  Future<void> removeBook(String bookId) async {
    try {
      await _repository.removeBook(bookId);

      _savedBooks.removeWhere((book) => book.id == bookId);
      notifyListeners();
    } catch (error) {
      Logger.showLog('Error removing book: $error', 'SavedBooksProvider');
      throw Exception('Failed to remove book: $error');
    }
  }

  Future<bool> isBookExist(BookMatch book) async {
    return _repository.bookExists(book.bookId);
  }

  Future<void> clearState() async {
    _savedBooks = [];
    _isLoading = false;
    _hasMore = true;
    _lastDocument = null;
    notifyListeners();
  }
}
