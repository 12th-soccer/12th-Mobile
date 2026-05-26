import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/core/constants/spacing.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/extensions/snackbar_extension.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';
import 'package:twelfth_mobile/core/router/team_route_args.dart';
import 'package:twelfth_mobile/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:twelfth_mobile/common/components/image/network_avatar.dart';
import 'package:twelfth_mobile/features/ranking/domain/entities/club_ranking.dart';
import 'package:twelfth_mobile/features/ranking/presentation/providers/ranking_provider.dart';

class RankingView extends ConsumerStatefulWidget {
  const RankingView({super.key});

  @override
  ConsumerState<RankingView> createState() => _RankingViewState();
}

class _RankingViewState extends ConsumerState<RankingView> {
  int _tabIndex = 0;
  late int _selectedYear;
  static const _tabs = ['K1', 'K2'];
  static const _spacing = AppSpacing.w10;

  static List<int> get _years {
    final current = DateTime.now().year;
    return List.generate(current - kStartSeason + 1, (i) => current - i);
  }

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

  String get _currentLeague => _tabs[_tabIndex];

  @override
  void initState() {
    super.initState();
    _selectedYear = DateTime.now().year;
  }

  RankingArgs get _rankingArgs => (league: _currentLeague, season: '$_selectedYear');

  @override
  Widget build(BuildContext context) {
    final rankingAsync = ref.watch(rankingProvider(_rankingArgs));

    return Scaffold(
      backgroundColor: CustomColor.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
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
                        style: CustomTextStyle.body2.copyWith(
                          color: CustomColor.gray500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      AppSpacing.h16,
                      GestureDetector(
                        onTap: () =>
                            ref.invalidate(rankingProvider(_rankingArgs)),
                        child: Text(
                          '다시 시도',
                          style: CustomTextStyle.body2.copyWith(
                            color: CustomColor.white,
                          ),
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

  Widget _buildHeader() {
    return Column(
      children: [
        _buildTabs(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PopupMenuButton<int>(
                onSelected: (y) => setState(() => _selectedYear = y),
                color: CustomColor.gray900,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.md,
                  side: const BorderSide(color: CustomColor.gray600),
                ),
                offset: const Offset(0, 40),
                itemBuilder: (_) => _years
                    .map(
                      (y) => PopupMenuItem<int>(
                        value: y,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 2,
                        ),
                        child: Text(
                          '$y년',
                          style: CustomTextStyle.body2.copyWith(
                            color: y == _selectedYear
                                ? CustomColor.main
                                : CustomColor.white,
                            fontWeight: y == _selectedYear
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: CustomColor.main,
                    borderRadius: AppRadius.lg,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$_selectedYear년',
                        style: CustomTextStyle.body3.copyWith(
                          color: CustomColor.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      AppSpacing.w4,
                      const Icon(
                        Icons.expand_more,
                        color: CustomColor.black,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(rankingProvider(_rankingArgs)),
      color: CustomColor.white,
      backgroundColor: CustomColor.gray900,
      child: ListView.builder(
        padding: AppPadding.listV,
        itemCount: teams.length,
        itemBuilder: (context, index) => _buildTeamItem(teams[index]),
      ),
    );
  }

  Widget _buildTeamItem(ClubRanking team) {
    final barColor = _rankBarColor(team.rank);
    final favorites = ref.watch(favoritesNotifierProvider);
    final isFavorite =
        favorites.valueOrNull?.any((c) => c.clubId == team.clubId) ?? false;

    return GestureDetector(
      onTap: () {
        context.push(
          AppRoutes.team,
          extra: TeamRouteArgs(clubId: team.clubId, teamName: team.clubName),
        );
      },
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
                    _spacing,
                    NetworkAvatar(imageUrl: team.clubImage, size: 32),
                    _spacing,
                    Expanded(
                      child: Text(
                        team.clubName,
                        style: CustomTextStyle.body1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _spacing,
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
                    AppSpacing.w4,
                    GestureDetector(
                      onTap: () async {
                        try {
                          await ref
                              .read(favoritesNotifierProvider.notifier)
                              .toggleFavorite(team.clubId, team.clubName);
                        } catch (_) {
                          if (!mounted) return;
                          {
                            context.showErrorSnackBar('관심 구단 설정에 실패했습니다.');
                          }
                        }
                      },
                      child: Icon(
                        Symbols.star,
                        color: isFavorite
                            ? CustomColor.yellow
                            : CustomColor.main,
                        fill: isFavorite ? 1 : 0,
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
