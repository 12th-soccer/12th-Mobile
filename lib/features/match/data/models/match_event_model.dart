import 'package:twelfth_mobile/features/match/domain/entities/match_event.dart';

class MatchEventModel {
  final int eventId;
  final int clubId;
  final String playerName;
  final String? playerImageUrl;
  final int eventMinute;
  final MatchEventType eventType;

  const MatchEventModel({
    required this.eventId,
    required this.clubId,
    required this.playerName,
    this.playerImageUrl,
    required this.eventMinute,
    required this.eventType,
  });

  factory MatchEventModel.fromJson(Map<String, dynamic> json) {
    final type = switch ((json['matchEventType'] as String? ?? '').toUpperCase()) {
      'GOAL' => MatchEventType.goal,
      'YELLOW_CARD' => MatchEventType.yellowCard,
      'RED_CARD' => MatchEventType.redCard,
      'SUB_OUT' => MatchEventType.subOut,
      'SUB_IN' => MatchEventType.subIn,
      _ => MatchEventType.unknown,
    };

    return MatchEventModel(
      eventId: _toInt(json['eventId']),
      clubId: _toInt(json['clubId']),
      playerName: (json['playerName'] as String? ?? '').trim(),
      playerImageUrl: _readPlayerImageUrl(json),
      eventMinute: _toInt(json['eventMinute']),
      eventType: type,
    );
  }

  MatchEvent toEntity() => MatchEvent(
    eventId: eventId,
    clubId: clubId,
    playerName: playerName,
    playerImageUrl: playerImageUrl,
    eventMinute: eventMinute,
    eventType: eventType,
  );
}

int _toInt(Object? value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

String? _readPlayerImageUrl(Map<String, dynamic> json) {
  for (final key in const ['playerImageUrl', 'playerImage']) {
    final value = json[key];
    if (value is String && value.trim().isNotEmpty) {
      return value;
    }
  }
  return null;
}
