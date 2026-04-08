import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twelfth_mobile/core/network/dio.dart';
import 'package:twelfth_mobile/core/network/token_storage.dart';
import 'package:twelfth_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:twelfth_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:twelfth_mobile/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:twelfth_mobile/features/auth/domain/usecases/auth_usecases.dart';
import 'package:twelfth_mobile/features/auth/presentation/providers/auth_state.dart';

final _dioProvider = Provider<Dio>((ref) => DioClient.instance.dio);
final _authRemoteDataSourceProvider = Provider<IAuthRemoteDataSource>(
  (ref) => AuthRemoteDataSourceImpl(ref.read(_dioProvider)),
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
    } on DioException catch (e) {
      developer.log(
        '[Auth] 인증 이메일 발송 실패 (DioException)\n'
        '  type: ${e.type}\n'
        '  status: ${e.response?.statusCode}\n'
        '  message: ${e.message}\n'
        '  response: ${e.response?.data}\n'
        '  URL: ${e.requestOptions.uri}',
      );
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _parseError(e),
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
    state = state.copyWith(status: AuthStatus.loading);
    try {
      developer.log('[Auth] 회원가입 시작: email=${state.signUpEmail}, code=${state.verificationCode}');
      await ref
          .read(_signUpUseCaseProvider)
          .call(
            email: state.signUpEmail,
            code: state.verificationCode,
            password: password,
          );
      developer.log('[Auth] 회원가입 성공');
      state = const AuthState(status: AuthStatus.success);
      return true;
    } on DioException catch (e) {
      developer.log(
        '[Auth] 회원가입 실패 (DioException)\n'
        '  type: ${e.type}\n'
        '  status: ${e.response?.statusCode}\n'
        '  message: ${e.message}\n'
        '  response: ${e.response?.data}\n'
        '  URL: ${e.requestOptions.uri}',
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
    } on DioException catch (e) {
      developer.log(
        '[Auth] 로그인 실패 (DioException)\n'
        '  type: ${e.type}\n'
        '  status: ${e.response?.statusCode}\n'
        '  message: ${e.message}\n'
        '  response: ${e.response?.data}\n'
        '  URL: ${e.requestOptions.uri}',
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
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await ref.read(_logoutUseCaseProvider).call();
    } finally {
      state = const AuthState();
    }
  }

  void clearError() {
    state = state.copyWith(status: AuthStatus.initial, errorMessage: null);
  }

  String _parseError(DioException e) {
    switch (e.response?.statusCode) {
      case 400:
        return '입력 정보를 확인해 주세요';
      case 401:
        return '이메일 또는 비밀번호가 올바르지 않습니다';
      case 403:
        return '권한이 없습니다';
      case 404:
        return '해당 이메일을 가진 유저를 찾을 수 없습니다';
      case 409:
        return '이미 가입된 이메일입니다';
      case 500:
        return '서버 오류가 발생했습니다';
      default:
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          return '네트워크 연결을 확인해 주세요';
        }
        return '오류가 발생했습니다. 다시 시도해 주세요';
    }
  }
}

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
