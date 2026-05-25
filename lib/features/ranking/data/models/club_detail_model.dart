import 'package:twelfth_mobile/core/constants/club_id_map.dart';
import 'package:twelfth_mobile/features/ranking/domain/entities/club_detail.dart';

class ClubMatchModel {
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

  ClubMatchModel({
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

  factory ClubMatchModel.fromJson(Map<String, dynamic> json) {
    final homeRaw = (json['homeTeam'] ?? json['homeTeamName'] ?? '') as String;
    final awayRaw = (json['awayTeam'] ?? json['awayTeamName'] ?? '') as String;
    return ClubMatchModel(
      matchId: json['matchId'] as int,
      matchDate: DateTime.parse(json['matchDate'] as String),
      homeTeamName: homeRaw,
      awayTeamName: awayRaw,
      homeTeamScore: (json['homeScore'] ?? json['homeTeamScore']) as int?,
      awayTeamScore: (json['awayScore'] ?? json['awayTeamScore']) as int?,
      homeTeamId: json['homeTeamId'] as int? ?? ClubIdMap.lookup(homeRaw),
      awayTeamId: json['awayTeamId'] as int? ?? ClubIdMap.lookup(awayRaw),
      homeTeamImageUrl:
          (json['homeTeamLogo'] ?? json['homeTeamImageUrl']) as String?,
      awayTeamImageUrl:
          (json['awayTeamLogo'] ?? json['awayTeamImageUrl']) as String?,
      matchStatus: (json['matchStatus'] ?? json['status']) as String?,
    );
  }

  ClubMatch toEntity() => ClubMatch(
    matchId: matchId,
    matchDate: matchDate,
    homeTeamName: homeTeamName,
    awayTeamName: awayTeamName,
    homeTeamScore: homeTeamScore,
    awayTeamScore: awayTeamScore,
    homeTeamId: homeTeamId,
    awayTeamId: awayTeamId,
    homeTeamImageUrl: homeTeamImageUrl,
    awayTeamImageUrl: awayTeamImageUrl,
    matchStatus: matchStatus,
  );
}

class ClubDetailModel {
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
  final List<ClubMatchModel> matches;

  const ClubDetailModel({
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

  factory ClubDetailModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> asList(dynamic v) => v is List ? v : [];
    final allMatches = [
      ...asList(json['recentMatches']),
      ...asList(json['matches']),
      ...asList(json['schedules']),
      ...asList(json['upcomingMatches']),
      ...asList(json['schedule']),
    ];

    return ClubDetailModel(
      clubId: json['teamId'] as int,
      clubName: json['name'] as String,
      logo: json['logo'] as String?,
      country: json['country'] as String?,
      founded: json['founded'] as int?,
      venueId: json['venueId'] as int?,
      venueName: (json['venueName'] ?? '') as String,
      venueAddress: json['venueAddress'] as String?,
      venueCity: json['venueCity'] as String?,
      venueCapacity: json['venueCapacity'] as int?,
      matches: allMatches
          .map((e) => ClubMatchModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  ClubDetail toEntity() => ClubDetail(
    clubId: clubId,
    clubName: clubName,
    logo: logo,
    country: country,
    founded: founded,
    venueId: venueId,
    venueName: venueName,
    venueAddress: venueAddress,
    venueCity: venueCity,
    venueCapacity: venueCapacity,
    matches: matches.map((m) => m.toEntity()).toList(),
  );
}
