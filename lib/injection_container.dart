import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:my_books_to_read/pages/home/api/search_books_api.dart';
import 'package:my_books_to_read/pages/home/api/trending_books_api.dart';
import 'package:my_books_to_read/pages/home/provider/search_books_provider.dart';
import 'package:my_books_to_read/pages/home/provider/trending_books_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'injection_container.main.dart';
