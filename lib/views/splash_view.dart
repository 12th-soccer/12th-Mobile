import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:twelfth_mobile/common/components/button/elevated_button.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/constants/twelfth_assets.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';

class TwelfthSplashView extends StatelessWidget {
  const TwelfthSplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const Spacer(),
              SvgPicture.asset(TwelfthAssets.logo),
              const Spacer(),
              TwelfthElevatedButton(
                onPressed: () => context.go(AppRoutes.login),
                child: const Text('로그인하러 가기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
