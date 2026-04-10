import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/common/components/app_bar/twelfth_app_bar.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/constants/team_social_links.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/constants/twelfth_assets.dart';
import 'package:twelfth_mobile/core/extensions/snackbar_extension.dart';
import 'package:twelfth_mobile/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:twelfth_mobile/features/ranking/domain/entities/club_detail.dart';
import 'package:twelfth_mobile/features/ranking/presentation/providers/ranking_provider.dart';
import 'package:url_launcher/url_launcher.dart';

const _vGap8 = SizedBox(height: 8);
const _hGap4 = SizedBox(width: 4);

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
    final favoritesAsync = ref.watch(favoritesNotifierProvider);
    final isFavorite =
        favoritesAsync.valueOrNull?.any((c) => c.clubId == clubId) ?? false;

    return Scaffold(
      backgroundColor: CustomColor.background,
      appBar: TwelfthAppBar(
        title: teamName,
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
                  context.showErrorSnackBar(
                    '관심 구단 설정에 실패했습니다.',
                  );
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
        data: (detail) => _buildBody(context, detail),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ClubDetail detail) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildTeamHeader(detail.stadiumName),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildSocialLinks() {
    final links = TeamSocials.of(teamName);
    if (links == null) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => _launchUrl(links.youtube),
          child: SvgPicture.asset(TwelfthAssets.youtube, width: 30, height: 30),
        ),
        const SizedBox(width: 50),
        GestureDetector(
          onTap: () => _launchUrl(links.instagram),
          child: SvgPicture.asset(
            TwelfthAssets.instagram,
            width: 30,
            height: 30,
          ),
        ),
      ],
    );
  }

  Widget _buildTeamHeader(String stadiumName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: CustomColor.gray900,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 16),
          Text(teamName, style: CustomTextStyle.heading1),
          _vGap8,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Symbols.location_on,
                size: 16,
                color: CustomColor.gray500,
                fill: 1,
              ),
              _hGap4,
              Text(
                stadiumName,
                style: CustomTextStyle.body3.copyWith(
                  color: CustomColor.gray500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          _buildSocialLinks(),
        ],
      ),
    );
  }
}
