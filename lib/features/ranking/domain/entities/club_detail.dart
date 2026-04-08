class ClubMatch {
  final int matchId;
  final DateTime matchDate;
  final String homeTeamName;
  final String awayTeamName;
  final int? homeTeamScore;
  final int? awayTeamScore;

  const ClubMatch({
    required this.matchId,
    required this.matchDate,
    required this.homeTeamName,
    required this.awayTeamName,
    this.homeTeamScore,
    this.awayTeamScore,
  });

  bool get isFinished => homeTeamScore != null && awayTeamScore != null;
}

class ClubDetail {
  final int clubId;
  final String clubName;
  final String stadiumName;
  final List<ClubMatch> matches;

  const ClubDetail({
    required this.clubId,
    required this.clubName,
    required this.stadiumName,
    required this.matches,
  });

  List<ClubMatch> get pastMatches =>
      matches.where((m) => m.isFinished).toList();

  List<ClubMatch> get upcomingMatches =>
      matches.where((m) => !m.isFinished).toList();
}
