import 'package:twelfth_mobile/features/match/domain/entities/match_event.dart';

class MatchEventModel {
  final int eventId;
  final int clubId;
  final int? playerId;
  final String playerName;
  final String? playerImageUrl;
  final int eventMinute;
  final MatchEventType eventType;

  const MatchEventModel({
    required this.eventId,
    required this.clubId,
    this.playerId,
    required this.playerName,
    this.playerImageUrl,
    required this.eventMinute,
    required this.eventType,
  });

  factory MatchEventModel.fromJson(Map<String, dynamic> json) {
    final typeStr = json['matchEventType'] as String? ?? '';
    final type = switch (typeStr) {
      'GOAL' => MatchEventType.goal,
      'YELLOW_CARD' => MatchEventType.yellowCard,
      'RED_CARD' => MatchEventType.redCard,
      'SUB_OUT' => MatchEventType.subOut,
      'SUB_IN' => MatchEventType.subIn,
      _ => MatchEventType.unknown,
    };

    return MatchEventModel(
      eventId: json['eventId'] as int,
      clubId: (json['clubId'] as int?) ?? 0,
      playerId: json['playerId'] as int?,
      playerName: json['playerName'] as String,
      playerImageUrl: json['playerImageUrl'] as String?,
      eventMinute: json['eventMinute'] as int,
      eventType: type,
    );
  }

  MatchEvent toEntity() => MatchEvent(
    eventId: eventId,
    clubId: clubId,
    playerId: playerId,
    playerName: playerName,
    playerImageUrl: playerImageUrl,
    eventMinute: eventMinute,
    eventType: eventType,
  );
}
