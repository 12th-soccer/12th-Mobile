class Comment {
  final int id;
  final String username;
  final String content;
  final DateTime createdAt;

  const Comment({
    required this.id,
    required this.username,
    required this.content,
    required this.createdAt,
  });
}
