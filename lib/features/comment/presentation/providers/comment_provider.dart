import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twelfth_mobile/core/network/api_client.dart';
import 'package:twelfth_mobile/core/network/dio.dart';
import 'package:twelfth_mobile/features/comment/data/datasources/comment_remote_datasource.dart';
import 'package:twelfth_mobile/features/comment/data/repositories/comment_repository_impl.dart';
import 'package:twelfth_mobile/features/comment/domain/entities/comment.dart';
import 'package:twelfth_mobile/features/comment/domain/repositories/i_comment_repository.dart';

final _commentApiClientProvider = Provider<ApiClient>(
  (ref) => DioClient.instance.apiClient,
);

final _commentDataSourceProvider = Provider<ICommentRemoteDataSource>(
  (ref) => CommentRemoteDataSourceImpl(ref.read(_commentApiClientProvider)),
);

final commentRepositoryProvider = Provider<ICommentRepository>(
  (ref) => CommentRepositoryImpl(ref.read(_commentDataSourceProvider)),
);

final commentListProvider =
    AsyncNotifierProvider.family<CommentListNotifier, List<Comment>, String>(
  CommentListNotifier.new,
);

class CommentListNotifier
    extends FamilyAsyncNotifier<List<Comment>, String> {
  @override
  Future<List<Comment>> build(String noticeId) =>
      ref.read(commentRepositoryProvider).getComments(noticeId);

  Future<void> submit(String content) async {
    final noticeId = arg;
    await ref.read(commentRepositoryProvider).createComment(noticeId, content);
    ref.invalidateSelf();
    await future;
  }
}
