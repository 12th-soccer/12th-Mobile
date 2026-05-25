import 'package:twelfth_mobile/features/recruitment/domain/entities/recruitment.dart';
import 'package:twelfth_mobile/features/recruitment/domain/entities/joined_recruitment.dart';

abstract interface class IRecruitmentRepository {
  Future<List<Recruitment>> getRecruitments({int page = 0, int size = 10});
  Future<Recruitment> getRecruitmentDetail(String id);
  Future<void> createRecruitment(Recruitment recruitment);
  Future<void> joinRecruitment(String id);
  Future<void> createNoticeRoom(String recruitmentId, String description);
  Future<List<JoinedRecruitment>> getMyJoinedRecruitments();
}
