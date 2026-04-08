import 'package:twelfth_mobile/features/auth/domain/entities/auth_token.dart';

class LoginResponseModel {
  final String accessToken;
  final String? refreshToken;

  const LoginResponseModel({required this.accessToken, this.refreshToken});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        accessToken: json['AccessToken'] as String,
        refreshToken: json['RefreshToken'] as String?,
      );

  AuthToken toEntity() =>
      AuthToken(accessToken: accessToken, refreshToken: refreshToken);
}
