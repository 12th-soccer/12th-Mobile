import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:twelfth_mobile/common/components/app_bar/twelfth_app_bar.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/common/components/image/network_avatar.dart';
import 'package:twelfth_mobile/core/router/player_route_args.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';
import 'package:twelfth_mobile/core/router/team_route_args.dart';
import 'package:twelfth_mobile/features/match/domain/entities/match.dart';
import 'package:twelfth_mobile/features/match/domain/entities/match_event.dart';
import 'package:twelfth_mobile/features/match/presentation/providers/match_provider.dart';
import 'package:twelfth_mobile/views/match/widgets/center_section.dart';
import 'package:twelfth_mobile/views/match/widgets/event_row.dart';
import 'package:twelfth_mobile/views/match/widgets/event_section.dart';
import 'package:twelfth_mobile/views/match/widgets/lineup_section.dart';

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

  MatchState _resolveState(Match match) {
    if (match.isFinished) return MatchState.finished;
    if (match.matchDate.isBefore(DateTime.now())) return MatchState.live;
    return MatchState.upcoming;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(matchDetailProvider(extra.matchId));
    final eventsAsync = ref.watch(matchEventsProvider(extra.matchId));

    return Scaffold(
      backgroundColor: CustomColor.background,
      appBar: const TwelfthAppBar(title: '경기 상세'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            detailAsync.when(
              loading: () => const SizedBox(
                height: 140,
                child: Center(
                  child: CircularProgressIndicator(color: CustomColor.white),
                ),
              ),
              error: (_, __) => _MatchHeader(
                homeTeam: extra.homeTeam,
                awayTeam: extra.awayTeam,
                matchState: extra.matchState,
                dateStr: extra.matchDate,
                timeStr: extra.matchTime,
              ),
              data: (match) {
                final state = _resolveState(match);
                final dateStr =
                    '${match.matchDate.month}/${match.matchDate.day}';
                final timeStr =
                    '${match.matchDate.hour.toString().padLeft(2, '0')}:${match.matchDate.minute.toString().padLeft(2, '0')}';
                return _MatchHeader(
                  homeTeam: match.homeTeamName,
                  awayTeam: match.awayTeamName,
                  matchState: state,
                  homeScore: match.homeTeamScore,
                  awayScore: match.awayTeamScore,
                  dateStr: dateStr,
                  timeStr: timeStr,
                  onHomeTap: match.homeTeamId != null
                      ? () => context.push(
                          AppRoutes.team,
                          extra: TeamRouteArgs(
                            clubId: match.homeTeamId!,
                            teamName: match.homeTeamName,
                          ),
                        )
                      : null,
                  onAwayTap: match.awayTeamId != null
                      ? () => context.push(
                          AppRoutes.team,
                          extra: TeamRouteArgs(
                            clubId: match.awayTeamId!,
                            teamName: match.awayTeamName,
                          ),
                        )
                      : null,
                  homeImageUrl: match.homeTeamImageUrl,
                  awayImageUrl: match.awayTeamImageUrl,
                );
              },
            ),

            const Divider(color: CustomColor.gray900, thickness: 1, height: 1),

            EventsSection(
              eventsAsync: eventsAsync,
              homeTeamId: detailAsync.valueOrNull?.homeTeamId,
              onPlayerTap: (playerId, playerName) => context.push(
                AppRoutes.player,
                extra: PlayerRouteArgs(
                  playerId: playerId,
                  playerName: playerName,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const LineupSection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _MatchHeader extends StatelessWidget {
  final String homeTeam;
  final String awayTeam;
  final MatchState matchState;
  final int? homeScore;
  final int? awayScore;
  final String? dateStr;
  final String? timeStr;
  final VoidCallback? onHomeTap;
  final VoidCallback? onAwayTap;
  final String? homeImageUrl;
  final String? awayImageUrl;

  const _MatchHeader({
    required this.homeTeam,
    required this.awayTeam,
    required this.matchState,
    this.homeScore,
    this.awayScore,
    this.dateStr,
    this.timeStr,
    this.onHomeTap,
    this.onAwayTap,
    this.homeImageUrl,
    this.awayImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: _TeamColumn(
              name: homeTeam,
              imageUrl: homeImageUrl,
              onTap: onHomeTap,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CenterSection(
              matchState: matchState,
              homeScore: homeScore,
              awayScore: awayScore,
              dateStr: dateStr,
              timeStr: timeStr,
            ),
          ),
          Expanded(
            child: _TeamColumn(
              name: awayTeam,
              imageUrl: awayImageUrl,
              onTap: onAwayTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamColumn extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final VoidCallback? onTap;

  const _TeamColumn({required this.name, this.imageUrl, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NetworkAvatar(imageUrl: imageUrl, size: 64),
          const SizedBox(height: 8),
          Text(
            name,
            style: CustomTextStyle.body2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
