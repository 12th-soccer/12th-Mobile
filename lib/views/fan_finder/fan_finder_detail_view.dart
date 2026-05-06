import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/common/components/snack_bar/custom_snack_bar.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/views/fan_finder/fan_finder_constants.dart';
import 'package:twelfth_mobile/views/fan_finder/model/fan_post.dart';

class FanFinderDetailView extends StatelessWidget {
  final FanPost post;

  const FanFinderDetailView({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final isFull = post.currentParticipants >= post.maxParticipants;

    return Scaffold(
      backgroundColor: CustomColor.background,
      appBar: AppBar(
        backgroundColor: CustomColor.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back_ios, color: CustomColor.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: FanFinderConstants.horizontalScreenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FanFinderConstants.spaceS,
            Text(
              post.title,
              style: CustomTextStyle.heading1,
            ),
            FanFinderConstants.spaceM,
            Text(
              post.content,
              style: CustomTextStyle.body1,
            ),
            FanFinderConstants.spaceLM,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: post.tags
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: CustomColor.gray600),
                        borderRadius: FanFinderConstants.tagChipRadius,
                      ),
                      child: Text(
                        tag,
                        style: CustomTextStyle.body2.copyWith(
                          color: CustomColor.gray500,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            FanFinderConstants.spaceM,
            Row(
              children: [
                const Icon(Symbols.group, color: CustomColor.main, size: 18),
                FanFinderConstants.spaceHXS,
                Text(
                  '${post.currentParticipants}명 참가 중 / 최대 ${post.maxParticipants}명',
                  style: CustomTextStyle.body2.copyWith(color: CustomColor.main),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                children: [
                  if (isFull)
                    Text(
                      '모집이 마감되었습니다',
                      style: CustomTextStyle.body2.copyWith(
                        color: CustomColor.gray600,
                      ),
                    ),
                  FanFinderConstants.spaceS,
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isFull ? null : () => _joinPost(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColor.main,
                        disabledBackgroundColor: CustomColor.gray800,
                        padding: FanFinderConstants.buttonVerticalPadding,
                        shape: RoundedRectangleBorder(
                          borderRadius: FanFinderConstants.buttonRadius,
                        ),
                      ),
                      child: Text(
                        isFull ? '마감' : '참가하기',
                        style: CustomTextStyle.heading2.copyWith(
                          color: isFull ? CustomColor.gray600 : CustomColor.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _joinPost(BuildContext context) {
    // TODO: 참가 API 호출
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar.error('참가 신청이 완료되었습니다!'),
    );
  }
}
