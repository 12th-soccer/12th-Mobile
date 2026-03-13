import 'package:flutter/material.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';

class MatchList extends StatelessWidget {
  final String homeTeam;
  final String awayTeam;
  final Widget center;
  final double logoSize;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const MatchList({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
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
                  _TeamLogo(size: logoSize),
                  const SizedBox(width: 8),
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
                  const SizedBox(width: 8),
                  _TeamLogo(size: logoSize),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamLogo extends StatelessWidget {
  final double size;

  const _TeamLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: CustomColor.gray900,
        shape: BoxShape.circle,
      ),
    );
  }
}
