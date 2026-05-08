class PlayerGoal {
  final int playerId;
  final String playerName;
  final int season;
  final String league;
  final int goalCount;

  const PlayerGoal({
    required this.playerId,
    required this.playerName,
    required this.season,
    required this.league,
    required this.goalCount,
  });
}
