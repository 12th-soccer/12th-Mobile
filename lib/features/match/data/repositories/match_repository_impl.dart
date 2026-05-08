import 'package:twelfth_mobile/features/match/data/datasources/match_remote_datasource.dart';
import 'package:twelfth_mobile/features/match/domain/entities/match.dart';
import 'package:twelfth_mobile/features/match/domain/entities/match_event.dart';
import 'package:twelfth_mobile/features/match/domain/entities/match_lineup.dart';
import 'package:twelfth_mobile/features/match/domain/repositories/i_match_repository.dart';

class MatchRepositoryImpl implements IMatchRepository {
  final IMatchRemoteDataSource _dataSource;

  const MatchRepositoryImpl(this._dataSource);

  @override
  Future<List<Match>> getMatchesByDate(String date, String leagueType) async {
    final models = await _dataSource.getMatchesByDate(date, leagueType);
    final matches = models.map((m) => m.toEntity()).toList();
    final requestedDate = DateTime.tryParse(date);

    if (requestedDate == null) return matches;

    final targetDate = DateTime(
      requestedDate.year,
      requestedDate.month,
      requestedDate.day,
    );

    return matches.where((match) {
      if (!_isSameDate(match.matchDate.toLocal(), targetDate)) return false;
      final lt = match.leagueType?.toLowerCase();
      if (lt == null) return true;
      return leagueType == 'K2'
          ? lt.contains('kleague2') || lt == 'k2'
          : lt.contains('kleague1') || lt == 'k1';
    }).toList();
  }

  @override
  Future<Match> getMatchDetail(int matchId) async {
    final model = await _dataSource.getMatchDetail(matchId);
    return model.toEntity();
  }

  @override
  Future<List<MatchEvent>> getMatchEvents(int matchId) async {
    final models = await _dataSource.getMatchEvents(matchId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<MatchLineup>> getMatchLineups(int matchId) async {
    final models = await _dataSource.getMatchLineups(matchId);
    return models.map((m) => m.toEntity()).toList();
  }

  bool _isSameDate(DateTime lhs, DateTime rhs) {
    return lhs.year == rhs.year && lhs.month == rhs.month && lhs.day == rhs.day;
  }
}
