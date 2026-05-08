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

  const PlayerSearchResultModel({
    required this.playerId,
    required this.name,
    this.imageUrl,
  });

  factory PlayerSearchResultModel.fromJson(Map<String, dynamic> json) =>
      PlayerSearchResultModel(
        playerId: json['playerId'] as int,
        name: (json['playerName'] ?? json['name']) as String? ?? '',
        imageUrl: (json['playerImgUrl'] ?? json['photo'] ?? json['playerPhoto'] ?? json['image'] ?? json['img']) as String?,
      );

  PlayerSearchResult toEntity() => PlayerSearchResult(
        playerId: playerId,
        name: name,
        imageUrl: imageUrl,
      );
}
