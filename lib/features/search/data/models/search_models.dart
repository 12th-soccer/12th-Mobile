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
        name: (json['clubName'] ?? json['name']) as String,
        logoUrl:
            (json['clubImageUrl'] ??
                    json['logoUrl'] ??
                    json['imageUrl'] ??
                    json['image'])
                as String?,
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
    final rawName = json['name'] as String? ?? '';
    final rawImageUrl =
        (json['playerImageUrl'] ??
                json['imageUrl'] ??
                json['image'] ??
                json['profileImageUrl'])
            as String?;
    final isSwapped = rawName.startsWith('http');
    return PlayerSearchResultModel(
      playerId: json['playerId'] as int,
      name: isSwapped ? (rawImageUrl ?? '') : rawName,
      imageUrl: isSwapped ? rawName : rawImageUrl,
      age: json['age'] as int?,
      position: json['position'] as String?,
      number: json['number'] as int?,
      clubName: json['clubName'] as String?,
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
