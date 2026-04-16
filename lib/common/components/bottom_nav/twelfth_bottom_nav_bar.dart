import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/constants/color.dart';

class TwelfthBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const TwelfthBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
    final isSelected = currentIndex == index;
    final color = isSelected ? CustomColor.white : CustomColor.gray600;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22, fill: isSelected ? 1.0 : 0.0),
            const SizedBox(height: 4),
            Text(label, style: CustomTextStyle.body2.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}
