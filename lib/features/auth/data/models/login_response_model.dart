import 'package:twelfth_mobile/features/auth/domain/entities/auth_token.dart';

class LoginResponseModel {
  final String accessToken;
  final String? refreshToken;
  final String? email;

  const LoginResponseModel({
    required this.accessToken,
    this.refreshToken,
    this.email,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final access = json['AccessToken'] ?? json['accessToken'];
    final refresh = json['RefreshToken'] ?? json['refreshToken'];
    final email = json['email'] ?? json['Email'];
    if (access is! String || access.isEmpty) {
      throw const FormatException('잘못된 로그인 응답: AccessToken이 누락되었거나 잘못되었습니다.');
    }
    return LoginResponseModel(
      accessToken: access,
      refreshToken: refresh is String ? refresh : null,
      email: email is String ? email : null,
    );
  }

  AuthToken toEntity() =>
      AuthToken(accessToken: accessToken, refreshToken: refreshToken);
}
