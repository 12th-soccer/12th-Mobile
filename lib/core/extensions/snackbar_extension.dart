import 'package:flutter/material.dart';
import 'package:twelfth_mobile/common/components/snack_bar/custom_snack_bar.dart';

extension SnackBarExtension on BuildContext {
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(CustomSnackBar.error(message));
  }

  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(CustomSnackBar.success(message));
  }
}
