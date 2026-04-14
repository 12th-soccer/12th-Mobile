class PlayerGoal {
  final int id;
  final int playerId;
  final String playerName;
  final DateTime matchDate;
  final int goalTime;
  final String? goalType;

  const PlayerGoal({
    required this.id,
    required this.playerId,
    required this.playerName,
    required this.matchDate,
    required this.goalTime,
    this.goalType,
  });
}
