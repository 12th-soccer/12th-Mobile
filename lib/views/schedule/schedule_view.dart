import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/common/components/match/match_card.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/components/text_form_field/text_form_field.dart';
import 'package:go_router/go_router.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';
import 'package:twelfth_mobile/common/components/bookmark/bookmarking.dart';
import 'package:twelfth_mobile/views/match/match_detail_view.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  late DateTime _focusedMonth;
  late DateTime _selectedDate;
  int _leagueTabIndex = 0;
  Timer? _autoRefreshTimer;
  final _searchController = TextEditingController();

  static final _searchBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: CustomColor.gray800),
    borderRadius: BorderRadius.circular(8),
  );

  static const String _liveHome = '강원FC';
  static const String _liveAway = '광주FC';
  static const String _liveTime = '65:31';
  static const String _liveScore = '2:1';

  static const List<_MockMatch> _mockMatches = [
    // K1 경기
    _MockMatch(homeTeam: '강원 FC', awayTeam: '광주 FC', time: '19:00', day: 5, league: 0, score: '2 : 1'),
    _MockMatch(homeTeam: 'FC 서울', awayTeam: '인천 유나이티드', time: '14:00', day: 8, league: 0, score: '3 : 2'),
    _MockMatch(homeTeam: '전북 현대', awayTeam: '포항 스틸러스', time: '16:30', day: 8, league: 0, score: '1 : 1'),
    _MockMatch(homeTeam: '울산 HD FC', awayTeam: '제주 유나이티드', time: '19:00', day: 21, league: 0),
    _MockMatch(homeTeam: '대전 하나 시티즌', awayTeam: '강원 FC', time: '19:00', day: 29, league: 0),
    // K2 경기
    _MockMatch(homeTeam: '김천 상무', awayTeam: '대전 하나 시티즌', time: '19:00', day: 5, league: 1, score: '0 : 0'),
    _MockMatch(homeTeam: '수원 삼성', awayTeam: '대구 FC', time: '14:00', day: 12, league: 1, score: '2 : 3'),
    _MockMatch(homeTeam: '광주 FC', awayTeam: '김천 상무', time: '16:30', day: 12, league: 1, score: '1 : 0'),
    _MockMatch(homeTeam: '부산 아이파크', awayTeam: '충남 아산', time: '14:00', day: 21, league: 1),
    _MockMatch(homeTeam: '서울 E-랜드', awayTeam: '경남 FC', time: '16:00', day: 29, league: 1),
  ];

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
    _searchController.dispose();
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
    await Future.delayed(const Duration(milliseconds: 500));
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
              child: CustomTextFormField(
                controller: _searchController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: '선수이름, 구단이름으로 검색',
                  fillColor: CustomColor.gray800,
                  enabledBorder: _searchBorder,
                  focusedBorder: _searchBorder,
                  prefixIcon: const Icon(
                    Symbols.search,
                    color: CustomColor.gray600,
                  ),
                ),
                onChanged: (_) => setState(() {}),
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
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isToday = _selectedDate == today;
    final isPast = _selectedDate.isBefore(today);
    final bookmarkedTeams = Bookmarking.instance.teams;

    bool _isFavoriteMatch(_MockMatch m) =>
        bookmarkedTeams.contains(m.homeTeam) ||
        bookmarkedTeams.contains(m.awayTeam);

    final filteredMatches = _mockMatches.where((match) {
      return match.league == _leagueTabIndex &&
          _selectedDate.year == _focusedMonth.year &&
          _selectedDate.month == _focusedMonth.month &&
          _selectedDate.day == match.day;
    }).toList()
      ..sort((a, b) {
        final aFav = _isFavoriteMatch(a) ? 0 : 1;
        final bFav = _isFavoriteMatch(b) ? 0 : 1;
        if (aFav != bFav) return aFav.compareTo(bFav);
        return a.homeTeam.compareTo(b.homeTeam);
      });

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: CustomColor.white,
      backgroundColor: CustomColor.gray900,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          if (isToday) ...[
            _LiveMatchCard(
              homeTeam: _liveHome,
              awayTeam: _liveAway,
              time: _liveTime,
              score: _liveScore,
              onTap: () => context.push(
                AppRoutes.match,
                extra: MatchExtra(
                  homeTeam: _liveHome,
                  awayTeam: _liveAway,
                  matchState: MatchState.live,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
          if (filteredMatches.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Text(
                  '해당 날짜에 경기가 없습니다',
                  style: CustomTextStyle.body2.copyWith(color: CustomColor.gray500),
                ),
              ),
            )
          else
            ...filteredMatches.map((match) {
              final matchState = isPast ? MatchState.finished : MatchState.upcoming;
              final centerWidget = isPast && match.score != null
                  ? Text(match.score!, style: CustomTextStyle.body2)
                  : Text(
                      match.time,
                      style: CustomTextStyle.body2.copyWith(color: CustomColor.gray500),
                    );

              return MatchCard(
                homeTeam: match.homeTeam,
                awayTeam: match.awayTeam,
                center: centerWidget,
                onTap: () => context.push(
                  AppRoutes.match,
                  extra: MatchExtra(
                    homeTeam: match.homeTeam,
                    awayTeam: match.awayTeam,
                    matchState: matchState,
                    matchDate: '${_selectedDate.month}/${_selectedDate.day}',
                    matchTime: match.time,
                  ),
                ),
              );
            }),
        ],
      ),
    );
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

class _LiveMatchCard extends StatelessWidget {
  const _LiveMatchCard({
    required this.homeTeam,
    required this.awayTeam,
    required this.time,
    required this.score,
    required this.onTap,
  });

  final String homeTeam;
  final String awayTeam;
  final String time;
  final String score;
  final VoidCallback onTap;

  static const _gap2 = SizedBox(height: 2);
  static const _gap8 = SizedBox(height: 8);
  static final _teamNameStyle = CustomTextStyle.heading3.copyWith(
    color: CustomColor.gray800,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: CustomColor.main,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const _TeamLogo(size: 70),
                _gap8,
                Text(homeTeam, style: _teamNameStyle),
              ],
            ),
            Column(
              children: [
                Text(
                  'Live',
                  style: CustomTextStyle.body2.copyWith(color: CustomColor.red),
                ),
                _gap2,
                Text(
                  time,
                  style: CustomTextStyle.body2.copyWith(
                    color: CustomColor.gray600,
                  ),
                ),
                _gap2,
                Text(
                  score,
                  style: CustomTextStyle.body2.copyWith(
                    color: CustomColor.gray800,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const _TeamLogo(size: 70),
                _gap8,
                Text(awayTeam, style: _teamNameStyle),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamLogo extends StatelessWidget {
  const _TeamLogo({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: CustomColor.gray900,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _MockMatch {
  final String homeTeam;
  final String awayTeam;
  final String time;
  final int day;
  final int league;
  final String? score;

  const _MockMatch({
    required this.homeTeam,
    required this.awayTeam,
    required this.time,
    required this.day,
    required this.league,
    this.score,
  });
}
