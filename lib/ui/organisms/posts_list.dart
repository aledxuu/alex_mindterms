import 'package:flutter/material.dart';

import '../../models/post.dart';
import '../molecules/post_tile.dart';

// Organism: the scrolling list of posts.
class PostsList extends StatelessWidget {
  const PostsList({super.key, required this.posts});

  final List<Post> posts;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) => PostTile(post: posts[index]),
    );
  }
}
