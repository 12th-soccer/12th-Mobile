import 'package:twelfth_mobile/features/auth/domain/entities/user_info.dart';

abstract interface class IAuthRepository {
  Future<void> sendVerificationEmail(String email);

  Future<void> signUp({
    required String email,
    required String code,
    required String password,
  });

  Future<void> login({required String email, required String password});

  Future<void> logout();

  Future<bool> isLoggedIn();

  Future<UserInfo> getUserInfo();
}
