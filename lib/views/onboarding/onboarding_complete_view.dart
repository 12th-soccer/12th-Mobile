import 'package:flutter/material.dart';
import 'package:twelfth_mobile/common/components/button/elevated_button.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:go_router/go_router.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';

class OnboardingCompleteView extends StatelessWidget {
  const OnboardingCompleteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text(
                '모든 설정이 끝났어요.',
                style: CustomTextStyle.title
              ),
              const SizedBox(height: 10),
              Text(
                '이제 12th에서 K리그를 즐겨보세요!',
                style: CustomTextStyle.body2.copyWith(
                  color: CustomColor.gray500,
                ),
              ),
              const Spacer(),
              TwelfthElevatedButton(
                gradient: TwelfthGradient.horizontal(CustomColor.silverGradient),
                textColor: CustomColor.black,
                onPressed: () => context.go(AppRoutes.schedule),
                child: const Text('시작하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
