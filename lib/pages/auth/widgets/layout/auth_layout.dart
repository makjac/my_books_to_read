import 'package:flutter/material.dart';
import 'package:my_books_to_read/core/theme/theme_extension.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({required this.title, required this.children, super.key});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: size.height * 0.02),
                _AuthLogo(),
                const SizedBox(height: 16),
                _TitleWithUnderline(title: title),
                SizedBox(height: size.height * 0.03),

                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.auto_stories,
      size: 64,
      color: context.colorScheme.primary,
    );
  }
}

class _TitleWithUnderline extends StatelessWidget {
  const _TitleWithUnderline({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: context.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 40,
          height: 3,
          decoration: BoxDecoration(
            color: context.colorScheme.primary,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}
