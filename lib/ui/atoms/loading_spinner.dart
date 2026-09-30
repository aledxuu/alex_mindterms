import 'package:flutter/material.dart';

// Atom: a centered spinner. Shown while a Future/Stream has no data yet.
class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
