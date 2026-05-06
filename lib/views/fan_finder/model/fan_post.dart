import 'package:twelfth_mobile/views/fan_finder/fan_finder_constants.dart';

class FanPost {
  final String id;
  final String title;
  final String content;
  final List<String> tags;
  final DateTime createdAt;
  final int currentParticipants;
  final int maxParticipants;

  const FanPost({
    required this.id,
    required this.title,
    required this.content,
    required this.tags,
    required this.createdAt,
    required this.currentParticipants,
    required this.maxParticipants,
  }) : assert(maxParticipants >= FanFinderConstants.minParticipants);
}

final mockFanPosts = [
  FanPost(
    id: '1',
    title: '5월 대전 VS 연산 보실 분!!',
    content: '같이 응원하실 분 구해요. 분위기 좋게 같이 보러 가요~',
    tags: ['#20대', '#여성'],
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    currentParticipants: 2,
    maxParticipants: 5,
  ),
  FanPost(
    id: '2',
    title: '촉월 5월 대전 VS 연산 보심!!',
    content: '혼자 가기 심심하신 분들 같이 가요. 경기 전 식사도 같이해요!',
    tags: ['#30대', '#성별무관'],
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    currentParticipants: 1,
    maxParticipants: 5,
  ),
  FanPost(
    id: '3',
    title: '뚜두 대전 VS 대전 보실!!!',
    content: '열정적으로 응원하실 분 환영해요. 응원도구 챙겨오세요~',
    tags: ['#20대', '#남성'],
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    currentParticipants: 3,
    maxParticipants: 6,
  ),
  FanPost(
    id: '4',
    title: '뚜두 대전 VS 대전 보실!!!',
    content: '처음 경기 보러 가시는 분도 환영해요! 같이 즐겨요.',
    tags: ['#40대', '#성별무관'],
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    currentParticipants: 1,
    maxParticipants: 5,
  ),
  FanPost(
    id: '5',
    title: '뚜두 대전 VS 대전 보실!!!',
    content: '자리 있어요~ 빨리 모집해서 같이 가요.',
    tags: ['#50대+', '#여성'],
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    currentParticipants: 2,
    maxParticipants: 5,
  ),
];
