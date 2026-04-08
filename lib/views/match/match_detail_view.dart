import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/common/components/app_bar/twelfth_app_bar.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';

enum MatchState { upcoming, live, finished }

class MatchExtra {
  final String homeTeam;
  final String awayTeam;
  final MatchState matchState;
  final String? matchDate;
  final String? matchTime;

  const MatchExtra({
    required this.homeTeam,
    required this.awayTeam,
    this.matchState = MatchState.upcoming,
    this.matchDate,
    this.matchTime,
  });
}

class MatchDetailView extends StatefulWidget {
  final String homeTeam;
  final String awayTeam;
  final MatchState matchState;
  final String? matchDate;
  final String? matchTime;

  const MatchDetailView({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
    this.matchState = MatchState.upcoming,
    this.matchDate,
    this.matchTime,
  });

  @override
  State<MatchDetailView> createState() => _MatchDetailViewState();
}

class _MatchDetailViewState extends State<MatchDetailView> {
  late MatchState _currentState;

  static const _vGap4 = SizedBox(height: 4);

  @override
  void initState() {
    super.initState();
    _currentState = widget.matchState;
  }

  @override
  void didUpdateWidget(covariant MatchDetailView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.matchState != widget.matchState) {
      _currentState = widget.matchState;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background,
      appBar: const TwelfthAppBar(title: '경기 상세'),
      body: SingleChildScrollView(
        child: _buildMatchHeader(),
      ),
    );
  }

  Widget _buildMatchHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTeamColumn(widget.awayTeam),
          _buildCenterSection(),
          _buildTeamColumn(widget.homeTeam),
        ],
      ),
    );
  }

  Widget _buildTeamColumn(String name) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: const BoxDecoration(
            color: CustomColor.gray900,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 10),
        Text(name, style: CustomTextStyle.body2),
      ],
    );
  }

  Widget _buildCenterSection() {
    switch (_currentState) {
      case MatchState.live:
        return Column(
          children: [
            Text(
              'Live',
              style: CustomTextStyle.body2.copyWith(color: CustomColor.green),
            ),
            _vGap4,
            Text('-  :  -', style: CustomTextStyle.heading1),
          ],
        );
      case MatchState.finished:
        return Text('-  :  -', style: CustomTextStyle.heading1);
      case MatchState.upcoming:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.matchDate != null)
              Text(
                widget.matchDate!,
                style: CustomTextStyle.body2.copyWith(color: CustomColor.gray500),
              ),
            if (widget.matchDate != null) _vGap4,
            if (widget.matchTime != null)
              Text(widget.matchTime!, style: CustomTextStyle.heading1),
          ],
        );
    }
  }
}
