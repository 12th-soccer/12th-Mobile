import 'package:flutter/material.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/constants/color.dart';

class CustomSnackBar {
  static const _radius = BorderRadius.all(Radius.circular(100));
  static const _margin = EdgeInsets.only(
    left: 16,
    right: 16,
    bottom: kBottomNavigationBarHeight + 8,
  );

  static SnackBar success(String message) => _build(
        message: message,
        backgroundColor: CustomColor.main,
      );

  static SnackBar error(String message) => _build(
        message: message,
        backgroundColor: CustomColor.red,
      );

  static SnackBar _build({
    required String message,
    required Color backgroundColor,
  }) {
    return SnackBar(
      content: Text(
        message,
        style: CustomTextStyle.body2.copyWith(color: CustomColor.gray950),
        textAlign: TextAlign.center,
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      margin: _margin,
      shape: const RoundedRectangleBorder(borderRadius: _radius),
      elevation: 8,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    );
  }
}
