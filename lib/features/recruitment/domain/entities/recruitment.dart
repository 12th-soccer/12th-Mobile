import 'package:twelfth_mobile/features/recruitment/domain/entities/recruitment_enums.dart';

class Recruitment {
  final String? id;
  final String title;
  final String content;
  final int headCount;
  final int? currentParticipants;
  final AgeGroup ageGroup;
  final GenderGroup genderGroup;
  final TeamGroup teamGroup;
  final DateTime? expiryDate;
  final String? noticeId;

  const Recruitment({
    this.id,
    required this.title,
    required this.content,
    required this.headCount,
    this.currentParticipants,
    required this.ageGroup,
    required this.genderGroup,
    required this.teamGroup,
    this.expiryDate,
    this.noticeId,
  });

  bool get isFull =>
      currentParticipants != null && currentParticipants! >= headCount;

  List<String> get tags => [
        ageGroup.displayTag,
        genderGroup.displayTag,
        teamGroup.displayTag,
      ];

  bool get isExpired {
    if (expiryDate == null) return false;
    final today = DateTime.now();
    final expiry = DateTime(
      expiryDate!.year,
      expiryDate!.month,
      expiryDate!.day,
    );
    return DateTime(today.year, today.month, today.day).isAfter(expiry);
  }
}
