import 'package:flutter/material.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/views/fan_finder/fan_finder_constants.dart';
import 'package:twelfth_mobile/views/fan_finder/model/fan_post.dart';

class FanPostCard extends StatelessWidget {
  final FanPost post;
  final VoidCallback onTap;

  const FanPostCard({super.key, required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: FanFinderConstants.cardMargin,
        padding: FanFinderConstants.cardPadding,
        decoration: BoxDecoration(
          color: CustomColor.gray800,
          borderRadius: FanFinderConstants.cardRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: CustomTextStyle.heading2,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            FanFinderConstants.spaceXS,
            Text(
              post.content,
              style: CustomTextStyle.body1.copyWith(color: CustomColor.gray500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: post.tags
                        .map((tag) => _TagChip(label: tag))
                        .toList(),
                  ),
                ),
                FanFinderConstants.spaceHS,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: CustomColor.gray900,
                    borderRadius: FanFinderConstants.participantChipRadius,
                  ),
                  child: Text(
                    '${post.currentParticipants}/${post.maxParticipants}',
                    style: CustomTextStyle.body2.copyWith(
                      color: CustomColor.main,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;

  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: CustomColor.gray600),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: CustomTextStyle.body2.copyWith(color: CustomColor.gray500),
      ),
    );
  }
}
