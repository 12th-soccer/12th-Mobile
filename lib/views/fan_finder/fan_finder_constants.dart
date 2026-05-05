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
  static const minParticipants = 5;

  /// 필터/태그 옵션
  static const ageOptions = ['#20대', '#30대', '#40대', '#50대+'];
  static const genderOptions = ['#여성', '#남성', '#성별무관'];
  static const k1Teams = [
    '#FC서울', '#전북현대', '#울산HD', '#수원FC',
    '#인천유나이티드', '#대전하나시티즌', '#포항스틸러스',
    '#성남FC', '#광주FC', '#대구FC',
  ];
  static const k2Teams = [
    '#부산아이파크', '#안산그리너스', '#충남아산',
    '#서울이랜드', '#경남FC', '#김천상무',
  ];
}
