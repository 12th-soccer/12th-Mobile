import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twelfth_mobile/core/network/api_endpoints.dart';
import 'package:twelfth_mobile/core/network/api_client.dart';
import 'package:twelfth_mobile/core/network/dio.dart';
import 'package:twelfth_mobile/core/network/token_storage.dart';
import 'package:twelfth_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:twelfth_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:twelfth_mobile/features/auth/domain/entities/user_info.dart';
import 'package:twelfth_mobile/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:twelfth_mobile/features/auth/domain/usecases/auth_usecases.dart';
import 'package:twelfth_mobile/features/auth/presentation/providers/auth_state.dart';

final _apiClientProvider = Provider<ApiClient>(
  (ref) => DioClient.instance.apiClient,
);
final _authRemoteDataSourceProvider = Provider<IAuthRemoteDataSource>(
  (ref) => AuthRemoteDataSourceImpl(ref.read(_apiClientProvider)),
);

final authRepositoryProvider = Provider<IAuthRepository>(
  (ref) => AuthRepositoryImpl(
    ref.read(_authRemoteDataSourceProvider),
    TokenStorage.instance,
  ),
);

final _loginUseCaseProvider = Provider<LoginUseCase>(
  (ref) => LoginUseCase(ref.read(authRepositoryProvider)),
);

final _signUpUseCaseProvider = Provider<SignUpUseCase>(
  (ref) => SignUpUseCase(ref.read(authRepositoryProvider)),
);

final _sendVerificationEmailUseCaseProvider =
    Provider<SendVerificationEmailUseCase>(
      (ref) => SendVerificationEmailUseCase(ref.read(authRepositoryProvider)),
    );

final _logoutUseCaseProvider = Provider<LogoutUseCase>(
  (ref) => LogoutUseCase(ref.read(authRepositoryProvider)),
);

final _deleteAccountUseCaseProvider = Provider<DeleteAccountUseCase>(
  (ref) => DeleteAccountUseCase(ref.read(authRepositoryProvider)),
);

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  Future<void> _refreshUserInfoCache() async {
    try {
      ref.invalidate(userInfoProvider);
      await ref.read(userInfoProvider.future);
    } catch (_) {
      ref.invalidate(userInfoProvider);
    }
  }

  Future<bool> sendVerificationEmail(String email) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await ref.read(_sendVerificationEmailUseCaseProvider).call(email);
      state = state.copyWith(status: AuthStatus.success, signUpEmail: email);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _parseEmailError(e),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: '오류가 발생했습니다. 다시 시도해 주세요',
      );
      return false;
    }
  }

  Future<bool> confirmVerificationCode(String code, String email) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      state = state.copyWith(
        verificationCode: code,
        signUpEmail: email,
        status: AuthStatus.success,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: '오류가 발생했습니다. 다시 시도해 주세요',
      );
      return false;
    }
  }

  Future<bool> signUp({required String password}) async {
    if (state.signUpEmail.isEmpty || state.verificationCode.isEmpty) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: '이메일 인증이 필요합니다',
      );
      return false;
    }
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await ref
          .read(_signUpUseCaseProvider)
          .call(
            email: state.signUpEmail,
            code: state.verificationCode,
            password: password,
          );
      await ref
          .read(_loginUseCaseProvider)
          .call(email: state.signUpEmail, password: password);
      await _refreshUserInfoCache();
      state = const AuthState(status: AuthStatus.success);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _parseError(e),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: '오류가 발생했습니다. 다시 시도해 주세요',
      );
      return false;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await ref
          .read(_loginUseCaseProvider)
          .call(email: email, password: password);
      await _refreshUserInfoCache();
      state = state.copyWith(status: AuthStatus.success);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _parseLoginError(e), // 로그인 전용 에러 메시지
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: '오류가 발생했습니다. 다시 시도해 주세요',
      );
      return false;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await ref.read(_logoutUseCaseProvider).call();
    } catch (_) {
    } finally {
      ref.invalidate(userInfoProvider);
      state = const AuthState();
    }
  }

  Future<void> deleteAccount() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await ref.read(_deleteAccountUseCaseProvider).call();
      ref.invalidate(userInfoProvider);
      state = const AuthState();
    } on ApiException catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _parseError(e),
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: '오류가 발생했습니다. 다시 시도해 주세요',
      );
    }
  }

  Future<bool> updateUsername(String username) async {
    try {
      await ref.read(authRepositoryProvider).updateUsername(username);
      await _refreshUserInfoCache();
      return true;
    } on ApiException catch (e) {
      final msg = switch (e.statusCode) {
        404 => '닉네임 변경에 실패했습니다. 다시 시도해 주세요.',
        409 => '이미 사용 중인 닉네임입니다.',
        _ => _parseError(e),
      };
      state = state.copyWith(status: AuthStatus.error, errorMessage: msg);
      return false;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: '오류가 발생했습니다. 다시 시도해 주세요',
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(status: AuthStatus.initial, errorMessage: null);
  }

  String _parseEmailError(ApiException e) {
    if (_isDuplicateEmailError(e)) {
      return '이미 가입된 이메일입니다. 로그인을 진행해주세요.';
    }
    return _parseError(e);
  }

  bool _isDuplicateEmailError(ApiException e) {
    final uriPath = e.uri?.path.toLowerCase() ?? '';
    final isEmailVerificationRequest = uriPath.endsWith(ApiEndpoints.email);
    if (!isEmailVerificationRequest) return false;

    final status = e.statusCode;
    if (status == 409) return true;

    final responseText = _flattenErrorPayload(e.responseData).toLowerCase();
    const duplicateKeywords = [
      'already',
      'exists',
      'duplicate',
      'registered',
      '이미',
      '존재',
      '중복',
      '가입된 이메일',
      '등록된 이메일',
    ];
    return duplicateKeywords.any(responseText.contains);
  }

  String _flattenErrorPayload(Object? data) {
    if (data == null) return '';
    if (data is Map || data is List) return data.toString();
    return '$data';
  }

  /// 로그인 전용 에러 파싱
  String _parseLoginError(ApiException e) {
    switch (e.statusCode) {
      case 401:
        return '잘못된 입력입니다. 다시 시도해주세요.';
      case 404:
        return '존재하지 않는 이메일입니다.';
      default:
        return _parseError(e);
    }
  }

  String _parseError(ApiException e) {
    switch (e.statusCode) {
      case 400:
        return '입력 정보를 확인해 주세요.';
      case 401:
        return '인증이 필요합니다.';
      case 403:
        return '권한이 없습니다.';
      case 404:
        return '요청한 정보를 찾을 수 없습니다.';
      case 500:
        return '서버 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.';
      default:
        if (e.isTimeout) {
          return '네트워크 연결을 확인해 주세요.';
        }
        return '오류가 발생했습니다. 다시 시도해 주세요.';
    }
  }
}

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

final userInfoProvider = FutureProvider<UserInfo>(
  (ref) => ref.read(authRepositoryProvider).getUserInfo(),
);
