import 'package:twelfth_mobile/features/recruitment/domain/entities/joined_recruitment.dart';
import 'package:twelfth_mobile/features/recruitment/domain/entities/recruitment_enums.dart';

class JoinedRecruitmentModel extends JoinedRecruitment {
  const JoinedRecruitmentModel({
    required super.joinId,
    required super.recruitmentId,
    required super.title,
    required super.content,
    required super.createdDate,
    required super.expiredAt,
    required super.headCount,
    required super.currentParticipants,
    required super.ageGroup,
    required super.genderGroup,
    super.k1Group,
    super.k2Group,
  });

  factory JoinedRecruitmentModel.fromJson(Map<String, dynamic> json) {
    return JoinedRecruitmentModel(
      joinId: json['joinId'] as int,
      recruitmentId: json['recruitmentId'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      createdDate: DateTime.parse(json['createdDate'] as String),
      expiredAt: DateTime.parse(json['expiredAt'] as String),
      headCount: json['headCount'] as int,
      currentParticipants: json['currentParticipants'] as int,
      ageGroup: AgeGroup.fromApiValue(json['ageGroup'] as String?) ?? AgeGroup.twenties,
      genderGroup: GenderGroup.fromApiValue(json['genderGroup'] as String?) ?? GenderGroup.any,
      k1Group: json['k1Group'] as String?,
      k2Group: json['k2Group'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'joinId': joinId,
      'recruitmentId': recruitmentId,
      'title': title,
      'content': content,
      'createdDate': createdDate.toIso8601String(),
      'expiredAt': expiredAt.toIso8601String(),
      'headCount': headCount,
      'currentParticipants': currentParticipants,
      'ageGroup': ageGroup.apiValue,
      'genderGroup': genderGroup.apiValue,
      'k1Group': k1Group,
      'k2Group': k2Group,
    };
  }
}