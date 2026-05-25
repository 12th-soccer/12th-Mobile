import 'package:twelfth_mobile/features/notice/domain/entities/notice.dart';

abstract interface class INoticeRepository {
  Future<Notice> getNotice(String noticeId);
  Future<void> createNotice(String recruitmentId, String description);
}
