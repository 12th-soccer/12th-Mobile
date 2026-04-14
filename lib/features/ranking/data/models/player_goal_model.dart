import 'package:twelfth_mobile/features/ranking/domain/entities/player_goal.dart';

class PlayerGoalModel {
  final int id;
  final int playerId;
  final String playerName;
  final DateTime matchDate;
  final int goalTime;
  final String? goalType;

  const PlayerGoalModel({
    required this.id,
    required this.playerId,
    required this.playerName,
    required this.matchDate,
    required this.goalTime,
    this.goalType,
  });

  factory PlayerGoalModel.fromJson(Map<String, dynamic> json) =>
      PlayerGoalModel(
        id: json['id'] as int,
        playerId: json['playerId'] as int,
        playerName: json['playerName'] as String,
        matchDate: DateTime.parse(json['matchDate'] as String),
        goalTime: json['goalTime'] as int,
        goalType: json['goalType'] as String?,
      );

  PlayerGoal toEntity() => PlayerGoal(
        id: id,
        playerId: playerId,
        playerName: playerName,
        matchDate: matchDate,
        goalTime: goalTime,
        goalType: goalType,
      );
}
