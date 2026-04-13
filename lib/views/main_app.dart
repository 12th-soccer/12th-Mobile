import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:twelfth_mobile/common/components/bottom_nav/twelfth_bottom_nav_bar.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/core/services/fcm_service.dart';

class TwelfthMainApp extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const TwelfthMainApp({super.key, required this.navigationShell});

  @override
  ConsumerState<TwelfthMainApp> createState() => _TwelfthMainAppState();
}

class _TwelfthMainAppState extends ConsumerState<TwelfthMainApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FcmService.initialize(ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background,
      body: widget.navigationShell,
      bottomNavigationBar: TwelfthBottomNavBar(
        currentIndex: widget.navigationShell.currentIndex,
        onTap: (index) {
          widget.navigationShell.goBranch(index, initialLocation: true);
        },
      ),
    );
  }
}
