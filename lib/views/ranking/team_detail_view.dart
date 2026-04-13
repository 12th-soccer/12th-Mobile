import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/common/components/app_bar/twelfth_app_bar.dart';
import 'package:twelfth_mobile/common/components/image/network_avatar.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/constants/team_social_links.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/constants/twelfth_assets.dart';
import 'package:twelfth_mobile/core/extensions/snackbar_extension.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';
import 'package:twelfth_mobile/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:twelfth_mobile/features/ranking/domain/entities/club_detail.dart';
import 'package:twelfth_mobile/features/ranking/presentation/providers/ranking_provider.dart';
import 'package:twelfth_mobile/views/match/match_detail_view.dart';
import 'package:twelfth_mobile/views/ranking/widget/team_detail_body.dart';
import 'package:url_launcher/url_launcher.dart';

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
              Symbols.star,
              color: isFavorite ? CustomColor.yellow : CustomColor.main,
              fill: isFavorite ? 1 : 0,
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
              const SizedBox(height: 16),
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
