import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_books_to_read/firebase_options.dart';
import 'package:my_books_to_read/main.dart' as app;
import 'package:my_books_to_read/pages/book/view/book_page.dart';
import 'package:my_books_to_read/pages/home/widgets/button/bookmark_button.dart';
import 'package:my_books_to_read/pages/home/widgets/home_widgets.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  testWidgets('Full app flow test', (WidgetTester tester) async {
    // Start app
    await app.main();
    await tester.pumpAndSettle();

    final savedTab = find.text('Saved');
    expect(savedTab, findsOneWidget);

    //Navigate to Saved screen
    await tester.tap(savedTab);
    await tester.pumpAndSettle();

    // Verify saved screen is loaded
    expect(find.text('Login Required'), findsOneWidget);

    final goToLoginBnt = find.byType(ElevatedButton);
    expect(goToLoginBnt, findsOneWidget);

    // Navigate to login screen
    await tester.tap(goToLoginBnt);
    await tester.pumpAndSettle();

    // Test login flow
    final emailField = find.byType(TextFormField).first;
    final passwordField = find.byType(TextFormField).last;
    final loginButton = find.byType(ElevatedButton);

    await tester.enterText(emailField, 'test@test.test');
    await tester.enterText(passwordField, 'qwe123asd');
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // Verify Saved page is loaded
    expect(find.byIcon(Icons.delete_outline), findsWidgets);

    // Navigate to Home screen
    final homeTab = find.text('Home');
    expect(homeTab, findsOneWidget);
    await tester.tap(homeTab);
    await tester.pumpAndSettle();

    // Toggle theme
    final themeIconBnt = find.byType(BookmarkButton);
    await tester.tap(themeIconBnt.first);
    await tester.pumpAndSettle();
    await tester.tap(themeIconBnt.first);
    await tester.pumpAndSettle();

    // Test search functionality
    final searchField = find.byType(SearchBar);

    await tester.enterText(searchField, 'Harry Potter');
    await tester.pumpAndSettle();

    // Wait for search results
    await tester.pump(const Duration(seconds: 2));

    // Verify search results are displayed
    expect(find.byType(HomeBooksGrid), findsOneWidget);

    // Test book details
    final firstBook = find.byType(CachedNetworkImage).first;
    await tester.tap(firstBook);
    await tester.pumpAndSettle();

    // Verify book details page
    expect(find.byType(BookPage), findsOneWidget);

    // Navigate back
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Test saving a book
    final saveButton = find.byType(BookmarkButton).first;
    await tester.tap(saveButton);
    await tester.pumpAndSettle();
    await tester.tap(themeIconBnt.first);
    await tester.pumpAndSettle();

    // Test logout
    final settingsTab = find.text('Settings');
    expect(settingsTab, findsOneWidget);
    await tester.tap(settingsTab);
    await tester.pumpAndSettle();

    final logoutBnt = find.text('Logout');
    expect(logoutBnt, findsOneWidget);
    await tester.tap(logoutBnt);
    await tester.pumpAndSettle();

    // Verify logout
    expect(find.text('Sign in to your account'), findsOneWidget);
  });
}
