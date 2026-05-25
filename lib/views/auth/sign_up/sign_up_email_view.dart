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
import 'package:twelfth_mobile/features/auth/presentation/providers/auth_provider.dart';

class SignUpEmailView extends ConsumerStatefulWidget {
  const SignUpEmailView({super.key});

  @override
  ConsumerState<SignUpEmailView> createState() => _SignUpEmailViewState();
}

class _SignUpEmailViewState extends ConsumerState<SignUpEmailView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _onNext() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final success = await ref
        .read(authNotifierProvider.notifier)
        .sendVerificationEmail(_emailController.text);
    if (!mounted) return;
    if (success) {
      context.push(AppRoutes.signUpVerify, extra: _emailController.text);
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
            padding: AppPadding.screenH,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TwelfthAccentTitle('이메일을 입력해 주세요'),
                  CustomTextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(hintText: '이메일 입력'),
                    onFieldSubmitted: (_) => _onNext(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '이메일을 입력해 주세요';
                      }
                      if (!RegExp(
                        r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return '올바른 이메일 형식을 입력해 주세요';
                      }
                      return null;
                    },
                  ),
                  const Spacer(),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _emailController,
                    builder: (context, value, _) {
                      final isValidEmail = RegExp(
                        r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value.text);
                      final enabled = isValidEmail && !isLoading;
                      return TwelfthElevatedButton(
                        gradient: enabled
                            ? TwelfthGradient.horizontal(
                                CustomColor.silverGradient,
                              )
                            : null,
                        textColor: enabled ? CustomColor.black : null,
                        onPressed: enabled ? _onNext : null,
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: CustomColor.black,
                                ),
                              )
                            : const Text('다음'),
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
