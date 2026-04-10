import 'package:twelfth_mobile/features/match/domain/entities/match.dart';

abstract interface class IMatchRepository {
  Future<List<Match>> getMatchesByDate(String date);

  Future<Match> getMatchDetail(int matchId);
}
