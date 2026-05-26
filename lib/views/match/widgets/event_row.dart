import 'package:twelfth_mobile/core/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twelfth_mobile/common/components/image/network_avatar.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/features/match/domain/entities/match_event.dart';
import 'package:twelfth_mobile/features/match/presentation/providers/match_provider.dart';

class EventRow extends ConsumerWidget {
  final MatchEvent event;
  final bool isHome;
  final String? teamImageUrl;
  final VoidCallback? onTap;

  const EventRow({
    super.key,
    required this.event,
    required this.isHome,
    this.teamImageUrl,
    this.onTap,
  });

  String get _minuteStr => "${event.eventMinute}'";

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final playerImageAsync = event.playerId != null
        ? ref.watch(playerImageProvider(event.playerId!))
        : null;

    final resolvedImageUrl = playerImageAsync?.valueOrNull;


    final photo = NetworkAvatar(imageUrl: resolvedImageUrl, size: 36);
    final name = Text(
      event.playerName,
      style: CustomTextStyle.body2.copyWith(),
      overflow: TextOverflow.ellipsis,
    );
    final time = Text(
      _minuteStr,
      style: CustomTextStyle.body2.copyWith(color: CustomColor.gray500),
    );
    final icon = _EventIcon(eventType: event.eventType);

    final row = isHome
        ? Row(
            children: [
              photo,
              AppSpacing.w10,
              Expanded(child: name),
              AppSpacing.w12,
              time,
              AppSpacing.w10,
              icon,
            ],
          )
        : Row(
            children: [
              icon,
              AppSpacing.w10,
              time,
              AppSpacing.w12,
              Expanded(
                child: Align(alignment: Alignment.centerRight, child: name),
              ),
              AppSpacing.w10,
              photo,
            ],
          );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: row,
      ),
    );
  }
}

class _EventIcon extends StatelessWidget {
  final MatchEventType eventType;

  const _EventIcon({required this.eventType});

  @override
  Widget build(BuildContext context) {
    switch (eventType) {
      case MatchEventType.goal:
        return const Text('⚽', style: TextStyle(fontSize: 18));
      case MatchEventType.yellowCard:
        return Container(
          width: 14,
          height: 18,
          decoration: BoxDecoration(
            color: CustomColor.yellow,
            borderRadius: AppRadius.xs,
          ),
        );
      case MatchEventType.redCard:
        return Container(
          width: 14,
          height: 18,
          decoration: BoxDecoration(
            color: CustomColor.red,
            borderRadius: AppRadius.xs,
          ),
        );
      case MatchEventType.subOut:
        return Text(
          'OUT',
          style: CustomTextStyle.body3.copyWith(
            color: CustomColor.red,
            fontWeight: FontWeight.w700,
          ),
        );
      case MatchEventType.subIn:
        return Text(
          'IN',
          style: CustomTextStyle.body3.copyWith(
            color: CustomColor.green,
            fontWeight: FontWeight.w700,
          ),
        );
      case MatchEventType.unknown:
        return const SizedBox(width: 20);
    }
  }
}
