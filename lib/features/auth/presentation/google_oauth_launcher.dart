import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:twelfth_mobile/core/network/token_storage.dart';
import 'package:twelfth_mobile/features/auth/data/models/login_response_model.dart';

class GoogleOAuthLauncher {
  static const String callbackScheme = 'twelfth';
  static final Uri _authorizationUri = Uri.parse(
    'http://12th.cloud:8080/oauth2/authorization/google',
  );

  static Future<bool> open() async {
    try {
      final result = await FlutterWebAuth2.authenticate(
        url: _authorizationUri.toString(),
        callbackUrlScheme: callbackScheme,
        options: const FlutterWebAuth2Options(
          timeout: 120,
        ),
      );
      debugPrint('[GoogleOAuth] callback URL: $result');

      final response = _parseLoginResponse(Uri.parse(result));
      debugPrint(
        '[GoogleOAuth] accessToken: ${response.accessToken.substring(0, response.accessToken.length.clamp(0, 20))}...',
      );

      await TokenStorage.instance.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      return true;
    } on PlatformException catch (e) {
      debugPrint('[GoogleOAuth] canceled or platform error: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      debugPrint('[GoogleOAuth] unexpected error: $e');
      rethrow;
    }
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

    debugPrint('[GoogleOAuth] 파싱 실패. URI: $uri');
    throw const FormatException('OAuth 콜백에 accessToken이 없습니다.');
  }

  static Map<String, dynamic>? _mapFromParameters(Map<String, String> params) {
    final accessToken =
        params['accessToken'] ?? params['AccessToken'] ?? params['access_token'];
    if (accessToken != null && accessToken.isNotEmpty) {
      return <String, dynamic>{
        'accessToken': accessToken,
        'refreshToken': params['refreshToken'] ??
            params['RefreshToken'] ??
            params['refresh_token'],
        'email': params['email'],
      };
    }
    return null;
  }
}
