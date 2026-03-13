import 'package:flutter/material.dart';
import 'package:twelfth_mobile/common/components/app_bar/twelfth_app_bar.dart';
import 'package:twelfth_mobile/common/components/button/elevated_button.dart';
import 'package:twelfth_mobile/common/components/title/twelfth_accent_title.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/core/components/text_form_field/text_form_field.dart';
import 'package:go_router/go_router.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';

class SignUpEmailView extends StatefulWidget {
  const SignUpEmailView({super.key});

  @override
  State<SignUpEmailView> createState() => _SignUpEmailViewState();
}

class _SignUpEmailViewState extends State<SignUpEmailView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_formKey.currentState?.validate() ?? false) {
      context.push(AppRoutes.signUpVerify, extra: _emailController.text);
    }
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
                      final emailRegex = RegExp(
                        r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                      );
                      if (!emailRegex.hasMatch(value)) {
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
                      return TwelfthElevatedButton(
                        gradient: isValidEmail
                            ? TwelfthGradient.horizontal(
                                CustomColor.silverGradient,
                              )
                            : null,
                        textColor: isValidEmail ? CustomColor.black : null,
                        onPressed: isValidEmail ? _onNext : null,
                        child: const Text('다음'),
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
