import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';
import 'package:twelfth_mobile/features/match/domain/entities/match.dart';
import 'package:twelfth_mobile/features/match/presentation/providers/match_provider.dart';
import 'package:twelfth_mobile/views/match/match_detail_view.dart';

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
            Padding(
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
            ),
            const SizedBox(height: 20),
            _ScheduleCalendar(
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
            _LeagueTabs(
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
    final matchesAsync = ref.watch(matchesByDateProvider(_dateKey));
    final leagueFilter = _leagueTabIndex == 0 ? 'K1' : 'K2';

    return matchesAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: CustomColor.white),
      ),
      error: (e, _) => RefreshIndicator(
        onRefresh: _onRefresh,
        color: CustomColor.white,
        backgroundColor: CustomColor.gray900,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 40),
          children: [
            Center(
              child: Text(
                '경기 정보를 불러오지 못했습니다',
                style: CustomTextStyle.body2.copyWith(
                  color: CustomColor.gray500,
                ),
              ),
            ),
          ],
        ),
      ),
      data: (matches) {
        final filtered = matches
            .where((m) => m.leagueType == null || m.leagueType == leagueFilter)
            .toList();

        if (filtered.isEmpty) {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: CustomColor.white,
            backgroundColor: CustomColor.gray900,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 40),
              children: [
                Center(
                  child: Text(
                    '해당 날짜에 경기가 없습니다',
                    style: CustomTextStyle.body2.copyWith(
                      color: CustomColor.gray500,
                    ),
                  ),
                ),
              ],
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
            itemBuilder: (context, index) => _MatchCard(match: filtered[index]),
          ),
        );
      },
    );
  }
}

class _MatchCard extends StatelessWidget {
  final Match match;

  const _MatchCard({required this.match});

  @override
  Widget build(BuildContext context) {
    final dateStr = '${match.matchDate.month}/${match.matchDate.day}';
    final timeStr =
        '${match.matchDate.hour.toString().padLeft(2, '0')}:${match.matchDate.minute.toString().padLeft(2, '0')}';

    MatchState state;
    if (match.isFinished) {
      state = MatchState.finished;
    } else if (match.matchDate.isBefore(DateTime.now())) {
      state = MatchState.live;
    } else {
      state = MatchState.upcoming;
    }

    final extra = MatchExtra(
      matchId: match.matchId,
      homeTeam: match.homeTeamName,
      awayTeam: match.awayTeamName,
      matchState: state,
      matchDate: dateStr,
      matchTime: timeStr,
    );

    return GestureDetector(
      onTap: () => context.push(AppRoutes.match, extra: extra),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CustomColor.gray900,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _TeamTag(name: match.awayTeamName, align: MainAxisAlignment.start),
            _CenterInfo(
              matchState: state,
              homeScore: match.homeTeamScore,
              awayScore: match.awayTeamScore,
              dateStr: dateStr,
              timeStr: timeStr,
            ),
            _TeamTag(name: match.homeTeamName, align: MainAxisAlignment.end),
          ],
        ),
      ),
    );
  }
}

class _TeamTag extends StatelessWidget {
  final String name;
  final MainAxisAlignment align;

  const _TeamTag({required this.name, required this.align});

  @override
  Widget build(BuildContext context) {
    final logo = Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: CustomColor.gray800,
        shape: BoxShape.circle,
      ),
    );
    final label = Flexible(
      child: Text(
        name,
        style: CustomTextStyle.body2,
        overflow: TextOverflow.ellipsis,
        textAlign: align == MainAxisAlignment.start
            ? TextAlign.left
            : TextAlign.right,
      ),
    );

    return Expanded(
      child: Row(
        mainAxisAlignment: align,
        children: align == MainAxisAlignment.start
            ? [logo, const SizedBox(width: 6), label]
            : [label, const SizedBox(width: 6), logo],
      ),
    );
  }
}

class _CenterInfo extends StatelessWidget {
  final MatchState matchState;
  final int? homeScore;
  final int? awayScore;
  final String? dateStr;
  final String? timeStr;

  const _CenterInfo({
    required this.matchState,
    this.homeScore,
    this.awayScore,
    this.dateStr,
    this.timeStr,
  });

  @override
  Widget build(BuildContext context) {
    switch (matchState) {
      case MatchState.live:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Live',
              style: CustomTextStyle.body3.copyWith(color: CustomColor.green),
            ),
            const SizedBox(height: 2),
            Text(
              homeScore != null && awayScore != null
                  ? '$awayScore : $homeScore'
                  : '- : -',
              style: CustomTextStyle.heading2,
            ),
          ],
        );
      case MatchState.finished:
        return Text(
          homeScore != null && awayScore != null
              ? '$awayScore : $homeScore'
              : '- : -',
          style: CustomTextStyle.heading2,
        );
      case MatchState.upcoming:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (dateStr != null)
              Text(
                dateStr!,
                style: CustomTextStyle.body3.copyWith(
                  color: CustomColor.gray500,
                ),
              ),
            if (timeStr != null) ...[
              const SizedBox(height: 2),
              Text(timeStr!, style: CustomTextStyle.heading2),
            ],
          ],
        );
    }
  }
}

class _ScheduleCalendar extends StatelessWidget {
  const _ScheduleCalendar({
    required this.focusedMonth,
    required this.selectedDate,
    required this.onPrevMonth,
    required this.onNextMonth,
    required this.onDateSelected,
  });

  final DateTime focusedMonth;
  final DateTime selectedDate;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;
  final ValueChanged<DateTime> onDateSelected;

  static const _weekLabels = ['일', '월', '화', '수', '목', '금', '토'];

  @override
  Widget build(BuildContext context) {
    final year = focusedMonth.year;
    final month = focusedMonth.month;
    final firstWeekday = DateTime(year, month, 1).weekday % 7;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final prevMonthDays = DateTime(year, month, 0).day;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: onPrevMonth,
                  behavior: HitTestBehavior.opaque,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Icon(
                      Symbols.arrow_back_ios,
                      color: CustomColor.white,
                      size: 12,
                    ),
                  ),
                ),
                Text('$month월', style: CustomTextStyle.heading2),
                GestureDetector(
                  onTap: onNextMonth,
                  behavior: HitTestBehavior.opaque,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Icon(
                      Symbols.arrow_forward_ios,
                      color: CustomColor.white,
                      size: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: List.generate(7, (i) {
              final color = i == 0
                  ? CustomColor.red
                  : i == 6
                  ? CustomColor.blue
                  : CustomColor.gray600;
              return Expanded(
                child: Center(
                  child: Text(
                    _weekLabels[i],
                    style: CustomTextStyle.body3.copyWith(color: color),
                  ),
                ),
              );
            }),
          ),
          ...List.generate(6, (row) {
            return Row(
              children: List.generate(7, (col) {
                final cellIndex = row * 7 + col;
                int day;
                bool isCurrentMonth;

                if (cellIndex < firstWeekday) {
                  day = prevMonthDays - firstWeekday + cellIndex + 1;
                  isCurrentMonth = false;
                } else {
                  final d = cellIndex - firstWeekday + 1;
                  if (d > daysInMonth) {
                    day = d - daysInMonth;
                    isCurrentMonth = false;
                  } else {
                    day = d;
                    isCurrentMonth = true;
                  }
                }

                final date = isCurrentMonth
                    ? DateTime(year, month, day)
                    : (cellIndex < firstWeekday
                          ? DateTime(year, month - 1, day)
                          : DateTime(year, month + 1, day));

                final isSelected =
                    selectedDate.year == date.year &&
                    selectedDate.month == date.month &&
                    selectedDate.day == date.day;

                Color textColor;
                if (!isCurrentMonth) {
                  textColor = CustomColor.gray900;
                } else if (isSelected) {
                  textColor = CustomColor.black;
                } else if (col == 0) {
                  textColor = CustomColor.red;
                } else if (col == 6) {
                  textColor = CustomColor.blue;
                } else {
                  textColor = CustomColor.white;
                }

                return Expanded(
                  child: GestureDetector(
                    onTap: isCurrentMonth ? () => onDateSelected(date) : null,
                    child: SizedBox(
                      height: 34,
                      child: Center(
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: isSelected
                              ? const BoxDecoration(
                                  color: CustomColor.main,
                                  shape: BoxShape.circle,
                                )
                              : null,
                          child: Center(
                            child: Text(
                              '$day',
                              style: CustomTextStyle.body2.copyWith(
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }
}

class _LeagueTabs extends StatelessWidget {
  const _LeagueTabs({required this.selectedIndex, required this.onTap});

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: CustomColor.gray900, width: 1),
        ),
      ),
      child: Row(
        children: List.generate(2, (index) {
          final isSelected = selectedIndex == index;
          final label = ['K1', 'K2'][index];
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected
                          ? CustomColor.white
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    label,
                    style: CustomTextStyle.heading3.copyWith(
                      color: isSelected
                          ? CustomColor.white
                          : CustomColor.gray600,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
