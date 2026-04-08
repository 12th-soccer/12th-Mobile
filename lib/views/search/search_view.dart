import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';
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
  final List<String> _history = [];

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _search(String query) {
    final q = query.trim();
    if (q.isEmpty) return;

    _history.remove(q);
    _history.insert(0, q);
    if (_history.length > 20) _history.removeLast();

    _focusNode.unfocus();
    ref.read(searchNotifierProvider.notifier).search(q);
  }

  void _onHistoryTap(String query) {
    _searchController.text = query;
    _search(query);
  }

  void _clearField() {
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

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchNotifierProvider);
    final showResults = searchState.status != SearchStatus.initial;

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
              Expanded(
                child: showResults
                    ? _buildResultsSection(searchState)
                    : _buildHistorySection(),
              ),
            ],
          ),
        ),
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
            child:
                const Icon(Symbols.arrow_back_ios, color: CustomColor.main),
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
                hintStyle: CustomTextStyle.body1
                    .copyWith(color: CustomColor.gray500),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onSubmitted: _search,
              onChanged: (v) {
                setState(() {});
                if (v.trim().isEmpty) {
                  ref.read(searchNotifierProvider.notifier).reset();
                }
              },
            ),
          ),
          _FilterDropdown(label: filterLabel, onSelected: _onFilterChanged),
        ],
      ),
    );
  }

  Widget _buildHistorySection() {
    if (_history.isEmpty) return const SizedBox.shrink();
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: _history.length,
      itemBuilder: (context, index) {
        final query = _history[index];
        return GestureDetector(
          onTap: () => _onHistoryTap(query),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                const Icon(Symbols.search,
                    color: CustomColor.gray500, size: 18),
                const SizedBox(width: 12),
                Text(query, style: CustomTextStyle.body1),
              ],
            ),
          ),
        );
      },
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
        child: Text(
          state.errorMessage ?? '오류가 발생했습니다',
          style:
              CustomTextStyle.body2.copyWith(color: CustomColor.gray500),
        ),
      );
    }
    if (state.status == SearchStatus.empty) {
      return Center(
        child: Text(
          '검색 결과가 없습니다.',
          style:
              CustomTextStyle.body2.copyWith(color: CustomColor.gray500),
        ),
      );
    }
    if (state.filter == SearchFilter.club) {
      return _buildClubResults(state.clubs);
    }
    return _buildPlayerResults(state.players);
  }

  Widget _buildClubResults(List<ClubSearchResult> clubs) {
    return ListView.builder(
      itemCount: clubs.length,
      itemBuilder: (context, index) {
        final club = clubs[index];
        return GestureDetector(
          onTap: () => context.push(AppRoutes.team, extra: club.name),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: CustomColor.gray900,
                    shape: BoxShape.circle,
                  ),
                  // TODO: club.logoUrl 이미지 로드
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(club.name, style: CustomTextStyle.body1)),
                Text(
                  '더보기',
                  style: CustomTextStyle.body2
                      .copyWith(color: CustomColor.gray500),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlayerResults(List<PlayerSearchResult> players) {
    return ListView.builder(
      itemCount: players.length,
      itemBuilder: (context, index) {
        final player = players[index];
        return GestureDetector(
          onTap: () => context.push(AppRoutes.player, extra: player.name),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: CustomColor.gray900,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(player.name, style: CustomTextStyle.body1),
                      Text(
                        '${player.clubName} · ${player.position} · #${player.number}',
                        style: CustomTextStyle.body3
                            .copyWith(color: CustomColor.gray500),
                      ),
                    ],
                  ),
                ),
                Text(
                  '더보기',
                  style: CustomTextStyle.body2
                      .copyWith(color: CustomColor.gray500),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Filter Dropdown ───────────────────────────────────────────────────

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
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: CustomColor.main),
        ),
        offset: const Offset(0, 36),
        constraints: const BoxConstraints(minWidth: 72, maxWidth: 72),
        itemBuilder: (_) => [
          PopupMenuItem(
            value: SearchFilter.player,
            height: 40,
            child:
                Center(child: Text('선수', style: CustomTextStyle.body2)),
          ),
          PopupMenuItem(
            value: SearchFilter.club,
            height: 40,
            child:
                Center(child: Text('구단', style: CustomTextStyle.body2)),
          ),
        ],
        child: SizedBox(
          width: 72,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: CustomColor.main),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: CustomTextStyle.body2),
                const SizedBox(width: 4),
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
