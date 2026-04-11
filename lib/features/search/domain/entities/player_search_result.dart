class PlayerSearchResult {
  final int playerId;
  final String name;
  final String? imageUrl;
  final int? age;
  final String? position;
  final int? number;
  final String? clubName;

  const PlayerSearchResult({
    required this.playerId,
    required this.name,
    this.imageUrl,
    this.age,
    this.position,
    this.number,
    this.clubName,
  });
}
