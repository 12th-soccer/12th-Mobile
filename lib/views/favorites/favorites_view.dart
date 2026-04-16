import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/common/components/image/network_avatar.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/core/router/player_route_args.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';
import 'package:twelfth_mobile/core/router/team_route_args.dart';
import 'package:twelfth_mobile/features/favorites/domain/entities/favorite_club.dart';
import 'package:twelfth_mobile/features/favorites/domain/entities/favorite_player.dart';
import 'package:twelfth_mobile/features/favorites/presentation/providers/favorites_provider.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  ConsumerState<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends ConsumerState<FavoritesView> {
  int _tabIndex = 0;
  final List<String> _tabs = ['구단', '선수'];

  static const _horizontalSpacing = SizedBox(width: 10);

  static const _itemPadding = EdgeInsets.all(16);
  static const _listPadding = EdgeInsets.symmetric(vertical: 8);

  TextStyle get _emptyTextStyle => CustomTextStyle.body1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTabs(),
            Expanded(
              child: _tabIndex == 0 ? _buildTeamTab() : _buildPlayerTab(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: CustomColor.gray900, width: 1),
        ),
      ),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = _tabIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _tabIndex = index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
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
                    _tabs[index],
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

  Widget _buildTeamTab() {
    final favoritesAsync = ref.watch(favoritesNotifierProvider);
    return favoritesAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: CustomColor.white),
      ),
      error: (e, _) => _buildError(
        '관심 구단을 불러오지 못했습니다',
        onRetry: () => ref.read(favoritesNotifierProvider.notifier).refresh(),
      ),
      data: (clubs) => _buildTeamList(clubs),
    );
  }

  Widget _buildTeamList(List<FavoriteClub> clubs) {
    if (clubs.isEmpty) {
      return Center(
        child: Text('관심 등록한 구단이 없습니다.', style: CustomTextStyle.body2),
      );
    }
    return RefreshIndicator(
      onRefresh: () => ref.read(favoritesNotifierProvider.notifier).refresh(),
      color: CustomColor.white,
      backgroundColor: CustomColor.gray900,
      child: ListView.builder(
        padding: _listPadding,
        itemCount: clubs.length,
        itemBuilder: (context, index) {
          final club = clubs[index];
          return GestureDetector(
            onTap: () {
              developer.log(
                '[TeamTap][Favorites] clubId=${club.clubId} clubName=${club.clubName}',
              );
              context.push(
                AppRoutes.team,
                extra: TeamRouteArgs(
                  clubId: club.clubId,
                  teamName: club.clubName,
                ),
              );
            },
            child: Padding(
              padding: _itemPadding,
              child: Row(
                children: [
                  NetworkAvatar(imageUrl: club.imageUrl, size: 36),
                  _horizontalSpacing,
                  Expanded(child: Text(club.clubName, style: _emptyTextStyle)),
                  GestureDetector(
                    onTap: () => ref
                        .read(favoritesNotifierProvider.notifier)
                        .toggleFavorite(club.clubId, club.clubName),
                    child: const Icon(
                      Symbols.star,
                      color: CustomColor.yellow,
                      fill: 1.0,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlayerTab() {
    final favoritesAsync = ref.watch(favoritePlayersNotifierProvider);
    return favoritesAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: CustomColor.white),
      ),
      error: (e, _) => _buildError(
        '관심 선수를 불러오지 못했습니다',
        onRetry: () =>
            ref.read(favoritePlayersNotifierProvider.notifier).refresh(),
      ),
      data: (players) => _buildPlayerList(players),
    );
  }

  Widget _buildPlayerList(List<FavoritePlayer> players) {
    if (players.isEmpty) {
      return Center(
        child: Text('관심 등록한 선수가 없습니다.', style: CustomTextStyle.body2),
      );
    }
    return RefreshIndicator(
      onRefresh: () =>
          ref.read(favoritePlayersNotifierProvider.notifier).refresh(),
      color: CustomColor.white,
      backgroundColor: CustomColor.gray900,
      child: ListView.builder(
        padding: _listPadding,
        itemCount: players.length,
        itemBuilder: (context, index) {
          final player = players[index];
          return GestureDetector(
            onTap: () => context.push(
              AppRoutes.player,
              extra: PlayerRouteArgs(
                playerId: player.playerId,
                playerName: player.playerName,
              ),
            ),
            child: Padding(
              padding: _itemPadding,
              child: Row(
                children: [
                  NetworkAvatar(imageUrl: player.imageUrl, size: 36),
                  _horizontalSpacing,
                  Expanded(
                    child: Text(player.playerName, style: _emptyTextStyle),
                  ),
                  GestureDetector(
                    onTap: () => ref
                        .read(favoritePlayersNotifierProvider.notifier)
                        .toggleFavorite(player.playerId, player.playerName),
                    child: const Icon(
                      Symbols.star,
                      color: CustomColor.yellow,
                      fill: 1,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildError(String message, {required VoidCallback onRetry}) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: CustomTextStyle.body2.copyWith(color: CustomColor.gray500),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onRetry,
            child: Text(
              '다시 시도',
              style: CustomTextStyle.body2.copyWith(color: CustomColor.white),
            ),
          ),
        ],
      ),
    );
  }
}
