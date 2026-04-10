import 'package:twelfth_mobile/constants/team_name_map.dart';
import 'package:twelfth_mobile/features/favorites/domain/entities/favorite_club.dart';

class FavoriteClubModel {
  final int clubId;
  final String clubName;

  const FavoriteClubModel({required this.clubId, required this.clubName});

  factory FavoriteClubModel.fromJson(Map<String, dynamic> json) =>
      FavoriteClubModel(
        clubId: json['clubId'] as int,
        clubName: TeamNameMap.translate(json['clubName'] as String),
      );

  FavoriteClub toEntity() => FavoriteClub(clubId: clubId, clubName: clubName);
}
