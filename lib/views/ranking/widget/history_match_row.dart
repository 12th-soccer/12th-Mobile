import 'package:twelfth_mobile/core/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/common/components/image/network_avatar.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/core/constants/club_id_map.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/features/ranking/domain/entities/club_detail.dart';

class HistoryMatchRow extends StatelessWidget {
  final ClubMatch match;
  final String clubName;
  final VoidCallback onTap;

  const HistoryMatchRow({
    super.key,
    required this.match,
    required this.clubName,
    required this.onTap,
  });

  bool get _isHome => ClubIdMap.sameTeam(match.homeTeamName, clubName);

  String get _dateStr {
    final koreanTime = match.matchDate.add(Duration(hours: 9));
    return '${koreanTime.month} / ${koreanTime.day}';
  }

  _MatchResult get _result {
    final myScore = _isHome ? match.homeTeamScore : match.awayTeamScore;
    final opScore = _isHome ? match.awayTeamScore : match.homeTeamScore;
    if (myScore == null || opScore == null) return _MatchResult.draw;
    if (myScore > opScore) return _MatchResult.win;
    if (myScore < opScore) return _MatchResult.loss;
    return _MatchResult.draw;
  }

  Color get _scoreColor {
    switch (_result) {
      case _MatchResult.win:
        return CustomColor.green;
      case _MatchResult.loss:
        return CustomColor.red;
      case _MatchResult.draw:
        return CustomColor.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final myScore = _isHome ? match.homeTeamScore : match.awayTeamScore;
    final opScore = _isHome ? match.awayTeamScore : match.homeTeamScore;
    final myImageUrl = _isHome
        ? match.homeTeamImageUrl
        : match.awayTeamImageUrl;
    final opponentImageUrl = _isHome
        ? match.awayTeamImageUrl
        : match.homeTeamImageUrl;
    final opponentName = _isHome ? match.awayTeamName : match.homeTeamName;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            NetworkAvatar(imageUrl: myImageUrl, size: 36),
            AppSpacing.w8,
            Expanded(
              child: Text(
                clubName,
                style: CustomTextStyle.body2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _dateStr,
                  style: CustomTextStyle.body3.copyWith(
                    color: CustomColor.gray500,
                  ),
                ),
                const SizedBox(height: 2),
                Icon(
                  _isHome ? Symbols.stadium : Symbols.flight,
                  size: 14,
                  color: CustomColor.gray500,
                ),
                const SizedBox(height: 2),
                Text(
                  '${myScore ?? '-'} : ${opScore ?? '-'}',
                  style: CustomTextStyle.body2.copyWith(
                    color: _scoreColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Text(
                opponentName,
                style: CustomTextStyle.body2,
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            AppSpacing.w8,
            NetworkAvatar(imageUrl: opponentImageUrl, size: 36),
          ],
        ),
      ),
    );
  }
}

enum _MatchResult { win, loss, draw }
