import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:twelfth_mobile/common/components/app_bar/twelfth_app_bar.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/core/constants/club_id_map.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/common/components/image/network_avatar.dart';
import 'package:twelfth_mobile/core/constants/stadium_map.dart';
import 'package:twelfth_mobile/core/extensions/snackbar_extension.dart';
import 'package:twelfth_mobile/core/router/player_route_args.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';
import 'package:twelfth_mobile/core/router/team_route_args.dart';
import 'package:twelfth_mobile/features/match/domain/entities/match.dart';
import 'package:twelfth_mobile/features/match/domain/entities/match_event.dart';
import 'package:twelfth_mobile/features/match/presentation/providers/match_provider.dart';
import 'package:twelfth_mobile/features/search/domain/entities/club_search_result.dart';
import 'package:twelfth_mobile/features/search/presentation/providers/search_provider.dart';
import 'package:twelfth_mobile/views/match/widgets/center_section.dart';
import 'package:twelfth_mobile/views/match/widgets/event_section.dart';
import 'package:twelfth_mobile/views/match/widgets/lineup_section.dart';
import 'package:url_launcher/url_launcher.dart';

enum MatchState { upcoming, live, finished }

class MatchExtra {
  final int matchId;
  final String homeTeam;
  final String awayTeam;
  final MatchState matchState;
  final String? matchDate;
  final String? matchTime;
  final int? homeTeamId;
  final int? awayTeamId;

  const MatchExtra({
    required this.matchId,
    required this.homeTeam,
    required this.awayTeam,
    this.matchState = MatchState.upcoming,
    this.matchDate,
    this.matchTime,
    this.homeTeamId,
    this.awayTeamId,
  });
}

class MatchDetailView extends ConsumerWidget {
  final MatchExtra extra;

  const MatchDetailView({super.key, required this.extra});

  MatchState _resolveState(Match match) {
    if (match.matchDate.isAfter(DateTime.now())) return MatchState.upcoming;
    if (match.isFinished) return MatchState.finished;
    return MatchState.live;
  }

  Future<void> _openPlayerDetail(
    BuildContext context,
    WidgetRef ref,
    MatchEvent event,
  ) async {
    if (event.playerId != null && event.playerName.isNotEmpty) {
      context.push(
        AppRoutes.player,
        extra: PlayerRouteArgs(
          playerId: event.playerId!,
          playerName: event.playerName,
        ),
      );
      return;
    }

    final playerName = event.playerName.trim();
    if (playerName.isEmpty) {
      context.showErrorSnackBar('선수 정보를 찾을 수 없습니다.');
      return;
    }

    try {
      final players = await ref
          .read(searchRepositoryProvider)
          .searchPlayers(playerName);
      if (!context.mounted) return;

      if (players.isEmpty) {
        context.showErrorSnackBar('선수 상세 정보를 찾을 수 없습니다.');
        return;
      }

      final normalizedTarget = _normalize(playerName);
      final match = players.firstWhere(
        (p) => _normalize(p.name) == normalizedTarget,
        orElse: () => players.first,
      );

      context.push(
        AppRoutes.player,
        extra: PlayerRouteArgs(playerId: match.playerId, playerName: match.name),
      );
    } catch (_) {
      if (!context.mounted) return;
      context.showErrorSnackBar('선수 상세 정보를 불러오지 못했습니다.');
    }
  }

  String _normalize(String? value) =>
      (value ?? '').replaceAll(RegExp(r'\s+'), '').toLowerCase();

  int? _resolveClubId(String teamName, int? fallbackClubId) {
    return fallbackClubId ?? ClubIdMap.lookup(teamName);
  }

  ClubSearchResult? _resolveClubSearchResult(
    List<ClubSearchResult> clubs,
    String teamName,
  ) {
    if (clubs.isEmpty) return null;

    final normalizedName = _normalize(teamName);
    final exactMatches = clubs.where((club) {
      return _normalize(club.name) == normalizedName;
    }).toList();
    if (exactMatches.isNotEmpty) return exactMatches.first;

    for (final club in clubs) {
      final normalizedClubName = _normalize(club.name);
      if (normalizedClubName.contains(normalizedName) ||
          normalizedName.contains(normalizedClubName)) {
        return club;
      }
    }

    return clubs.first;
  }

  Future<void> _openTeamDetail(
    BuildContext context,
    WidgetRef ref,
    String teamName,
    int? fallbackClubId,
  ) async {
    int? resolvedClubId = _resolveClubId(teamName, fallbackClubId);

    try {
      final searchedClubs = await ref.read(searchRepositoryProvider).searchClubs(
        teamName,
      );
      if (!context.mounted) return;

      final matchedClub = _resolveClubSearchResult(searchedClubs, teamName);
      if (matchedClub != null) {
        resolvedClubId = matchedClub.clubId;
      }
    } catch (_) {
      if (!context.mounted) return;
    }

    if (resolvedClubId == null) {
      context.showErrorSnackBar('구단 정보를 찾을 수 없습니다.');
      return;
    }

    context.push(
      AppRoutes.team,
      extra: TeamRouteArgs(clubId: resolvedClubId, teamName: teamName),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(matchDetailProvider(extra.matchId));
    final eventsAsync = ref.watch(matchEventsProvider(extra.matchId));
    final lineupsAsync = ref.watch(matchLineupsProvider(extra.matchId));

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
                final resolvedHomeClubId = _resolveClubId(
                  match.homeTeamName,
                  match.homeTeamId,
                );
                final resolvedAwayClubId = _resolveClubId(
                  match.awayTeamName,
                  match.awayTeamId,
                );
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
                  onHomeTap: () => _openTeamDetail(
                    context,
                    ref,
                    match.homeTeamName,
                    resolvedHomeClubId,
                  ),
                  onAwayTap: () => _openTeamDetail(
                    context,
                    ref,
                    match.awayTeamName,
                    resolvedAwayClubId,
                  ),
                  homeImageUrl: match.homeTeamImageUrl,
                  awayImageUrl: match.awayTeamImageUrl,
                );
              },
            ),

            if ((detailAsync.valueOrNull != null
                    ? _resolveState(detailAsync.valueOrNull!)
                    : extra.matchState) !=
                MatchState.upcoming) ...[
              const Divider(
                color: CustomColor.gray900,
                thickness: 1,
                height: 1,
              ),
              EventsSection(
                eventsAsync: eventsAsync,
                homeTeamId:
                    detailAsync.valueOrNull?.homeTeamId ?? extra.homeTeamId,
                awayTeamId:
                    detailAsync.valueOrNull?.awayTeamId ?? extra.awayTeamId,
                homeTeamName: detailAsync.valueOrNull?.homeTeamName ?? extra.homeTeam,
                onPlayerTap: (event) => _openPlayerDetail(context, ref, event),
              ),
              const SizedBox(height: 20),
              LineupSection(lineupsAsync: lineupsAsync),
              const SizedBox(height: 32),
            ],
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

  Future<void> _openStadium(String stadiumName) async {
    final appUri = StadiumMap.naverMapUri(stadiumName);
    if (await canLaunchUrl(appUri)) {
      await launchUrl(appUri);
      return;
    }
    final webUri = StadiumMap.naverMapWebUri(stadiumName);
    await launchUrl(webUri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final stadiumName = StadiumMap.lookup(homeTeam);

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
              stadiumName: stadiumName,
              onStadiumTap: stadiumName != null
                  ? () => _openStadium(stadiumName)
                  : null,
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
