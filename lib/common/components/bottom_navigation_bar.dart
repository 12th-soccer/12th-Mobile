import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/constants/color.dart';

class TwelfthBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const TwelfthBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const icons = [
    Symbols.star,
    Symbols.home,
    Symbols.person,
  ];

  static const labels = [
    '관심',
    '경기',
    '마이',
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: TwelfthColor.background,
        selectedItemColor: TwelfthColor.main,
        unselectedItemColor: TwelfthColor.gray500,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: icons.asMap().entries.map((entry) {
          final index = entry.key;
          final icon = entry.value;
          return BottomNavigationBarItem(
            icon: Icon(icon, fill: currentIndex == index ? 1 : 0),
            label: labels[index],
          );
        }).toList(),
      ),
    );
  }
}