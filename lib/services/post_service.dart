import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post.dart';

// Placing the order: ask the server for posts. Returns a Future because the
// answer arrives later.
Future<List<Post>> fetchPosts() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'))
      .timeout(const Duration(seconds: 10)); // don't wait forever

  if (response.statusCode != 200) {
    throw Exception('Server replied ${response.statusCode}');
  }

  final list = jsonDecode(response.body) as List<dynamic>;
  return list
      .map((item) => Post.fromJson(item as Map<String, dynamic>))
      .toList();
}
