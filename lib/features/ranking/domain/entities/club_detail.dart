class ClubMatch {
  final int matchId;
  final DateTime matchDate;
  final String homeTeamName;
  final String awayTeamName;
  final int? homeTeamScore;
  final int? awayTeamScore;
  final int? homeTeamId;
  final int? awayTeamId;
  final String? homeTeamImageUrl;
  final String? awayTeamImageUrl;
  final String? matchStatus;

  const ClubMatch({
    required this.matchId,
    required this.matchDate,
    required this.homeTeamName,
    required this.awayTeamName,
    this.homeTeamScore,
    this.awayTeamScore,
    this.homeTeamId,
    this.awayTeamId,
    this.homeTeamImageUrl,
    this.awayTeamImageUrl,
    this.matchStatus,
  });

  bool get isFinished => matchDate.isBefore(DateTime.now());
}

class ClubDetail {
  final int clubId;
  final String clubName;
  final String? imageUrl;
  final String? leagueType;
  final String stadiumName;
  final List<ClubMatch> matches;

  const ClubDetail({
    required this.clubId,
    required this.clubName,
    this.imageUrl,
    this.leagueType,
    required this.stadiumName,
    required this.matches,
  });

  List<ClubMatch> get pastMatches =>
      matches.where((m) => m.isFinished).toList();

  List<ClubMatch> get upcomingMatches =>
      matches.where((m) => !m.isFinished).toList();
}
