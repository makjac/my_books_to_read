import 'package:flutter/material.dart';
import 'package:my_books_to_read/core/utils/logger.dart';
import 'package:my_books_to_read/pages/home/api/trending_books_api.dart';
import 'package:my_books_to_read/pages/home/models/book_match/book_match.dart';

class TrendingBooksProvider extends ChangeNotifier {
  TrendingBooksProvider({TrendingBooksApi? trendingBooksApi})
    : _trendingBooksApi = trendingBooksApi ?? TrendingBooksApiImpl();

  final TrendingBooksApi _trendingBooksApi;

  int _page = 1;
  bool _isLoading = false;
  final List<BookMatch> _books = [];

  int get page => _page;
  bool get isLoading => _isLoading;
  List<BookMatch> get books => _books;

  Future<void> fetchTrendingBooks() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final newBooks = await _trendingBooksApi.call(page: _page);

      _books.addAll(newBooks?.works ?? []);
      _page++;
    } catch (e) {
      Logger.showLog(
        'Error fetching trending books: $e',
        'TrendingBooksProvider',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
