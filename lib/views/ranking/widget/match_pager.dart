import 'package:twelfth_mobile/core/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:twelfth_mobile/features/ranking/domain/entities/club_detail.dart';
import 'package:twelfth_mobile/views/ranking/widget/history_match_row.dart';
import 'package:twelfth_mobile/views/ranking/widget/schedule_match_row.dart';
import 'package:twelfth_mobile/core/constants/color.dart';

class MatchPager extends StatefulWidget {
  final List<ClubMatch> matches;
  final String clubName;
  final bool isHistory;
  final void Function(ClubMatch) onTap;

  const MatchPager({
    super.key,
    required this.matches,
    required this.clubName,
    required this.isHistory,
    required this.onTap,
  });

  @override
  State<MatchPager> createState() => MatchPagerState();
}

class MatchPagerState extends State<MatchPager> {
  late final PageController _controller;
  int _currentPage = 0;

  static const int _perPage = 3;
  static const double _scheduleRowH = 56.0;
  static const double _historyRowH = 80.0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get _totalPages =>
      (widget.matches.length / _perPage).ceil().clamp(1, 9999);

  int get _activeDotZone {
    if (_currentPage == 0) return 0;
    if (_currentPage >= _totalPages - 1) return 2;
    return 1;
  }

  void _animateTo(int page) => _controller.animateToPage(
    page,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
  );

  @override
  Widget build(BuildContext context) {
    final rowH = widget.isHistory ? _historyRowH : _scheduleRowH;
    final pagerH = rowH * _perPage;

    return Column(
      children: [
        SizedBox(
          height: pagerH,
          child: PageView.builder(
            controller: _controller,
            itemCount: _totalPages,
            onPageChanged: (p) => setState(() => _currentPage = p),
            itemBuilder: (_, pageIndex) {
              final start = pageIndex * _perPage;
              final end = (start + _perPage).clamp(0, widget.matches.length);
              final items = widget.matches.sublist(start, end);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: items
                    .map(
                      (m) => SizedBox(
                        height: rowH,
                        child: widget.isHistory
                            ? HistoryMatchRow(
                                match: m,
                                clubName: widget.clubName,
                                onTap: () => widget.onTap(m),
                              )
                            : ScheduleMatchRow(
                                match: m,
                                clubName: widget.clubName,
                                onTap: () => widget.onTap(m),
                              ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ),
        if (_totalPages > 1) ...[
          AppSpacing.h12,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) {
              final isActive = i == _activeDotZone;
              return GestureDetector(
                onTap: () {
                  if (i == 0) {
                    _animateTo(0);
                  } else if (i == 2) {
                    _animateTo(_totalPages - 1);
                  } else {
                    _animateTo((_totalPages / 2).floor());
                  }
                },
                child: Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive ? CustomColor.main : CustomColor.gray600,
                  ),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}
