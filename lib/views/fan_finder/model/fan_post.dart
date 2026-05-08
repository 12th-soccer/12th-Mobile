import 'package:twelfth_mobile/views/fan_finder/fan_finder_constants.dart';

class FanPost {
  final String id;
  final String title;
  final String content;
  final List<String> tags;
  final DateTime createdAt;
  final int currentParticipants;
  final int maxParticipants;
  final DateTime? expiryDate;

  const FanPost({
    required this.id,
    required this.title,
    required this.content,
    required this.tags,
    required this.createdAt,
    required this.currentParticipants,
    required this.maxParticipants,
    this.expiryDate,
  }) : assert(maxParticipants >= FanFinderConstants.minParticipants);

  bool get isExpired {
    if (expiryDate == null) return false;
    final today = DateTime.now();
    final expiry = DateTime(expiryDate!.year, expiryDate!.month, expiryDate!.day);
    final todayDate = DateTime(today.year, today.month, today.day);
    return todayDate.isAfter(expiry);
  }
}

