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
        clubId: (json['teamId'] ?? json['clubId']) as int,
        name: (json['teamName'] ?? json['name']) as String,
        logoUrl: (json['teamLogo'] ?? json['logo'] ?? json['teamImageUrl'] ?? json['logoUrl'] ?? json['image']) as String?,
      );

  ClubSearchResult toEntity() =>
      ClubSearchResult(clubId: clubId, name: name, logoUrl: logoUrl);
}

class PlayerSearchResultModel {
  final int playerId;
  final String name;
  final String? imageUrl;
  final int? age;
  final String? position;
  final int? number;
  final String? clubName;

  const PlayerSearchResultModel({
    required this.playerId,
    required this.name,
    this.imageUrl,
    this.age,
    this.position,
    this.number,
    this.clubName,
  });

  factory PlayerSearchResultModel.fromJson(Map<String, dynamic> json) {
    String? imageUrl = json['playerImgUrl'] as String? ??
        json['photo'] as String? ??
        json['playerPhoto'] as String? ??
        json['image'] as String? ??
        json['img'] as String? ??
        json['playerImageUrl'] as String? ??
        json['profileImage'] as String? ??
        json['profileImg'] as String? ??
        json['playerImg'] as String? ??
        json['headshot'] as String?;

    if (imageUrl != null && imageUrl.trim().isEmpty) {
      imageUrl = null;
    }

    return PlayerSearchResultModel(
      playerId: json['playerId'] as int,
      name: (json['playerName'] ?? json['name']) as String? ?? '',
      imageUrl: imageUrl,
      age: json['age'] as int?,
      position: (json['position'] ?? json['pos']) as String?,
      number: (json['number'] ?? json['jerseyNumber'] ?? json['shirtNumber']) as int?,
      clubName: (json['clubName'] ?? json['teamName'] ?? json['club'] ?? json['team']) as String?,
    );
  }

  PlayerSearchResult toEntity() => PlayerSearchResult(
        playerId: playerId,
        name: name,
        imageUrl: imageUrl,
        age: age,
        position: position,
        number: number,
        clubName: clubName,
      );
}
