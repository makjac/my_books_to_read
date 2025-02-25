import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:my_books_to_read/pages/settings/widgets/settings_widget.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: const [
          AccountSection(),
          SizedBox(height: 24),
          AppearanceSection(),
          SizedBox(height: 24),
          AboutSection(),
        ],
      ),
    );
  }
}
