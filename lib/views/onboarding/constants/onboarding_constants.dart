import 'package:flutter/material.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';

class OnboardingUI {
  static const SizedBox gapH32 = SizedBox(height: 32);
  static const SizedBox gapH10 = SizedBox(height: 10);
  static const SizedBox gapH8 = SizedBox(height: 8);
  static const SizedBox gapW10 = SizedBox(width: 10);

  static const EdgeInsets horizontalPadding = EdgeInsets.symmetric(
    horizontal: 24,
  );

  static const EdgeInsets itemPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 14,
  );

  static final heading = CustomTextStyle.heading1;

  static final subText = CustomTextStyle.body2.copyWith(
    color: CustomColor.gray500,
  );

  static final itemText = CustomTextStyle.body1;

  static final itemSubText = CustomTextStyle.body2.copyWith(
    color: CustomColor.gray500,
  );

  static BoxDecoration itemBoxDecoration = BoxDecoration(
    color: CustomColor.gray900,
    borderRadius: BorderRadius.circular(8),
  );
}
