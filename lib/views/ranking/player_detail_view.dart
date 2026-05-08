import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/common/components/app_bar/twelfth_app_bar.dart';
import 'package:twelfth_mobile/common/components/image/network_avatar.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/extensions/snackbar_extension.dart';
import 'package:twelfth_mobile/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:twelfth_mobile/features/ranking/domain/entities/player_detail.dart';
import 'package:twelfth_mobile/features/ranking/domain/entities/player_goal.dart';
import 'package:twelfth_mobile/features/ranking/presentation/providers/ranking_provider.dart';

class PlayerDetailView extends ConsumerWidget {
  final int playerId;
  final String playerName;

  const PlayerDetailView({
    super.key,
    required this.playerId,
    required this.playerName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(playerDetailProvider(playerId));
    final goalsAsync = ref.watch(playerGoalsProvider(playerId));
    final favoritesAsync = ref.watch(favoritePlayersNotifierProvider);
    final isFavorite =
        favoritesAsync.valueOrNull?.any((p) => p.playerId == playerId) ?? false;

    return Scaffold(
      backgroundColor: CustomColor.background,
      appBar: TwelfthAppBar(
        title: '선수 상세',
        actions: [
          IconButton(
            icon: Icon(
              Symbols.star,
              color: isFavorite ? CustomColor.yellow : CustomColor.main,
              fill: isFavorite ? 1 : 0,
            ),
            onPressed: () async {
              try {
                await ref
                    .read(favoritePlayersNotifierProvider.notifier)
                    .toggleFavorite(playerId, playerName);
              } catch (_) {
                if (context.mounted) {
                  context.showErrorSnackBar('관심 선수 설정에 실패했습니다.');
                }
              }
            },
          ),
        ],
      ),
      body: detailAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: CustomColor.white),
        ),
        error: (e, _) => _buildBody(
          PlayerDetail(playerId: playerId, name: playerName),
          goalsAsync,
        ),
        data: (detail) => _buildBody(detail, goalsAsync),
      ),
    );
  }

  Widget _buildBody(
    PlayerDetail detail,
    AsyncValue<PlayerGoal?> goalsAsync,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: NetworkAvatar(imageUrl: detail.imageUrl, size: 100)),
            const SizedBox(height: 16),
            Center(child: Text(detail.name, style: CustomTextStyle.heading1)),
            const SizedBox(height: 24),
            _InfoGrid(detail: detail),
            const SizedBox(height: 32),
            _GoalsSection(goalsAsync: goalsAsync),
          ],
        ),
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  final PlayerDetail detail;

  static const _vGap20 = SizedBox(height: 20);

  const _InfoGrid({required this.detail});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              _InfoCell(label: '소속', value: detail.clubName),
              _vGap20,
              _InfoCell(label: '포지션', value: detail.position),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              _InfoCell(
                label: '나이',
                value: detail.age != null ? '${detail.age}세' : null,
              ),
              _vGap20,
              _InfoCell(label: '번호', value: detail.number?.toString()),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoCell extends StatelessWidget {
  final String label;
  final String? value;

  const _InfoCell({required this.label, this.value});

  @override
  Widget build(BuildContext context) {
    if (value == null) return const SizedBox.shrink();
    return Column(
      children: [
        Text(
          label,
          style: CustomTextStyle.body3.copyWith(color: CustomColor.gray500),
        ),
        const SizedBox(height: 4),
        Text(value!, style: CustomTextStyle.body1),
      ],
    );
  }
}

class _GoalsSection extends StatelessWidget {
  final AsyncValue<PlayerGoal?> goalsAsync;

  const _GoalsSection({required this.goalsAsync});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('골 기록', style: CustomTextStyle.heading2),
        const SizedBox(height: 16),
        goalsAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: CustomColor.white),
          ),
          error: (_, __) => Text(
            '골 기록이 없습니다',
            style: CustomTextStyle.body2.copyWith(color: CustomColor.gray500),
          ),
          data: (goal) {
            if (goal == null || goal.goalCount == 0) {
              return Text(
                '골 기록이 없습니다',
                style: CustomTextStyle.body2.copyWith(color: CustomColor.gray500),
              );
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${goal.season}시즌',
                  style: CustomTextStyle.body2.copyWith(color: CustomColor.gray500),
                ),
                Text(
                  '${goal.goalCount}골',
                  style: CustomTextStyle.body1,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
