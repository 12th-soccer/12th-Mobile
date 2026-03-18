import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/common/components/app_bar/twelfth_app_bar.dart';
import 'package:twelfth_mobile/common/components/bookmark/bookmarking.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/constants/twelfth_assets.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';
import 'package:twelfth_mobile/views/match/match_detail_view.dart';

const _vGap2 = SizedBox(height: 2);
const _vGap8 = SizedBox(height: 8);
const _hGap4 = SizedBox(width: 4);

class TeamDetailView extends StatefulWidget {
  final String teamName;

  const TeamDetailView({super.key, required this.teamName});

  @override
  State<TeamDetailView> createState() => _TeamDetailViewState();
}

class _TeamDetailViewState extends State<TeamDetailView> {
  static const _upcomingMatches = [
    _MockMatchResult(
      home: '강원 FC',
      away: '울산 HD FC',
      date: '3/21',
      time: '19:00',
      isTeamHome: true,
    ),
    _MockMatchResult(
      home: '대전 하나 시티즌',
      away: '강원 FC',
      date: '3/29',
      time: '19:00',
      isTeamHome: false,
    ),
    _MockMatchResult(
      home: '강원 FC',
      away: '포항 스틸러스',
      date: '4/5',
      time: '14:00',
      isTeamHome: true,
    ),
    _MockMatchResult(
      home: '수원 삼성',
      away: '강원 FC',
      date: '4/12',
      time: '16:30',
      isTeamHome: false,
    ),
    _MockMatchResult(
      home: '강원 FC',
      away: 'FC 서울',
      date: '4/19',
      time: '19:00',
      isTeamHome: true,
    ),
  ];

  static const _pastMatches = [
    _MockMatchResult(
      home: '강원 FC',
      away: '광주 FC',
      homeScore: 3,
      awayScore: 1,
      date: '12/11',
      isTeamHome: true,
    ),
    _MockMatchResult(
      home: '강원 FC',
      away: '광주 FC',
      homeScore: 2,
      awayScore: 3,
      date: '12/1',
      isTeamHome: true,
    ),
    _MockMatchResult(
      home: '강원 FC',
      away: '광주 FC',
      homeScore: 3,
      awayScore: 1,
      date: '11/30',
      isTeamHome: true,
    ),
    _MockMatchResult(
      home: '인천 유나이티드',
      away: '강원 FC',
      homeScore: 0,
      awayScore: 2,
      date: '11/20',
      isTeamHome: false,
    ),
    _MockMatchResult(
      home: '강원 FC',
      away: '전북 현대',
      homeScore: 1,
      awayScore: 1,
      date: '11/10',
      isTeamHome: true,
    ),
    _MockMatchResult(
      home: '포항 스틸러스',
      away: '강원 FC',
      homeScore: 2,
      awayScore: 0,
      date: '11/3',
      isTeamHome: false,
    ),
    _MockMatchResult(
      home: '강원 FC',
      away: '대구 FC',
      homeScore: 4,
      awayScore: 1,
      date: '10/27',
      isTeamHome: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Bookmarking.instance,
      builder: (context, _) => _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    final isBookmarked = Bookmarking.instance.isTeamBookmarked(widget.teamName);
    return Scaffold(
      backgroundColor: CustomColor.background,
      appBar: TwelfthAppBar(
        title: widget.teamName,
        actions: [
          IconButton(
            icon: Icon(
              Symbols.star,
              color: isBookmarked ? CustomColor.yellow : CustomColor.main,
              fill: isBookmarked ? 1 : 0,
            ),
            onPressed: () => Bookmarking.instance.toggleTeam(widget.teamName),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildTeamHeader(),
            _MatchSection(
              title: '일정',
              matches: _upcomingMatches,
              isUpcoming: true,
            ),
            _MatchSection(
              title: '경기 내역',
              matches: _pastMatches,
              isUpcoming: false,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamHeader() {
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
          Text(widget.teamName, style: CustomTextStyle.heading1),
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
                '대전월드컵경기장',
                style: CustomTextStyle.body3.copyWith(
                  color: CustomColor.gray500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(TwelfthAssets.youtube, width: 30, height: 30),
              const SizedBox(width: 50),
              SvgPicture.asset(TwelfthAssets.instagram, width: 30, height: 30),
            ],
          ),
        ],
      ),
    );
  }
}

class _MatchSection extends StatefulWidget {
  final String title;
  final List<_MockMatchResult> matches;
  final bool isUpcoming;

  const _MatchSection({
    required this.title,
    required this.matches,
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
                      .map(
                        (m) => SizedBox(
                          height: rowHeight,
                          child: _buildMatchRow(m, context),
                        ),
                      )
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

  Widget _buildMatchRow(_MockMatchResult match, BuildContext context) {
    final extra = MatchExtra(
      homeTeam: match.home,
      awayTeam: match.away,
      matchState: widget.isUpcoming ? MatchState.upcoming : MatchState.finished,
      matchDate: match.date,
      matchTime: match.time,
    );

    String? scoreText;
    Color scoreColor = CustomColor.gray500;
    if (!widget.isUpcoming &&
        match.homeScore != null &&
        match.awayScore != null) {
      scoreText = '${match.homeScore} : ${match.awayScore}';
      final ourScore = match.isTeamHome ? match.homeScore! : match.awayScore!;
      final theirScore = match.isTeamHome ? match.awayScore! : match.homeScore!;
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
            Expanded(child: _buildTeamTag(match.away, MainAxisAlignment.start)),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  match.date,
                  style: CustomTextStyle.body2.copyWith(
                    color: CustomColor.gray500,
                  ),
                ),
                _vGap2,
                _buildHABadge(match.isTeamHome),
                if (scoreText != null) ...[
                  _vGap2,
                  Text(
                    scoreText,
                    style: CustomTextStyle.body3.copyWith(color: scoreColor),
                  ),
                ],
              ],
            ),
            Expanded(child: _buildTeamTag(match.home, MainAxisAlignment.end)),
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

class _MockMatchResult {
  final String home;
  final String away;
  final String date;
  final String? time;
  final int? homeScore;
  final int? awayScore;
  final bool isTeamHome;

  const _MockMatchResult({
    required this.home,
    required this.away,
    required this.date,
    required this.isTeamHome,
    this.time,
    this.homeScore,
    this.awayScore,
  });
}
