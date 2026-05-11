import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/core/extensions/snackbar_extension.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';
import 'package:twelfth_mobile/features/recruitment/domain/entities/recruitment.dart';
import 'package:twelfth_mobile/views/fan_finder/fan_finder_constants.dart';
import 'package:twelfth_mobile/views/fan_finder/model/fan_post.dart';

class FanFinderDetailView extends StatelessWidget {
  final Recruitment recruitment;

  const FanFinderDetailView({super.key, required this.recruitment});

  void _joinRecruitment(BuildContext context) {
    // TODO: 참가 신청 API 호출
    // TODO: 참가 신청 API 호출
    context.showErrorSnackBar('참가 신청이 완료됐습니다.');
  }

  String _formatDate(DateTime d) =>
      '${d.year}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final fanPost = FanPost(
      id: recruitment.id ?? '',
      title: recruitment.title,
      content: recruitment.content,
      tags: recruitment.tags,
      createdAt: DateTime.now(),
      currentParticipants: 0,
      maxParticipants: recruitment.headCount,
      expiryDate: recruitment.expiryDate,
    );

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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: CustomColor.main.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                recruitment.teamGroup.displayTag,
                style: CustomTextStyle.body3.copyWith(
                  color: CustomColor.main,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            FanFinderConstants.spaceS,
            Text(recruitment.title, style: CustomTextStyle.heading1),
            FanFinderConstants.spaceM,
            Text(recruitment.content, style: CustomTextStyle.body1),
            FanFinderConstants.spaceLM,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: recruitment.tags
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
                  '최대 ${recruitment.headCount}명',
                  style: CustomTextStyle.body2.copyWith(
                    color: CustomColor.main,
                  ),
                ),
              ],
            ),
            if (recruitment.expiryDate != null) ...[
              FanFinderConstants.spaceS,
              Row(
                children: [
                  Text(
                    '${_formatDate(recruitment.expiryDate!)} 마감',
                    style: CustomTextStyle.body3.copyWith(
                      color: CustomColor.gray500,
                    ),
                  ),
                ],
              ),
            ],
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                children: [
                  if (recruitment.currentParticipants != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${recruitment.currentParticipants}/${recruitment.headCount}명 참여 중',
                          style: CustomTextStyle.body2.copyWith(
                            color: recruitment.isFull
                                ? CustomColor.main
                                : CustomColor.gray500,
                          ),
                        ),
                      ],
                    ),
                    if (recruitment.isFull) ...[
                      FanFinderConstants.spaceXS,
                      Text(
                        '인원이 모두 찼습니다! 채팅방이 열렸습니다.',
                        style: CustomTextStyle.body3.copyWith(
                          color: CustomColor.main,
                        ),
                      ),
                    ],
                    FanFinderConstants.spaceS,
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: recruitment.isFull
                          ? () => context.push(
                              AppRoutes.fanFinderChat,
                              extra: fanPost,
                            )
                          : () => _joinRecruitment(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColor.main,
                        padding: FanFinderConstants.buttonVerticalPadding,
                        shape: RoundedRectangleBorder(
                          borderRadius: FanFinderConstants.buttonRadius,
                        ),
                      ),
                      child: Text(
                        recruitment.isFull ? '채팅방 입장' : '신청',
                        style: CustomTextStyle.heading2.copyWith(
                          color: CustomColor.black,
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
}
