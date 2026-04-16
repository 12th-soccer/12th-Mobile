import 'dart:convert';

import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:twelfth_mobile/core/network/token_storage.dart';
import 'package:twelfth_mobile/features/auth/data/models/login_response_model.dart';

class GoogleOAuthLauncher {
  static const String callbackScheme = 'twelfth';
  static final Uri _authorizationUri = Uri.parse(
    'http://12th.cloud/oauth2/authorization/google',
  );

  static Future<bool> open() async {
    final result = await FlutterWebAuth2.authenticate(
      url: _authorizationUri.toString(),
      callbackUrlScheme: callbackScheme,
    );
    final response = _parseLoginResponse(Uri.parse(result));
    await TokenStorage.instance.saveTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
    return true;
  }

  static LoginResponseModel _parseLoginResponse(Uri uri) {
    final queryJson = _mapFromParameters(uri.queryParameters);
    if (queryJson != null) {
      return LoginResponseModel.fromJson(queryJson);
    }

    if (uri.fragment.isNotEmpty) {
      final fragmentJson = _mapFromParameters(
        Uri.splitQueryString(uri.fragment),
      );
      if (fragmentJson != null) {
        return LoginResponseModel.fromJson(fragmentJson);
      }
    }

    final payload =
        uri.queryParameters['payload'] ?? uri.queryParameters['data'];
    if (payload != null && payload.isNotEmpty) {
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) {
        return LoginResponseModel.fromJson(decoded);
      }
    }

    throw const FormatException('OAuth 콜백에 accessToken이 없습니다.');
  }

  static Map<String, dynamic>? _mapFromParameters(Map<String, String> params) {
    if (params.containsKey('accessToken') ||
        params.containsKey('AccessToken')) {
      return <String, dynamic>{
        'accessToken': params['accessToken'] ?? params['AccessToken'],
        'refreshToken': params['refreshToken'] ?? params['RefreshToken'],
        'email': params['email'],
      };
    }
    return null;
  }
}
