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
  final List<String> _tabs = ['K1', 'K2'];
  final spacing = const SizedBox(width: 10);

  late List<_MockTeam> _k1Teams;
  late List<_MockTeam> _k2Teams;

  @override
  void initState() {
    super.initState();
    _k1Teams = [
      _MockTeam(rank: 1, name: '울산 HD FC', points: 45),
      _MockTeam(rank: 2, name: '강원 FC', points: 42),
      _MockTeam(rank: 3, name: 'FC 서울', points: 40),
      _MockTeam(rank: 4, name: '전북 현대', points: 38),
      _MockTeam(rank: 5, name: '인천 유나이티드', points: 35),
      _MockTeam(rank: 6, name: '포항 스틸러스', points: 32),
      _MockTeam(rank: 7, name: '대구 FC', points: 28),
      _MockTeam(rank: 8, name: '제주 유나이티드', points: 25),
      _MockTeam(rank: 9, name: '광주 FC', points: 22),
      _MockTeam(rank: 10, name: '수원 삼성', points: 20),
      _MockTeam(rank: 11, name: '대전 하나 시티즌', points: 15),
      _MockTeam(rank: 12, name: '김천 상무', points: 12),
    ];
    _k2Teams = [
      _MockTeam(rank: 1, name: '서울 이랜드', points: 40),
      _MockTeam(rank: 2, name: '성남 FC', points: 38),
      _MockTeam(rank: 3, name: '수원 삼성', points: 37),
      _MockTeam(rank: 4, name: '수원 FC', points: 36),
      _MockTeam(rank: 5, name: '성남 FC', points: 35),
      _MockTeam(rank: 6, name: '용인 FC', points: 34),
      _MockTeam(rank: 7, name: '파주 프런티어', points: 32),
      _MockTeam(rank: 8, name: '화성 FC', points: 31),
      _MockTeam(rank: 9, name: '부산 아이파크', points: 30),
      _MockTeam(rank: 10, name: '경남 FC', points: 28),
      _MockTeam(rank: 11, name: '전남 드래곤즈', points: 25),
      _MockTeam(rank: 12, name: '충남 아산', points: 22),
      _MockTeam(rank: 13, name: '충북 청주', points: 20),
      _MockTeam(rank: 14, name: '안산 그리너스', points: 18),
      _MockTeam(rank: 15, name: 'FC 안양', points: 12),
      _MockTeam(rank: 16, name: '천안 시티', points: 8),
      _MockTeam(rank: 17, name: '김해 FC', points: 4),
    ];
  }

  List<_MockTeam> get _teams => _tabIndex == 0 ? _k1Teams : _k2Teams;

  Color? _rankBarColor(int rank) {
    if (_tabIndex == 0) {
      if (rank <= 3) return CustomColor.blue;
      if (rank >= 10 && rank < 12) return CustomColor.orange;
      if (rank >= 12) return CustomColor.red;
    } else {
      if (rank <= 1) return CustomColor.blue;
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

    return GestureDetector(
      onTap: () => context.push(AppRoutes.team, extra: team.name),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(width: 12, color: barColor ?? Colors.transparent),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    SizedBox(
                      child: Text(
                        '${team.rank}',
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
                      child: Text(team.name, style: CustomTextStyle.body1),
                    ),
                    Text(
                      '${team.points}',
                      style: CustomTextStyle.body2.copyWith(
                        color: CustomColor.gray500,
                      ),
                    ),
                    spacing,
                    GestureDetector(
                      onTap: () => Bookmarking.instance.toggleTeam(team.name),
                      child: Icon(
                        Symbols.star,
                        color: Bookmarking.instance.isTeamBookmarked(team.name)
                            ? CustomColor.yellow
                            : CustomColor.main,
                        fill: Bookmarking.instance.isTeamBookmarked(team.name) ? 1.0 : 0.0,
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

  _MockTeam({required this.rank, required this.name, required this.points});
}
