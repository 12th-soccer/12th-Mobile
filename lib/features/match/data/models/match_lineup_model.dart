import 'package:twelfth_mobile/features/match/domain/entities/match_lineup.dart';

class MatchLineupModel {
  final int teamId;
  final String teamName;
  final String formation;
  final String coachName;

  const MatchLineupModel({
    required this.teamId,
    required this.teamName,
    required this.formation,
    required this.coachName,
  });

  factory MatchLineupModel.fromJson(Map<String, dynamic> json) =>
      MatchLineupModel(
        teamId: json['teamId'] as int? ?? 0,
        teamName: (json['teamName'] as String? ?? '').trim(),
        formation: (json['formation'] as String? ?? '').trim(),
        coachName: (json['coachName'] as String? ?? '').trim(),
      );

  MatchLineup toEntity() => MatchLineup(
    teamId: teamId,
    teamName: teamName,
    formation: formation,
    coachName: coachName,
  );
}
