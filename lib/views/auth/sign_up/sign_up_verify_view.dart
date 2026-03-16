import 'dart:async';

import 'package:flutter/material.dart';
import 'package:twelfth_mobile/common/components/app_bar/twelfth_app_bar.dart';
import 'package:twelfth_mobile/common/components/button/elevated_button.dart';
import 'package:twelfth_mobile/common/components/title/twelfth_accent_title.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/core/components/text_form_field/text_form_field.dart';
import 'package:go_router/go_router.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/router/router.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';

class SignUpVerifyView extends StatefulWidget {
  final String email;

  const SignUpVerifyView({super.key, required this.email});

  @override
  State<SignUpVerifyView> createState() => _SignUpVerifyViewState();
}

class _SignUpVerifyViewState extends State<SignUpVerifyView> {
  /// 실제 서비스에서는 서버로부터 받은 코드로 교체
  static const _correctCode = '123456';

  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  Timer? _timer;
  int _remainingSeconds = 300;

  @override
  void initState() {
    super.initState();
    _sendCode();
  }

  /// 인증번호 발송 (타이머 초기화 + 실제 서비스에서는 API 호출)
  void _sendCode() {
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

  @override
  void dispose() {
    _timer?.cancel();
    _codeController.dispose();
    super.dispose();
  }

  String get _timerText {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _onNext() {
    context.push(AppRoutes.signUpPassword);
  }

  @override
  Widget build(BuildContext context) {
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
                          onTap: _sendCode,
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
                    gradient: _codeController.text == _correctCode
                        ? TwelfthGradient.horizontal(CustomColor.silverGradient)
                        : null,
                    textColor: _codeController.text == _correctCode
                        ? CustomColor.black
                        : null,
                    onPressed: _codeController.text == _correctCode
                        ? _onNext
                        : null,
                    child: const Text('다음'),
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
