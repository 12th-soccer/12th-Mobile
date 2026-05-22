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

  Future<void> deleteAccount();
  Future<void> updateUsername(String username);
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
      decoder: (data) =>
          LoginResponseModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<void> sendVerificationEmail(String email) async {
    await _apiClient.postVoid(ApiEndpoints.email, data: {'email': email});
  }

  @override
  Future<void> signUp({
    required String email,
    required String code,
    required String password,
  }) async {
    final result = await _apiClient.post<dynamic>(
      ApiEndpoints.signUp,
      data: {'email': email, 'code': code, 'password': password},
      decoder: (data) => data,
    );
    // 서버가 false를 반환하면 회원가입 실패
    if (result == false) {
      throw const ApiException(
        type: ApiErrorType.badResponse,
        statusCode: 400,
        message: '회원가입에 실패했습니다. 인증번호를 확인해 주세요.',
      );
    }
  }

  @override
  Future<void> logout() async {
    await _apiClient.deleteVoid(ApiEndpoints.logOut);
  }

  @override
  Future<void> deleteAccount() =>
      _apiClient.deleteVoid(ApiEndpoints.deleteAccount);

  @override
  Future<void> updateUsername(String username) =>
      _apiClient.patchVoid(
        ApiEndpoints.updateUsername,
        data: {'username': username},
      );

  @override
  Future<UserInfo> getUserInfo() async {
    try {
      return await _apiClient.get(
        ApiEndpoints.userInfo,
        decoder: (data) {
          final json = data as Map<String, dynamic>;
          return UserInfo(
            userId: json['userId'] as int,
            email: json['email'] as String,
            username: json['name'] as String?,
          );
        },
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      rethrow;
    }
  }
}
