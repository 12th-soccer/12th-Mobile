class Match {
  final int matchId;
  final String? leagueType;
  final DateTime matchDate;
  final String homeTeamName;
  final String awayTeamName;
  final int? homeTeamScore;
  final int? awayTeamScore;
  final int? homeTeamId;
  final int? awayTeamId;
  final String? homeTeamImageUrl;
  final String? awayTeamImageUrl;

  const Match({
    required this.matchId,
    this.leagueType,
    required this.matchDate,
    required this.homeTeamName,
    required this.awayTeamName,
    this.homeTeamScore,
    this.awayTeamScore,
    this.homeTeamId,
    this.awayTeamId,
    this.homeTeamImageUrl,
    this.awayTeamImageUrl,
  });

  bool get isFinished {
    if (homeTeamScore == null || awayTeamScore == null) return false;
    final koreanMatchTime = matchDate.add(Duration(hours: 9));
    final nowKorean = DateTime.now().add(Duration(hours: 9));
    return nowKorean.difference(koreanMatchTime).inMinutes > 130;
  }
}
