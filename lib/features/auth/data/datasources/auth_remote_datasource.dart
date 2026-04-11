import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:twelfth_mobile/core/network/api_endpoints.dart';
import 'package:twelfth_mobile/features/auth/data/models/login_response_model.dart';
import 'package:twelfth_mobile/features/auth/domain/entities/user_info.dart';

abstract interface class IAuthRemoteDataSource {
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  });

  Future<void> sendVerificationEmail(String email);

  Future<void> signUp({
    required String email,
    required String code,
    required String password,
  });

  Future<void> logout();

  Future<UserInfo> getUserInfo();
}

class AuthRemoteDataSourceImpl implements IAuthRemoteDataSource {
  final Dio _dio;

  const AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.logIn,
      data: {'email': email, 'password': password},
    );
    final rawData = response.data;
    assert(() {
      developer.log('[Auth] 로그인 응답 data type: ${rawData.runtimeType}');
      return true;
    }());
    final Map<String, dynamic> jsonMap = rawData is String
        ? jsonDecode(rawData) as Map<String, dynamic>
        : rawData as Map<String, dynamic>;
    return LoginResponseModel.fromJson(jsonMap);
  }

  @override
  Future<void> sendVerificationEmail(String email) async {
    developer.log('[Auth] 인증 이메일 발송 요청: $email');
    final response = await _dio.post(ApiEndpoints.email, data: {'email': email});
    developer.log('[Auth] 인증 이메일 발송 응답: status=${response.statusCode}, data=${response.data}');
  }

  @override
  Future<void> signUp({
    required String email,
    required String code,
    required String password,
  }) async {
    await _dio.post(
      ApiEndpoints.signUp,
      data: {'email': email, 'code': code, 'password': password},
    );
  }

  @override
  Future<void> logout() async {
    developer.log('[Auth] 로그아웃 요청: DELETE ${ApiEndpoints.logOut}');
    final response = await _dio.delete(ApiEndpoints.logOut);
    developer.log('[Auth] 로그아웃 응답: status=${response.statusCode}');
  }

  @override
  Future<UserInfo> getUserInfo() async {
    try {
      developer.log('[Auth] 유저 정보 요청: GET ${ApiEndpoints.userInfo}');
      final response = await _dio.get(ApiEndpoints.userInfo);
      developer.log('[Auth] 유저 정보 응답: status=${response.statusCode} | data=${response.data}');
      final rawData = response.data;
      final Map<String, dynamic> json = rawData is String
          ? jsonDecode(rawData) as Map<String, dynamic>
          : rawData as Map<String, dynamic>;
      return UserInfo(
        userId: json['userId'] as int,
        email: json['email'] as String,
      );
    } on DioException catch (e) {
      developer.log(
        '[Auth] 유저 정보 실패 (DioException)\n'
        '  status: ${e.response?.statusCode}\n'
        '  response: ${e.response?.data}',
      );
      rethrow;
    } catch (e, stack) {
      developer.log('[Auth] 유저 정보 실패 (Exception)\n  $e\n$stack');
      rethrow;
    }
  }
}
