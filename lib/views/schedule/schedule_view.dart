import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';
import 'package:twelfth_mobile/features/match/presentation/providers/match_provider.dart';
import 'package:twelfth_mobile/views/schedule/widgets/league_tabs.dart';
import 'package:twelfth_mobile/views/schedule/widgets/schedule_calendar.dart';
import 'package:twelfth_mobile/views/schedule/widgets/schedule_match_card.dart';

class ScheduleView extends ConsumerStatefulWidget {
  const ScheduleView({super.key});

  @override
  ConsumerState<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends ConsumerState<ScheduleView> {
  late DateTime _focusedMonth;
  late DateTime _selectedDate;
  int _leagueTabIndex = 0;
  Timer? _autoRefreshTimer;

  String get _dateKey {
    final d = _selectedDate;
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '${d.year}-$mm-$dd';
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _focusedMonth = DateTime(now.year, now.month);
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  void _resetToToday() {
    if (!mounted) return;
    final now = DateTime.now();
    setState(() {
      _selectedDate = DateTime(now.year, now.month, now.day);
      _focusedMonth = DateTime(now.year, now.month);
    });
  }

  void _startAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = Timer.periodic(
      const Duration(hours: 2),
      (_) => _resetToToday(),
    );
  }

  Future<void> _onRefresh() async {
    ref.invalidate(matchesByDateProvider(_dateKey));
    _resetToToday();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(context),
            const SizedBox(height: 20),
            ScheduleCalendar(
              focusedMonth: _focusedMonth,
              selectedDate: _selectedDate,
              onPrevMonth: () => setState(
                () => _focusedMonth = DateTime(
                  _focusedMonth.year,
                  _focusedMonth.month - 1,
                ),
              ),
              onNextMonth: () => setState(
                () => _focusedMonth = DateTime(
                  _focusedMonth.year,
                  _focusedMonth.month + 1,
                ),
              ),
              onDateSelected: (date) => setState(() => _selectedDate = date),
            ),
            LeagueTabs(
              selectedIndex: _leagueTabIndex,
              onTap: (index) => setState(() => _leagueTabIndex = index),
            ),
            Expanded(child: _buildMatchList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: () => context.push(AppRoutes.search),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: CustomColor.gray800,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: CustomColor.gray800),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              const Icon(
                Symbols.search,
                color: CustomColor.gray600,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '선수이름, 구단이름으로 검색',
                style: CustomTextStyle.body2.copyWith(
                  color: CustomColor.gray600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatchList() {
    final matchesAsync = ref.watch(matchesByDateProvider(_dateKey));
    final leagueFilter = _leagueTabIndex == 0 ? 'K1' : 'K2';

    return matchesAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: CustomColor.white),
      ),
      error: (e, _) => _buildRefreshList(
        child: Center(
          child: Text(
            '경기 정보를 불러오지 못했습니다',
            style: CustomTextStyle.body2.copyWith(color: CustomColor.gray500),
          ),
        ),
      ),
      data: (matches) {
        final filtered = matches
            .where((m) => m.leagueType == null || m.leagueType == leagueFilter)
            .toList();

        if (filtered.isEmpty) {
          return _buildRefreshList(
            child: Center(
              child: Text(
                '해당 날짜에 경기가 없습니다',
                style:
                    CustomTextStyle.body2.copyWith(color: CustomColor.gray500),
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _onRefresh,
          color: CustomColor.white,
          backgroundColor: CustomColor.gray900,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: filtered.length,
            itemBuilder: (context, index) =>
                ScheduleMatchCard(match: filtered[index]),
          ),
        );
      },
    );
  }

  Widget _buildRefreshList({required Widget child}) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: CustomColor.white,
      backgroundColor: CustomColor.gray900,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 40),
        children: [child],
      ),
    );
  }
}
