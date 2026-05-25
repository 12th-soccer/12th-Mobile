import 'package:flutter/material.dart';
import 'package:twelfth_mobile/core/constants/spacing.dart';
import 'package:twelfth_mobile/common/components/image/network_avatar.dart';
import 'package:twelfth_mobile/constants/text_style.dart';

class MatchCard extends StatelessWidget {
  final String homeTeam;
  final String awayTeam;
  final String? homeLogoUrl;
  final String? awayLogoUrl;
  final Widget center;
  final double logoSize;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const MatchCard({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
    this.homeLogoUrl,
    this.awayLogoUrl,
    required this.center,
    this.logoSize = 40,
    this.padding = const EdgeInsets.all(20),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  NetworkAvatar(imageUrl: homeLogoUrl, size: logoSize),
                  AppSpacing.w8,
                  Expanded(
                    child: Text(
                      homeTeam,
                      style: CustomTextStyle.body2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: center,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      awayTeam,
                      style: CustomTextStyle.body2,
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  AppSpacing.w8,
                  NetworkAvatar(imageUrl: awayLogoUrl, size: logoSize),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

