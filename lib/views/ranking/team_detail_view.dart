import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/common/components/app_bar/twelfth_app_bar.dart';
import 'package:twelfth_mobile/common/components/bookmark/bookmarking.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/constants/team_social_links.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/constants/twelfth_assets.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';
import 'package:twelfth_mobile/features/ranking/domain/entities/club_detail.dart';
import 'package:twelfth_mobile/features/ranking/presentation/providers/ranking_provider.dart';
import 'package:twelfth_mobile/views/match/match_detail_view.dart';
import 'package:url_launcher/url_launcher.dart';

const _vGap2 = SizedBox(height: 2);
const _vGap8 = SizedBox(height: 8);
const _hGap4 = SizedBox(width: 4);

class TeamDetailView extends ConsumerWidget {
  final int clubId;
  final String teamName;

  const TeamDetailView({
    super.key,
    required this.clubId,
    required this.teamName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(clubDetailProvider(clubId));

    return ListenableBuilder(
      listenable: Bookmarking.instance,
      builder: (context, _) {
        final isBookmarked = Bookmarking.instance.isTeamBookmarked(teamName);
        return Scaffold(
          backgroundColor: CustomColor.background,
          appBar: TwelfthAppBar(
            title: teamName,
            actions: [
              IconButton(
                icon: Icon(
                  Symbols.star,
                  color: isBookmarked ? CustomColor.yellow : CustomColor.main,
                  fill: isBookmarked ? 1 : 0,
                ),
                onPressed: () => Bookmarking.instance.toggleTeam(teamName),
              ),
            ],
          ),
          body: detailAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: CustomColor.white),
            ),
            error: (e, _) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '정보를 불러오지 못했습니다',
                    style: CustomTextStyle.body2.copyWith(color: CustomColor.gray500),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => ref.invalidate(clubDetailProvider(clubId)),
                    child: Text(
                      '다시 시도',
                      style: CustomTextStyle.body2.copyWith(color: CustomColor.white),
                    ),
                  ),
                ],
              ),
            ),
            data: (detail) => _buildBody(context, detail),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ClubDetail detail) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildTeamHeader(detail.stadiumName),
          if (detail.upcomingMatches.isNotEmpty)
            _MatchSection(
              title: '일정',
              matches: detail.upcomingMatches,
              teamName: teamName,
              isUpcoming: true,
            ),
          if (detail.pastMatches.isNotEmpty)
            _MatchSection(
              title: '경기 내역',
              matches: detail.pastMatches,
              teamName: teamName,
              isUpcoming: false,
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildSocialLinks() {
    final links = TeamSocials.of(teamName);
    if (links == null) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => _launchUrl(links.youtube),
          child: SvgPicture.asset(TwelfthAssets.youtube, width: 30, height: 30),
        ),
        const SizedBox(width: 50),
        GestureDetector(
          onTap: () => _launchUrl(links.instagram),
          child: SvgPicture.asset(TwelfthAssets.instagram, width: 30, height: 30),
        ),
      ],
    );
  }

  Widget _buildTeamHeader(String stadiumName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: CustomColor.gray900,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 16),
          Text(teamName, style: CustomTextStyle.heading1),
          _vGap8,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Symbols.location_on,
                size: 16,
                color: CustomColor.gray500,
                fill: 1,
              ),
              _hGap4,
              Text(
                stadiumName,
                style: CustomTextStyle.body3.copyWith(color: CustomColor.gray500),
              ),
            ],
          ),
          const SizedBox(height: 28),
          _buildSocialLinks(),
        ],
      ),
    );
  }
}

class _MatchSection extends StatefulWidget {
  final String title;
  final List<ClubMatch> matches;
  final String teamName;
  final bool isUpcoming;

  const _MatchSection({
    required this.title,
    required this.matches,
    required this.teamName,
    required this.isUpcoming,
  });

  @override
  State<_MatchSection> createState() => _MatchSectionState();
}

class _MatchSectionState extends State<_MatchSection> {
  late final PageController _controller;
  int _currentPage = 0;

  static const _perPage = 3;

  int get _totalPages => widget.matches.isEmpty
      ? 0
      : ((widget.matches.length - 1) ~/ _perPage) + 1;

  int get _activeDot {
    if (_totalPages <= 1) return 0;
    if (_currentPage == 0) return 0;
    if (_currentPage >= _totalPages - 1) return 2;
    return 1;
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _controller.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    final page = _controller.page?.round() ?? 0;
    if (page != _currentPage) setState(() => _currentPage = page);
  }

  @override
  void dispose() {
    _controller.removeListener(_onPageChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.matches.isEmpty) return const SizedBox.shrink();
    final rowHeight = widget.isUpcoming ? 56.0 : 72.0;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title, style: CustomTextStyle.heading3),
          const SizedBox(height: 12),
          SizedBox(
            height: rowHeight * _perPage,
            child: PageView.builder(
              controller: _controller,
              itemCount: _totalPages,
              itemBuilder: (context, pageIndex) {
                final start = pageIndex * _perPage;
                final end = (start + _perPage).clamp(0, widget.matches.length);
                final pageMatches = widget.matches.sublist(start, end);
                return Column(
                  children: pageMatches
                      .map((m) => SizedBox(
                            height: rowHeight,
                            child: _buildMatchRow(m, context),
                          ))
                      .toList(),
                );
              },
            ),
          ),
          _vGap8,
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                final active = i == _activeDot;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: active ? CustomColor.gray600 : CustomColor.gray900,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchRow(ClubMatch match, BuildContext context) {
    final dateStr =
        '${match.matchDate.month}/${match.matchDate.day}';
    final timeStr =
        '${match.matchDate.hour.toString().padLeft(2, '0')}:${match.matchDate.minute.toString().padLeft(2, '0')}';
    final isTeamHome = match.homeTeamName == widget.teamName;

    final extra = MatchExtra(
      homeTeam: match.homeTeamName,
      awayTeam: match.awayTeamName,
      matchState: widget.isUpcoming ? MatchState.upcoming : MatchState.finished,
      matchDate: dateStr,
      matchTime: timeStr,
    );

    String? scoreText;
    Color scoreColor = CustomColor.gray500;
    if (!widget.isUpcoming &&
        match.homeTeamScore != null &&
        match.awayTeamScore != null) {
      scoreText = '${match.homeTeamScore} : ${match.awayTeamScore}';
      final ourScore = isTeamHome ? match.homeTeamScore! : match.awayTeamScore!;
      final theirScore = isTeamHome ? match.awayTeamScore! : match.homeTeamScore!;
      if (ourScore > theirScore) {
        scoreColor = CustomColor.green;
      } else if (ourScore < theirScore) {
        scoreColor = CustomColor.red;
      }
    }

    return GestureDetector(
      onTap: () => context.push(AppRoutes.match, extra: extra),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: _buildTeamTag(match.awayTeamName, MainAxisAlignment.start),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  dateStr,
                  style: CustomTextStyle.body2.copyWith(color: CustomColor.gray500),
                ),
                _vGap2,
                _buildHABadge(isTeamHome),
                if (scoreText != null) ...[
                  _vGap2,
                  Text(
                    scoreText,
                    style: CustomTextStyle.body3.copyWith(color: scoreColor),
                  ),
                ],
              ],
            ),
            Expanded(
              child: _buildTeamTag(match.homeTeamName, MainAxisAlignment.end),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamTag(String name, MainAxisAlignment alignment) {
    return Row(
      mainAxisAlignment: alignment,
      children: [
        if (alignment == MainAxisAlignment.start) ...[
          Container(
            width: 35,
            height: 35,
            decoration: const BoxDecoration(
              color: CustomColor.gray900,
              shape: BoxShape.circle,
            ),
          ),
          _hGap4,
          Flexible(
            child: Text(
              name,
              style: CustomTextStyle.body2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ] else ...[
          Flexible(
            child: Text(
              name,
              style: CustomTextStyle.body2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _hGap4,
          Container(
            width: 35,
            height: 35,
            decoration: const BoxDecoration(
              color: CustomColor.gray900,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHABadge(bool isHome) {
    return Icon(
      isHome ? Symbols.stadium : Symbols.flight,
      size: 16,
      fill: 1,
      color: CustomColor.gray500,
    );
  }
}
