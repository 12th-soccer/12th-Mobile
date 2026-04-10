import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/common/components/app_bar/twelfth_app_bar.dart';
import 'package:twelfth_mobile/common/components/button/elevated_button.dart';
import 'package:twelfth_mobile/common/components/title/twelfth_accent_title.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/components/text_form_field/text_form_field.dart';
import 'package:twelfth_mobile/core/extensions/snackbar_extension.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';
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

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _onCreate() async {
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

    return Scaffold(
      backgroundColor: CustomColor.background,
      appBar: const TwelfthAppBar(),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
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
                              ? Symbols.visibility_off
                              : Symbols.visibility,
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
                      final passwordRegex = RegExp(
                        r'^(?=.*[0-9])(?=.*[A-Z])(?=.*[a-z])(?=.*[_!#$*])[a-zA-Z0-9_!#$*]{8,}$',
                      );
                      if (!passwordRegex.hasMatch(value)) {
                        return '최소 비밀번호는 8글자이며 숫자, 영어 대소문자, _!#\$*만 가능합니다';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    controller: _confirmController,
                    obscureText: _obscureConfirm,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: '비밀번호 재입력',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm
                              ? Symbols.visibility_off
                              : Symbols.visibility,
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
                      final passwordRegex = RegExp(
                        r'^(?=.*[0-9])(?=.*[A-Z])(?=.*[a-z])(?=.*[_!#$*])[a-zA-Z0-9_!#$*]{8,}$',
                      );
                      if (!passwordRegex.hasMatch(value)) {
                        return '최소 비밀번호는 8글자이며 숫자, 영어 대소문자, _!#\$*만 가능합니다';
                      }
                      return null;
                    },
                  ),
                  const Spacer(),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
