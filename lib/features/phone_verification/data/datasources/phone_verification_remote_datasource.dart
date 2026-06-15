import 'package:twelfth_mobile/core/network/api_client.dart';
import 'package:twelfth_mobile/core/network/api_endpoints.dart';

abstract interface class IPhoneVerificationRemoteDataSource {
  Future<void> sendCode(String phone);

  Future<void> verifyCode({required String phone, required String code});
}

class PhoneVerificationRemoteDataSourceImpl
    implements IPhoneVerificationRemoteDataSource {
  const PhoneVerificationRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<void> sendCode(String phone) async {
    await _apiClient.postVoid(
      ApiEndpoints.phoneSend,
      data: {'phone': phone},
    );
  }

  @override
  Future<void> verifyCode({
    required String phone,
    required String code,
  }) async {
    await _apiClient.postVoid(
      ApiEndpoints.phoneVerify,
      data: {'phone': phone, 'code': code},
    );
  }
}
