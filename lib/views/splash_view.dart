import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twelfth_mobile/constants/twelfth_assets.dart';

class TwelfthSplashView extends StatelessWidget {
  const TwelfthSplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(TwelfthAssets.logo)
      ),
    );
  }
}