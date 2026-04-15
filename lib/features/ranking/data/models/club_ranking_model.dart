import 'package:twelfth_mobile/features/ranking/domain/entities/club_ranking.dart';

class ClubRankingModel {
  final int clubId;
  final String clubName;
  final String? clubImage;
  final int win;
  final int lose;
  final int draw;
  final int point;

  const ClubRankingModel({
    required this.clubId,
    required this.clubName,
    this.clubImage,
    required this.win,
    required this.lose,
    required this.draw,
    required this.point,
  });

  factory ClubRankingModel.fromJson(Map<String, dynamic> json) =>
      ClubRankingModel(
        clubId: json['clubId'] as int,
        clubName: json['clubName'] as String,
        clubImage: json['clubImage'] as String,
        win: json['win'] as int,
        lose: json['lose'] as int,
        draw: json['draw'] as int,
        point: json['point'] as int,
      );

  ClubRanking toEntity({required int rank}) => ClubRanking(
    clubId: clubId,
    clubName: clubName,
    clubImage: clubImage,
    win: win,
    lose: lose,
    draw: draw,
    point: point,
    rank: rank,
  );
}
