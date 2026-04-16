import 'package:twelfth_mobile/features/ranking/domain/entities/club_detail.dart';
import 'package:twelfth_mobile/features/ranking/domain/repositories/i_ranking_repository.dart';

class GetClubDetailUseCase {
  final IRankingRepository _repository;
  const GetClubDetailUseCase(this._repository);

  Future<ClubDetail> call(int clubId) => _repository.getClubDetail(clubId);
}
