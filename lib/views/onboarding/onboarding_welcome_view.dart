import 'package:flutter/material.dart';
import 'package:twelfth_mobile/common/components/button/elevated_button.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/core/constants/spacing.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:go_router/go_router.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart' show AppRoutes;

class OnboardingWelcomeView extends StatelessWidget {
  const OnboardingWelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background,
      body: SafeArea(
        child: Padding(
          padding: AppPadding.screenH,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text(
                '오신 것을 환영해요',
                style: CustomTextStyle.title,
              ),
              AppSpacing.h10,
              Text(
                '12th와 함께 K리그를 더 가깝게 즐겨보세요.\n시작하기 전 간단한 설문과 함께 좋아하는 팀과 선수를 설정해 드릴게요.',
                style: CustomTextStyle.body2.copyWith(
                  color: CustomColor.gray500,
                ),
              ),
              const Spacer(),
              TwelfthElevatedButton(
                gradient: TwelfthGradient.horizontal(CustomColor.silverGradient),
                textColor: CustomColor.black,
                onPressed: () => context.push(AppRoutes.onboardingPlayer),
                child: const Text('다음'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
