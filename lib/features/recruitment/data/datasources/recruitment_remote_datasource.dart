import 'package:twelfth_mobile/core/network/api_client.dart';
import 'package:twelfth_mobile/core/network/api_endpoints.dart';
import 'package:twelfth_mobile/features/recruitment/data/models/recruitment_model.dart';
import 'package:twelfth_mobile/features/recruitment/data/models/joined_recruitment_model.dart';

abstract interface class IRecruitmentRemoteDataSource {
  Future<List<RecruitmentModel>> getRecruitments({int page = 0, int size = 10});
  Future<RecruitmentModel> getRecruitmentDetail(String id);
  Future<void> createRecruitment(RecruitmentModel model);
  Future<void> joinRecruitment(String id);
  Future<void> createNoticeRoom(String recruitmentId, String description);
  Future<List<JoinedRecruitmentModel>> getMyJoinedRecruitments();
}

class RecruitmentRemoteDataSourceImpl implements IRecruitmentRemoteDataSource {
  final ApiClient _apiClient;
  const RecruitmentRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<RecruitmentModel>> getRecruitments({
    int page = 0,
    int size = 10,
  }) async {
    return await _apiClient.get(
      ApiEndpoints.recruitments(page: page, size: size, sort: 'createdAt,desc'),
      decoder: (data) {
        final json = data as Map<String, dynamic>;
        final list = json['content'] as List<dynamic>? ?? [];
        return list
            .map((e) => RecruitmentModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  @override
  Future<RecruitmentModel> getRecruitmentDetail(String id) async {
    return await _apiClient.get(
      ApiEndpoints.recruitmentDetail(id),
      decoder: (data) =>
          RecruitmentModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<void> createRecruitment(RecruitmentModel model) async {
    final jsonData = model.toJson();

    await _apiClient.postVoid(
      ApiEndpoints.recruitmentCreate,
      data: jsonData,
    );
  }

  @override
  Future<void> joinRecruitment(String id) async {
    await _apiClient.postVoid(ApiEndpoints.joinRecruitment(id));
  }

  @override
  Future<void> createNoticeRoom(String recruitmentId, String description) async {
    await _apiClient.postVoid(
      ApiEndpoints.noticeCreate(recruitmentId),
      data: {'description': description},
    );
  }

  @override
  Future<List<JoinedRecruitmentModel>> getMyJoinedRecruitments() async {
    return await _apiClient.get(
      ApiEndpoints.myJoinedRecruitments,
      decoder: (data) {
        final list = data as List<dynamic>;
        return list
            .map((e) => JoinedRecruitmentModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }
}
