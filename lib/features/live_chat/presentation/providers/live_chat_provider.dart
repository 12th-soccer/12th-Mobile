import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twelfth_mobile/core/network/api_client.dart';
import 'package:twelfth_mobile/core/network/dio.dart';
import 'package:twelfth_mobile/features/live_chat/data/datasources/live_chat_remote_datasource.dart';
import 'package:twelfth_mobile/features/live_chat/data/datasources/live_chat_socket_datasource.dart';
import 'package:twelfth_mobile/features/live_chat/domain/entities/chat_message.dart';

final _apiClientProvider = Provider<ApiClient>(
  (ref) => DioClient.instance.apiClient,
);

final _liveChatRemoteDataSourceProvider =
    Provider<ILiveChatRemoteDataSource>(
  (ref) => LiveChatRemoteDataSourceImpl(ref.read(_apiClientProvider)),
);

final liveChatSocketProvider = Provider.family<LiveChatSocketDatasource, int>((
  ref,
  matchId,
) {
  final socket = LiveChatSocketDatasource(matchId);
  socket.connect();
  ref.onDispose(socket.dispose);
  return socket;
});

final liveChatConnectionProvider =
    StreamProvider.family<bool, int>((ref, matchId) {
  return ref.watch(liveChatSocketProvider(matchId)).connectionState;
});

class LiveChatMessageNotifier extends FamilyNotifier<List<ChatMessage>, int> {
  @override
  List<ChatMessage> build(int matchId) {
    final socket = ref.watch(liveChatSocketProvider(matchId));
    final sub = socket.messages.listen((message) {
      state = [...state, message];
    });
    ref.onDispose(sub.cancel);

    _loadHistory(matchId);

    return const [];
  }

  Future<void> _loadHistory(int matchId) async {
    try {
      final history =
          await ref.read(_liveChatRemoteDataSourceProvider).getHistory(matchId);

      history.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      final realtime = state;
      final historyIds = history.map((m) => m.chatId).whereType<int>().toSet();
      final newRealtime = realtime
          .where((m) => m.chatId == null || !historyIds.contains(m.chatId))
          .toList();

      state = [...history, ...newRealtime];
    } catch (_) {
    }
  }

  void send(String content) {
    final text = content.trim();
    if (text.isEmpty) return;
    ref.read(liveChatSocketProvider(arg)).send(text);
  }
}

final liveChatMessagesProvider =
    NotifierProvider.family<LiveChatMessageNotifier, List<ChatMessage>, int>(
  LiveChatMessageNotifier.new,
);
