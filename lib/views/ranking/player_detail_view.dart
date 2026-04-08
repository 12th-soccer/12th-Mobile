import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/common/components/app_bar/twelfth_app_bar.dart';
import 'package:twelfth_mobile/common/components/bookmark/bookmarking.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';

class PlayerDetailView extends StatelessWidget {
  final String playerName;
  static const spacing = SizedBox(height: 20);

  const PlayerDetailView({super.key, required this.playerName});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Bookmarking.instance,
      builder: (context, _) {
        final isBookmarked = Bookmarking.instance.isPlayerBookmarked(playerName);
        return Scaffold(
          backgroundColor: CustomColor.background,
          appBar: TwelfthAppBar(
            title: '선수 상세',
            actions: [
              IconButton(
                icon: Icon(
                  Symbols.star,
                  color: isBookmarked ? CustomColor.yellow : CustomColor.main,
                  fill: isBookmarked ? 1 : 0,
                ),
                onPressed: () => Bookmarking.instance.togglePlayer(playerName),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: _buildPlayerHeader(),
          ),
        );
      },
    );
  }

  Widget _buildPlayerHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        children: [
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: CustomColor.gray900,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(child: Text(playerName, style: CustomTextStyle.heading1)),
        ],
      ),
    );
  }
}
