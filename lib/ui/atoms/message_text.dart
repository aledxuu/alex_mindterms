import 'package:flutter/material.dart';

// Atom: a centered line of text (empty and error messages).
class MessageText extends StatelessWidget {
  const MessageText(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}
