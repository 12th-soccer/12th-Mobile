import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:twelfth_mobile/common/components/image/network_avatar.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';
import 'package:twelfth_mobile/features/match/domain/entities/match.dart';
import 'package:twelfth_mobile/views/match/match_detail_view.dart';

class ScheduleMatchCard extends StatelessWidget {
  const ScheduleMatchCard({super.key, required this.match});

  final Match match;

  MatchState get _state {
    if (match.isFinished) return MatchState.finished;
    if (match.matchDate.isBefore(DateTime.now())) return MatchState.live;
    return MatchState.upcoming;
  }

  String get _timeStr =>
      '${match.matchDate.hour.toString().padLeft(2, '0')}:${match.matchDate.minute.toString().padLeft(2, '0')}';

  String get _dateStr => '${match.matchDate.month}/${match.matchDate.day}';

  void _onTap(BuildContext context) {
    context.push(
      AppRoutes.match,
      extra: MatchExtra(
        matchId: match.matchId,
        homeTeam: match.homeTeamName,
        awayTeam: match.awayTeamName,
        matchState: _state,
        matchDate: _dateStr,
        matchTime: _timeStr,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _state == MatchState.live
        ? _LiveCard(match: match, onTap: () => _onTap(context))
        : _NormalRow(
            match: match,
            state: _state,
            timeStr: _timeStr,
            onTap: () => _onTap(context),
          );
  }
}

class _LiveCard extends StatelessWidget {
  final Match match;
  final VoidCallback onTap;

  const _LiveCard({required this.match, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final timeStr =
        '${match.matchDate.hour.toString().padLeft(2, '0')}:${match.matchDate.minute.toString().padLeft(2, '0')}';
    final scoreStr = match.homeTeamScore != null && match.awayTeamScore != null
        ? '${match.homeTeamScore} : ${match.awayTeamScore}'
        : '- : -';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: CustomColor.main,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: _LiveTeamBlock(
                name: match.homeTeamName,
                imageUrl: match.homeTeamImageUrl,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Live',
                    style: CustomTextStyle.body3.copyWith(
                      color: CustomColor.red,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    timeStr,
                    style: CustomTextStyle.body3.copyWith(
                      color: CustomColor.gray600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    scoreStr,
                    style: CustomTextStyle.heading2.copyWith(
                      color: CustomColor.black,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _LiveTeamBlock(
                name: match.awayTeamName,
                imageUrl: match.awayTeamImageUrl,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveTeamBlock extends StatelessWidget {
  final String name;
  final String? imageUrl;

  const _LiveTeamBlock({required this.name, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NetworkAvatar(
          imageUrl: imageUrl,
          size: 52,
          placeholderColor: CustomColor.gray500,
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: CustomTextStyle.body2.copyWith(color: CustomColor.black),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _NormalRow extends StatelessWidget {
  final Match match;
  final MatchState state;
  final String timeStr;
  final VoidCallback onTap;

  const _NormalRow({
    required this.match,
    required this.state,
    required this.timeStr,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final centerWidget =
        state == MatchState.finished &&
            match.homeTeamScore != null &&
            match.awayTeamScore != null
        ? Text(
            '${match.homeTeamScore} : ${match.awayTeamScore}',
            style: CustomTextStyle.heading3,
          )
        : Text(timeStr, style: CustomTextStyle.heading3);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  NetworkAvatar(imageUrl: match.homeTeamImageUrl, size: 32),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      match.homeTeamName,
                      style: CustomTextStyle.body2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: centerWidget,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      match.awayTeamName,
                      style: CustomTextStyle.body2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(width: 8),
                  NetworkAvatar(imageUrl: match.awayTeamImageUrl, size: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
