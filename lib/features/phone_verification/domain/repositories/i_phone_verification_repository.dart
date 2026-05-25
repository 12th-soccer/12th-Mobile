abstract interface class IPhoneVerificationRepository {
  Future<void> verifyPhone(String firebaseIdToken);
}