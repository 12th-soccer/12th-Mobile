import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:twelfth_mobile/core/config/app_env.dart';
import 'package:twelfth_mobile/core/network/token_storage.dart';

class DioClient {
  static final DioClient instance = DioClient._();

  DioClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppEnv.baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        headers: {'Content-Type': 'application/json'},
        followRedirects: true,
        maxRedirects: 5,
      ),
    );
    _dio.interceptors.add(_AuthInterceptor());
  }

  late final Dio _dio;

  Dio get dio => _dio;
}

class _AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await TokenStorage.instance.getAccessToken();
    developer.log('[Dio] ${options.method} ${options.path} | authHeader: ${token != null && token.isNotEmpty ? 'set' : 'unset'}');
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
      // TODO: 로그인 페이지로 이동 (NavigationService 또는 GoRouter ref 주입 필요)
    }
    handler.next(err);
  }
}
