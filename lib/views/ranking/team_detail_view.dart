import 'package:twelfth_mobile/core/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twelfth_mobile/common/components/app_bar/twelfth_app_bar.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/extensions/snackbar_extension.dart';
import 'package:twelfth_mobile/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:twelfth_mobile/features/ranking/presentation/providers/ranking_provider.dart';
import 'package:twelfth_mobile/views/ranking/widget/team_detail_body.dart';

class TeamDetailView extends ConsumerWidget {
  final int clubId;
  final String teamName;

  const TeamDetailView({
    super.key,
    required this.clubId,
    required this.teamName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(clubDetailProvider(clubId));
    final isFavorite =
        ref
            .watch(favoritesNotifierProvider)
            .valueOrNull
            ?.any((c) => c.clubId == clubId) ??
        false;

    return Scaffold(
      backgroundColor: CustomColor.background,
      appBar: TwelfthAppBar(
        title: '구단 상세',
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              color: isFavorite ? CustomColor.yellow : CustomColor.main,
            ),
            onPressed: () async {
              try {
                await ref
                    .read(favoritesNotifierProvider.notifier)
                    .toggleFavorite(clubId, teamName);
              } catch (_) {
                if (context.mounted) {
                  context.showErrorSnackBar('관심 구단 설정에 실패했습니다.');
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
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '정보를 불러오지 못했습니다',
                style: CustomTextStyle.body2.copyWith(
                  color: CustomColor.gray500,
                ),
              ),
              AppSpacing.h16,
              GestureDetector(
                onTap: () => ref.invalidate(clubDetailProvider(clubId)),
                child: Text(
                  '다시 시도',
                  style: CustomTextStyle.body2.copyWith(
                    color: CustomColor.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        data: (detail) => TeamDetailBody(detail: detail),
      ),
    );
  }
}
