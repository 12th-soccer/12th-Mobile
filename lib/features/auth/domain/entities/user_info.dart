class UserInfo {
  final int userId;
  final String email;
  final String? username;

  const UserInfo({
    required this.userId,
    required this.email,
    this.username,
  });

  bool get hasUsername => username != null && username!.isNotEmpty;
}
