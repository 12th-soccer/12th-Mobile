import 'package:flutter/material.dart';
import 'package:twelfth_mobile/constants/color.dart';

class TwelfthTextStyle {
  static const TextStyle Pretendard = TextStyle(fontFamily: 'Pretendard', color: TwelfthColor.white);

  /// Heading
  static TextStyle heading1 = Pretendard.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600
  );
  static TextStyle heading2 = Pretendard.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600
  );
  static TextStyle heading3 = Pretendard.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w600
  );

  /// BODY
  static TextStyle body1 = Pretendard.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w400
  );
  static TextStyle body2 = Pretendard.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w400
  );
  static TextStyle body3 = Pretendard.copyWith(
      fontSize: 10,
      fontWeight: FontWeight.w400
  );
  static TextStyle body4 = Pretendard.copyWith(
      fontSize: 8,
      fontWeight: FontWeight.w400
  );
}