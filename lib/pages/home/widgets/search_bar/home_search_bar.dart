import 'package:flutter/material.dart';
import 'package:my_books_to_read/core/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class HomeSearchbar extends StatelessWidget implements PreferredSizeWidget {
  const HomeSearchbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(85);

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: SearchBar(
        onChanged: (query) {},
        leading: const Icon(Icons.search),
        hintText: 'Search books',
        constraints: const BoxConstraints(maxHeight: 50),
        trailing: <Widget>[
          Tooltip(
            message: 'Change brightness mode',
            child: IconButton(
              isSelected: themeProvider.themeMode == ThemeMode.dark,
              onPressed: () {
                themeProvider.themeMode =
                    themeProvider.themeMode == ThemeMode.dark
                        ? ThemeMode.light
                        : ThemeMode.dark;
              },
              icon: const Icon(Icons.wb_sunny_outlined),
              selectedIcon: const Icon(Icons.brightness_2_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
