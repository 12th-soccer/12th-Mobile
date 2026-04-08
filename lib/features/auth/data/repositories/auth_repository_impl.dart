import 'package:twelfth_mobile/core/network/token_storage.dart';
import 'package:twelfth_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:twelfth_mobile/features/auth/domain/repositories/i_auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDataSource _dataSource;
  final TokenStorage _tokenStorage;

  const AuthRepositoryImpl(this._dataSource, this._tokenStorage);

  @override
  Future<void> login({required String email, required String password}) async {
    final response = await _dataSource.login(email: email, password: password);
    final token = response.toEntity();
    await _tokenStorage.saveTokens(
      accessToken: token.accessToken,
      refreshToken: token.refreshToken,
    );
  }

  @override
  Future<void> sendVerificationEmail(String email) =>
      _dataSource.sendVerificationEmail(email);

  @override
  Future<void> signUp({
    required String email,
    required String code,
    required String password,
  }) => _dataSource.signUp(email: email, code: code, password: password);

  @override
  Future<void> logout() async {
    try {
      await _dataSource.logout();
    } finally {
      await _tokenStorage.clearTokens();
    }
  }

  @override
  Future<bool> isLoggedIn() => _tokenStorage.hasToken();
}
