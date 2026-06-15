abstract interface class IPhoneVerificationRepository {
  Future<void> sendCode(String phone);
  Future<void> verifyCode({required String phone, required String code});
}
