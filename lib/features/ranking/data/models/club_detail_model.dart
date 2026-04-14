import 'package:twelfth_mobile/constants/club_id_map.dart';
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
    final homeRaw = json['homeTeamName'] as String;
    final awayRaw = json['awayTeamName'] as String;
    return ClubMatchModel(
      matchId: json['matchId'] as int,
      matchDate: DateTime.parse(json['matchDate'] as String),
      homeTeamName: homeRaw,
      awayTeamName: awayRaw,
      homeTeamScore: json['homeTeamScore'] as int?,
      awayTeamScore: json['awayTeamScore'] as int?,
      homeTeamId: json['homeTeamId'] as int? ?? ClubIdMap.lookup(homeRaw),
      awayTeamId: json['awayTeamId'] as int? ?? ClubIdMap.lookup(awayRaw),
      homeTeamImageUrl: json['homeTeamImageUrl'] as String?,
      awayTeamImageUrl: json['awayTeamImageUrl'] as String?,
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
  final String? imageUrl;
  final String? leagueType;
  final String stadiumName;
  final List<ClubMatchModel> matches;

  const ClubDetailModel({
    required this.clubId,
    required this.clubName,
    this.imageUrl,
    this.leagueType,
    required this.stadiumName,
    required this.matches,
  });

  factory ClubDetailModel.fromJson(Map<String, dynamic> json) {
    // 서버가 과거 경기와 미래 일정을 별도 필드로 내려줄 수 있음
    // matches / schedules / upcomingMatches / schedule 키를 모두 수집
    List<dynamic> _asList(dynamic v) =>
        v is List ? v : [];
    final pastList = _asList(json['matches']);
    final scheduleList = _asList(json['schedules']) +
        _asList(json['upcomingMatches']) +
        _asList(json['schedule']);
    final allMatches = [...pastList, ...scheduleList];
    return ClubDetailModel(
      clubId: json['clubId'] as int,
      clubName: json['clubName'] as String,
      imageUrl: json['clubImageUrl'] as String?,
      leagueType: json['leagueType'] as String?,
      stadiumName: json['stadiumName'] as String,
      matches: allMatches
          .map((e) => ClubMatchModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  ClubDetail toEntity() => ClubDetail(
        clubId: clubId,
        clubName: clubName,
        imageUrl: imageUrl,
        leagueType: leagueType,
        stadiumName: stadiumName,
        matches: matches.map((m) => m.toEntity()).toList(),
      );
}
