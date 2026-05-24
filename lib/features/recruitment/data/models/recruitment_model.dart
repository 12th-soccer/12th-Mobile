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
  final int? hostId;
  final String? hostName;

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
    this.hostId,
    this.hostName,
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
        noticeId: json['notice_id']?.toString(),
        expiredAt: json['expiredAt'] != null
            ? DateTime.tryParse(json['expiredAt'] as String)
            : null,
        createdDate: json['createdDate'] != null
            ? DateTime.tryParse(json['createdDate'] as String)
            : null,
        hostId: json['hostId'] as int?,
        hostName: json['hostName'] as String?,
      );

  factory RecruitmentModel.fromEntity(Recruitment entity) => RecruitmentModel(
        id: entity.id,
        title: entity.title,
        content: entity.content,
        headCount: entity.headCount,
        currentParticipants: entity.currentParticipants,
        ageGroup: entity.ageGroup.apiValue,
        genderGroup: entity.genderGroup.apiValue,
        k1Group: entity.isK1 ? entity.teamCode : null,
        k2Group: entity.isK1 ? null : entity.teamCode,
        expiredAt: entity.expiryDate,
        hostId: entity.authorId,
        hostName: entity.authorName,
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
      map['expiredAt'] = expiredAt!.toIso8601String().split('.').first;
    }
    return map;
  }

  Recruitment toEntity() => Recruitment(
        id: id,
        title: title,
        content: content,
        headCount: headCount,
        currentParticipants: currentParticipants,
        ageGroup: AgeGroup.fromApiValue(ageGroup) ?? AgeGroup.twenties,
        genderGroup: GenderGroup.fromApiValue(genderGroup) ?? GenderGroup.any,
        teamCode: k1Group ?? k2Group,
        isK1: k1Group != null,
        teamDisplayName: null,
        noticeId: noticeId,
        expiryDate: expiredAt,
        authorId: hostId,
        authorName: hostName,
      );
}
