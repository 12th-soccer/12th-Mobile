import 'package:flutter/material.dart';
import 'package:twelfth_mobile/core/constants/spacing.dart';

abstract final class FanFinderConstants {
  /// BorderRadius
  static final tagChipRadius = AppRadius.sm;
  static final buttonRadius = AppRadius.sm;
  static final cardRadius = AppRadius.md;
  static final participantChipRadius = AppRadius.lg;

  /// Padding
  static const horizontalScreenPadding = AppPadding.pageH;
  static const screenPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 16);
  static const tagChipPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 6);
  static const buttonVerticalPadding = AppPadding.itemV14;
  static const cardMargin = EdgeInsets.symmetric(horizontal: 20, vertical: 6);
  static const cardPadding = AppPadding.item16;

  /// SizedBox
  static const spaceXS = AppSpacing.h6;
  static const spaceS = AppSpacing.h8;
  static const spaceM = AppSpacing.h16;
  static const spaceLM = AppSpacing.h24;
  static const spaceL = AppSpacing.h32;
  static const spaceHXS = AppSpacing.w6;
  static const spaceHS = AppSpacing.w8;

  static const filterRowHeight = 44.0;
  static const tagRowHeight = 36.0;
  static const minParticipants = 4;
  static const maxParticipants = 10;
}
