import 'package:flutter/material.dart';

import '../atoms/app_button.dart';

// Molecule: an error message plus a Retry button.
class ErrorRetry extends StatelessWidget {
  const ErrorRetry({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          const SizedBox(height: 12),
          AppButton(label: 'Retry', onPressed: onRetry),
        ],
      ),
    );
  }
}
