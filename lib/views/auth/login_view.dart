import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twelfth_mobile/common/components/button/elevated_button.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/constants/twelfth_assets.dart';
import 'package:twelfth_mobile/core/components/text_form_field/text_form_field.dart';
import 'package:go_router/go_router.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/router/router.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.go(AppRoutes.schedule);
    }
  }

  void _onGoogleLogin() {
    // TODO: 서버 연결 후 Google OAuth 구현
  }

  @override
  Widget build(BuildContext context) {
    const smallSpacing = SizedBox(height: 5);
    const middleSpacing = SizedBox(height: 10);
    const bigSpacing = SizedBox(height: 20);

    return Scaffold(
      backgroundColor: CustomColor.background,
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
                  const Spacer(flex: 2),
                  Center(child: SvgPicture.asset(TwelfthAssets.logo)),
                  const SizedBox(height: 48),
                  _buildLabel('이메일'),
                  smallSpacing,
                  CustomTextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(hintText: '이메일 입력'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '이메일을 입력해 주세요';
                      }
                      return null;
                    },
                  ),
                  bigSpacing,
                  _buildLabel('비밀번호'),
                  smallSpacing,
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
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
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
                    gradient: TwelfthGradient.horizontal(
                      CustomColor.silverGradient,
                    ),
                    textColor: CustomColor.black,
                    onPressed: _onLogin,
                    child: const Text('로그인'),
                  ),
                  middleSpacing,
                  TwelfthElevatedButton(
                    isOutlined: true,
                    borderGradient: TwelfthGradient.horizontal(
                      CustomColor.silverGradient,
                    ),
                    onPressed: () => context.push(AppRoutes.signUpEmail),
                    child: const Text('회원가입'),
                  ),
                  bigSpacing,
                  Center(
                    child: Text(
                      '소셜 로그인',
                      style: CustomTextStyle.body1.copyWith(
                        color: CustomColor.gray600,
                      ),
                    ),
                  ),
                  middleSpacing,
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
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: CustomTextStyle.body2);
  }
}
