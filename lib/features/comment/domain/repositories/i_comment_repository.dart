import 'package:twelfth_mobile/features/comment/domain/entities/comment.dart';

abstract interface class ICommentRepository {
  Future<List<Comment>> getComments(String noticeId);
  Future<void> createComment(String noticeId, String content);
}
