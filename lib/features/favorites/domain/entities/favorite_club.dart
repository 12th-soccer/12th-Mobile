class FavoriteClub {
  final int clubId;
  final String clubName;
  final String? imageUrl;

  const FavoriteClub({
    required this.clubId,
    required this.clubName,
    this.imageUrl,
  });
}
