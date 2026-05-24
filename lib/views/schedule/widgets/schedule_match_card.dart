import 'package:twelfth_mobile/core/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/common/components/image/network_avatar.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';
import 'package:twelfth_mobile/features/match/domain/entities/match.dart';
import 'package:twelfth_mobile/features/no_spoiler/presentation/providers/no_spoiler_provider.dart';
import 'package:twelfth_mobile/features/no_spoiler/presentation/providers/revealed_matches_provider.dart';
import 'package:twelfth_mobile/views/match/match_detail_view.dart';

class ScheduleMatchCard extends ConsumerWidget {
  const ScheduleMatchCard({super.key, required this.match});

  final Match match;

  MatchState get _state {
    final now = DateTime.now();
    if (match.matchDate.isAfter(now)) return MatchState.upcoming;
    if (match.isFinished) return MatchState.finished;
    return MatchState.live;
  }

  String get _timeStr {
    final koreaTime = match.matchDate.add(const Duration(hours: 9));
    return '${koreaTime.hour.toString().padLeft(2, '0')}:${koreaTime.minute.toString().padLeft(2, '0')}';
  }

  String get _dateStr {
    final koreaTime = match.matchDate.add(const Duration(hours: 9));
    return '${koreaTime.month}/${koreaTime.day}';
  }

  void _onTap(BuildContext context, WidgetRef ref) {
    ref.read(revealedMatchesProvider.notifier).reveal(match.matchId.toString());
    context.push(
      AppRoutes.match,
      extra: MatchExtra(
        matchId: match.matchId,
        homeTeam: match.homeTeamName,
        awayTeam: match.awayTeamName,
        matchState: _state,
        matchDate: _dateStr,
        matchTime: _timeStr,
        homeTeamId: match.homeTeamId,
        awayTeamId: match.awayTeamId,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noSpoiler = ref.watch(noSpoilerProvider).valueOrNull ?? false;
    final isRevealed = ref.watch(revealedMatchesProvider
        .select((s) => s.contains(match.matchId.toString())));

    final hideScore = noSpoiler &&
        _state == MatchState.finished &&
        !isRevealed;

    return _state == MatchState.live
        ? _LiveCard(match: match, onTap: () => _onTap(context, ref))
        : _NormalRow(
            match: match,
            state: _state,
            timeStr: _timeStr,
            hideScore: hideScore,
            onTap: () => _onTap(context, ref),
          );
  }
}

class _LiveCard extends StatelessWidget {
  final Match match;
  final VoidCallback onTap;

  const _LiveCard({required this.match, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final koreaTime = match.matchDate.add(const Duration(hours: 9));
    final timeStr =
        '${koreaTime.hour.toString().padLeft(2, '0')}:${koreaTime.minute.toString().padLeft(2, '0')}';
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
          borderRadius: AppRadius.md,
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
                      color: CustomColor.green,
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
                  AppSpacing.h4,
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
        AppSpacing.h8,
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
  final bool hideScore;
  final VoidCallback onTap;

  const _NormalRow({
    required this.match,
    required this.state,
    required this.timeStr,
    required this.hideScore,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget centerWidget;

    if (state == MatchState.finished &&
        match.homeTeamScore != null &&
        match.awayTeamScore != null) {
      if (hideScore) {
        centerWidget = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Symbols.lock, size: 14, color: CustomColor.gray500),
            AppSpacing.w4,
            Text(
              '결과 보기',
              style: CustomTextStyle.body3.copyWith(color: CustomColor.gray500),
            ),
          ],
        );
      } else {
        centerWidget = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${match.homeTeamScore} : ${match.awayTeamScore}',
              style: CustomTextStyle.heading3,
            ),
            const SizedBox(height: 2),
            Text(
              timeStr,
              style: CustomTextStyle.body3.copyWith(
                color: CustomColor.gray500,
              ),
            ),
          ],
        );
      }
    } else {
      centerWidget = Text(timeStr, style: CustomTextStyle.heading3);
    }

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
                  AppSpacing.w8,
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
                  AppSpacing.w8,
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
