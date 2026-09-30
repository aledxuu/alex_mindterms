// One blog post from jsonplaceholder.typicode.com/posts.
// The JSON also has a userId; we ignore it because the screen doesn't need it.
class Post {
  const Post({required this.id, required this.title, required this.body});

  final int id;
  final String title;
  final String body;

  // Turns one JSON object (a Map) into a typed Post.
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }
}
