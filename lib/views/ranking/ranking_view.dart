import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/common/components/bookmark/bookmarking.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';
import 'package:twelfth_mobile/features/ranking/domain/entities/club_ranking.dart';
import 'package:twelfth_mobile/features/ranking/presentation/providers/ranking_provider.dart';

class RankingView extends ConsumerStatefulWidget {
  const RankingView({super.key});

  @override
  ConsumerState<RankingView> createState() => _RankingViewState();
}

class _RankingViewState extends ConsumerState<RankingView> {
  int _tabIndex = 0;
  static const _tabs = ['K1', 'K2'];
  static const _spacing = SizedBox(width: 10);

  Color? _rankBarColor(int rank) {
    if (_tabIndex == 0) {
      if (rank <= 3) return CustomColor.blue;
      if (rank >= 10 && rank < 12) return CustomColor.orange;
      if (rank >= 12) return CustomColor.red;
    } else {
      if (rank == 1) return CustomColor.blue;
      if (rank == 2) return CustomColor.yellow;
      if (rank >= 17) return CustomColor.orange;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final rankingAsync = ref.watch(rankingNotifierProvider);

    return Scaffold(
      backgroundColor: CustomColor.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTabs(),
            Expanded(
              child: rankingAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: CustomColor.white),
                ),
                error: (e, _) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _parseError(e),
                        style: CustomTextStyle.body2
                            .copyWith(color: CustomColor.gray500),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () =>
                            ref.read(rankingNotifierProvider.notifier).refresh(),
                        child: Text(
                          '다시 시도',
                          style: CustomTextStyle.body2
                              .copyWith(color: CustomColor.white),
                        ),
                      ),
                    ],
                  ),
                ),
                data: (teams) => _buildRankingList(teams),
              ),
            ),
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

  Widget _buildRankingList(List<ClubRanking> teams) {
    return ListenableBuilder(
      listenable: Bookmarking.instance,
      builder: (context, _) => RefreshIndicator(
        onRefresh: () =>
            ref.read(rankingNotifierProvider.notifier).refresh(),
        color: CustomColor.white,
        backgroundColor: CustomColor.gray900,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: teams.length,
          itemBuilder: (context, index) => _buildTeamItem(teams[index]),
        ),
      ),
    );
  }

  Widget _buildTeamItem(ClubRanking team) {
    final barColor = _rankBarColor(team.rank);
    final isBookmarked = Bookmarking.instance.isTeamBookmarked(team.clubName);

    return GestureDetector(
      onTap: () => context.push(AppRoutes.team, extra: team),
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
                        style: CustomTextStyle.body2
                            .copyWith(color: CustomColor.gray500),
                      ),
                    ),
                    _spacing,
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: CustomColor.gray900,
                        shape: BoxShape.circle,
                      ),
                    ),
                    _spacing,
                    Expanded(
                      child: Text(
                        team.clubName,
                        style: CustomTextStyle.body1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _spacing,
                    // 승-무-패
                    SizedBox(
                      width: 48,
                      child: Text(
                        '${team.win}-${team.draw}-${team.lose}',
                        textAlign: TextAlign.center,
                        style: CustomTextStyle.body3.copyWith(
                          color: CustomColor.gray500,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    // 승점
                    SizedBox(
                      width: 28,
                      child: Text(
                        '${team.point}',
                        textAlign: TextAlign.center,
                        style: CustomTextStyle.body2.copyWith(
                          color: CustomColor.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () =>
                          Bookmarking.instance.toggleTeam(team.clubName),
                      child: Icon(
                        Symbols.star,
                        color: isBookmarked
                            ? CustomColor.yellow
                            : CustomColor.main,
                        fill: isBookmarked ? 1 : 0,
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

  String _parseError(Object e) {
    final msg = e.toString();
    if (msg.contains('403')) return '권한이 없습니다';
    if (msg.contains('404')) return '랭킹을 조회할 수 없습니다';
    if (msg.contains('SocketException') || msg.contains('connection')) {
      return '네트워크 연결을 확인해 주세요';
    }
    return '랭킹을 불러오지 못했습니다';
  }
}
