class ClubSearchResult {
  final int clubId;
  final String name;
  final String? logoUrl;

  const ClubSearchResult({
    required this.clubId,
    required this.name,
    this.logoUrl,
  });
}
