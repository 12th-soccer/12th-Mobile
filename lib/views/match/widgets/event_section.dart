import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/features/match/domain/entities/match_event.dart';
import 'package:twelfth_mobile/views/match/widgets/event_row.dart';

class EventsSection extends StatelessWidget {
  final AsyncValue<List<MatchEvent>> eventsAsync;
  final int? homeTeamId;
  final int? awayTeamId;
  final void Function(MatchEvent event)? onPlayerTap;

  const EventsSection({
    super.key,
    required this.eventsAsync,
    this.homeTeamId,
    this.awayTeamId,
    this.onPlayerTap,
  });

  bool _resolveIsHome(MatchEvent event) {
    if (homeTeamId != null && event.clubId == homeTeamId) return true;
    if (awayTeamId != null && event.clubId == awayTeamId) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return eventsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: CircularProgressIndicator(color: CustomColor.white),
        ),
      ),
      error: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Text(
          '이벤트 정보를 불러오지 못했습니다',
          style: CustomTextStyle.body2.copyWith(color: CustomColor.gray500),
        ),
      ),
      data: (events) {
        if (events.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Text(
              '이벤트 정보가 없습니다',
              style: CustomTextStyle.body2.copyWith(color: CustomColor.gray500),
            ),
          );
        }

        final sorted = [...events]
          ..sort((a, b) => a.eventMinute.compareTo(b.eventMinute));

        final widgets = <Widget>[];
        bool halfTimeInserted = false;

        for (final event in sorted) {
          if (!halfTimeInserted && event.eventMinute > 45) {
            widgets.add(const _HalfTimeDivider());
            halfTimeInserted = true;
          }
          widgets.add(
            EventRow(
              event: event,
              isHome: _resolveIsHome(event),
              onTap: event.playerName.trim().isNotEmpty
                  ? () => onPlayerTap?.call(event)
                  : null,
            ),
          );
        }

        return Column(children: widgets);
      },
    );
  }
}

class _HalfTimeDivider extends StatelessWidget {
  const _HalfTimeDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(
        children: [
          const Expanded(
            child: Divider(color: CustomColor.gray900, thickness: 1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '하프타임',
              style: CustomTextStyle.body3.copyWith(color: CustomColor.gray500),
            ),
          ),
          const Expanded(
            child: Divider(color: CustomColor.gray900, thickness: 1),
          ),
        ],
      ),
    );
  }
}
