import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/common/components/bookmark/bookmarking.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:go_router/go_router.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';

class RankingView extends StatefulWidget {
  const RankingView({super.key});

  @override
  State<RankingView> createState() => _RankingViewState();
}

class _RankingViewState extends State<RankingView> {
  int _tabIndex = 0;
  final spacing = const SizedBox(width: 10);
  final List<String> _tabs = ['K1', 'K2'];

  late List<_MockTeam> _k1Teams;
  late List<_MockTeam> _k2Teams;

  @override
  void initState() {
    super.initState();
    _k1Teams = [
      _MockTeam(rank: 1,  name: '울산 HD FC',          points: 45, goalsFor: 45, goalsAgainst: 20),
      _MockTeam(rank: 2,  name: '강원 FC',              points: 42, goalsFor: 42, goalsAgainst: 22),
      _MockTeam(rank: 3,  name: 'FC 서울',              points: 40, goalsFor: 38, goalsAgainst: 23),
      _MockTeam(rank: 4,  name: '전북 현대 모터스 FC',   points: 40, goalsFor: 35, goalsAgainst: 26),
      _MockTeam(rank: 5,  name: '인천 유나이티드',        points: 35, goalsFor: 33, goalsAgainst: 28),
      _MockTeam(rank: 6,  name: '포항 스틸러스',          points: 32, goalsFor: 30, goalsAgainst: 27),
      _MockTeam(rank: 7,  name: '부천 FC',              points: 28, goalsFor: 28, goalsAgainst: 30),
      _MockTeam(rank: 8,  name: '제주 SK',              points: 25, goalsFor: 26, goalsAgainst: 32),
      _MockTeam(rank: 9,  name: '광주 FC',              points: 22, goalsFor: 24, goalsAgainst: 35),
      _MockTeam(rank: 10, name: 'FC 안양',              points: 20, goalsFor: 22, goalsAgainst: 36),
      _MockTeam(rank: 11, name: '대전 하나 시티즌',       points: 15, goalsFor: 18, goalsAgainst: 40),
      _MockTeam(rank: 12, name: '김천 상무',             points: 12, goalsFor: 15, goalsAgainst: 45),
    ];
    _k2Teams = [
      _MockTeam(rank: 1,  name: '서울 이랜드',   points: 40, goalsFor: 38, goalsAgainst: 18),
      _MockTeam(rank: 2,  name: '성남 FC',       points: 38, goalsFor: 35, goalsAgainst: 20),
      _MockTeam(rank: 3,  name: '수원 삼성',     points: 37, goalsFor: 33, goalsAgainst: 22),
      _MockTeam(rank: 4,  name: '수원 FC',       points: 36, goalsFor: 30, goalsAgainst: 22),
      _MockTeam(rank: 5,  name: '전남 드래곤즈', points: 35, goalsFor: 32, goalsAgainst: 25),
      _MockTeam(rank: 6,  name: '용인 FC',       points: 34, goalsFor: 28, goalsAgainst: 20),
      _MockTeam(rank: 7,  name: '파주 프런티어', points: 32, goalsFor: 26, goalsAgainst: 22),
      _MockTeam(rank: 8,  name: '화성 FC',       points: 31, goalsFor: 25, goalsAgainst: 22),
      _MockTeam(rank: 9,  name: '부산 아이파크', points: 30, goalsFor: 24, goalsAgainst: 23),
      _MockTeam(rank: 10, name: '경남 FC',       points: 28, goalsFor: 23, goalsAgainst: 22),
      _MockTeam(rank: 11, name: '충남 아산',     points: 25, goalsFor: 20, goalsAgainst: 22),
      _MockTeam(rank: 12, name: '충북 청주',     points: 20, goalsFor: 18, goalsAgainst: 26),
      _MockTeam(rank: 13, name: '안산 그리너스', points: 18, goalsFor: 16, goalsAgainst: 28),
      _MockTeam(rank: 14, name: 'FC 안양',       points: 12, goalsFor: 14, goalsAgainst: 34),
      _MockTeam(rank: 15, name: '천안 시티',     points: 8,  goalsFor: 12, goalsAgainst: 36),
      _MockTeam(rank: 16, name: '김해 FC',       points: 4,  goalsFor: 8,  goalsAgainst: 42),
      _MockTeam(rank: 17, name: '대구 FC',       points: 4,  goalsFor: 8,  goalsAgainst: 42),
    ];
  }

  List<_MockTeam> get _teams => _tabIndex == 0 ? _k1Teams : _k2Teams;

  Color? _rankBarColor(int rank) {
    if (_tabIndex == 0) {
      if (rank <= 3) return CustomColor.blue;
      if (rank >= 10 && rank < 12) return CustomColor.orange;
      if (rank >= 12) return CustomColor.red;
    } else {
      if (rank == 1) return CustomColor.blue;
      if (rank <= 2) return CustomColor.yellow;
      if (rank >= 17) return CustomColor.orange;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTabs(),
            Expanded(child: _buildRankingList()),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      children: List.generate(_tabs.length, (index) {
        final isSelected = _tabIndex == index;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _tabIndex = index),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? CustomColor.white : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  _tabs[index],
                  style: CustomTextStyle.heading3.copyWith(
                    color: isSelected ? CustomColor.white : CustomColor.gray600,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildRankingList() {
    return ListenableBuilder(
      listenable: Bookmarking.instance,
      builder: (context, _) => ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _teams.length,
        itemBuilder: (context, index) => _buildTeamItem(_teams[index]),
      ),
    );
  }

  Widget _buildTeamItem(_MockTeam team) {
    final barColor = _rankBarColor(team.rank);
    final isBookmarked = Bookmarking.instance.isTeamBookmarked(team.name);
    final goalDiff = team.goalsFor - team.goalsAgainst;
    final diffText = goalDiff >= 0 ? '+$goalDiff' : '$goalDiff';
    final diffColor = goalDiff > 0
        ? CustomColor.blue
        : goalDiff < 0
            ? CustomColor.red
            : CustomColor.gray500;

    return GestureDetector(
      onTap: () => context.push(AppRoutes.team, extra: team.name),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(width: 12, color: barColor ?? Colors.transparent),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      child: Text(
                        '${team.rank}',
                        textAlign: TextAlign.center,
                        style: CustomTextStyle.body2.copyWith(
                          color: CustomColor.gray500,
                        ),
                      ),
                    ),
                    spacing,
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: CustomColor.gray900,
                        shape: BoxShape.circle,
                      ),
                    ),
                    spacing,
                    Expanded(
                      child: Text(
                        team.name,
                        style: CustomTextStyle.body1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    spacing,
                    // +/- (득점-실점)
                    SizedBox(
                      width: 42,
                      child: Text(
                        '${team.goalsFor}-${team.goalsAgainst}',
                        textAlign: TextAlign.center,
                        style: CustomTextStyle.body3.copyWith(
                          color: CustomColor.gray500,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    // = (득실차)
                    SizedBox(
                      width: 32,
                      child: Text(
                        diffText,
                        textAlign: TextAlign.center,
                        style: CustomTextStyle.body3.copyWith(color: diffColor),
                      ),
                    ),
                    // 승점
                    SizedBox(
                      width: 28,
                      child: Text(
                        '${team.points}',
                        textAlign: TextAlign.center,
                        style: CustomTextStyle.body2.copyWith(
                          color: CustomColor.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => Bookmarking.instance.toggleTeam(team.name),
                      child: Icon(
                        Symbols.star,
                        color: isBookmarked
                            ? CustomColor.yellow
                            : CustomColor.main,
                        fill: isBookmarked ? 1.0 : 0.0,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MockTeam {
  final int rank;
  final String name;
  final int points;
  final int goalsFor;
  final int goalsAgainst;

  const _MockTeam({
    required this.rank,
    required this.name,
    required this.points,
    required this.goalsFor,
    required this.goalsAgainst,
  });
}
