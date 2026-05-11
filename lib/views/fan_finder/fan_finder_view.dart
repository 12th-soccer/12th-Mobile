import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';
import 'package:twelfth_mobile/features/recruitment/domain/entities/recruitment.dart';
import 'package:twelfth_mobile/features/recruitment/domain/entities/recruitment_enums.dart';
import 'package:twelfth_mobile/features/recruitment/presentation/providers/recruitment_provider.dart';
import 'package:twelfth_mobile/features/recruitment/presentation/providers/team_list_provider.dart';
import 'package:twelfth_mobile/views/fan_finder/fan_finder_constants.dart';
import 'package:twelfth_mobile/views/fan_finder/widgets/age_verification_dialog.dart';

class FanFinderView extends ConsumerStatefulWidget {
  const FanFinderView({super.key});

  @override
  ConsumerState<FanFinderView> createState() => _FanFinderViewState();
}

class _FanFinderViewState extends ConsumerState<FanFinderView> {
  final _pageController = PageController(viewportFraction: 0.88);
  AgeGroup? _ageFilter;
  GenderGroup? _genderFilter;
  TeamGroup? _k1Filter;
  TeamGroup? _k2Filter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showVerification());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _showVerification() async {
    final result = await AgeVerificationDialog.show(context);
    if (!mounted) return;
    if (result == true) {
      // TODO: 포트원 나이 인증 페이지로 이동
    } else {
      context.pop();
    }
  }

  List<Recruitment> _applyFilters(List<Recruitment> posts) {
    return posts.where((p) {
      if (_ageFilter != null && p.ageGroup != _ageFilter) return false;
      if (_genderFilter != null && p.genderGroup != _genderFilter) return false;
      if (_k1Filter != null && p.teamGroup != _k1Filter) return false;
      if (_k2Filter != null && p.teamGroup != _k2Filter) return false;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final listAsync = ref.watch(recruitmentListProvider);

    return Scaffold(
      backgroundColor: CustomColor.background,
      appBar: AppBar(
        backgroundColor: CustomColor.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back_ios, color: CustomColor.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          const Divider(color: CustomColor.gray800, height: 1),
          Expanded(
            child: listAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: CustomColor.white),
              ),
              error: (_, __) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '모집글을 불러오지 못했습니다',
                      style: CustomTextStyle.body2.copyWith(
                        color: CustomColor.gray500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () =>
                          ref.read(recruitmentListProvider.notifier).refresh(),
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
              data: (posts) {
                final filtered = _applyFilters(posts);
                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      '해당 조건의 모집글이 없습니다',
                      style: CustomTextStyle.body1.copyWith(
                        color: CustomColor.gray500,
                      ),
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () =>
                      ref.read(recruitmentListProvider.notifier).refresh(),
                  color: CustomColor.white,
                  backgroundColor: CustomColor.gray900,
                  child: _buildPageView(filtered),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.fanFinderWrite),
        backgroundColor: CustomColor.main,
        shape: const CircleBorder(),
        child: const Icon(Symbols.add, color: CustomColor.black),
      ),
    );
  }

  static const int _pageSize = 10;

  List<List<Recruitment>> _chunk(List<Recruitment> list) {
    final pages = <List<Recruitment>>[];
    for (var i = 0; i < list.length; i += _pageSize) {
      pages.add(list.sublist(i, min(i + _pageSize, list.length)));
    }
    return pages;
  }

  Widget _buildPageView(List<Recruitment> posts) {
    final pages = _chunk(posts);

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            onPageChanged: (i) {
              if (i >= pages.length - 1) {
                ref.read(recruitmentListProvider.notifier).loadMore();
              }
            },
            itemBuilder: (context, pageIndex) {
              final items = pages[pageIndex];
              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: items.length,
                itemBuilder: (_, i) => _RecruitmentListItem(
                  recruitment: items[i],
                  onTap: () =>
                      context.push(AppRoutes.fanFinderDetail, extra: items[i]),
                ),
              );
            },
          ),
        ),
        if (pages.length > 1)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: _PageIndicator(
              controller: _pageController,
              count: pages.length,
            ),
          ),
      ],
    );
  }

  Widget _buildFilterBar() {
    final teamAsync = ref.watch(teamListProvider);
    final hasFilter =
        _ageFilter != null ||
        _genderFilter != null ||
        _k1Filter != null ||
        _k2Filter != null;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          _FilterChip(
            label: _ageFilter?.displayTag ?? '나이대',
            isActive: _ageFilter != null,
            onTap: () => _showPickerSheet(
              title: '나이대',
              options: AgeGroup.values,
              selected: _ageFilter,
              label: (v) => v.displayTag,
              onSelect: (v) =>
                  setState(() => _ageFilter = v == _ageFilter ? null : v),
            ),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: _genderFilter?.displayTag ?? '성별',
            isActive: _genderFilter != null,
            onTap: () => _showPickerSheet(
              title: '성별',
              options: GenderGroup.values,
              selected: _genderFilter,
              label: (v) => v.displayTag,
              onSelect: (v) =>
                  setState(() => _genderFilter = v == _genderFilter ? null : v),
            ),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: _k1Filter?.displayTag ?? 'K1',
            isActive: _k1Filter != null,
            onTap: () {
              final teams =
                  teamAsync.valueOrNull?.k1Teams ??
                  TeamGroup.values
                      .where((t) => t.isK1)
                      .map((t) => TeamItem(group: t, displayName: t.displayTag))
                      .toList();
              _showTeamSheet(
                title: 'K1 구단',
                teams: teams,
                selected: _k1Filter,
                onSelect: (g) =>
                    setState(() => _k1Filter = g == _k1Filter ? null : g),
              );
            },
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: _k2Filter?.displayTag ?? 'K2',
            isActive: _k2Filter != null,
            onTap: () {
              final teams =
                  teamAsync.valueOrNull?.k2Teams ??
                  TeamGroup.values
                      .where((t) => !t.isK1)
                      .map((t) => TeamItem(group: t, displayName: t.displayTag))
                      .toList();
              _showTeamSheet(
                title: 'K2 구단',
                teams: teams,
                selected: _k2Filter,
                onSelect: (g) =>
                    setState(() => _k2Filter = g == _k2Filter ? null : g),
              );
            },
          ),
          if (hasFilter) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => setState(() {
                _ageFilter = null;
                _genderFilter = null;
                _k1Filter = null;
                _k2Filter = null;
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: CustomColor.gray600),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '초기화',
                  style: CustomTextStyle.body3.copyWith(
                    color: CustomColor.gray500,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showPickerSheet<T>({
    required String title,
    required List<T> options,
    required T? selected,
    required String Function(T) label,
    required void Function(T) onSelect,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: CustomColor.gray900,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: CustomColor.gray600,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
              child: Text(title, style: CustomTextStyle.heading2),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: options.map((opt) {
                  final isSel = selected == opt;
                  return ListTile(
                    dense: true,
                    title: Text(
                      label(opt),
                      style: CustomTextStyle.body2.copyWith(
                        color: isSel ? CustomColor.main : CustomColor.white,
                        fontWeight: isSel ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    trailing: isSel
                        ? const Icon(
                            Symbols.check,
                            color: CustomColor.main,
                            size: 18,
                          )
                        : null,
                    onTap: () {
                      onSelect(opt);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showTeamSheet({
    required String title,
    required List<TeamItem> teams,
    required TeamGroup? selected,
    required void Function(TeamGroup) onSelect,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: CustomColor.gray900,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: CustomColor.gray600,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
              child: Text(title, style: CustomTextStyle.heading2),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: teams.map((t) {
                  final isSel = selected == t.group;
                  return ListTile(
                    dense: true,
                    title: Text(
                      t.group.displayTag,
                      style: CustomTextStyle.body2.copyWith(
                        color: isSel ? CustomColor.main : CustomColor.white,
                        fontWeight: isSel ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    trailing: isSel
                        ? const Icon(
                            Symbols.check,
                            color: CustomColor.main,
                            size: 18,
                          )
                        : null,
                    onTap: () {
                      onSelect(t.group);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _RecruitmentListItem extends StatelessWidget {
  final Recruitment recruitment;
  final VoidCallback onTap;

  const _RecruitmentListItem({required this.recruitment, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: CustomColor.gray800,
          borderRadius: FanFinderConstants.cardRadius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: CustomColor.main.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    recruitment.teamGroup.displayTag,
                    style: CustomTextStyle.body3.copyWith(
                      color: CustomColor.main,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                const Icon(Symbols.group, color: CustomColor.gray500, size: 14),
                const SizedBox(width: 3),
                Text(
                  '최대 ${recruitment.headCount}명',
                  style: CustomTextStyle.body3.copyWith(
                    color: CustomColor.gray500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              recruitment.title,
              style: CustomTextStyle.body1.copyWith(
                color: CustomColor.white,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              recruitment.content,
              style: CustomTextStyle.body2.copyWith(color: CustomColor.gray500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _PageIndicator extends StatefulWidget {
  final PageController controller;
  final int count;

  const _PageIndicator({required this.controller, required this.count});

  @override
  State<_PageIndicator> createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<_PageIndicator> {
  int _current = 0;

  static const int _maxDots = 5;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onPage);
  }

  void _onPage() {
    final p = widget.controller.page?.round() ?? 0;
    if (p != _current) setState(() => _current = p);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onPage);
    super.dispose();
  }

  int get _activeDotIndex {
    final total = widget.count;
    if (total <= _maxDots) return _current;
    if (_current == 0) return 0;
    if (_current == total - 1) return 4;
    final progress = (_current - 1) / (total - 2);
    return 1 + (progress * 2).round();
  }

  int get _dotCount => min(widget.count, _maxDots);

  @override
  Widget build(BuildContext context) {
    final activeDot = _activeDotIndex;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_dotCount, (i) {
        final isActive = i == activeDot;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 16 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? CustomColor.main : CustomColor.gray600,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? CustomColor.main.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? CustomColor.main : CustomColor.gray600,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: CustomTextStyle.body3.copyWith(
                color: isActive ? CustomColor.main : CustomColor.gray500,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 14,
              color: isActive ? CustomColor.main : CustomColor.gray500,
            ),
          ],
        ),
      ),
    );
  }
}
