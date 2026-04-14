import 'package:twelfth_mobile/features/ranking/domain/entities/club_detail.dart';
import 'package:twelfth_mobile/features/ranking/domain/entities/club_ranking.dart';
import 'package:twelfth_mobile/features/ranking/domain/entities/player_detail.dart';
import 'package:twelfth_mobile/features/ranking/domain/entities/player_goal.dart';

abstract interface class IRankingRepository {
  Future<List<ClubRanking>> getRanking(String leagueType);

  Future<ClubDetail> getClubDetail(int clubId);

  Future<PlayerDetail> getPlayerDetail(int playerId);

  Future<List<PlayerGoal>> getPlayerGoals(int playerId);
}
