import 'package:twelfth_mobile/features/recruitment/domain/entities/recruitment.dart';
import 'package:twelfth_mobile/features/recruitment/domain/entities/recruitment_enums.dart';

class RecruitmentModel {
  final String? id;
  final String title;
  final String content;
  final int headCount;
  final int? currentParticipants;
  final String ageGroup;
  final String genderGroup;
  final String? k1Group;
  final String? k2Group;
  final String? noticeId;
  final DateTime? expiredAt;
  final DateTime? createdDate;

  const RecruitmentModel({
    this.id,
    required this.title,
    required this.content,
    required this.headCount,
    this.currentParticipants,
    required this.ageGroup,
    required this.genderGroup,
    this.k1Group,
    this.k2Group,
    this.noticeId,
    this.expiredAt,
    this.createdDate,
  });

  factory RecruitmentModel.fromJson(Map<String, dynamic> json) =>
      RecruitmentModel(
        id: (json['recruitmentId'] ?? json['id'])?.toString(),
        title: json['title'] as String? ?? '',
        content: json['content'] as String? ?? '',
        headCount: json['headCount'] as int? ?? 4,
        currentParticipants: json['currentParticipants'] as int?,
        ageGroup: json['ageGroup'] as String? ?? 'TWENTIES',
        genderGroup: json['genderGroup'] as String? ?? 'ANY',
        k1Group: json['k1Group'] as String?,
        k2Group: json['k2Group'] as String?,
        noticeId: json['noticeId']?.toString(),
        expiredAt: json['expiredAt'] != null
            ? DateTime.tryParse(json['expiredAt'] as String)
            : null,
        createdDate: json['createdDate'] != null
            ? DateTime.tryParse(json['createdDate'] as String)
            : null,
      );

  factory RecruitmentModel.fromEntity(Recruitment entity) => RecruitmentModel(
        id: entity.id,
        title: entity.title,
        content: entity.content,
        headCount: entity.headCount,
        currentParticipants: entity.currentParticipants,
        ageGroup: entity.ageGroup.apiValue,
        genderGroup: entity.genderGroup.apiValue,
        k1Group: entity.teamGroup.isK1 ? entity.teamGroup.apiValue : null,
        k2Group: entity.teamGroup.isK1 ? null : entity.teamGroup.apiValue,
        expiredAt: entity.expiryDate,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'title': title,
      'content': content,
      'headCount': headCount,
      'ageGroup': ageGroup,
      'genderGroup': genderGroup,
    };
    if (k1Group != null) map['k1Group'] = k1Group;
    if (k2Group != null) map['k2Group'] = k2Group;
    if (expiredAt != null) {
      map['expiredAt'] = expiredAt!.toIso8601String().split('.').first; // "2026-05-25T18:00:00"
    }
    return map;
  }

  Recruitment toEntity() {
    final teamApiVal = k1Group ?? k2Group;
    final team = TeamGroup.fromApiValue(teamApiVal) ?? TeamGroup.fcSeoul;
    return Recruitment(
      id: id,
      title: title,
      content: content,
      headCount: headCount,
      currentParticipants: currentParticipants,
      ageGroup: AgeGroup.fromApiValue(ageGroup) ?? AgeGroup.twenties,
      genderGroup: GenderGroup.fromApiValue(genderGroup) ?? GenderGroup.any,
      teamGroup: team,
      noticeId: noticeId,
      expiryDate: expiredAt, // 서버: expiredAt → 클라: expiryDate
    );
  }
}
