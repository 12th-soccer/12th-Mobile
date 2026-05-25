import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/common/components/image/network_avatar.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/core/constants/spacing.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/router/player_route_args.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';
import 'package:twelfth_mobile/core/router/team_route_args.dart';
import 'package:twelfth_mobile/features/search/domain/entities/club_search_result.dart';
import 'package:twelfth_mobile/features/search/domain/entities/player_search_result.dart';
import 'package:twelfth_mobile/features/search/presentation/providers/search_provider.dart';
import 'package:twelfth_mobile/features/search/presentation/providers/search_state.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({super.key});

  @override
  ConsumerState<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _debounce;

  static const double _avatarSize = 44;
  static const double _itemSpacing = 12;
  static const EdgeInsets _itemPadding = EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 10,
  );

  TextStyle get _subTextStyle =>
      CustomTextStyle.body2.copyWith(color: CustomColor.gray500);

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    if (value.trim().isEmpty) {
      ref.read(searchNotifierProvider.notifier).reset();
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(searchNotifierProvider.notifier).search(value.trim());
    });
  }

  void _clearField() {
    _debounce?.cancel();
    _searchController.clear();
    ref.read(searchNotifierProvider.notifier).reset();
    _focusNode.requestFocus();
  }

  void _onFilterChanged(SearchFilter filter) {
    ref.read(searchNotifierProvider.notifier).setFilter(filter);
    final q = _searchController.text.trim();
    if (q.isNotEmpty) {
      ref.read(searchNotifierProvider.notifier).search(q);
    }
  }

  static List<String> get _seasons {
    final current = DateTime.now().year;
    return List.generate(current - kStartSeason + 1, (i) => (current - i).toString());
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchNotifierProvider);
    final showResults =
        searchState.status != SearchStatus.initial ||
        _searchController.text.isNotEmpty;
    final isPlayerFilter = searchState.filter == SearchFilter.player;

    return GestureDetector(
      onTap: () => _focusNode.unfocus(),
      child: Scaffold(
        backgroundColor: CustomColor.background,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(searchState),
              const Divider(color: CustomColor.main, height: 1),
              if (isPlayerFilter) _buildSeasonDropdown(searchState),
              Expanded(
                child: showResults
                    ? _buildResultsSection(searchState)
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeasonDropdown(SearchState state) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AppSpacing.w8,
          PopupMenuButton<String>(
            onSelected: (season) {
              ref.read(searchNotifierProvider.notifier).setSeason(season);
              final q = _searchController.text.trim();
              if (q.isNotEmpty) {
                ref.read(searchNotifierProvider.notifier).search(q);
              }
            },
            color: CustomColor.gray900,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.md,
              side: const BorderSide(color: CustomColor.gray600),
            ),
            offset: const Offset(0, 40),
            itemBuilder: (_) => _seasons
                .map(
                  (season) => PopupMenuItem<String>(
                    value: season,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 2,
                    ),
                    child: Text(
                      '${season}년',
                      style: CustomTextStyle.body2.copyWith(
                        color: season == state.selectedSeason
                            ? CustomColor.main
                            : CustomColor.white,
                        fontWeight: season == state.selectedSeason
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
                    '${state.selectedSeason}년',
                    style: CustomTextStyle.body3.copyWith(
                      color: CustomColor.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppSpacing.w4,
                  const Icon(
                    Symbols.expand_more,
                    color: CustomColor.black,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(SearchState state) {
    final filterLabel = state.filter == SearchFilter.player ? '선수' : '구단';
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: _clearField,
            child: const Icon(Symbols.arrow_back_ios, color: CustomColor.main),
          ),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              autofocus: true,
              cursorColor: CustomColor.main,
              style: CustomTextStyle.body1,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: '검색',
                hintStyle: CustomTextStyle.body1.copyWith(
                  color: CustomColor.gray500,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onSubmitted: (v) => _onChanged(v),
              onChanged: (v) {
                setState(() {});
                _onChanged(v);
              },
            ),
          ),
          _FilterDropdown(label: filterLabel, onSelected: _onFilterChanged),
        ],
      ),
    );
  }

  Widget _buildResultsSection(SearchState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('검색 결과', style: CustomTextStyle.heading1),
        ),
        Expanded(child: _buildResultsBody(state)),
      ],
    );
  }

  Widget _buildResultsBody(SearchState state) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: CustomColor.white),
      );
    }
    if (state.status == SearchStatus.error) {
      return Center(
        child: Text(state.errorMessage ?? '오류가 발생했습니다', style: _subTextStyle),
      );
    }
    if (state.status == SearchStatus.empty) {
      return Center(child: Text('검색 결과가 없습니다.', style: _subTextStyle));
    }
    if (state.filter == SearchFilter.club) {
      return _buildClubResults(state.clubs);
    }
    return _buildPlayerResults(state.players);
  }

  Widget _buildClubResults(List<ClubSearchResult> clubs) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 48),
      itemCount: clubs.length,
      itemBuilder: (context, index) {
        final club = clubs[index];
        return GestureDetector(
          onTap: () {
            context.push(
              AppRoutes.team,
              extra: TeamRouteArgs(clubId: club.clubId, teamName: club.name),
            );
          },
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: _itemPadding,
            child: Row(
              children: [
                NetworkAvatar(imageUrl: club.logoUrl, size: _avatarSize),
                const SizedBox(width: _itemSpacing),
                Expanded(child: Text(club.name, style: CustomTextStyle.body1)),
                Text('더보기', style: _subTextStyle),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlayerResults(List<PlayerSearchResult> players) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 48),
      itemCount: players.length,
      itemBuilder: (context, index) {
        final player = players[index];
        return GestureDetector(
          onTap: () => context.push(
            AppRoutes.player,
            extra: PlayerRouteArgs(
              playerId: player.playerId,
              playerName: player.name,
            ),
          ),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: _itemPadding,
            child: Row(
              children: [
                NetworkAvatar(imageUrl: player.imageUrl, size: _avatarSize),
                const SizedBox(width: _itemSpacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(player.name, style: CustomTextStyle.body1),
                      Text(
                        [
                          if (player.clubName != null) player.clubName!,
                          if (player.position != null) player.position!,
                          if (player.number != null) '#${player.number}',
                        ].join(' · '),
                        style: CustomTextStyle.body3.copyWith(
                          color: CustomColor.gray500,
                        ),
                      ),
                    ],
                  ),
                ),
                Text('더보기', style: _subTextStyle),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final String label;
  final void Function(SearchFilter) onSelected;

  const _FilterDropdown({required this.label, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: PopupMenuButton<SearchFilter>(
        onSelected: onSelected,
        color: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.sm,
          side: const BorderSide(color: CustomColor.main),
        ),
        offset: const Offset(0, 36),
        constraints: const BoxConstraints(minWidth: 72, maxWidth: 72),
        itemBuilder: (_) => [
          PopupMenuItem(
            value: SearchFilter.player,
            height: 40,
            child: Center(child: Text('선수', style: CustomTextStyle.body2)),
          ),
          PopupMenuItem(
            value: SearchFilter.club,
            height: 40,
            child: Center(child: Text('구단', style: CustomTextStyle.body2)),
          ),
        ],
        child: SizedBox(
          width: 72,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // 고유값
            decoration: BoxDecoration(
              border: Border.all(color: CustomColor.main),
              borderRadius: AppRadius.sm,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: CustomTextStyle.body2),
                AppSpacing.w4,
                const Icon(
                  Symbols.keyboard_arrow_down,
                  color: CustomColor.white,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
