import 'package:twelfth_mobile/features/comment/domain/entities/comment.dart';

class CommentModel {
  final int id;
  final String username;
  final String content;
  final DateTime createdAt;

  const CommentModel({
    required this.id,
    required this.username,
    required this.content,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: json['id'] as int,
        username: json['username'] as String? ?? '',
        content: json['content'] as String? ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
            DateTime.now(),
      );

  Comment toEntity() => Comment(
        id: id,
        username: username,
        content: content,
        createdAt: createdAt,
      );
}
