// Slide: FutureBuilder = the status board at the burger counter.
// It shows "waiting", "failed" or "ready" depending on what the Future is doing.
// Demonstrates: Future + REST API + the four snapshot states.
import 'package:flutter/material.dart';

import '../../models/post.dart';
import '../../services/post_service.dart';
import '../atoms/loading_spinner.dart';
import '../atoms/message_text.dart';
import '../molecules/error_retry.dart';
import '../organisms/posts_list.dart';

class PostsPage extends StatefulWidget {
  // loadPosts can be swapped in tests, so no real network is needed.
  const PostsPage({super.key, this.loadPosts = fetchPosts});

  final Future<List<Post>> Function() loadPosts;

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    // Place the order ONCE, here. Never call fetchPosts() inside build():
    // build() runs on every rebuild, so each rebuild would place a brand-new
    // order (a new HTTP request) and the status board would flicker forever.
    _postsFuture = widget.loadPosts();
  }

  // Retry = throw away the old order and place a new one.
  void _retry() {
    setState(() {
      // Use { } and not `=>` here. An arrow would RETURN the Future to
      // setState, and Flutter asserts: "setState() callback returned a Future".
      _postsFuture = widget.loadPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(future: _postsFuture, builder: _buildBody);
  }

  // Check the branches in this order: waiting, error, empty, data.
  Widget _buildBody(BuildContext ctx, AsyncSnapshot<List<Post>> snap) {
    if (snap.connectionState == ConnectionState.waiting) {
      return const LoadingSpinner();
    }

    if (snap.hasError) {
      return ErrorRetry(
        message: 'Something went wrong: ${snap.error}',
        onRetry: _retry,
      );
    }

    final posts = snap.data!;
    if (posts.isEmpty) {
      return const MessageText('Nothing here yet');
    }

    return PostsList(posts: posts);
  }
}
