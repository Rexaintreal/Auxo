import 'package:flutter/material.dart';

class MyFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MyFloatingActionButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return FloatingActionButton(
      onPressed: onPressed,
      shape: const CircleBorder(),
      backgroundColor: scheme.onSurface, //  follows theme primary
      foregroundColor: scheme.surface, // ensures icon is visible
      child: const Icon(Icons.add, size: 28),
    );
  }
}
