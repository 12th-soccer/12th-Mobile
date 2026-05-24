import 'package:twelfth_mobile/features/notice/domain/entities/notice.dart';

class NoticeModel {
  final int id;
  final String title;
  final String description;
  final int headCount;

  const NoticeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.headCount,
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) => NoticeModel(
        id: json['id'] as int,
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        headCount: json['headCount'] as int? ?? 0,
      );

  Notice toEntity() => Notice(
        id: id,
        title: title,
        description: description,
        headCount: headCount,
      );
}
