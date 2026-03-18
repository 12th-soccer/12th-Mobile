import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/common/components/app_bar/twelfth_app_bar.dart';
import 'package:twelfth_mobile/common/components/bookmark/bookmarking.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';
import 'package:twelfth_mobile/views/match/match_detail_view.dart';

class PlayerDetailView extends StatelessWidget {
  final String playerName;
  static const spacing = SizedBox(height: 20);

  const PlayerDetailView({super.key, required this.playerName});

  static const _matches = [
    _MockPlayerMatch(
      date: '2018. 01. 13',
      home: '전북 현대 모터스 FC',
      away: '울산 HD FC',
      result: "골 14'",
      isTeamHome: true,
    ),
    _MockPlayerMatch(
      date: '2018. 01. 13',
      home: '울산 HD FC',
      away: 'FC 서울',
      result: "골 14'",
      isTeamHome: false,
    ),
    _MockPlayerMatch(
      date: '2018. 01. 13',
      home: 'FC 서울',
      away: '포항 스틸러스',
      result: "골 14'",
      isTeamHome: false,
    ),
    _MockPlayerMatch(
      date: '2018. 01. 13',
      home: '인천 유나이티드',
      away: '강원 FC',
      result: "골 14'",
      isTeamHome: false,
    ),
    _MockPlayerMatch(
      date: '2024. 03. 30',
      home: '전북 현대 모터스 FC',
      away: '광주 FC',
      result: "어시스트 33'",
      isTeamHome: true,
    ),
    _MockPlayerMatch(
      date: '2024. 04. 06',
      home: '대전 하나 시티즌',
      away: '수원 삼성 FC',
      result: "골 71'",
      isTeamHome: true,
    ),
    _MockPlayerMatch(
      date: '2024. 04. 06',
      home: '제주 SK',
      away: '수원 삼성 FC',
      result: "어시스트 22'",
      isTeamHome: false,
    ),
    _MockPlayerMatch(
      date: '2024. 04. 06',
      home: '대전 하나 시티즌',
      away: '김천 상무',
      result: "어시스트 71'",
      isTeamHome: true,
    ),
    _MockPlayerMatch(
      date: '2024. 04. 06',
      home: '광주 FC',
      away: 'FC 안양',
      result: "어시스트 10''",
      isTeamHome: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Bookmarking.instance,
      builder: (context, _) {
        final isBookmarked = Bookmarking.instance.isPlayerBookmarked(
          playerName,
        );
        return Scaffold(
          backgroundColor: CustomColor.background,
          appBar: TwelfthAppBar(
            title: '선수 상세',
            actions: [
              IconButton(
                icon: Icon(
                  Symbols.star,
                  color: isBookmarked ? CustomColor.yellow : CustomColor.main,
                  fill: isBookmarked ? 1 : 0,
                ),
                onPressed: () => Bookmarking.instance.togglePlayer(playerName),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_buildPlayerHeader(), _buildMatchHistory(context)],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlayerHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        children: [
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: CustomColor.gray900,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(child: Text(playerName, style: CustomTextStyle.heading1)),
          spacing,
          Row(
            children: [
              Expanded(child: _buildInfoCell('소속', '대전 하나 시티즌')),
              Expanded(child: _buildInfoCell('나이', '25세')),
            ],
          ),
          spacing,
          Row(
            children: [
              Expanded(child: _buildInfoCell('포지션', 'LW')),
              Expanded(child: _buildInfoCell('번호', '19')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCell(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: CustomTextStyle.body1.copyWith(color: CustomColor.gray500),
        ),
        Text(value, style: CustomTextStyle.heading2),
      ],
    );
  }

  Widget _buildMatchHistory(BuildContext context) {
    return Column(
      children: _matches
          .map((match) => _buildMatchRow(match, context))
          .toList(),
    );
  }

  Widget _buildMatchRow(_MockPlayerMatch match, BuildContext context) {
    final extra = MatchExtra(
      homeTeam: match.home,
      awayTeam: match.away,
      matchState: MatchState.finished,
    );

    return GestureDetector(
      onTap: () => context.push(AppRoutes.match, extra: extra),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: Row(
              children: [
                Text(
                  match.date,
                  style: CustomTextStyle.body1.copyWith(
                    color: CustomColor.gray500,
                  ),
                ),
                const Spacer(),
                Text(match.result, style: CustomTextStyle.heading2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MockPlayerMatch {
  final String date;
  final String home;
  final String away;
  final String result;
  final bool isTeamHome;

  const _MockPlayerMatch({
    required this.date,
    required this.home,
    required this.away,
    required this.result,
    required this.isTeamHome,
  });
}
