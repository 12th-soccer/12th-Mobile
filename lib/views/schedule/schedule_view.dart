import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/core/constants/spacing.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/features/favorites/presentation/providers/favorites_provider.dart';
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

  String get _leagueType => _leagueTabIndex == 0 ? 'K1' : 'K2';

  Future<void> _onRefresh() async {
    ref.invalidate(
      matchesByDateProvider((date: _dateKey, leagueType: _leagueType)),
    );
    _resetToToday();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background,
      body: SafeArea(
        child: Column(
          children: [
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
              onHeaderTap: _resetToToday,
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

  Widget _buildMatchList() {
    final matchesAsync = ref.watch(
      matchesByDateProvider((date: _dateKey, leagueType: _leagueType)),
    );
    final favoriteClubNames = ref
            .watch(favoritesNotifierProvider)
            .valueOrNull
            ?.map((c) => c.clubName)
            .toSet() ??
        {};

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
        final filtered = matches;

        if (filtered.isEmpty) {
          return _buildRefreshList(
            child: Center(
              child: Text(
                '해당 날짜에 경기가 없습니다',
                style: CustomTextStyle.body2
                    .copyWith(color: CustomColor.gray500),
              ),
            ),
          );
        }

        bool isFavoriteMatch(m) =>
            favoriteClubNames.contains(m.homeTeamName) ||
            favoriteClubNames.contains(m.awayTeamName);

        final sorted = [
          ...filtered.where(isFavoriteMatch),
          ...filtered.where((m) => !isFavoriteMatch(m)),
        ];

        return RefreshIndicator(
          onRefresh: _onRefresh,
          color: CustomColor.white,
          backgroundColor: CustomColor.gray900,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: AppPadding.listV,
            itemCount: sorted.length,
            itemBuilder: (context, index) =>
                ScheduleMatchCard(match: sorted[index]),
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
