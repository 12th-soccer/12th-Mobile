import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/views/match/match_detail_view.dart';

class CenterSection extends StatelessWidget {
  final MatchState matchState;
  final int? homeScore;
  final int? awayScore;
  final String? dateStr;
  final String? timeStr;
  final String? stadiumName;
  final VoidCallback? onStadiumTap;

  const CenterSection({
    super.key,
    required this.matchState,
    this.homeScore,
    this.awayScore,
    this.dateStr,
    this.timeStr,
    this.stadiumName,
    this.onStadiumTap,
  });

  Widget _stadiumRow() {
    if (stadiumName == null) return const SizedBox.shrink();
    return GestureDetector(
      onTap: onStadiumTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Symbols.location_on,
              size: 12,
              fill: 1,
              color: onStadiumTap != null
                  ? CustomColor.main
                  : CustomColor.gray500,
            ),
            const SizedBox(width: 4),
            Text(
              stadiumName!,
              style: CustomTextStyle.body3.copyWith(
                color: onStadiumTap != null
                    ? CustomColor.main
                    : CustomColor.gray500,
                decoration: onStadiumTap != null
                    ? TextDecoration.underline
                    : null,
                decorationColor: CustomColor.main,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (matchState) {
      case MatchState.live:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Live',
              style: CustomTextStyle.body2.copyWith(color: CustomColor.red),
            ),
            const SizedBox(height: 4),
            Text(
              homeScore != null && awayScore != null
                  ? '$homeScore  :  $awayScore'
                  : '-  :  -',
              style: CustomTextStyle.heading1,
            ),
            _stadiumRow(),
          ],
        );
      case MatchState.finished:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              homeScore != null && awayScore != null
                  ? '$homeScore  :  $awayScore'
                  : '-  :  -',
              style: CustomTextStyle.heading1,
            ),
            _stadiumRow(),
          ],
        );
      case MatchState.upcoming:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (dateStr != null)
              Text(
                dateStr!,
                style: CustomTextStyle.body2.copyWith(
                  color: CustomColor.gray500,
                ),
              ),
            if (dateStr != null) const SizedBox(height: 4),
            if (timeStr != null)
              Text(timeStr!, style: CustomTextStyle.heading1),
            _stadiumRow(),
          ],
        );
    }
  }
}
