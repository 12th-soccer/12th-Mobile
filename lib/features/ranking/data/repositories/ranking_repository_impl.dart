import 'package:twelfth_mobile/features/ranking/data/datasources/ranking_remote_datasource.dart';
import 'package:twelfth_mobile/features/ranking/domain/entities/club_detail.dart';
import 'package:twelfth_mobile/features/ranking/domain/entities/club_ranking.dart';
import 'package:twelfth_mobile/features/ranking/domain/entities/player_detail.dart';
import 'package:twelfth_mobile/features/ranking/domain/entities/player_goal.dart';
import 'package:twelfth_mobile/features/ranking/domain/repositories/i_ranking_repository.dart';

class RankingRepositoryImpl implements IRankingRepository {
  final IRankingRemoteDataSource _dataSource;
  const RankingRepositoryImpl(this._dataSource);

  @override
  Future<List<ClubRanking>> getRanking(String leagueType) async {
    final models = await _dataSource.getRanking(leagueType);
    // 승점 내림차순 → 승수 내림차순 정렬 후 순위 부여
    final sorted = [...models]
      ..sort((a, b) {
        final pointDiff = b.point.compareTo(a.point);
        if (pointDiff != 0) return pointDiff;
        return b.win.compareTo(a.win);
      });
    return sorted
        .asMap()
        .entries
        .map((e) => e.value.toEntity(rank: e.key + 1))
        .toList();
  }

  @override
  Future<ClubDetail> getClubDetail(int clubId) async {
    final model = await _dataSource.getClubDetail(clubId);
    return model.toEntity();
  }

  @override
  Future<PlayerDetail> getPlayerDetail(int playerId) =>
      _dataSource.getPlayerDetail(playerId);

  @override
  Future<List<PlayerGoal>> getPlayerGoals(int playerId) =>
      _dataSource.getPlayerGoals(playerId);
}
