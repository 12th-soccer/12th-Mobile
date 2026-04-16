class FavoritePlayer {
  final int playerId;
  final String playerName;
  final String? imageUrl;

  const FavoritePlayer({
    required this.playerId,
    required this.playerName,
    this.imageUrl,
  });
}
