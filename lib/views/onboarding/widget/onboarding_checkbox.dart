import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/constants/color.dart';

class OnboardingCheckbox extends StatelessWidget {
  final bool isSelected;

  const OnboardingCheckbox({
    super.key,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: isSelected ? CustomColor.black : Colors.transparent,
        border: Border.all(
          color: isSelected ? CustomColor.white : CustomColor.gray600,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: isSelected
          ? const Center(
        child: Icon(
          Symbols.check,
          size: 14,
          color: CustomColor.white,
          weight: 700,
        ),
      )
          : null,
    );
  }
}