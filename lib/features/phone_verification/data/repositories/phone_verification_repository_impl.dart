import 'package:twelfth_mobile/features/phone_verification/data/datasources/phone_verification_remote_datasource.dart';
import 'package:twelfth_mobile/features/phone_verification/domain/repositories/i_phone_verification_repository.dart';

class PhoneVerificationRepositoryImpl implements IPhoneVerificationRepository {
  const PhoneVerificationRepositoryImpl(this._dataSource);

  final IPhoneVerificationRemoteDataSource _dataSource;

  @override
  Future<void> verifyPhone(String firebaseIdToken) =>
      _dataSource.verifyPhone(firebaseIdToken);
}