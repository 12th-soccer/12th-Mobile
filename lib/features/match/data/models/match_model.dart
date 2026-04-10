import 'package:twelfth_mobile/features/match/domain/entities/match.dart';

class MatchModel {
  final int matchId;
  final String? leagueType;
  final String matchDate;
  final String homeTeamName;
  final String awayTeamName;
  final int? homeTeamScore;
  final int? awayTeamScore;

  const MatchModel({
    required this.matchId,
    this.leagueType,
    required this.matchDate,
    required this.homeTeamName,
    required this.awayTeamName,
    this.homeTeamScore,
    this.awayTeamScore,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      matchId: json['matchId'] as int,
      leagueType: json['leagueType'] as String?,
      matchDate: json['matchDate'] as String,
      homeTeamName: json['homeTeamName'] as String,
      awayTeamName: json['awayTeamName'] as String,
      homeTeamScore: json['homeTeamScore'] as int?,
      awayTeamScore: json['awayTeamScore'] as int?,
    );
  }

  Match toEntity() {
    return Match(
      matchId: matchId,
      leagueType: leagueType,
      matchDate: DateTime.parse(matchDate),
      homeTeamName: homeTeamName,
      awayTeamName: awayTeamName,
      homeTeamScore: homeTeamScore,
      awayTeamScore: awayTeamScore,
    );
  }
}
