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

  bool get isFinished {
    final koreanMatchTime = matchDate.add(Duration(hours: 9));
    final nowKorean = DateTime.now().add(Duration(hours: 9));
    return koreanMatchTime.isBefore(nowKorean);
  }
}

class ClubDetail {
  final int clubId;
  final String clubName;
  final String? logo;
  final String? country;
  final int? founded;
  final int? venueId;
  final String venueName;
  final String? venueAddress;
  final String? venueCity;
  final int? venueCapacity;
  final List<ClubMatch> matches;

  const ClubDetail({
    required this.clubId,
    required this.clubName,
    this.logo,
    this.country,
    this.founded,
    this.venueId,
    required this.venueName,
    this.venueAddress,
    this.venueCity,
    this.venueCapacity,
    this.matches = const [],
  });

  List<ClubMatch> get pastMatches =>
      matches.where((m) => m.isFinished).toList();

  List<ClubMatch> get upcomingMatches =>
      matches.where((m) => !m.isFinished).toList();
}
