class ChatMessage {
  final int? chatId;
  final int? userId;
  final String nickname;
  final String? profileImageUrl;
  final String content;
  final DateTime createdAt;

  const ChatMessage({
    this.chatId,
    this.userId,
    required this.nickname,
    this.profileImageUrl,
    required this.content,
    required this.createdAt,
  });
}
