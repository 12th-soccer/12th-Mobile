import 'package:flutter/material.dart';
import 'package:twelfth_mobile/common/components/image/network_avatar.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/features/ranking/domain/entities/club_detail.dart';

class ScheduleMatchRow extends StatelessWidget {
  final ClubMatch match;
  final String clubName;
  final VoidCallback onTap;

  const ScheduleMatchRow({
    super.key,
    required this.match,
    required this.clubName,
    required this.onTap,
  });

  bool get _isHome => match.homeTeamName == clubName;

  String get _dateStr {
    final d = match.matchDate;
    return '${d.month}/${d.day}';
  }

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                clubName,
                style: CustomTextStyle.body2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              _dateStr,
              style: CustomTextStyle.body3.copyWith(color: CustomColor.gray500),
            ),
            Expanded(
              child: Text(
                opponentName,
                style: CustomTextStyle.body2,
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            NetworkAvatar(imageUrl: opponentImageUrl, size: 36),
          ],
        ),
      ),
    );
  }
}
