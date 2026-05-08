import 'package:twelfth_mobile/features/match/domain/entities/match.dart';
import 'package:twelfth_mobile/features/match/domain/entities/match_event.dart';
import 'package:twelfth_mobile/features/match/domain/entities/match_lineup.dart';

abstract interface class IMatchRepository {
  Future<List<Match>> getMatchesByDate(String date, String leagueType);
  Future<Match> getMatchDetail(int matchId);
  Future<List<MatchEvent>> getMatchEvents(int matchId);
  Future<List<MatchLineup>> getMatchLineups(int matchId);
}
