enum MatchEventType { goal, yellowCard, redCard, subOut, subIn, unknown }

class MatchEvent {
  final int eventId;
  final int clubId;
  final String playerName;
  final String? playerImageUrl;
  final int eventMinute;
  final MatchEventType eventType;

  const MatchEvent({
    required this.eventId,
    required this.clubId,
    required this.playerName,
    this.playerImageUrl,
    required this.eventMinute,
    required this.eventType,
  });
}
