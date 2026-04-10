class Match {
  final int matchId;
  final String? leagueType;
  final DateTime matchDate;
  final String homeTeamName;
  final String awayTeamName;
  final int? homeTeamScore;
  final int? awayTeamScore;

  const Match({
    required this.matchId,
    this.leagueType,
    required this.matchDate,
    required this.homeTeamName,
    required this.awayTeamName,
    this.homeTeamScore,
    this.awayTeamScore,
  });

  bool get isFinished => homeTeamScore != null && awayTeamScore != null;
}
