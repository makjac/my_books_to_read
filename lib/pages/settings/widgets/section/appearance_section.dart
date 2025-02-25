import 'package:flutter/material.dart';
import 'package:my_books_to_read/core/theme/theme_provider.dart';
import 'package:my_books_to_read/pages/settings/widgets/header/section_header.dart';
import 'package:my_books_to_read/pages/settings/widgets/tile/theme_option_tile.dart';
import 'package:provider/provider.dart';

class AppearanceSection extends StatelessWidget {
  const AppearanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Appearance'),
        const SizedBox(height: 8),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(
            children: [
              ThemeOptionTile(
                title: 'System Theme',
                subtitle: 'Follow system settings',
                icon: Icons.settings_brightness,
                iconColor: Colors.purple,
                value: ThemeMode.system,
                groupValue: themeProvider.themeMode,
                onChanged: (newValue) {
                  context.read<ThemeProvider>().themeMode = newValue;
                },
              ),
              const Divider(height: 1, indent: 72),
              ThemeOptionTile(
                title: 'Dark Theme',
                subtitle: 'Reduce eye strain in low light',
                icon: Icons.dark_mode,
                iconColor: Colors.indigo,
                value: ThemeMode.dark,
                groupValue: themeProvider.themeMode,
                onChanged: (newValue) {
                  context.read<ThemeProvider>().themeMode = newValue;
                },
              ),
              const Divider(height: 1, indent: 72),
              ThemeOptionTile(
                title: 'Light Theme',
                subtitle: 'Standard bright appearance',
                icon: Icons.light_mode,
                iconColor: Colors.amber,
                value: ThemeMode.light,
                groupValue: themeProvider.themeMode,
                onChanged: (newValue) {
                  context.read<ThemeProvider>().themeMode = newValue;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
