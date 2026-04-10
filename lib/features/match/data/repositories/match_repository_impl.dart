import 'package:twelfth_mobile/features/match/data/datasources/match_remote_datasource.dart';
import 'package:twelfth_mobile/features/match/domain/entities/match.dart';
import 'package:twelfth_mobile/features/match/domain/repositories/i_match_repository.dart';

class MatchRepositoryImpl implements IMatchRepository {
  final IMatchRemoteDataSource _dataSource;

  const MatchRepositoryImpl(this._dataSource);

  @override
  Future<List<Match>> getMatchesByDate(String date) async {
    final models = await _dataSource.getMatchesByDate(date);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Match> getMatchDetail(int matchId) async {
    final model = await _dataSource.getMatchDetail(matchId);
    return model.toEntity();
  }
}
