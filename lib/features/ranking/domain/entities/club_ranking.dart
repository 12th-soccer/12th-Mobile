class ClubRanking {
  final int clubId;
  final String clubName;
  final int win;
  final int lose;
  final int draw;
  final int point;

  /// 서버 응답 리스트의 index + 1 로 계산
  final int rank;

  const ClubRanking({
    required this.clubId,
    required this.clubName,
    required this.win,
    required this.lose,
    required this.draw,
    required this.point,
    required this.rank,
  });

  int get matchesPlayed => win + lose + draw;
}
