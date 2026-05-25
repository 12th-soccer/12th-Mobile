import 'package:twelfth_mobile/features/notice/data/datasources/notice_remote_datasource.dart';
import 'package:twelfth_mobile/features/notice/domain/entities/notice.dart';
import 'package:twelfth_mobile/features/notice/domain/repositories/i_notice_repository.dart';

class NoticeRepositoryImpl implements INoticeRepository {
  const NoticeRepositoryImpl(this._dataSource);
  final INoticeRemoteDataSource _dataSource;

  @override
  Future<Notice> getNotice(String noticeId) async {
    final model = await _dataSource.getNotice(noticeId);
    return model.toEntity();
  }

  @override
  Future<void> createNotice(String recruitmentId, String description) =>
      _dataSource.createNotice(recruitmentId, description);
}
