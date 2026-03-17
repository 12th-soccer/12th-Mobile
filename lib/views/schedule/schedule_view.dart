import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/common/components/match/match_card.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/components/text_form_field/text_form_field.dart';
import 'package:go_router/go_router.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';
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

  static const _gap2 = SizedBox(height: 2);
  static const _gap8 = SizedBox(height: 8);

  static final _liveTeamNameStyle =
      CustomTextStyle.heading3.copyWith(color: CustomColor.gray800);

  static final _searchBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: CustomColor.gray800),
    borderRadius: BorderRadius.circular(8),
  );

  static const String _liveHome = '강원FC';
  static const String _liveAway = '광주FC';
  static const String _liveTime = '65:31';
  static const String _liveScore = '2:1';

  static const List<_MockMatch> _mockMatches = [
    _MockMatch(homeTeam: '강원 FC', awayTeam: '광주 FC', time: '19:00', day: 5),
    _MockMatch(homeTeam: '김천 상무', awayTeam: '대전 하나 시티즌', time: '19:00', day: 5),
    _MockMatch(homeTeam: 'FC 서울', awayTeam: '인천 유나이티드', time: '14:00', day: 8),
    _MockMatch(homeTeam: '전북 현대', awayTeam: '포항 스틸러스', time: '16:30', day: 8),
    _MockMatch(
      homeTeam: '울산 HD FC',
      awayTeam: '제주 유나이티드',
      time: '19:00',
      day: 21,
    ),
    _MockMatch(homeTeam: '수원 삼성', awayTeam: '대구 FC', time: '14:00', day: 12),
    _MockMatch(homeTeam: '광주 FC', awayTeam: '김천 상무', time: '16:30', day: 12),
    _MockMatch(
      homeTeam: '대전 하나 시티즌',
      awayTeam: '강원 FC',
      time: '19:00',
      day: 29,
    ),
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

  void _prevMonth() => setState(
    () => _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1),
  );

  void _nextMonth() => setState(
    () => _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1),
  );

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
            _buildCalendar(),
            _buildLeagueTabs(),
            Expanded(child: _buildMatchList()),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    final year = _focusedMonth.year;
    final month = _focusedMonth.month;
    final firstWeekday = DateTime(year, month, 1).weekday % 7;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final prevMonthDays = DateTime(year, month, 0).day;

    const weekLabels = ['일', '월', '화', '수', '목', '금', '토'];

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
                  onTap: _prevMonth,
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
                  onTap: _nextMonth,
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
                child: SizedBox(
                  child: Center(
                    child: Text(
                      weekLabels[i],
                      style: CustomTextStyle.body3.copyWith(color: color),
                    ),
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
                    _selectedDate.year == date.year &&
                    _selectedDate.month == date.month &&
                    _selectedDate.day == date.day;

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
                    onTap: isCurrentMonth
                        ? () => setState(() => _selectedDate = date)
                        : null,
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

  Widget _buildLeagueTabs() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: CustomColor.gray900, width: 1),
        ),
      ),
      child: Row(
        children: List.generate(2, (index) {
          final isSelected = _leagueTabIndex == index;
          final label = ['K1', 'K2'][index];
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _leagueTabIndex = index),
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

  Widget _buildMatchList() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: CustomColor.white,
      backgroundColor: CustomColor.gray900,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          _buildLiveMatchCard(),
          const SizedBox(height: 8),
          ..._mockMatches.asMap().entries.expand((entry) sync* {
            yield _buildMatchItem(entry.value);
          }),
        ],
      ),
    );
  }

  Widget _buildLiveMatchCard() {
    return GestureDetector(
      onTap: () => context.push(
        AppRoutes.match,
        extra: MatchExtra(
          homeTeam: _liveHome,
          awayTeam: _liveAway,
          matchState: MatchState.live,
        ),
      ),
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
              _buildTeamLogo(size: 70),
              _gap8,
              Text(_liveHome, style: _liveTeamNameStyle),
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
                _liveTime,
                style: CustomTextStyle.body2.copyWith(
                  color: CustomColor.gray600,
                ),
              ),
              _gap2,
              Text(
                _liveScore,
                style: CustomTextStyle.body2.copyWith(
                  color: CustomColor.gray800,
                ),
              ),
            ],
          ),
          Column(
            children: [
              _buildTeamLogo(size: 70),
              _gap8,
              Text(_liveAway, style: _liveTeamNameStyle),
            ],
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildMatchItem(_MockMatch match) {
    return MatchCard(
      homeTeam: match.homeTeam,
      awayTeam: match.awayTeam,
      center: Text(
        match.time,
        style: CustomTextStyle.body2.copyWith(color: CustomColor.gray500),
      ),
      onTap: () => context.push(
        AppRoutes.match,
        extra: MatchExtra(
          homeTeam: match.homeTeam,
          awayTeam: match.awayTeam,
        ),
      ),
    );
  }

  Widget _buildTeamLogo({required double size}) {
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

  const _MockMatch({
    required this.homeTeam,
    required this.awayTeam,
    required this.time,
    required this.day,
  });
}
