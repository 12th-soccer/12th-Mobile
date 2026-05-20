import 'package:flutter/material.dart';

int get kStartSeason => DateTime.now().year - 10;

abstract final class AppSpacing {
  /// vertical SizedBox
  static const h4 = SizedBox(height: 4);
  static const h6 = SizedBox(height: 6);
  static const h8 = SizedBox(height: 8);
  static const h10 = SizedBox(height: 10);
  static const h12 = SizedBox(height: 12);
  static const h16 = SizedBox(height: 16);
  static const h20 = SizedBox(height: 20);
  static const h24 = SizedBox(height: 24);
  static const h32 = SizedBox(height: 32);
  static const h48 = SizedBox(height: 48);

  /// horizontal SizedBox
  static const w4 = SizedBox(width: 4);
  static const w6 = SizedBox(width: 6);
  static const w8 = SizedBox(width: 8);
  static const w10 = SizedBox(width: 10);
  static const w12 = SizedBox(width: 12);
}

abstract final class AppPadding {
  /// screen-level horizontal padding
  static const screenH = EdgeInsets.symmetric(horizontal: 24);
  static const pageH = EdgeInsets.symmetric(horizontal: 20);
  static const cardH = EdgeInsets.symmetric(horizontal: 16);

  /// list / item padding
  static const listV = EdgeInsets.symmetric(vertical: 8);
  static const itemV12 = EdgeInsets.symmetric(vertical: 12);
  static const itemV14 = EdgeInsets.symmetric(vertical: 14);
  static const item16 = EdgeInsets.all(16);
  static const item20 = EdgeInsets.all(20);
}

abstract final class AppRadius {
  static const double xsValue = 2;
  static const double smValue = 8;
  static const double mdValue = 12;
  static const double lgValue = 20;

  static final xs = BorderRadius.circular(xsValue);
  static final sm = BorderRadius.circular(smValue);
  static final md = BorderRadius.circular(mdValue);
  static final lg = BorderRadius.circular(lgValue);
}
