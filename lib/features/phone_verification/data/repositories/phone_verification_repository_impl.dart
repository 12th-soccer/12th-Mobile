import 'package:twelfth_mobile/features/phone_verification/data/datasources/phone_verification_remote_datasource.dart';
import 'package:twelfth_mobile/features/phone_verification/domain/repositories/i_phone_verification_repository.dart';

class PhoneVerificationRepositoryImpl implements IPhoneVerificationRepository {
  const PhoneVerificationRepositoryImpl(this._dataSource);

  final IPhoneVerificationRemoteDataSource _dataSource;

  @override
  Future<void> sendCode(String phone) => _dataSource.sendCode(phone);

  @override
  Future<void> verifyCode({required String phone, required String code}) =>
      _dataSource.verifyCode(phone: phone, code: code);
}
