import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twelfth_mobile/core/network/api_client.dart';
import 'package:twelfth_mobile/core/network/dio.dart';
import 'package:twelfth_mobile/features/phone_verification/data/datasources/phone_verification_remote_datasource.dart';
import 'package:twelfth_mobile/features/phone_verification/data/repositories/phone_verification_repository_impl.dart';
import 'package:twelfth_mobile/features/phone_verification/domain/repositories/i_phone_verification_repository.dart';

final _apiClientProvider = Provider<ApiClient>(
  (ref) => DioClient.instance.apiClient,
);

final _phoneVerificationRemoteDataSourceProvider =
    Provider<IPhoneVerificationRemoteDataSource>(
  (ref) => PhoneVerificationRemoteDataSourceImpl(
    ref.read(_apiClientProvider),
  ),
);

final phoneVerificationRepositoryProvider =
    Provider<IPhoneVerificationRepository>(
  (ref) => PhoneVerificationRepositoryImpl(
    ref.read(_phoneVerificationRemoteDataSourceProvider),
  ),
);

class PhoneVerificationNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> sendCode(String phone) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(phoneVerificationRepositoryProvider).sendCode(phone);
    });
  }

  Future<void> verifyCode({
    required String phone,
    required String code,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(phoneVerificationRepositoryProvider)
          .verifyCode(phone: phone, code: code);
    });
  }
}

final phoneVerificationProvider = AutoDisposeAsyncNotifierProvider<
    PhoneVerificationNotifier, void>(PhoneVerificationNotifier.new);