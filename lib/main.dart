import 'package:flutter/material.dart';
import 'package:my_books_to_read/app/app.dart';
import 'package:my_books_to_read/core/theme/theme_provider.dart';
import 'package:my_books_to_read/injection_container.dart' as di;
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ThemeProvider())],
      child: const App(),
    ),
  );
}
