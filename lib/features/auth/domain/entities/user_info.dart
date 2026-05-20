class UserInfo {
  final int userId;
  final String email;
  final String? nickname;

  const UserInfo({
    required this.userId,
    required this.email,
    this.nickname,
  });

  bool get hasNickname => nickname != null && nickname!.isNotEmpty;
}
