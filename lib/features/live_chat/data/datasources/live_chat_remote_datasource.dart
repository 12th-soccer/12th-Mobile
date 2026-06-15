import 'package:twelfth_mobile/core/network/api_client.dart';
import 'package:twelfth_mobile/core/network/api_endpoints.dart';
import 'package:twelfth_mobile/features/live_chat/data/models/chat_message_model.dart';

abstract interface class ILiveChatRemoteDataSource {
  Future<List<ChatMessageModel>> getHistory(int matchId);
}

class LiveChatRemoteDataSourceImpl implements ILiveChatRemoteDataSource {
  const LiveChatRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;

  @override
  Future<List<ChatMessageModel>> getHistory(int matchId) => _apiClient.get(
        ApiEndpoints.liveChatHistory(matchId),
        decoder: ChatMessageModel.listFromPage,
      );
}
