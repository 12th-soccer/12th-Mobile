import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:twelfth_mobile/common/components/app_bar/twelfth_app_bar.dart';
import 'package:twelfth_mobile/common/components/button/elevated_button.dart';
import 'package:twelfth_mobile/common/components/title/twelfth_accent_title.dart';
import 'package:twelfth_mobile/core/components/text_form_field/text_form_field.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/core/constants/spacing.dart';
import 'package:twelfth_mobile/core/extensions/snackbar_extension.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/features/auth/presentation/providers/auth_provider.dart';

class SignUpPasswordView extends ConsumerStatefulWidget {
  const SignUpPasswordView({super.key});

  @override
  ConsumerState<SignUpPasswordView> createState() => _SignUpPasswordViewState();
}

class _SignUpPasswordViewState extends ConsumerState<SignUpPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _submitted = false;

  static final _allowedChars = RegExp(r'^[a-zA-Z0-9_!#$*]+$');

  bool get _hasMinLength => _passwordController.text.length >= 8;
  bool get _hasMaxLength => _passwordController.text.length <= 255;
  bool get _hasUppercase => _passwordController.text.contains(RegExp(r'[A-Z]'));
  bool get _hasLowercase => _passwordController.text.contains(RegExp(r'[a-z]'));
  bool get _hasDigit => _passwordController.text.contains(RegExp(r'[0-9]'));
  bool get _hasSpecial =>
      _passwordController.text.contains(RegExp(r'[_!#$*]'));
  bool get _hasOnlyAllowed =>
      _passwordController.text.isEmpty ||
      _allowedChars.hasMatch(_passwordController.text);

  bool get _isPasswordValid =>
      _hasMinLength &&
      _hasMaxLength &&
      _hasUppercase &&
      _hasLowercase &&
      _hasDigit &&
      _hasSpecial &&
      _hasOnlyAllowed;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() => setState(() {}));
    _confirmController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _onCreate() async {
    setState(() => _submitted = true);
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final success = await ref
        .read(authNotifierProvider.notifier)
        .signUp(password: _passwordController.text);
    if (!mounted) return;
    if (success) {
      context.go(AppRoutes.signUpSuccess);
    } else {
      final errorMessage =
          ref.read(authNotifierProvider).errorMessage ?? '오류가 발생했습니다.';
      context.showErrorSnackBar(errorMessage);
      ref.read(authNotifierProvider.notifier).clearError();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authNotifierProvider).isLoading;
    final pw = _passwordController.text;
    final showRequirements = pw.isNotEmpty || _submitted;

    return Scaffold(
      backgroundColor: CustomColor.background,
      appBar: TwelfthAppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: CustomColor.main,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: AppPadding.screenH,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TwelfthAccentTitle('비밀번호를 생성해주세요'),
                  CustomTextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: '비밀번호 입력',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: CustomColor.gray600,
                          size: 20,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '비밀번호를 입력해 주세요';
                      }
                      if (!_isPasswordValid) return '';
                      return null;
                    },
                  ),
                  if (showRequirements) ...[
                    AppSpacing.h8,
                    _PasswordRequirements(
                      hasMinLength: _hasMinLength,
                      hasMaxLength: _hasMaxLength,
                      hasUppercase: _hasUppercase,
                      hasLowercase: _hasLowercase,
                      hasDigit: _hasDigit,
                      hasSpecial: _hasSpecial,
                      hasOnlyAllowed: _hasOnlyAllowed,
                      submitted: _submitted,
                    ),
                  ],
                  AppSpacing.h16,
                  CustomTextFormField(
                    controller: _confirmController,
                    obscureText: _obscureConfirm,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: '비밀번호 재입력',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: CustomColor.gray600,
                          size: 20,
                        ),
                        onPressed: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                    ),
                    onFieldSubmitted: (_) => _onCreate(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '비밀번호를 다시 입력해 주세요';
                      }
                      if (value != _passwordController.text) {
                        return '비밀번호가 일치하지 않습니다';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  ListenableBuilder(
                    listenable: Listenable.merge([
                      _passwordController,
                      _confirmController,
                    ]),
                    builder: (context, _) {
                      final isFilled =
                          _passwordController.text.isNotEmpty &&
                          _confirmController.text.isNotEmpty;
                      final enabled = isFilled && !isLoading;
                      return TwelfthElevatedButton(
                        gradient: enabled
                            ? TwelfthGradient.horizontal(
                                CustomColor.silverGradient,
                              )
                            : null,
                        textColor: enabled ? CustomColor.black : null,
                        onPressed: enabled ? _onCreate : null,
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: CustomColor.black,
                                ),
                              )
                            : const Text('생성'),
                      );
                    },
                  ),
                  AppSpacing.h48,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordRequirements extends StatelessWidget {
  final bool hasMinLength;
  final bool hasMaxLength;
  final bool hasUppercase;
  final bool hasLowercase;
  final bool hasDigit;
  final bool hasSpecial;
  final bool hasOnlyAllowed;
  final bool submitted;

  const _PasswordRequirements({
    required this.hasMinLength,
    required this.hasMaxLength,
    required this.hasUppercase,
    required this.hasLowercase,
    required this.hasDigit,
    required this.hasSpecial,
    required this.hasOnlyAllowed,
    required this.submitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CustomColor.gray900,
        borderRadius: AppRadius.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow(hasMinLength, '최소 8자 이상'),
          const SizedBox(height: 4),
          _buildRow(hasMaxLength, '최대 255자 이하'),
          const SizedBox(height: 4),
          _buildRow(hasUppercase && hasLowercase, '영어 대문자(A-Z) 및 소문자(a-z) 포함'),
          const SizedBox(height: 4),
          _buildRow(hasDigit, '숫자(0-9) 포함'),
          const SizedBox(height: 4),
          _buildRow(hasSpecial, '특수문자 포함 (_ ! # \$ *)'),
          if (!hasOnlyAllowed) ...[
            const SizedBox(height: 4),
            _buildRow(false, '허용되지 않는 문자가 포함되어 있습니다'),
          ],
        ],
      ),
    );
  }

  Widget _buildRow(bool met, String label) {
    final color = met ? CustomColor.main : CustomColor.gray500;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          met ? Icons.check_circle : Icons.radio_button_unchecked,
          color: color,
          size: 14,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: CustomTextStyle.body3.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
