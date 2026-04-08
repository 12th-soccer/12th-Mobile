import 'package:twelfth_mobile/features/auth/domain/repositories/i_auth_repository.dart';

class SendVerificationEmailUseCase {
  final IAuthRepository _repository;

  const SendVerificationEmailUseCase(this._repository);

  Future<void> call(String email) => _repository.sendVerificationEmail(email);
}

class SignUpUseCase {
  final IAuthRepository _repository;

  const SignUpUseCase(this._repository);

  Future<void> call({
    required String email,
    required String code,
    required String password,
  }) => _repository.signUp(email: email, code: code, password: password);
}

class LoginUseCase {
  final IAuthRepository _repository;

  const LoginUseCase(this._repository);

  Future<void> call({required String email, required String password}) =>
      _repository.login(email: email, password: password);
}

class LogoutUseCase {
  final IAuthRepository _repository;

  const LogoutUseCase(this._repository);

  Future<void> call() => _repository.logout();
}
