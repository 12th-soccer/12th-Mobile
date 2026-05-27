import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:twelfth_mobile/core/network/token_storage.dart';
import 'package:twelfth_mobile/features/auth/data/models/login_response_model.dart';

class GoogleOAuthLauncher {
  static const String callbackScheme = 'twelfth';
  static final Uri _authorizationUri = Uri.parse(
    'http://12th.cloud:8080/oauth2/authorization/google',
  );

  static bool _isInProgress = false;
  static Completer<Uri>? _completer;
  static StreamSubscription<Uri>? _sub;

  static Future<bool> open() async {
    if (_isInProgress) return false;
    _isInProgress = true;
    _completer = Completer<Uri>();

    try {
      final launched = await launchUrl(
        _authorizationUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        return false;
      }

      final appLinks = AppLinks();
      _sub = appLinks.uriLinkStream.listen(
        (uri) {
          if (uri.scheme == callbackScheme && !(_completer?.isCompleted ?? true)) {
            _completer!.complete(uri);
          }
        },
        onError: (e) {
          if (!(_completer?.isCompleted ?? true)) {
            _completer!.completeError(e);
          }
        },
      );

      final callbackUri = await _completer!.future.timeout(
        const Duration(seconds: 120),
        onTimeout: () => throw TimeoutException('OAuth 타임아웃'),
      );

      final response = _parseLoginResponse(callbackUri);

      await TokenStorage.instance.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      return true;
    } on TimeoutException {
      return false;
    } catch (e) {
      rethrow;
    } finally {
      _cleanup();
    }
  }

  static void cancel() {
    if (!_isInProgress) return;
    if (!(_completer?.isCompleted ?? true)) {
      _completer!.completeError(Exception('cancelled'));
    }
    _cleanup();
  }

  static void _cleanup() {
    _sub?.cancel();
    _sub = null;
    _completer = null;
    _isInProgress = false;
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
      try {
        final decoded = Uri.splitQueryString(payload);
        final result = _mapFromParameters(decoded);
        if (result != null) return LoginResponseModel.fromJson(result);
      } catch (_) {}
    }

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
        'email': params['email'] ?? params['Email'],
      };
    }
    return null;
  }
}
