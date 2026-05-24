class UserInfo {
  final int userId;
  final String email;
  final String? username;

  const UserInfo({
    required this.userId,
    required this.email,
    this.username,
  });

  String? get validUsername {
    final value = username?.trim();
    if (value == null || value.isEmpty) return null;
    if (value.runes.length > 5) return null;
    if (RegExp(r'\s').hasMatch(value)) return null;
    return value;
  }

  bool get hasUsername => validUsername != null;
}
