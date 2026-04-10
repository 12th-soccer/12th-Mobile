import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:twelfth_mobile/common/components/app_bar/twelfth_app_bar.dart';
import 'package:twelfth_mobile/common/components/button/elevated_button.dart';
import 'package:twelfth_mobile/common/components/title/twelfth_accent_title.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/components/text_form_field/text_form_field.dart';
import 'package:twelfth_mobile/core/extensions/snackbar_extension.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';
import 'package:twelfth_mobile/features/auth/presentation/providers/auth_provider.dart';

class SignUpVerifyView extends ConsumerStatefulWidget {
  final String email;

  const SignUpVerifyView({super.key, required this.email});

  @override
  ConsumerState<SignUpVerifyView> createState() => _SignUpVerifyViewState();
}

class _SignUpVerifyViewState extends ConsumerState<SignUpVerifyView> {
  final _codeController = TextEditingController();
  Timer? _timer;
  int _remainingSeconds = 300;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _resendCode() async {
    await ref
        .read(authNotifierProvider.notifier)
        .sendVerificationEmail(widget.email);
    if (!mounted) return;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _remainingSeconds = 300);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  String get _timerText {
    final m = _remainingSeconds ~/ 60;
    final s = _remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Future<void> _onNext() async {
    final success = await ref
        .read(authNotifierProvider.notifier)
        .confirmVerificationCode(_codeController.text, widget.email);
    if (!mounted) return;
    if (success) {
      context.push(AppRoutes.signUpPassword);
    } else {
      final errorMessage =
          ref.read(authNotifierProvider).errorMessage ?? '오류가 발생했습니다';

      context.showErrorSnackBar(errorMessage);
      ref.read(authNotifierProvider.notifier).clearError();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isComplete = _codeController.text.length == 6;
    final isLoading = ref.watch(authNotifierProvider).isLoading;

    return Scaffold(
      backgroundColor: CustomColor.background,
      appBar: const TwelfthAppBar(),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TwelfthAccentTitle('이메일을 인증해주세요'),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          controller: _codeController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            hintText: '인증번호 입력',
                            counterText: '',
                            suffixIcon: Align(
                              alignment: Alignment.centerRight,
                              widthFactor: 1.0,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Text(
                                  _timerText,
                                  style: CustomTextStyle.body2.copyWith(
                                    color: _remainingSeconds > 0
                                        ? CustomColor.red
                                        : CustomColor.gray600,
                                  ),
                                ),
                              ),
                            ),
                            suffixIconConstraints: const BoxConstraints(),
                          ),
                          maxLength: 6,
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _resendCode,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: CustomColor.gray900,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text('재전송', style: CustomTextStyle.body2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                TwelfthElevatedButton(
                  gradient: isComplete && !isLoading
                      ? TwelfthGradient.horizontal(CustomColor.silverGradient)
                      : null,
                  textColor: isComplete && !isLoading
                      ? CustomColor.black
                      : null,
                  onPressed: isComplete && !isLoading ? _onNext : null,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
