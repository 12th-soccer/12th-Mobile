import 'dart:convert';

import 'package:twelfth_mobile/features/live_chat/domain/entities/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  const ChatMessageModel({
    super.chatId,
    super.userId,
    required super.nickname,
    super.profileImageUrl,
    required super.content,
    required super.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      chatId: _toInt(json['chatId'] ?? json['id']),
      userId: _toInt(json['userId'] ?? json['senderId']),
      nickname: (json['nickname'] ?? json['senderName'] ?? '익명').toString(),
      profileImageUrl: json['profileImageUrl']?.toString(),
      content: (json['content'] ?? '').toString(),
      createdAt: _parseDate(json['createdAt']),
    );
  }

  static ChatMessageModel fromSocketBody(String body) {
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      return ChatMessageModel.fromJson(decoded);
    }
    throw const FormatException('잘못된 채팅 메시지 형식');
  }

  static List<ChatMessageModel> listFromPage(dynamic data) {
    if (data is! Map<String, dynamic>) return const [];
    final content = data['content'];
    if (content is! List) return const [];
    return content
        .whereType<Map<String, dynamic>>()
        .map(ChatMessageModel.fromJson)
        .toList();
  }

  static int? _toInt(dynamic v) =>
      v is int ? v : (v is String ? int.tryParse(v) : null);

  static DateTime _parseDate(dynamic raw) {
    if (raw is String) {
      final parsed = DateTime.tryParse(raw);
      if (parsed != null) return parsed;
    }
    if (raw is int) {
      return DateTime.fromMillisecondsSinceEpoch(raw);
    }
    return DateTime.now();
  }
}
