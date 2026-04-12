import 'package:flutter/material.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/views/match/match_detail_view.dart';

class CenterSection extends StatelessWidget {
  final MatchState matchState;
  final int? homeScore;
  final int? awayScore;
  final String? dateStr;
  final String? timeStr;

  const CenterSection({
    super.key,
    required this.matchState,
    this.homeScore,
    this.awayScore,
    this.dateStr,
    this.timeStr,
  });

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
          ],
        );
      case MatchState.finished:
        return Text(
          homeScore != null && awayScore != null
              ? '$homeScore  :  $awayScore'
              : '-  :  -',
          style: CustomTextStyle.heading1,
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
          ],
        );
    }
  }
}
