import 'package:flutter/material.dart';
import 'package:twelfth_mobile/common/components/button/elevated_button.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:go_router/go_router.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/core/router/router.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';

class SignUpSuccessView extends StatelessWidget {
  const SignUpSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text(
                '회원가입 성공',
                style: CustomTextStyle.heading1,
              ),
              const SizedBox(height: 10),
              Text(
                '12th에 오신 것을 환영합니다.\n시작 전 간단한 설문을 진행할게요.',
                style: CustomTextStyle.body2.copyWith(
                  color: CustomColor.gray500,
                ),
              ),
              const Spacer(),
              TwelfthElevatedButton(
                gradient: TwelfthGradient.horizontal(
                  CustomColor.silverGradient
                ),
                textColor: CustomColor.black,
                onPressed: () {
                  context.go(AppRoutes.onboardingWelcome);
                },
                child: const Text('다음'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
