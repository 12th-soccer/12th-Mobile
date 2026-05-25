import 'package:twelfth_mobile/features/recruitment/domain/entities/recruitment.dart';
import 'package:twelfth_mobile/features/recruitment/domain/repositories/i_recruitment_repository.dart';

class GetRecruitmentsUseCase {
  final IRecruitmentRepository _repo;
  const GetRecruitmentsUseCase(this._repo);

  Future<List<Recruitment>> call({int page = 0, int size = 10}) =>
      _repo.getRecruitments(page: page, size: size);
}

class GetRecruitmentDetailUseCase {
  final IRecruitmentRepository _repo;
  const GetRecruitmentDetailUseCase(this._repo);

  Future<Recruitment> call(String id) => _repo.getRecruitmentDetail(id);
}

class CreateRecruitmentUseCase {
  final IRecruitmentRepository _repo;
  const CreateRecruitmentUseCase(this._repo);

  Future<void> call(Recruitment recruitment) =>
      _repo.createRecruitment(recruitment);
}
