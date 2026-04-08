import 'package:twelfth_mobile/constants/team_name_map.dart';
import 'package:twelfth_mobile/features/ranking/domain/entities/club_ranking.dart';

class ClubRankingModel {
  final int clubId;
  final String clubName;
  final int win;
  final int lose;
  final int draw;
  final int point;

  const ClubRankingModel({
    required this.clubId,
    required this.clubName,
    required this.win,
    required this.lose,
    required this.draw,
    required this.point,
  });

  factory ClubRankingModel.fromJson(Map<String, dynamic> json) =>
      ClubRankingModel(
        clubId: json['clubId'] as int,
        clubName: TeamNameMap.translate(json['clubName'] as String),
        win: json['win'] as int,
        lose: json['lose'] as int,
        draw: json['draw'] as int,
        point: json['point'] as int,
      );

  ClubRanking toEntity({required int rank}) => ClubRanking(
        clubId: clubId,
        clubName: clubName,
        win: win,
        lose: lose,
        draw: draw,
        point: point,
        rank: rank,
      );
}
