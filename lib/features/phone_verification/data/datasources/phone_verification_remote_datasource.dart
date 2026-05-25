import 'package:twelfth_mobile/core/network/api_client.dart';
import 'package:twelfth_mobile/core/network/api_endpoints.dart';

abstract interface class IPhoneVerificationRemoteDataSource {
  Future<void> verifyPhone(String firebaseIdToken);
}

class PhoneVerificationRemoteDataSourceImpl
    implements IPhoneVerificationRemoteDataSource {
  const PhoneVerificationRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<void> verifyPhone(String firebaseIdToken) async {
    await _apiClient.postVoid(
      ApiEndpoints.phoneVerify,
      data: {'firebaseIdToken': firebaseIdToken},
    );
  }
}