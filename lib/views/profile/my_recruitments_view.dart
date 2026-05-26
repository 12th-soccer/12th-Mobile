import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/core/constants/spacing.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';
import 'package:twelfth_mobile/features/recruitment/domain/entities/joined_recruitment.dart';
import 'package:twelfth_mobile/features/recruitment/presentation/providers/recruitment_provider.dart';

final myJoinedRecruitmentsProvider = FutureProvider<List<JoinedRecruitment>>((ref) async {
  final repository = ref.read(recruitmentRepositoryProvider);
  final joinedRecruitments = await repository.getMyJoinedRecruitments();

  final sortedList = [...joinedRecruitments];
  sortedList.sort((a, b) => a.expiredAt.compareTo(b.expiredAt));

  return sortedList;
});

class MyRecruitmentsView extends ConsumerWidget {
  const MyRecruitmentsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myJoinedRecruitmentsAsync = ref.watch(myJoinedRecruitmentsProvider);

    return Scaffold(
      backgroundColor: CustomColor.background,
      appBar: AppBar(
        backgroundColor: CustomColor.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: CustomColor.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '모임 모아보기',
          style: CustomTextStyle.heading2.copyWith(color: CustomColor.white),
        ),
      ),
      body: myJoinedRecruitmentsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: CustomColor.white),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '모임을 불러오지 못했습니다.',
                style: CustomTextStyle.body2.copyWith(color: CustomColor.gray500),
              ),
              AppSpacing.h12,
              GestureDetector(
                onTap: () => ref.invalidate(myJoinedRecruitmentsProvider),
                child: Text(
                  '다시 시도',
                  style: CustomTextStyle.body2.copyWith(color: CustomColor.white),
                ),
              ),
            ],
          ),
        ),
        data: (joinedRecruitments) {
          if (joinedRecruitments.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  '참여한 모임이 없습니다',
                  style: CustomTextStyle.body1.copyWith(color: CustomColor.gray500),
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 48),
            itemCount: joinedRecruitments.length,
            itemBuilder: (context, index) {
              final joinedRecruitment = joinedRecruitments[index];
              return _MyJoinedRecruitmentItem(
                joinedRecruitment: joinedRecruitment,
                onTap: () async {
                  try {
                    final repository = ref.read(recruitmentRepositoryProvider);
                    final recruitment = await repository.getRecruitmentDetail(
                      joinedRecruitment.recruitmentId.toString(),
                    );
                    if (context.mounted) {
                      context.push(
                        AppRoutes.fanFinderDetail,
                        extra: recruitment,
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('모집글을 불러올 수 없습니다.'),
                          backgroundColor: CustomColor.red,
                        ),
                      );
                    }
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _MyJoinedRecruitmentItem extends StatelessWidget {
  final JoinedRecruitment joinedRecruitment;
  final VoidCallback onTap;

  const _MyJoinedRecruitmentItem({
    required this.joinedRecruitment,
    required this.onTap,
  });

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }

  String _getDaysLeft(DateTime expiredAt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final expiry = DateTime(expiredAt.year, expiredAt.month, expiredAt.day);

    final difference = expiry.difference(today).inDays;

    if (difference < 0) return '마감됨';
    if (difference == 0) return '오늘 마감';
    return 'D-$difference';
  }

  @override
  Widget build(BuildContext context) {
    final daysLeft = _getDaysLeft(joinedRecruitment.expiredAt);
    final isExpired = joinedRecruitment.isExpired;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isExpired ? CustomColor.gray800.withValues(alpha: 0.5) : CustomColor.gray800,
          borderRadius: AppRadius.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: CustomColor.main.withValues(alpha: 0.15),
                    borderRadius: AppRadius.sm,
                  ),
                  child: Text(
                    joinedRecruitment.k1Group ?? joinedRecruitment.k2Group ?? '전체',
                    style: CustomTextStyle.body3.copyWith(
                      color: CustomColor.main,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                if (daysLeft.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isExpired
                          ? CustomColor.gray600
                          : daysLeft == '오늘 마감'
                              ? CustomColor.red.withValues(alpha: 0.15)
                              : CustomColor.gray600,
                      borderRadius: AppRadius.sm,
                    ),
                    child: Text(
                      daysLeft,
                      style: CustomTextStyle.body3.copyWith(
                        color: isExpired
                            ? CustomColor.gray500
                            : daysLeft == '오늘 마감'
                                ? CustomColor.red
                                : CustomColor.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            AppSpacing.h16,
            Text(
              joinedRecruitment.title,
              style: CustomTextStyle.body1.copyWith(
                color: isExpired ? CustomColor.gray500 : CustomColor.white,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            AppSpacing.h12,
            Text(
              joinedRecruitment.content,
              style: CustomTextStyle.body2.copyWith(
                color: isExpired ? CustomColor.gray500 : CustomColor.gray500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            AppSpacing.h16,
            Row(
              children: [
                Icon(
                  Icons.group,
                  color: isExpired ? CustomColor.gray500 : CustomColor.gray500,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${joinedRecruitment.currentParticipants}/${joinedRecruitment.headCount}명',
                  style: CustomTextStyle.body3.copyWith(
                    color: isExpired ? CustomColor.gray500 : CustomColor.gray500,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.schedule,
                  color: isExpired ? CustomColor.gray500 : CustomColor.gray500,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatDate(joinedRecruitment.expiredAt),
                  style: CustomTextStyle.body3.copyWith(
                    color: isExpired ? CustomColor.gray500 : CustomColor.gray500,
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