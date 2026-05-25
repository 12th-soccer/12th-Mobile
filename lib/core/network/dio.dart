import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:twelfth_mobile/core/config/app_env.dart';
import 'package:twelfth_mobile/core/network/api_client.dart';
import 'package:twelfth_mobile/core/network/token_storage.dart';
import 'package:twelfth_mobile/core/services/session_manager.dart';

class DioClient {
  static final DioClient instance = DioClient._();

  DioClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppEnv.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
        followRedirects: true,
        maxRedirects: 5,
      ),
    );
    _dio.interceptors.add(_AuthInterceptor());
    _dio.interceptors.add(_LogInterceptor());
    _apiClient = DioApiClient(_dio);
  }

  late final Dio _dio;
  late final ApiClient _apiClient;

  Dio get dio => _dio;
  ApiClient get apiClient => _apiClient;
}

class _LogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('┌── REQUEST ─────────────────────────────');
    debugPrint('│ ${options.method} ${options.uri}');
    final auth = options.headers['Authorization'] as String?;
    debugPrint('│ auth: ${auth != null ? 'Bearer ***${auth.length > 20 ? auth.substring(auth.length - 6) : '?'}' : '❌ NO TOKEN'}');
    if (options.data != null) debugPrint('│ body: ${options.data}');
    debugPrint('└────────────────────────────────────────');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('┌── RESPONSE ────────────────────────────');
    debugPrint('│ ${response.statusCode} ${response.requestOptions.uri}');
    debugPrint('│ body: ${response.data}');
    debugPrint('└────────────────────────────────────────');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('┌── ERROR ───────────────────────────────');
    debugPrint('│ ${err.response?.statusCode} ${err.requestOptions.uri}');
    debugPrint('│ message: ${err.message}');
    debugPrint('│ response: ${err.response?.data}');
    debugPrint('└────────────────────────────────────────');
    handler.next(err);
  }
}

class _AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await TokenStorage.instance.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      await TokenStorage.instance.clearTokens();
      SessionManager.notifyExpired(); // 앱 전체에 세션 만료 알림
    }
    handler.next(err);
  }
}
