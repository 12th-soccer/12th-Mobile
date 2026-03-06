import 'package:flutter/material.dart';
import 'package:twelfth_mobile/constants/color.dart';

class CustomTextStyle {
  /// title
  static TextStyle title = defaultTextStyle.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w600
  );

  /// heading
  static TextStyle heading1 = defaultTextStyle.copyWith(
    fontSize:20,
    fontWeight: FontWeight.w600
  );

  static TextStyle heading2 = defaultTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600
  );

  static TextStyle heading3 = defaultTextStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600
  );

  /// body
  static TextStyle body1 = defaultTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400
  );

  static TextStyle body2 = defaultTextStyle.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w400
  );

  static TextStyle body3 = defaultTextStyle.copyWith(
      fontSize: 10,
      fontWeight: FontWeight.w400
  );

  static TextStyle body4 = defaultTextStyle.copyWith(
      fontSize: 8,
      fontWeight: FontWeight.w400
  );
}

const TextStyle defaultTextStyle = TextStyle(
  color: CustomColor.white,
  fontFamily: 'Pretendard',
);