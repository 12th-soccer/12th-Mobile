import 'package:twelfth_mobile/constants/team_name_map.dart';
import 'package:twelfth_mobile/features/search/domain/entities/club_search_result.dart';
import 'package:twelfth_mobile/features/search/domain/entities/player_search_result.dart';

class ClubSearchResultModel {
  final int clubId;
  final String name;
  final String? logoUrl;

  const ClubSearchResultModel({
    required this.clubId,
    required this.name,
    this.logoUrl,
  });

  factory ClubSearchResultModel.fromJson(Map<String, dynamic> json) =>
      ClubSearchResultModel(
        clubId: json['clubId'] as int,
        name: TeamNameMap.translate(
          (json['clubName'] ?? json['name']) as String,
        ),
        logoUrl: json['logoUrl'] as String?,
      );

  ClubSearchResult toEntity() =>
      ClubSearchResult(clubId: clubId, name: name, logoUrl: logoUrl);
}

class PlayerSearchResultModel {
  final int playerId;
  final String name;
  final int? age;
  final String? position;
  final int? number;
  final String? clubName;

  const PlayerSearchResultModel({
    required this.playerId,
    required this.name,
    this.age,
    this.position,
    this.number,
    this.clubName,
  });

  factory PlayerSearchResultModel.fromJson(Map<String, dynamic> json) =>
      PlayerSearchResultModel(
        playerId: json['playerId'] as int,
        name: json['name'] as String,
        age: json['age'] as int?,
        position: json['position'] as String?,
        number: json['number'] as int?,
        clubName: json['clubName'] as String?,
      );

  PlayerSearchResult toEntity() => PlayerSearchResult(
    playerId: playerId,
    name: name,
    age: age,
    position: position,
    number: number,
    clubName: clubName,
  );
}
