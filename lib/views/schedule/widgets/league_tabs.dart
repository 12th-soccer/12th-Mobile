import 'package:flutter/material.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';

class LeagueTabs extends StatelessWidget {
  const LeagueTabs({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: CustomColor.gray900, width: 1),
        ),
      ),
      child: Row(
        children: List.generate(2, (index) {
          final isSelected = selectedIndex == index;
          final label = ['K1', 'K2'][index];
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected
                          ? CustomColor.white
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    label,
                    style: CustomTextStyle.heading3.copyWith(
                      color: isSelected
                          ? CustomColor.white
                          : CustomColor.gray600,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
