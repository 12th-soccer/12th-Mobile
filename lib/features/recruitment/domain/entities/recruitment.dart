import 'package:twelfth_mobile/features/recruitment/domain/entities/recruitment_enums.dart';

class Recruitment {
  final String? id;
  final String title;
  final String content;
  final int headCount;
  final int? currentParticipants;
  final AgeGroup ageGroup;
  final GenderGroup genderGroup;
  final String? teamCode;
  final bool isK1;
  final String? teamDisplayName;
  final DateTime? expiryDate;
  final String? noticeId;
  final int? authorId;
  final String? authorName;

  const Recruitment({
    this.id,
    required this.title,
    required this.content,
    required this.headCount,
    this.currentParticipants,
    required this.ageGroup,
    required this.genderGroup,
    this.teamCode,
    this.isK1 = true,
    this.teamDisplayName,
    this.expiryDate,
    this.noticeId,
    this.authorId,
    this.authorName,
  });

  bool get isFull =>
      currentParticipants != null && currentParticipants! >= headCount;

  List<String> get tags => [
        ageGroup.displayTag,
        genderGroup.displayTag,
        if (teamDisplayName != null) '#$teamDisplayName'
        else if (teamCode != null) '#$teamCode',
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
