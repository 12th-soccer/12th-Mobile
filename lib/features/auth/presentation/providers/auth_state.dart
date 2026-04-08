enum AuthStatus { initial, loading, success, error }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;
  final String signUpEmail;
  final String verificationCode;

  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.signUpEmail = '',
    this.verificationCode = '',
  });

  bool get isLoading => status == AuthStatus.loading;

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    String? signUpEmail,
    String? verificationCode,
  }) => AuthState(
    status: status ?? this.status,
    errorMessage: errorMessage,
    signUpEmail: signUpEmail ?? this.signUpEmail,
    verificationCode: verificationCode ?? this.verificationCode,
  );
}
