class ClubRanking {
  final int clubId;
  final String clubName;
  final String? imageUrl;
  final int win;
  final int lose;
  final int draw;
  final int point;
  final int rank;

  const ClubRanking({
    required this.clubId,
    required this.clubName,
    this.imageUrl,
    required this.win,
    required this.lose,
    required this.draw,
    required this.point,
    required this.rank,
  });

  int get matchesPlayed => win + lose + draw;
}
