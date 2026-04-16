import 'dart:developer' as developer;
import 'package:twelfth_mobile/core/network/api_endpoints.dart';
import 'package:twelfth_mobile/core/network/api_client.dart';
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
  final ApiClient _apiClient;

  const AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    return _apiClient.post(
      ApiEndpoints.logIn,
      data: {'email': email, 'password': password},
      decoder: (data) {
        assert(() {
          developer.log('[Auth] 로그인 응답 data type: ${data.runtimeType}');
          return true;
        }());
        return LoginResponseModel.fromJson(data as Map<String, dynamic>);
      },
    );
  }

  @override
  Future<void> sendVerificationEmail(String email) async {
    developer.log('[Auth] 인증 이메일 발송 요청: $email');
    await _apiClient.postVoid(ApiEndpoints.email, data: {'email': email});
    developer.log('[Auth] 인증 이메일 발송 성공');
  }

  @override
  Future<void> signUp({
    required String email,
    required String code,
    required String password,
  }) async {
    await _apiClient.postVoid(
      ApiEndpoints.signUp,
      data: {'email': email, 'code': code, 'password': password},
    );
  }

  @override
  Future<void> logout() async {
    developer.log('[Auth] 로그아웃 요청: DELETE ${ApiEndpoints.logOut}');
    await _apiClient.deleteVoid(ApiEndpoints.logOut);
    developer.log('[Auth] 로그아웃 성공');
  }

  @override
  Future<UserInfo> getUserInfo() async {
    try {
      developer.log('[Auth] 유저 정보 요청: GET ${ApiEndpoints.userInfo}');
      return await _apiClient.get(
        ApiEndpoints.userInfo,
        decoder: (data) {
          developer.log('[Auth] 유저 정보 응답 data: $data');
          final json = data as Map<String, dynamic>;
          return UserInfo(
            userId: json['userId'] as int,
            email: json['email'] as String,
          );
        },
      );
    } on ApiException catch (e) {
      developer.log(
        '[Auth] 유저 정보 실패 (ApiException)\n'
        '  status: ${e.statusCode}\n'
        '  response: ${e.responseData}',
      );
      rethrow;
    } catch (e, stack) {
      developer.log('[Auth] 유저 정보 실패 (Exception)\n  $e\n$stack');
      rethrow;
    }
  }
}
