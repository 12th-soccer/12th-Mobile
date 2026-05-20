import 'package:flutter/material.dart';
import 'package:twelfth_mobile/common/components/snack_bar/custom_snack_bar.dart';
import 'package:twelfth_mobile/core/constants/color.dart';

extension SnackBarExtension on BuildContext {
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      CustomSnackBar.error(message),
    );
  }

  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: CustomColor.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}