import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:go_router/go_router.dart';
import 'package:twelfth_mobile/common/components/button/elevated_button.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/constants/twelfth_assets.dart';
import 'package:twelfth_mobile/core/components/text_form_field/text_form_field.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/core/constants/spacing.dart';
import 'package:twelfth_mobile/core/extensions/snackbar_extension.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';
import 'package:twelfth_mobile/features/auth/presentation/google_oauth_launcher.dart';
import 'package:twelfth_mobile/features/auth/presentation/providers/auth_provider.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  static const _smallSpacing = AppSpacing.h8;
  static const _middleSpacing = AppSpacing.h10;
  static const _bigSpacing = AppSpacing.h20;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final success = await ref
        .read(authNotifierProvider.notifier)
        .login(
          email: _emailController.text,
          password: _passwordController.text,
        );
    if (!mounted) return;
    if (success) {
      context.go(AppRoutes.schedule);
    } else {
      final error = ref.read(authNotifierProvider).errorMessage;
      _showError(error ?? '오류가 발생했습니다');
      ref.read(authNotifierProvider.notifier).clearError();
    }
  }

  Future<void> _onGoogleLogin() async {
    try {
      final success = await GoogleOAuthLauncher.open();
      if (!mounted || !success) return;
      ref.invalidate(userInfoProvider);
      context.go(AppRoutes.schedule);
    } catch (_) {
      if (!mounted) return;
      context.showErrorSnackBar('구글 로그인을 시작하지 못했습니다.');
    }
  }

  void _showError(String message) {
    final errorMessage =
        ref.read(authNotifierProvider).errorMessage ?? '오류가 발생했습니다';

    context.showErrorSnackBar(errorMessage);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authNotifierProvider).isLoading;

    return Scaffold(
      backgroundColor: CustomColor.background,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: AppPadding.screenH,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(flex: 2),
                  Center(child: Image.asset(TwelfthAssets.logo, width: 160)),
                  AppSpacing.h32,
                  _buildLabel('이메일'),
                  _smallSpacing,
                  CustomTextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(hintText: '이메일 입력'),
                    validator: (value) {
                      if (value == null || value.isEmpty) return '이메일을 입력해 주세요';
                      return null;
                    },
                  ),
                  _bigSpacing,
                  _buildLabel('비밀번호'),
                  _smallSpacing,
                  CustomTextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: '비밀번호 입력',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Symbols.visibility_off
                              : Symbols.visibility,
                          color: CustomColor.gray600,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
                    onFieldSubmitted: (_) => _onLogin(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '비밀번호를 입력해 주세요';
                      }
                      return null;
                    },
                  ),
                  const Spacer(flex: 1),
                  TwelfthElevatedButton(
                    gradient: !isLoading
                        ? TwelfthGradient.horizontal(CustomColor.silverGradient)
                        : null,
                    textColor: !isLoading ? CustomColor.black : null,
                    onPressed: !isLoading ? _onLogin : null,
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: CustomColor.black,
                            ),
                          )
                        : const Text('로그인'),
                  ),
                  _middleSpacing,
                  TwelfthElevatedButton(
                    isOutlined: true,
                    borderGradient: TwelfthGradient.horizontal(
                      CustomColor.silverGradient,
                    ),
                    onPressed: () => context.push(AppRoutes.signUpEmail),
                    child: const Text('회원가입'),
                  ),
                  _bigSpacing,
                  Center(
                    child: Text(
                      '소셜 로그인',
                      style: CustomTextStyle.body1.copyWith(
                        color: CustomColor.gray600,
                      ),
                    ),
                  ),
                  _middleSpacing,
                  TwelfthElevatedButton(
                    backgroundColor: CustomColor.white,
                    textColor: CustomColor.black,
                    imgPath: TwelfthAssets.google,
                    onPressed: _onGoogleLogin,
                    child: const Text('구글 계정으로 로그인'),
                  ),
                ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(text, style: CustomTextStyle.body2);
}
