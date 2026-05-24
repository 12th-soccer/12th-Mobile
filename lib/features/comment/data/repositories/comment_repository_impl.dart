import 'package:twelfth_mobile/features/comment/data/datasources/comment_remote_datasource.dart';
import 'package:twelfth_mobile/features/comment/domain/entities/comment.dart';
import 'package:twelfth_mobile/features/comment/domain/repositories/i_comment_repository.dart';

class CommentRepositoryImpl implements ICommentRepository {
  const CommentRepositoryImpl(this._dataSource);
  final ICommentRemoteDataSource _dataSource;

  @override
  Future<List<Comment>> getComments(String noticeId) async {
    final models = await _dataSource.getComments(noticeId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> createComment(String noticeId, String content) =>
      _dataSource.createComment(noticeId, content);
}
