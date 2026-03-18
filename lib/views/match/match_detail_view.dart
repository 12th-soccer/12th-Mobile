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

  @override
  void initState() {
    super.initState();
    _currentState = widget.matchState;
  }

  static const _events = [
    _MatchEvent(
      playerName: '서진수',
      minute: 24,
      type: EventType.goal,
      isHome: true,
    ),
    _MatchEvent(
      playerName: '주앙 빅토르',
      minute: 31,
      type: EventType.goal,
      isHome: false,
    ),
    _MatchEvent(
      playerName: '하창래',
      minute: 32,
      type: EventType.yellowCard,
      isHome: true,
    ),
    _MatchEvent(
      playerName: '하창래',
      minute: 39,
      type: EventType.redCard,
      isHome: true,
    ),
    _MatchEvent(
      playerName: '강윤성',
      minute: 45,
      type: EventType.out,
      isHome: true,
    ),
    _MatchEvent(
      playerName: '김준범',
      minute: 45,
      type: EventType.inn,
      isHome: true,
    ),
    _MatchEvent(
      playerName: '디오고',
      minute: 57,
      type: EventType.out,
      isHome: false,
    ),
    _MatchEvent(
      playerName: '엄원상',
      minute: 57,
      type: EventType.inn,
      isHome: false,
    ),
  ];

  static const _homeFormation = [
    ['이창근'],
    ['안톤', '김현욱', '밥신', '박규현'],
    ['서영재', '디오고', '김봉수', '이명재'],
    ['서진수', '마사'],
  ];

  static const _awayFormation = [
    ['조현우'],
    ['류선수', '오선수', '서선수', '신선수'],
    ['권선수', '황선수', '안선수', '홍선수'],
    ['이승우', '전진우'],
  ];

  static const _homeBench = ['강윤성', '김준범', '박규현', '루빅속', '엄원상'];
  static const _awayBench = ['송범근', '신상은', '강윤성', '모따'];

  static const _halftimeMinute = 45;

  static const _vGap4 = SizedBox(height: 4);
  static const _vGap12 = SizedBox(height: 12);
  static const _vGap24 = SizedBox(height: 24);
  static const _hGap4 = SizedBox(width: 4);
  static const _hGap6 = SizedBox(width: 6);
  static const _hGap8 = SizedBox(width: 8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background,
      appBar: const TwelfthAppBar(title: '경기 상세'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildMatchHeader(),
            if (_currentState != MatchState.upcoming) ...[
              _buildEventList(),
              _vGap24,
              _buildField(),
              _vGap24,
              _buildBench(),
            ],
          ],
        ),
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
            Text('1 : 2', style: CustomTextStyle.heading1),
          ],
        );
      case MatchState.finished:
        return Text('2 : 1', style: CustomTextStyle.heading1);
      case MatchState.upcoming:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.matchDate != null)
              Text(
                widget.matchDate!,
                style: CustomTextStyle.body2.copyWith(
                  color: CustomColor.gray500,
                ),
              ),
            if (widget.matchDate != null) _vGap4,
            if (widget.matchTime != null)
              Text(widget.matchTime!, style: CustomTextStyle.heading1),
          ],
        );
    }
  }

  Widget _buildEventList() {
    final List<Widget> items = [];
    bool halftimeInserted = false;

    for (final event in _events) {
      if (!halftimeInserted && event.minute > _halftimeMinute) {
        items.add(_buildHalftimeDivider());
        halftimeInserted = true;
      }
      items.add(_buildEventItem(event));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(children: items),
    );
  }

  Widget _buildHalftimeDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(child: Text('하프타임', style: CustomTextStyle.body2)),
    );
  }

  Widget _buildEventItem(_MatchEvent event) {
    final avatar = Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: CustomColor.gray900,
        shape: BoxShape.circle,
      ),
    );
    final timeText = Text(
      "${event.minute}'",
      style: CustomTextStyle.body2.copyWith(color: CustomColor.gray600),
    );
    final nameText = Text(
      event.playerName,
      style: CustomTextStyle.body2,
      overflow: TextOverflow.ellipsis,
    );
    final icon = _buildEventIcon(event.type);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: event.isHome
            ? [
                const Spacer(),
                icon,
                _hGap6,
                timeText,
                _hGap4,
                nameText,
                _hGap8,
                avatar,
              ]
            : [
                avatar,
                _hGap8,
                nameText,
                _hGap4,
                timeText,
                _hGap6,
                icon,
                const Spacer(),
              ],
      ),
    );
  }

  Widget _buildEventIcon(EventType type) {
    switch (type) {
      case EventType.goal:
        return const Icon(
          Symbols.sports_soccer,
          color: CustomColor.white,
          size: 18,
        );
      case EventType.yellowCard:
        return Container(
          width: 12,
          height: 16,
          decoration: BoxDecoration(
            color: CustomColor.yellow,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      case EventType.redCard:
        return Container(
          width: 12,
          height: 16,
          decoration: BoxDecoration(
            color: CustomColor.red,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      case EventType.out:
        return Text('OUT', style: CustomTextStyle.body2);
      case EventType.inn:
        return Text('IN', style: CustomTextStyle.body2);
    }
  }

  Widget _buildField() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: CustomColor.gray800,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        child: Column(
          children: [
            ..._homeFormation.map(_buildFormationRow),
            _vGap12,
            Stack(
              alignment: Alignment.center,
              children: [
                Container(height: 1, color: CustomColor.white),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: CustomColor.white, width: 1),
                  ),
                ),
              ],
            ),
            _vGap12,
            ..._awayFormation.reversed.map(_buildFormationRow),
          ],
        ),
      ),
    );
  }

  Widget _buildBench() {
    final maxLen = _homeBench.length > _awayBench.length
        ? _homeBench.length
        : _awayBench.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(maxLen, (i) {
            final away = i < _awayBench.length ? _awayBench[i] : null;
            final home = i < _homeBench.length ? _homeBench[i] : null;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: away != null
                          ? _buildBenchPlayer(away)
                          : const SizedBox.shrink(),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: home != null
                          ? _buildBenchPlayer(home)
                          : const SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBenchPlayer(String name) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: CustomColor.gray900,
            shape: BoxShape.circle,
          ),
        ),
        _vGap4,
        Text(
          name,
          style: CustomTextStyle.body4,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildFormationRow(List<String> players) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: players.map(_buildPlayerBadge).toList(),
      ),
    );
  }

  Widget _buildPlayerBadge(String name) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: CustomColor.gray900,
            shape: BoxShape.circle,
          ),
        ),
        _vGap4,
        Text(name, style: CustomTextStyle.body4, textAlign: TextAlign.center),
      ],
    );
  }
}

enum EventType { goal, yellowCard, redCard, out, inn }

class _MatchEvent {
  final String playerName;
  final int minute;
  final EventType type;
  final bool isHome;

  const _MatchEvent({
    required this.playerName,
    required this.minute,
    required this.type,
    required this.isHome,
  });
}
