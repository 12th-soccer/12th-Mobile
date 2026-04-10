import 'package:flutter/material.dart';
import 'package:twelfth_mobile/common/components/snack_bar/custom_snack_bar.dart';

extension SnackBarExtension on BuildContext {
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      CustomSnackBar.error(message),
    );
  }
}