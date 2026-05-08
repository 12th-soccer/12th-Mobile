import 'package:twelfth_mobile/features/ranking/domain/entities/club_ranking.dart';
import 'package:twelfth_mobile/features/ranking/domain/repositories/i_ranking_repository.dart';

class GetRankingUseCase {
  final IRankingRepository _repository;

  const GetRankingUseCase(this._repository);

  Future<List<ClubRanking>> call(String leagueType, String season) =>
      _repository.getRanking(leagueType, season);
}
