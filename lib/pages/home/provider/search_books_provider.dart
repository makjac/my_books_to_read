import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:my_books_to_read/core/utils/logger.dart';
import 'package:my_books_to_read/pages/home/api/search_books_api.dart';
import 'package:my_books_to_read/pages/home/models/book_match/book_match.dart';

class SearchBooksProvider with ChangeNotifier {
  SearchBooksProvider({SearchBooksApi? searchApi})
    : _searchApi = searchApi ?? SearchBooksApiImpl();

  final SearchBooksApi _searchApi;

  final List<BookMatch> _books = [];
  int _founded = 0;
  String _query = '';
  int _offset = 0;
  bool _isLoading = false;
  CancelToken? _cancelToken;

  List<BookMatch> get books => _books;
  int get founded => _founded;
  String get query => _query;
  bool get isLoading => _isLoading;
  String get currentQuery => _query;

  Future<void> searchBooks(String query) async {
    if (query.isEmpty) {
      clearState();
      return;
    }

    if (query == _query) return;

    _cancelToken?.cancel();
    _cancelToken = CancelToken();
    var canceled = false;

    _books.clear();
    _query = query;
    _offset = 0;
    _isLoading = true;
    notifyListeners();

    try {
      final results = await _searchApi.call(
        query: query,
        offset: 0,
        cancelToken: _cancelToken,
      );

      _books
        ..clear()
        ..addAll(results?.docs ?? []);
      _founded = results?.numFound ?? 0;
      _offset++;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        Logger.showLog('Search canceled', 'SearchBooksProvider');
        canceled = true;
      } else {
        Logger.showLog('Error searching books: $e', 'SearchBooksProvider');
      }
    } catch (e) {
      Logger.showLog('Error searching books: $e', 'SearchBooksProvider');
    } finally {
      if (!canceled) {
        _isLoading = false;
      }
      notifyListeners();
    }
  }

  Future<void> searchMoreBooks() async {
    if (_isLoading || _query.isEmpty) return;

    if (_founded <= _books.length) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final newBooks = await _searchApi.call(
        query: _query,
        offset: _offset,
        cancelToken: _cancelToken,
      );

      _books.addAll(newBooks?.docs ?? []);
      _founded = newBooks?.numFound ?? 0;
      _offset++;
    } catch (e) {
      Logger.showLog('Error searching more books: $e', 'SearchBooksProvider');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearState() {
    _cancelToken?.cancel();
    _books.clear();
    _query = '';
    _offset = 0;
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _cancelToken?.cancel();
    super.dispose();
  }
}
