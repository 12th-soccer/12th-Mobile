import 'package:twelfth_mobile/core/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/core/extensions/snackbar_extension.dart';
import 'package:twelfth_mobile/core/network/api_client.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';
import 'package:twelfth_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:twelfth_mobile/features/notice/presentation/providers/notice_provider.dart';
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

  bool _isAuthor(Recruitment recruitment) {
    final userInfo = ref.read(userInfoProvider).valueOrNull;

    if (userInfo == null || recruitment.authorId == null) {
      return false;
    }

    final isAuthor = userInfo.userId == recruitment.authorId;
    return isAuthor;
  }

  bool _isAuthorByError(ApiException e) {
    final msg = e.responseData?.toString().toLowerCase() ?? '';
    return msg.contains('작성자') || msg.contains('author') ||
           msg.contains('본인이 생성한') || msg.contains('자신이 만든');
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

  Future<bool> _recoverJoinSuccess(Recruitment current) async {
    final id = current.id;
    if (id == null) return false;

    try {
      ref.invalidate(recruitmentDetailProvider(id));
      final updated = await ref.read(recruitmentDetailProvider(id).future);
      ref.read(recruitmentListProvider.notifier).refresh();

      final before = current.currentParticipants ?? 0;
      final after = updated.currentParticipants ?? before;
      final joined = after > before;

      if (!mounted || !joined) return joined;

      if (updated.noticeId != null) {
        context.push(AppRoutes.fanFinderChat, extra: updated);
      } else {
        context.showSuccessSnackBar('참가 신청이 완료됐습니다.');
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _ensureNoticeAccess(Recruitment recruitment) async {
    final noticeId = recruitment.noticeId;
    if (noticeId == null) return false;

    setState(() => _isJoining = true);
    try {
      ref.invalidate(noticeProvider(noticeId));
      await ref.read(noticeProvider(noticeId).future);
      if (!mounted) return true;
      context.push(AppRoutes.fanFinderChat, extra: recruitment);
      return true;
    } on ApiException catch (e) {
      if (!mounted) return false;
      final msg = switch (e.statusCode) {
        400 => '해당 모집방에 참여한 사람만 공지방에 입장할 수 있습니다.',
        403 => '해당 모집방에 참여한 사람만 공지방에 입장할 수 있습니다.',
        404 => '공지방을 찾을 수 없습니다.',
        _ => '공지방 입장에 실패했습니다.',
      };
      context.showErrorSnackBar(msg);
      return false;
    } catch (_) {
      if (!mounted) return false;
      context.showErrorSnackBar('공지방 입장에 실패했습니다.');
      return false;
    } finally {
      if (mounted) setState(() => _isJoining = false);
    }
  }

  Future<void> _createNoticeRoom(Recruitment current) async {
    final userInfo = ref.read(userInfoProvider).valueOrNull;
    if (userInfo == null || !userInfo.hasUsername) {
      if (!mounted) return;
      context.showErrorSnackBar('닉네임을 설정해야 해당 기능의 사용이 가능합니다.');
      return;
    }

    final id = current.id;
    if (id == null) return;

    if (!current.isFull) {
      context.showErrorSnackBar('설정된 인원이 모두 모여야 공지방을 생성할 수 있습니다.');
      return;
    }

    final description = await _showDescriptionDialog();
    if (description == null || description.trim().isEmpty) return;

    setState(() => _isJoining = true);
    try {
      await createNoticeRoom(ref, id, description);

      if (!mounted) return;

      ref.invalidate(recruitmentDetailProvider(id));
      ref.read(recruitmentListProvider.notifier).refresh();

      final updatedRecruitment = await ref.read(recruitmentDetailProvider(id).future);

      if (!mounted) return;
      context.showSuccessSnackBar('공지방이 생성됐습니다.');

      if (updatedRecruitment.noticeId == null) {
        context.showErrorSnackBar('공지방이 생성되었지만 입장에 실패했습니다. 잠시 후 다시 시도해주세요.');
        return;
      }

      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      await _ensureNoticeAccess(updatedRecruitment);
    } on ApiException catch (e) {
      if (!mounted) return;
      final msg = switch (e.statusCode) {
        400 => '공지방은 최소 4명이 모여야 작성할 수 있습니다.',
        403 => '공지방은 모집글 작성자만 작성할 수 있습니다.',
        404 => '모집글을 찾을 수 없습니다.',
        _ => '공지방 생성에 실패했습니다.',
      };
      context.showErrorSnackBar(msg);
    } catch (_) {
      if (!mounted) return;
      context.showErrorSnackBar('공지방 생성에 실패했습니다.');
    } finally {
      if (mounted) setState(() => _isJoining = false);
    }
  }

  Future<void> _handleJoin(Recruitment current) async {
    final userInfo = ref.read(userInfoProvider).valueOrNull;
    if (userInfo == null || !userInfo.hasUsername) {
      if (!mounted) return;
      context.showErrorSnackBar('닉네임을 설정해야 해당 기능의 사용이 가능합니다.');
      return;
    }

    if (current.noticeId != null) {
      await _ensureNoticeAccess(current);
      return;
    }

    final id = current.id;
    if (id == null) return;

    setState(() => _isJoining = true);
    try {
      await joinRecruitment(ref, id);
      if (!mounted) return;
      try {
        ref.invalidate(recruitmentDetailProvider(id));
        await ref.read(recruitmentDetailProvider(id).future);
      } catch (_) {
      }
      ref.read(recruitmentListProvider.notifier).refresh();
      if (!mounted) return;
      context.showSuccessSnackBar('참가 신청이 완료됐습니다.');
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.statusCode == 400 && _isAlreadyJoined(e)) {
        final detail = ref.read(recruitmentDetailProvider(id)).valueOrNull;
        final target = detail ?? current;
        if (target.noticeId != null) {
          context.push(AppRoutes.fanFinderChat, extra: target);
        } else {
          context.showSuccessSnackBar('이미 참가한 모집글입니다.');
        }
        return;
      }
      if (e.statusCode == 403) {
        if (_isAuthorByError(e)) {
          context.showErrorSnackBar('본인이 생성한 글에는 가입을 할 수 없습니다.');
          return;
        }

        final recovered = await _recoverJoinSuccess(current);
        if (!mounted) return;
        if (recovered) return;
        context.showErrorSnackBar('해당 모집방에 참여한 사람만 공지방에 입장할 수 있습니다.');
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

  @override
  Widget build(BuildContext context) {
    final recruitment = widget.recruitment;
    final detailAsync = recruitment.id != null
        ? ref.watch(recruitmentDetailProvider(recruitment.id!))
        : null;
    final current = detailAsync?.valueOrNull ?? recruitment;

    final hasNotice = current.noticeId != null;
    final isAuthor = _isAuthor(current);
    final canShowJoinButton = !isAuthor && !current.isExpired;
    final canShowCreateNoticeButton = isAuthor && !hasNotice && current.isFull;

    return Scaffold(
      backgroundColor: CustomColor.background,
      appBar: AppBar(
        backgroundColor: CustomColor.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: CustomColor.white),
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
                const Icon(Icons.group, color: CustomColor.main, size: 18),
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
              padding: const EdgeInsets.only(bottom: 48),
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
                  if (canShowJoinButton) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isJoining ? null : () => _handleJoin(current),
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
                                '가입하기',
                                style: CustomTextStyle.heading2.copyWith(
                                  color: CustomColor.black,
                                ),
                              ),
                      ),
                    ),
                  ]
                  else if (canShowCreateNoticeButton) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isJoining ? null : () => _createNoticeRoom(current),
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
                                '공지방 생성하기',
                                style: CustomTextStyle.heading2.copyWith(
                                  color: CustomColor.black,
                                ),
                              ),
                      ),
                    ),
                  ]
                  else if (hasNotice) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isJoining ? null : () => _ensureNoticeAccess(current),
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
                                '공지방 입장',
                                style: CustomTextStyle.heading2.copyWith(
                                  color: CustomColor.black,
                                ),
                              ),
                      ),
                    ),
                  ]
                  else if (isAuthor && !current.isFull) ...[
                    Container(
                      width: double.infinity,
                      padding: FanFinderConstants.buttonVerticalPadding,
                      decoration: BoxDecoration(
                        color: CustomColor.gray600,
                        borderRadius: FanFinderConstants.buttonRadius,
                      ),
                      child: Text(
                        '인원이 모두 모이면 공지방을 생성할 수 있습니다',
                        style: CustomTextStyle.heading2.copyWith(
                          color: CustomColor.gray500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _showDescriptionDialog() async {
    final controller = TextEditingController();

    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: CustomColor.gray900,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: CustomColor.gray600,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                AppSpacing.h16,
                Text(
                  '공지방 생성',
                  style: CustomTextStyle.heading1,
                ),
                AppSpacing.h8,
                Text(
                  '공지방에서 사용할 설명을 입력해주세요.',
                  style: CustomTextStyle.body1.copyWith(color: CustomColor.gray500),
                ),
                AppSpacing.h16,
                TextField(
                  controller: controller,
                  maxLines: 4,
                  maxLength: 100,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: '예: 오늘 7시까지 모여주세요.',
                    hintStyle: CustomTextStyle.body2.copyWith(color: CustomColor.gray600),
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.md,
                      borderSide: BorderSide(color: CustomColor.gray600),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppRadius.md,
                      borderSide: BorderSide(color: CustomColor.gray600),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: AppRadius.md,
                      borderSide: BorderSide(color: CustomColor.main),
                    ),
                    fillColor: CustomColor.gray800,
                    filled: true,
                  ),
                  style: CustomTextStyle.body2.copyWith(color: CustomColor.white),
                ),
                AppSpacing.h20,
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.md,
                            side: BorderSide(color: CustomColor.gray600),
                          ),
                        ),
                        child: Text(
                          '취소',
                          style: CustomTextStyle.body1,
                        ),
                      ),
                    ),
                    AppSpacing.w12,
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final text = controller.text.trim();
                          if (text.isNotEmpty) {
                            Navigator.of(context).pop(text);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColor.main,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
                        ),
                        child: Text(
                          '생성',
                          style: CustomTextStyle.body1.copyWith(color: CustomColor.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
