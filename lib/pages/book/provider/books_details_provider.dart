import 'package:flutter/foundation.dart';
import 'package:my_books_to_read/core/utils/logger.dart';
import 'package:my_books_to_read/pages/book/api/book_details_api.dart';
import 'package:my_books_to_read/pages/book/models/book.dart';

class BooksDetailsProvider with ChangeNotifier {
  BooksDetailsProvider({BookDetailsApi? api})
    : _api = api ?? BookDetailsApiImpl();

  final BookDetailsApi _api;

  Book? _book;
  bool _isLoading = false;
  String? _error;

  Book? get book => _book;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchBook(String id) async {
    _book = null;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _book = await _api.call(id);
    } catch (e) {
      Logger.showLog(
        'Error loading book $id details: $e',
        'BooksDetailsProvider',
      );
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearState() {
    _book = null;
    _error = null;
    notifyListeners();
  }
}
