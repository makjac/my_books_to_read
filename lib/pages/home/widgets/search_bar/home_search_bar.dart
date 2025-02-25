import 'package:flutter/material.dart';
import 'package:my_books_to_read/core/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class HomeSearchbar extends StatefulWidget implements PreferredSizeWidget {
  const HomeSearchbar({required this.onChanged, super.key});

  final ValueChanged<String> onChanged;

  @override
  State<HomeSearchbar> createState() => _HomeSearchbarState();

  @override
  Size get preferredSize => const Size.fromHeight(85);
}

class _HomeSearchbarState extends State<HomeSearchbar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onClear() {
    _controller.clear();
    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: SearchBar(
        controller: _controller,
        onChanged: widget.onChanged,
        leading: const Icon(Icons.search),
        hintText: 'Search books',
        constraints: const BoxConstraints(maxHeight: 50),
        trailing: <Widget>[
          if (_controller.text.isEmpty)
            const ThemeToggeButton()
          else
            IconButton(
              onPressed: _onClear,
              icon: const Icon(Icons.clear),
              tooltip: 'Clear search',
            ),
        ],
      ),
    );
  }
}

class ThemeToggeButton extends StatelessWidget {
  const ThemeToggeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return Tooltip(
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
    );
  }
}
