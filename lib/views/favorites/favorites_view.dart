import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/common/components/bookmark/bookmarking.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:go_router/go_router.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  int _tabIndex = 0;
  static const spacing = SizedBox(width: 10);
  final List<String> _tabs = ['구단', '선수'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTabs(),
            Expanded(
              child: ListenableBuilder(
                listenable: Bookmarking.instance,
                builder: (context, _) =>
                    _tabIndex == 0 ? _buildTeamList() : _buildPlayerList(),
              ),
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

  Widget _buildTeamList() {
    final teams = Bookmarking.instance.teams.toList();
    if (teams.isEmpty) {
      return Center(
        child: Text('관심 등록한 구단이 없습니다.', style: CustomTextStyle.body2),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: teams.length,
      itemBuilder: (context, index) {
        final name = teams[index];
        return GestureDetector(
          onTap: () => context.push(AppRoutes.team, extra: name),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: CustomColor.gray900,
                    shape: BoxShape.circle,
                  ),
                ),
                spacing,
                Expanded(child: Text(name, style: CustomTextStyle.body1)),
                GestureDetector(
                  onTap: () => Bookmarking.instance.toggleTeam(name),
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
    );
  }

  Widget _buildPlayerList() {
    final players = Bookmarking.instance.players.toList();
    if (players.isEmpty) {
      return Center(
        child: Text('관심 등록한 선수가 없습니다.', style: CustomTextStyle.body2),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: players.length,
      itemBuilder: (context, index) {
        final name = players[index];
        return GestureDetector(
          onTap: () => context.push(AppRoutes.player, extra: name),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: CustomColor.gray900,
                    shape: BoxShape.circle,
                  ),
                ),
                spacing,
                Expanded(child: Text(name, style: CustomTextStyle.body1)),
                GestureDetector(
                  onTap: () => Bookmarking.instance.togglePlayer(name),
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
    );
  }
}
