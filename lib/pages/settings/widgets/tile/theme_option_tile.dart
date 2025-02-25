import 'package:flutter/material.dart';

class ThemeOptionTile extends StatelessWidget {
  const ThemeOptionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final ThemeMode value;
  final ThemeMode groupValue;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return RadioListTile<ThemeMode>(
      title: Text(title),
      subtitle: Text(subtitle),
      secondary: CircleAvatar(
        backgroundColor: iconColor.withValues(alpha: .2),
        child: Icon(icon, color: iconColor),
      ),
      value: value,
      groupValue: groupValue,
      onChanged: (ThemeMode? newValue) {
        if (newValue != null) {
          onChanged(newValue);
        }
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}
