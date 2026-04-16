import 'package:twelfth_mobile/features/favorites/domain/entities/favorite_player.dart';

class FavoritePlayerModel {
  final int playerId;
  final String playerName;
  final String? imageUrl;

  const FavoritePlayerModel({
    required this.playerId,
    required this.playerName,
    this.imageUrl,
  });

  factory FavoritePlayerModel.fromJson(Map<String, dynamic> json) =>
      FavoritePlayerModel(
        playerId: json['playerId'] as int,
        playerName: json['playerName'] as String,
        imageUrl: json['playerImageUrl'] as String?,
      );

  FavoritePlayer toEntity() => FavoritePlayer(
        playerId: playerId,
        playerName: playerName,
        imageUrl: imageUrl,
      );
}
