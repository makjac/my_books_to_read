import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:get_it/get_it.dart';
import 'package:my_books_to_read/core/auth/auth_provider.dart';
import 'package:my_books_to_read/pages/book/api/book_details_api.dart';
import 'package:my_books_to_read/pages/book/provider/books_details_provider.dart';
import 'package:my_books_to_read/pages/home/api/search_books_api.dart';
import 'package:my_books_to_read/pages/home/api/trending_books_api.dart';
import 'package:my_books_to_read/pages/home/provider/search_books_provider.dart';
import 'package:my_books_to_read/pages/home/provider/trending_books_provider.dart';
import 'package:my_books_to_read/pages/saved_books/provider/saved_books_provider.dart';
import 'package:my_books_to_read/pages/saved_books/repository/saved_books_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'injection_container.main.dart';
