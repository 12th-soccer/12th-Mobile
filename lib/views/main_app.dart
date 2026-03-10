import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/views/favorites/favorites_view.dart';
import 'package:twelfth_mobile/views/profile/profile_view.dart';
import 'package:twelfth_mobile/views/ranking/ranking_view.dart';
import 'package:twelfth_mobile/views/schedule/schedule_view.dart';

class TwelfthMainApp extends StatefulWidget {
  const TwelfthMainApp({super.key});

  @override
  State<TwelfthMainApp> createState() => _TwelfthMainAppState();
}

class _TwelfthMainAppState extends State<TwelfthMainApp> {
  int _currentIndex = 2;

  final List<Widget> _pages = const [
    RankingView(),
    ScheduleView(),
    ScheduleView(),
    FavoritesView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background,
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: const BoxDecoration(
        color: CustomColor.background,
        border: Border(top: BorderSide(color: CustomColor.gray900, width: 1)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Symbols.leaderboard, '랭킹'),
              _buildNavItem(1, Symbols.search, '검색'),
              _buildNavItem(2, Symbols.home, '홈'),
              _buildNavItem(3, Symbols.star, '관심'),
              _buildNavItem(4, Symbols.person, '프로필'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? CustomColor.white : CustomColor.gray600;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(label, style: CustomTextStyle.body4.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}
