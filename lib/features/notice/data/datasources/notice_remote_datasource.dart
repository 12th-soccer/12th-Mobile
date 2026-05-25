import 'package:twelfth_mobile/core/network/api_client.dart';
import 'package:twelfth_mobile/core/network/api_endpoints.dart';
import 'package:twelfth_mobile/features/notice/data/models/notice_model.dart';

abstract interface class INoticeRemoteDataSource {
  Future<NoticeModel> getNotice(String noticeId);
  Future<void> createNotice(String recruitmentId, String description);
}

class NoticeRemoteDataSourceImpl implements INoticeRemoteDataSource {
  const NoticeRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;

  @override
  Future<NoticeModel> getNotice(String noticeId) => _apiClient.get(
        ApiEndpoints.noticeDetail(noticeId),
        decoder: (data) =>
            NoticeModel.fromJson(data as Map<String, dynamic>),
      );

  @override
  Future<void> createNotice(String recruitmentId, String description) =>
      _apiClient.postVoid(
        ApiEndpoints.noticeCreate(recruitmentId),
        data: {'description': description},
      );
}
