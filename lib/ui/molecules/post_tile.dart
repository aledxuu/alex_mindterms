import 'package:flutter/material.dart';

import '../../models/post.dart';

// Molecule: one row in the posts list (title + one-line body preview).
class PostTile extends StatelessWidget {
  const PostTile({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(post.title),
      subtitle: Text(post.body, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}
