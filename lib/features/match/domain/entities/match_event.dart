enum MatchEventType { goal, yellowCard, redCard, subOut, subIn, unknown }

class MatchEvent {
  final int eventId;
  final int clubId;
  final String teamName;
  final int? playerId;
  final String playerName;
  final String? playerImageUrl;
  final int eventMinute;
  final MatchEventType eventType;

  const MatchEvent({
    required this.eventId,
    required this.clubId,
    required this.teamName,
    this.playerId,
    required this.playerName,
    this.playerImageUrl,
    required this.eventMinute,
    required this.eventType,
  });
}
