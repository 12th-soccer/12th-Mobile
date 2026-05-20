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
    await _apiClient.postVoid(
      ApiEndpoints.signUp,
      data: {'email': email, 'code': code, 'password': password},
    );
  }

  @override
  Future<void> logout() async {
    await _apiClient.deleteVoid(ApiEndpoints.logOut);
  }

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
            nickname: json['nickname'] as String?,
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
