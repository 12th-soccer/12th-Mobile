import 'package:twelfth_mobile/features/match/domain/entities/match_event.dart';

class MatchEventModel {
  final int clubId;
  final String teamName;
  final int? playerId;
  final String playerName;
  final int eventMinute;
  final MatchEventType eventType;

  const MatchEventModel({
    required this.clubId,
    required this.teamName,
    this.playerId,
    required this.playerName,
    required this.eventMinute,
    required this.eventType,
  });

  factory MatchEventModel.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String? ?? '';
    final detail = (json['detail'] as String? ?? '').toLowerCase();

    final eventType = switch (type) {
      'Goal' => MatchEventType.goal,
      'Card' =>
        detail.contains('red') ? MatchEventType.redCard : MatchEventType.yellowCard,
      'subst' => MatchEventType.subOut,
      _ => MatchEventType.unknown,
    };

    return MatchEventModel(
      clubId: json['teamId'] as int? ?? 0,
      teamName: (json['teamName'] as String? ?? '').trim(),
      playerId: json['playerId'] as int?,
      playerName: (json['playerName'] as String? ?? '').trim(),
      eventMinute: _parseTime(json['time'] as String? ?? '0'),
      eventType: eventType,
    );
  }

  MatchEvent toEntity() => MatchEvent(
    eventId: 0,
    clubId: clubId,
    teamName: teamName,
    playerId: playerId,
    playerName: playerName,
    playerImageUrl: null,
    eventMinute: eventMinute,
    eventType: eventType,
  );
}

int _parseTime(String time) {
  final parts = time.split('+');
  final base = int.tryParse(parts[0]) ?? 0;
  final extra = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;
  return base + extra;
}
