import 'package:twelfth_mobile/features/recruitment/data/datasources/recruitment_remote_datasource.dart';
import 'package:twelfth_mobile/features/recruitment/data/models/recruitment_model.dart';
import 'package:twelfth_mobile/features/recruitment/domain/entities/recruitment.dart';
import 'package:twelfth_mobile/features/recruitment/domain/repositories/i_recruitment_repository.dart';

class RecruitmentRepositoryImpl implements IRecruitmentRepository {
  final IRecruitmentRemoteDataSource _dataSource;
  const RecruitmentRepositoryImpl(this._dataSource);

  @override
  Future<List<Recruitment>> getRecruitments({
    int page = 0,
    int size = 10,
  }) async {
    final models = await _dataSource.getRecruitments(page: page, size: size);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Recruitment> getRecruitmentDetail(String id) async {
    final model = await _dataSource.getRecruitmentDetail(id);
    return model.toEntity();
  }

  @override
  Future<void> createRecruitment(Recruitment recruitment) async {
    await _dataSource.createRecruitment(
      RecruitmentModel.fromEntity(recruitment),
    );
  }

  @override
  Future<void> joinRecruitment(String id) =>
      _dataSource.joinRecruitment(id);
}
