import 'package:twelfth_mobile/features/ranking/data/datasources/ranking_remote_datasource.dart';
import 'package:twelfth_mobile/features/ranking/domain/entities/club_detail.dart';
import 'package:twelfth_mobile/features/ranking/domain/entities/club_ranking.dart';
import 'package:twelfth_mobile/features/ranking/domain/repositories/i_ranking_repository.dart';

class RankingRepositoryImpl implements IRankingRepository {
  final IRankingRemoteDataSource _dataSource;
  const RankingRepositoryImpl(this._dataSource);

  @override
  Future<List<ClubRanking>> getRanking() async {
    final models = await _dataSource.getRanking();
    return models
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
}
