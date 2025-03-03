import 'package:flutter/material.dart';

class SavedBookButton extends StatelessWidget {
  const SavedBookButton({required this.onRemove, super.key});

  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete_outline),
      onPressed: onRemove,
      tooltip: 'Remove from must-read list',
      iconSize: 25,
    );
  }
}
