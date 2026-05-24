import 'package:twelfth_mobile/core/network/api_client.dart';
import 'package:twelfth_mobile/core/network/api_endpoints.dart';
import 'package:twelfth_mobile/features/comment/data/models/comment_model.dart';

abstract interface class ICommentRemoteDataSource {
  Future<List<CommentModel>> getComments(String noticeId);
  Future<void> createComment(String noticeId, String content);
}

class CommentRemoteDataSourceImpl implements ICommentRemoteDataSource {
  const CommentRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;

  @override
  Future<List<CommentModel>> getComments(String noticeId) => _apiClient.get(
        ApiEndpoints.commentList(noticeId),
        decoder: (data) => (data as List<dynamic>)
            .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  Future<void> createComment(String noticeId, String content) =>
      _apiClient.postVoid(
        ApiEndpoints.commentCreate(noticeId),
        data: {'content': content},
      );
}
