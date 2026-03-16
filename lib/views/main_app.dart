import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:twelfth_mobile/common/components/bottom_nav/twelfth_bottom_nav_bar.dart';
import 'package:twelfth_mobile/constants/color.dart';

class TwelfthMainApp extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const TwelfthMainApp({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background,
      body: navigationShell,
      bottomNavigationBar: TwelfthBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}
