import 'package:twelfth_mobile/features/recruitment/domain/entities/recruitment_enums.dart';

class JoinedRecruitment {
  final int joinId;
  final int recruitmentId;
  final String title;
  final String content;
  final DateTime createdDate;
  final DateTime expiredAt;
  final int headCount;
  final int currentParticipants;
  final AgeGroup ageGroup;
  final GenderGroup genderGroup;
  final String? k1Group;
  final String? k2Group;

  const JoinedRecruitment({
    required this.joinId,
    required this.recruitmentId,
    required this.title,
    required this.content,
    required this.createdDate,
    required this.expiredAt,
    required this.headCount,
    required this.currentParticipants,
    required this.ageGroup,
    required this.genderGroup,
    this.k1Group,
    this.k2Group,
  });

  bool get isExpired => DateTime.now().isAfter(expiredAt);

  bool get isFull => currentParticipants >= headCount;

  String get status {
    if (isExpired) return '마감';
    if (isFull) return '모집완료';
    return '모집중';
  }
}
