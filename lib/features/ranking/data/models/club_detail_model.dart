import 'package:twelfth_mobile/constants/team_name_map.dart';
import 'package:twelfth_mobile/features/ranking/domain/entities/club_detail.dart';

class ClubMatchModel {
  final int matchId;
  final DateTime matchDate;
  final String homeTeamName;
  final String awayTeamName;
  final int? homeTeamScore;
  final int? awayTeamScore;

  const ClubMatchModel({
    required this.matchId,
    required this.matchDate,
    required this.homeTeamName,
    required this.awayTeamName,
    this.homeTeamScore,
    this.awayTeamScore,
  });

  factory ClubMatchModel.fromJson(Map<String, dynamic> json) => ClubMatchModel(
        matchId: json['matchId'] as int,
        matchDate: DateTime.parse(json['matchDate'] as String),
        homeTeamName: TeamNameMap.translate(json['homeTeamName'] as String),
        awayTeamName: TeamNameMap.translate(json['awayTeamName'] as String),
        homeTeamScore: json['homeTeamScore'] as int?,
        awayTeamScore: json['awayTeamScore'] as int?,
      );

  ClubMatch toEntity() => ClubMatch(
        matchId: matchId,
        matchDate: matchDate,
        homeTeamName: homeTeamName,
        awayTeamName: awayTeamName,
        homeTeamScore: homeTeamScore,
        awayTeamScore: awayTeamScore,
      );
}

class ClubDetailModel {
  final int clubId;
  final String clubName;
  final String stadiumName;
  final List<ClubMatchModel> matches;

  const ClubDetailModel({
    required this.clubId,
    required this.clubName,
    required this.stadiumName,
    required this.matches,
  });

  factory ClubDetailModel.fromJson(Map<String, dynamic> json) => ClubDetailModel(
        clubId: json['clubId'] as int,
        clubName: TeamNameMap.translate(json['clubName'] as String),
        stadiumName: json['stadiumName'] as String,
        matches: (json['matches'] as List<dynamic>)
            .map((e) => ClubMatchModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  ClubDetail toEntity() => ClubDetail(
        clubId: clubId,
        clubName: clubName,
        stadiumName: stadiumName,
        matches: matches.map((m) => m.toEntity()).toList(),
      );
}
