import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twelfth_mobile/common/components/app_bar/twelfth_app_bar.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/features/match/domain/entities/match.dart';
import 'package:twelfth_mobile/features/match/presentation/providers/match_provider.dart';

enum MatchState { upcoming, live, finished }

class MatchExtra {
  final int matchId;
  final String homeTeam;
  final String awayTeam;
  final MatchState matchState;
  final String? matchDate;
  final String? matchTime;

  const MatchExtra({
    required this.matchId,
    required this.homeTeam,
    required this.awayTeam,
    this.matchState = MatchState.upcoming,
    this.matchDate,
    this.matchTime,
  });
}

class MatchDetailView extends ConsumerWidget {
  final MatchExtra extra;

  const MatchDetailView({super.key, required this.extra});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(matchDetailProvider(extra.matchId));

    return Scaffold(
      backgroundColor: CustomColor.background,
      appBar: const TwelfthAppBar(title: '경기 상세'),
      body: detailAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: CustomColor.white),
        ),
        error: (e, _) => _buildFromExtra(extra),
        data: (match) => SingleChildScrollView(child: _buildMatchHeader(match)),
      ),
    );
  }

  Widget _buildMatchHeader(Match match) {
    final dateStr = '${match.matchDate.month}/${match.matchDate.day}';
    final timeStr =
        '${match.matchDate.hour.toString().padLeft(2, '0')}:${match.matchDate.minute.toString().padLeft(2, '0')}';

    MatchState state;
    if (match.isFinished) {
      state = MatchState.finished;
    } else if (match.matchDate.isBefore(DateTime.now())) {
      state = MatchState.live;
    } else {
      state = MatchState.upcoming;
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTeamColumn(match.awayTeamName),
          _buildCenterSection(
            matchState: state,
            homeScore: match.homeTeamScore,
            awayScore: match.awayTeamScore,
            dateStr: dateStr,
            timeStr: timeStr,
          ),
          _buildTeamColumn(match.homeTeamName),
        ],
      ),
    );
  }

  Widget _buildFromExtra(MatchExtra e) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTeamColumn(e.awayTeam),
            _buildCenterSection(
              matchState: e.matchState,
              homeScore: null,
              awayScore: null,
              dateStr: e.matchDate,
              timeStr: e.matchTime,
            ),
            _buildTeamColumn(e.homeTeam),
          ],
        ),
      ),
    );
  }

  static const _vGap4 = SizedBox(height: 4);

  Widget _buildTeamColumn(String name) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: const BoxDecoration(
            color: CustomColor.gray900,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 10),
        Text(name, style: CustomTextStyle.body2),
      ],
    );
  }

  Widget _buildCenterSection({
    required MatchState matchState,
    required int? homeScore,
    required int? awayScore,
    required String? dateStr,
    required String? timeStr,
  }) {
    switch (matchState) {
      case MatchState.live:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Live',
              style: CustomTextStyle.body2.copyWith(color: CustomColor.green),
            ),
            _vGap4,
            Text(
              homeScore != null && awayScore != null
                  ? '$awayScore  :  $homeScore'
                  : '-  :  -',
              style: CustomTextStyle.heading1,
            ),
          ],
        );
      case MatchState.finished:
        return Text(
          homeScore != null && awayScore != null
              ? '$awayScore  :  $homeScore'
              : '-  :  -',
          style: CustomTextStyle.heading1,
        );
      case MatchState.upcoming:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (dateStr != null)
              Text(
                dateStr,
                style: CustomTextStyle.body2.copyWith(
                  color: CustomColor.gray500,
                ),
              ),
            if (dateStr != null) _vGap4,
            if (timeStr != null) Text(timeStr, style: CustomTextStyle.heading1),
          ],
        );
    }
  }
}
