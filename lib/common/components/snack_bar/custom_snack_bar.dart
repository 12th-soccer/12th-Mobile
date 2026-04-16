import 'package:flutter/material.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/constants/color.dart';

class CustomSnackBar {
  static SnackBar error(String message) {
    return SnackBar(
      content: Text(
        message,
        style: CustomTextStyle.body2.copyWith(color: CustomColor.black),
      ),
      backgroundColor: CustomColor.main,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}