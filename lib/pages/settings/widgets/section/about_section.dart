import 'package:flutter/material.dart';
import 'package:my_books_to_read/core/theme/theme_extension.dart';
import 'package:my_books_to_read/pages/settings/widgets/header/section_header.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'About'),
        const SizedBox(height: 8),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: context.colorScheme.secondaryContainer,
            child: Icon(
              Icons.info_outline,
              color: context.colorScheme.secondary,
            ),
          ),
          title: const Text('Version'),
          subtitle: const Text('1.0.0 (Build 1)'),
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: context.colorScheme.tertiaryContainer,
            child: Icon(
              Icons.privacy_tip_outlined,
              color: context.colorScheme.tertiary,
            ),
          ),
          title: const Text('Privacy Policy'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {},
        ),
      ],
    );
  }
}
