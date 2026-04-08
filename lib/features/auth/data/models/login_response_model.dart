import 'package:twelfth_mobile/features/auth/domain/entities/auth_token.dart';

class LoginResponseModel {
  final String accessToken;
  final String? refreshToken;

  const LoginResponseModel({required this.accessToken, this.refreshToken});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final access = json['AccessToken'];
    final refresh = json['RefreshToken'];
    if (access is! String || access.isEmpty) {
      throw const FormatException(
        '잘못된 로그인 응답: AccessToken이 누락되었거나 잘못되었습니다.',
      );
    }
    return LoginResponseModel(
      accessToken: access,
      refreshToken: refresh is String ? refresh : null,
    );
  }

  AuthToken toEntity() =>
      AuthToken(accessToken: accessToken, refreshToken: refreshToken);
}
