import 'package:twelfth_mobile/features/favorites/domain/entities/favorite_club.dart';

class FavoriteClubModel {
  final int clubId;
  final String clubName;
  final String? imageUrl;

  const FavoriteClubModel({
    required this.clubId,
    required this.clubName,
    this.imageUrl,
  });

  factory FavoriteClubModel.fromJson(Map<String, dynamic> json) =>
      FavoriteClubModel(
        clubId: json['clubId'] as int,
        clubName: json['clubName'] as String,
        imageUrl: json['clubImageUrl'] as String?,
      );

  FavoriteClub toEntity() =>
      FavoriteClub(clubId: clubId, clubName: clubName, imageUrl: imageUrl);
}
