import 'package:twelfth_mobile/core/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:twelfth_mobile/common/components/button/elevated_button.dart';
import 'package:twelfth_mobile/constants/twelfth_assets.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/core/network/token_storage.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';

class TwelfthSplashView extends StatefulWidget {
  const TwelfthSplashView({super.key});

  @override
  State<TwelfthSplashView> createState() => _TwelfthSplashViewState();
}

class _TwelfthSplashViewState extends State<TwelfthSplashView> {
  bool _checked = false;
  bool _hasToken = false;

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    final hasToken = await TokenStorage.instance.hasToken();
    if (!mounted) return;
    if (hasToken) {
      context.go(AppRoutes.ranking);
    } else {
      setState(() {
        _checked = true;
        _hasToken = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_checked || _hasToken) {
      return Scaffold(
        backgroundColor: CustomColor.background,
        body: Center(child: SvgPicture.asset(TwelfthAssets.logo)),
      );
    }

    return Scaffold(
      backgroundColor: CustomColor.background,
      body: SafeArea(
        child: Padding(
          padding: AppPadding.pageH,
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
