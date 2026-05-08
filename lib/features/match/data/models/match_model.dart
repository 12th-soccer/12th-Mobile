import 'package:twelfth_mobile/core/constants/club_id_map.dart';
import 'package:twelfth_mobile/features/match/domain/entities/match.dart';

class MatchModel {
  final int matchId;
  final String? leagueType;
  final String matchDate;
  final String homeTeamName;
  final String awayTeamName;
  final int? homeTeamScore;
  final int? awayTeamScore;
  final int? homeTeamId;
  final int? awayTeamId;
  final String? homeTeamImageUrl;
  final String? awayTeamImageUrl;

  const MatchModel({
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

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    final homeRaw = (json['homeTeamName'] ?? json['homeTeam']) as String;
    final awayRaw = (json['awayTeamName'] ?? json['awayTeam']) as String;
    final homeImageUrl = (json['homeTeamImageUrl'] ?? json['homeTeamLogo']) as String?;
    final awayImageUrl = (json['awayTeamImageUrl'] ?? json['awayTeamLogo']) as String?;
    return MatchModel(
      matchId: json['matchId'] as int,
      leagueType: json['leagueType'] as String?,
      matchDate: json['matchDate'] as String,
      homeTeamName: homeRaw,
      awayTeamName: awayRaw,
      homeTeamScore: (json['homeTeamScore'] ?? json['homeScore']) as int?,
      awayTeamScore: (json['awayTeamScore'] ?? json['awayScore']) as int?,
      homeTeamId: json['homeTeamId'] as int? ??
          _extractIdFromUrl(homeImageUrl) ??
          ClubIdMap.lookup(homeRaw),
      awayTeamId: json['awayTeamId'] as int? ??
          _extractIdFromUrl(awayImageUrl) ??
          ClubIdMap.lookup(awayRaw),
      homeTeamImageUrl: homeImageUrl,
      awayTeamImageUrl: awayImageUrl,
    );
  }

  static int? _extractIdFromUrl(String? url) {
    if (url == null) return null;
    final m = RegExp(r'/teams/(\d+)\.').firstMatch(url);
    return m != null ? int.tryParse(m.group(1)!) : null;
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
      homeTeamId: homeTeamId,
      awayTeamId: awayTeamId,
      homeTeamImageUrl: homeTeamImageUrl,
      awayTeamImageUrl: awayTeamImageUrl,
    );
  }
}
