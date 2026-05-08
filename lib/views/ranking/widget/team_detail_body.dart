import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twelfth_mobile/core/constants/stadium_map.dart';
import 'package:twelfth_mobile/core/constants/team_social_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/common/components/image/network_avatar.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/constants/twelfth_assets.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';
import 'package:twelfth_mobile/features/ranking/domain/entities/club_detail.dart';
import 'package:twelfth_mobile/views/match/match_detail_view.dart';
import 'package:twelfth_mobile/views/ranking/widget/match_pager.dart';

class TeamDetailBody extends StatelessWidget {
  final ClubDetail detail;

  const TeamDetailBody({super.key, required this.detail});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _openStadium(String stadiumName) async {
    final appUri = StadiumMap.naverMapUri(stadiumName);
    if (await canLaunchUrl(appUri)) {
      await launchUrl(appUri);
      return;
    }
    final webUri = StadiumMap.naverMapWebUri(stadiumName);
    await launchUrl(webUri, mode: LaunchMode.externalApplication);
  }

  void _onMatchTap(BuildContext context, ClubMatch m) {
    final state = m.isFinished
        ? MatchState.finished
        : m.matchDate.isBefore(DateTime.now())
        ? MatchState.live
        : MatchState.upcoming;
    context.push(
      AppRoutes.match,
      extra: MatchExtra(
        matchId: m.matchId,
        homeTeam: m.homeTeamName,
        awayTeam: m.awayTeamName,
        matchState: state,
        matchDate: '${m.matchDate.month}/${m.matchDate.day}',
        matchTime:
            '${m.matchDate.hour.toString().padLeft(2, '0')}:${m.matchDate.minute.toString().padLeft(2, '0')}',
        homeTeamId: m.homeTeamId,
        awayTeamId: m.awayTeamId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final upcoming = detail.upcomingMatches;
    final past = detail.pastMatches;
    final socialLinks = TeamSocials.of(detail.clubName);

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Column(
              children: [
                NetworkAvatar(imageUrl: detail.logo, size: 100),
                const SizedBox(height: 16),
                Text(detail.clubName, style: CustomTextStyle.heading1),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _openStadium(detail.venueName),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Symbols.location_on,
                        size: 16,
                        color: CustomColor.main,
                        fill: 1,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        detail.venueName,
                        style: CustomTextStyle.body3.copyWith(
                          color: CustomColor.main,
                        ),
                      ),
                    ],
                  ),
                ),
                if (socialLinks != null) ...[
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => _launchUrl(socialLinks.youtube),
                        child: SvgPicture.asset(
                          TwelfthAssets.youtube,
                          width: 30,
                          height: 30,
                        ),
                      ),
                      const SizedBox(width: 50),
                      GestureDetector(
                        onTap: () => _launchUrl(socialLinks.instagram),
                        child: SvgPicture.asset(
                          TwelfthAssets.instagram,
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          _SectionHeader(title: '일정'),
          const SizedBox(height: 4),
          if (upcoming.isNotEmpty)
            MatchPager(
              matches: upcoming,
              clubName: detail.clubName,
              isHistory: false,
              onTap: (m) => _onMatchTap(context, m),
            )
          else
            _EmptySection(message: '해당 구단의 경기 일정이 없습니다.'),
          const SizedBox(height: 24),

          _SectionHeader(title: '경기 내역'),
          const SizedBox(height: 4),
          if (past.isNotEmpty)
            MatchPager(
              matches: past,
              clubName: detail.clubName,
              isHistory: true,
              onTap: (m) => _onMatchTap(context, m),
            )
          else
            _EmptySection(message: '해당 구단의 경기 내역이 없습니다.'),
          const SizedBox(height: 24),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: CustomTextStyle.heading3),
      ),
    );
  }
}

class _EmptySection extends StatelessWidget {
  final String message;
  const _EmptySection({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Text(
        message,
        style: CustomTextStyle.body2.copyWith(color: CustomColor.gray500),
      ),
    );
  }
}
