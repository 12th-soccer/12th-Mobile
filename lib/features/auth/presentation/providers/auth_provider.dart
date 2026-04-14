import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  Future<bool> sendVerificationEmail(String email) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      developer.log('[Auth] 인증 이메일 발송: $email');
      await ref.read(_sendVerificationEmailUseCaseProvider).call(email);
      state = state.copyWith(status: AuthStatus.success, signUpEmail: email);
      developer.log('[Auth] 인증 이메일 발송 성공');
      return true;
    } on ApiException catch (e) {
      developer.log(
        '[Auth] 인증 이메일 발송 실패 (ApiException)\n'
        '  type: ${e.type}\n'
        '  status: ${e.statusCode}\n'
        '  message: ${e.message}\n'
        '  response: ${e.responseData}\n'
        '  URL: ${e.uri}',
      );
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _parseEmailError(e),
      );
      return false;
    } catch (e, stack) {
      developer.log('[Auth] 인증 이메일 발송 실패 (Exception)\n  $e\n$stack');
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
      developer.log('[Auth] 인증 코드 저장: email=$email, code=$code');
      state = state.copyWith(
        verificationCode: code,
        signUpEmail: email,
        status: AuthStatus.success,
      );
      developer.log('[Auth] 인증 코드 저장 완료');
      return true;
    } catch (e, stack) {
      developer.log('[Auth] 인증 코드 저장 실패 (Exception)\n  $e\n$stack');
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
      developer.log(
        '[Auth] 회원가입 시작: email=${state.signUpEmail}, code=${state.verificationCode}',
      );
      await ref
          .read(_signUpUseCaseProvider)
          .call(
            email: state.signUpEmail,
            code: state.verificationCode,
            password: password,
          );
      developer.log('[Auth] 회원가입 성공 → 자동 로그인 시도');
      // 회원가입 후 바로 토큰을 받아야 온보딩에서 API 호출 가능
      await ref
          .read(_loginUseCaseProvider)
          .call(email: state.signUpEmail, password: password);
      developer.log('[Auth] 자동 로그인 성공 → 토큰 저장 완료');
      state = const AuthState(status: AuthStatus.success);
      return true;
    } on ApiException catch (e) {
      developer.log(
        '[Auth] 회원가입 실패 (ApiException)\n'
        '  type: ${e.type}\n'
        '  status: ${e.statusCode}\n'
        '  message: ${e.message}\n'
        '  response: ${e.responseData}\n'
        '  URL: ${e.uri}',
      );
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _parseError(e),
      );
      return false;
    } catch (e, stack) {
      developer.log('[Auth] 회원가입 실패 (Exception)\n  $e\n$stack');
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
      developer.log('[Auth] 로그인 시작: email=$email');
      await ref
          .read(_loginUseCaseProvider)
          .call(email: email, password: password);
      developer.log('[Auth] 로그인 성공');
      state = state.copyWith(status: AuthStatus.success);
      return true;
    } on ApiException catch (e) {
      developer.log(
        '[Auth] 로그인 실패 (ApiException)\n'
        '  type: ${e.type}\n'
        '  status: ${e.statusCode}\n'
        '  message: ${e.message}\n'
        '  response: ${e.responseData}\n'
        '  URL: ${e.uri}',
      );
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _parseError(e),
      );
      return false;
    } catch (e, stack) {
      developer.log('[Auth] 로그인 실패 (Exception)\n  $e\n$stack');
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: '오류가 발생했습니다. 다시 시도해 주세요',
      );
      return false;
    }
  }

  Future<void> logout() async {
    developer.log('[Auth] 로그아웃 시작');
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await ref.read(_logoutUseCaseProvider).call();
      developer.log('[Auth] 로그아웃 성공 → 상태 초기화');
    } on ApiException catch (e) {
      developer.log(
        '[Auth] 로그아웃 실패 (ApiException)\n'
        '  type: ${e.type}\n'
        '  status: ${e.statusCode}\n'
        '  message: ${e.message}\n'
        '  response: ${e.responseData}',
      );
    } catch (e, stack) {
      developer.log('[Auth] 로그아웃 실패 (Exception)\n  $e\n$stack');
    } finally {
      developer.log('[Auth] 로그아웃 finally → 토큰 초기화');
      state = const AuthState();
    }
  }

  void clearError() {
    state = state.copyWith(status: AuthStatus.initial, errorMessage: null);
  }

  String _parseEmailError(ApiException e) {
    final status = e.statusCode;
    if (status == 409 || status == 400) {
      return '이미 가입된 이메일 입니다.';
    }
    return _parseError(e);
  }

  String _parseError(ApiException e) {
    switch (e.statusCode) {
      case 400:
        return '입력 정보를 확인해 주세요';
      case 401:
        return '이메일 또는 비밀번호가 올바르지 않습니다';
      case 403:
        return '권한이 없습니다';
      case 404:
        return '해당 이메일을 가진 유저를 찾을 수 없습니다';
      case 409:
        return '이미 등록된 이메일입니다.';
      case 500:
        return '서버 오류가 발생했습니다';
      default:
        if (e.isTimeout) {
          return '네트워크 연결을 확인해 주세요';
        }
        return '오류가 발생했습니다. 다시 시도해 주세요';
    }
  }
}

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

final userInfoProvider = FutureProvider<UserInfo>(
  (ref) => ref.read(authRepositoryProvider).getUserInfo(),
);
