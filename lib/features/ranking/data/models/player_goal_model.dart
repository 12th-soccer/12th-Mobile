import 'package:twelfth_mobile/features/ranking/domain/entities/player_goal.dart';

class PlayerGoalModel {
  final int playerId;
  final String playerName;
  final int season;
  final String league;
  final int goalCount;

  const PlayerGoalModel({
    required this.playerId,
    required this.playerName,
    required this.season,
    required this.league,
    required this.goalCount,
  });

  factory PlayerGoalModel.fromJson(Map<String, dynamic> json) => PlayerGoalModel(
        playerId: json['playerId'] as int,
        playerName: json['playerName'] as String,
        season: json['season'] as int,
        league: json['league'] as String,
        goalCount: json['goalCount'] as int,
      );

  PlayerGoal toEntity() => PlayerGoal(
        playerId: playerId,
        playerName: playerName,
        season: season,
        league: league,
        goalCount: goalCount,
      );
}
