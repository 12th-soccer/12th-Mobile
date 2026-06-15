import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:twelfth_mobile/core/network/api_endpoints.dart';
import 'package:twelfth_mobile/core/network/token_storage.dart';
import 'package:twelfth_mobile/features/live_chat/data/models/chat_message_model.dart';

class LiveChatSocketDatasource {
  LiveChatSocketDatasource(this.matchId);

  final int matchId;
  StompClient? _client;
  final _messageController = StreamController<ChatMessageModel>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();

  Stream<ChatMessageModel> get messages => _messageController.stream;

  Stream<bool> get connectionState => _connectionController.stream;

  bool get isConnected => _client?.connected ?? false;

  Future<void> connect() async {
    if (_client != null) return;

    final token = await TokenStorage.instance.getAccessToken();

    _client = StompClient(
      config: StompConfig(
        url: ApiEndpoints.liveChatWebSocket,
        onConnect: _onConnect,
        onDisconnect: (_) => _connectionController.add(false),
        onWebSocketError: (e) {
          debugPrint('[Live Chat] socket error $e');
          _connectionController.add(false);
        },
        onStompError: (f) => debugPrint('Live Chat] stomp error ${f.body}'),
        stompConnectHeaders: token != null
            ? {'Authorization': 'Bearer $token'}
            : null,
        reconnectDelay: const Duration(seconds: 3),
      ),
    );
    _client!.activate();
  }

  void _onConnect(StompFrame frame) {
    _connectionController.add(true);
    _client!.subscribe(
      destination: ApiEndpoints.liveChatSubscribe(matchId),
      callback: (StompFrame frame) {
        final body = frame.body;
        if (body == null || body.isEmpty) return;
        try {
          _messageController.add(ChatMessageModel.fromSocketBody(body));
        } catch (e) {
          debugPrint('[Live Chat] 메시지 파싱 실패 : $e');
        }
      },
    );
  }

  void send(String content) {
    final client = _client;
    if (client == null || !client.connected) return;
    client.send(
      destination: ApiEndpoints.liveChatSend(matchId),
      body: jsonEncode({'content': content}),
    );
  }

  void dispose() {
    _client?.deactivate();
    _client = null;
    _messageController.close();
    _connectionController.close();
  }
}
