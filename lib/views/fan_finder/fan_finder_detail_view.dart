import 'package:twelfth_mobile/core/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/core/extensions/snackbar_extension.dart';
import 'package:twelfth_mobile/core/network/api_client.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';
import 'package:twelfth_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:twelfth_mobile/features/recruitment/domain/entities/recruitment.dart';
import 'package:twelfth_mobile/features/recruitment/presentation/providers/recruitment_provider.dart';
import 'package:twelfth_mobile/views/fan_finder/fan_finder_constants.dart';

class FanFinderDetailView extends ConsumerStatefulWidget {
  final Recruitment recruitment;

  const FanFinderDetailView({super.key, required this.recruitment});

  @override
  ConsumerState<FanFinderDetailView> createState() =>
      _FanFinderDetailViewState();
}

class _FanFinderDetailViewState extends ConsumerState<FanFinderDetailView> {
  bool _isJoining = false;
  bool _didAutoNavigate = false;

  @override
  void initState() {
    super.initState();
    if (widget.recruitment.noticeId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _didAutoNavigate) return;
        _didAutoNavigate = true;
        context.push(AppRoutes.fanFinderChat, extra: widget.recruitment);
      });
    }
  }

  bool _isAlreadyJoined(ApiException e) {
    final raw = e.responseData?.toString().toLowerCase() ?? '';
    return raw.contains('already') || raw.contains('이미');
  }

  String _parse400Message(ApiException e) {
    final raw = e.responseData?.toString().toLowerCase() ?? '';
    if (raw.contains('full') || raw.contains('초과') || raw.contains('가득')) {
      return '모집 인원이 가득 찼습니다.';
    }
    if (raw.contains('closed') ||
        raw.contains('마감') ||
        raw.contains('expired')) {
      return '마감된 모집글입니다.';
    }
    return '참가 신청에 실패했습니다.';
  }

  String _formatDate(DateTime d) =>
      '${d.year}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}';

  Future<void> _handleJoin() async {
    final userInfo = ref.read(userInfoProvider).valueOrNull;
    if (userInfo == null || !userInfo.hasUsername) {
      if (!mounted) return;
      context.showErrorSnackBar('닉네임을 설정해야 해당 기능의 사용이 가능합니다.');
      return;
    }

    final id = widget.recruitment.id;
    if (id == null) return;

    setState(() => _isJoining = true);
    try {
      await joinRecruitment(ref, id);
      if (!mounted) return;
      ref.invalidate(recruitmentDetailProvider(id));
      ref.read(recruitmentListProvider.notifier).refresh();
      context.showSuccessSnackBar('참가 신청이 완료됐습니다.');
    } on ApiException catch (e) {
      if (!mounted) return;
      if ((e.statusCode == 400 && _isAlreadyJoined(e)) || e.statusCode == 403) {
        final detail = ref.read(recruitmentDetailProvider(id)).valueOrNull;
        final target = detail ?? widget.recruitment;
        context.push(AppRoutes.fanFinderChat, extra: target);
        return;
      }
      final msg = switch (e.statusCode) {
        400 => _parse400Message(e),
        404 => '모집글을 찾을 수 없습니다.',
        _ => '참가 신청에 실패했습니다.',
      };
      context.showErrorSnackBar(msg);
    } catch (_) {
      if (!mounted) return;
      context.showErrorSnackBar('참가 신청에 실패했습니다.');
    } finally {
      if (mounted) setState(() => _isJoining = false);
    }
  }

  void _enterNoticeRoom(Recruitment current) {
    context.push(AppRoutes.fanFinderChat, extra: current);
  }

  @override
  Widget build(BuildContext context) {
    final recruitment = widget.recruitment;
    final detailAsync = recruitment.id != null
        ? ref.watch(recruitmentDetailProvider(recruitment.id!))
        : null;
    final current = detailAsync?.valueOrNull ?? recruitment;

    if (current.noticeId != null && !_didAutoNavigate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _didAutoNavigate) return;
        _didAutoNavigate = true;
        context.push(AppRoutes.fanFinderChat, extra: current);
      });
    }

    final hasNotice = current.noticeId != null;

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
                borderRadius: AppRadius.lg,
              ),
              child: Text(
                current.teamDisplayName ?? current.teamCode ?? '',
                style: CustomTextStyle.body3.copyWith(
                  color: CustomColor.main,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            FanFinderConstants.spaceS,
            Text(current.title, style: CustomTextStyle.heading1),
            FanFinderConstants.spaceM,
            Text(current.content, style: CustomTextStyle.body1),
            FanFinderConstants.spaceLM,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: current.tags
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
                  current.currentParticipants != null
                      ? '${current.currentParticipants}/${current.headCount}명 참여 중'
                      : '최대 ${current.headCount}명',
                  style: CustomTextStyle.body2.copyWith(
                    color: current.isFull
                        ? CustomColor.main
                        : CustomColor.gray500,
                  ),
                ),
              ],
            ),
            if (current.expiryDate != null) ...[
              FanFinderConstants.spaceS,
              Text(
                '${_formatDate(current.expiryDate!)} 마감',
                style: CustomTextStyle.body3.copyWith(
                  color: CustomColor.gray500,
                ),
              ),
            ],
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                children: [
                  if (hasNotice) ...[
                    Text(
                      '그룹공지방이 열려 있습니다!',
                      style: CustomTextStyle.body3.copyWith(
                        color: CustomColor.main,
                      ),
                    ),
                    FanFinderConstants.spaceS,
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isJoining
                          ? null
                          : hasNotice
                          ? () => _enterNoticeRoom(current)
                          : _handleJoin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColor.main,
                        disabledBackgroundColor: CustomColor.main.withValues(
                          alpha: 0.5,
                        ),
                        padding: FanFinderConstants.buttonVerticalPadding,
                        shape: RoundedRectangleBorder(
                          borderRadius: FanFinderConstants.buttonRadius,
                        ),
                      ),
                      child: _isJoining
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: CustomColor.black,
                              ),
                            )
                          : Text(
                              hasNotice ? '공지방 입장' : '가입하기',
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
