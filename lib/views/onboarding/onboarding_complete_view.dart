import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twelfth_mobile/common/components/button/elevated_button.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/core/constants/spacing.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:go_router/go_router.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';
import 'package:twelfth_mobile/features/favorites/presentation/providers/favorites_provider.dart';

class OnboardingCompleteView extends ConsumerWidget {
  const OnboardingCompleteView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                '모든 설정이 끝났어요.',
                style: CustomTextStyle.title,
              ),
              AppSpacing.h10,
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
                onPressed: () {
                  // 온보딩에서 등록한 관심 선수/구단이 목록에 반영되도록 갱신
                  ref.invalidate(favoritesNotifierProvider);
                  ref.invalidate(favoritePlayersNotifierProvider);
                  context.go(AppRoutes.schedule);
                },
                child: const Text('시작하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
