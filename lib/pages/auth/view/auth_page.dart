import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:my_books_to_read/pages/auth/view/login_page.dart';
import 'package:my_books_to_read/pages/auth/view/register_page.dart';

@RoutePage()
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true;

  void toggleScreen() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showLoginPage
        ? LoginScreen(onTap: toggleScreen)
        : RegisterScreen(onTap: toggleScreen);
  }
}
