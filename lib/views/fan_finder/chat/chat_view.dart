import 'package:twelfth_mobile/core/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/core/extensions/snackbar_extension.dart';
import 'package:twelfth_mobile/core/network/api_client.dart';
import 'package:twelfth_mobile/features/comment/domain/entities/comment.dart';
import 'package:twelfth_mobile/features/comment/presentation/providers/comment_provider.dart';
import 'package:twelfth_mobile/features/notice/domain/entities/notice.dart';
import 'package:twelfth_mobile/features/notice/presentation/providers/notice_provider.dart';
import 'package:twelfth_mobile/features/recruitment/domain/entities/recruitment.dart';

class ChatView extends ConsumerStatefulWidget {
  final Recruitment recruitment;

  const ChatView({super.key, required this.recruitment});

  @override
  ConsumerState<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {
  final _commentController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSubmitting = false;

  String? get _noticeId => widget.recruitment.noticeId;

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _submitComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty || _isSubmitting || _noticeId == null) return;

    setState(() => _isSubmitting = true);
    try {
      await ref.read(commentListProvider(_noticeId!).notifier).submit(text);
      _commentController.clear();
      _scrollToBottom();
    } on ApiException catch (e) {
      if (!mounted) return;
      final msg = switch (e.statusCode) {
        403 => '해당 모집방에 참여한 사람만 댓글을 작성할 수 있습니다.',
        404 => '공지방을 찾을 수 없습니다.',
        _ => '댓글 작성에 실패했습니다.',
      };
      context.showErrorSnackBar(msg);
    } catch (_) {
      if (!mounted) return;
      context.showErrorSnackBar('댓글 작성에 실패했습니다.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatDate(DateTime d) =>
      '${d.year}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')} '
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background,
      appBar: AppBar(
        backgroundColor: CustomColor.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back_ios, color: CustomColor.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '그룹공지방',
          style: CustomTextStyle.body1.copyWith(
            color: CustomColor.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          const Divider(color: CustomColor.gray800, height: 1),
          Expanded(child: _buildBody()),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_noticeId == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Symbols.hourglass_empty, color: CustomColor.gray500, size: 40),
              AppSpacing.h16,
              Text(
                '아직 공지방이 생성되지 않았습니다.',
                style: CustomTextStyle.body1.copyWith(color: CustomColor.white),
                textAlign: TextAlign.center,
              ),
              AppSpacing.h8,
              Text(
                '인원이 모두 모이면 모임장이 공지방을 만들어요.',
                style: CustomTextStyle.body2.copyWith(color: CustomColor.gray500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final noticeAsync = ref.watch(noticeProvider(_noticeId!));
    final commentsAsync = ref.watch(commentListProvider(_noticeId!));

    return noticeAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: CustomColor.main),
      ),
      error: (e, _) {
        final msg = e is ApiException && e.statusCode == 403
            ? '해당 모집방에 참여한 사람만 조회할 수 있습니다.'
            : '공지방 정보를 불러오지 못했습니다.';
        return Center(
          child: Text(
            msg,
            style: CustomTextStyle.body2.copyWith(color: CustomColor.gray500),
          ),
        );
      },
      data: (notice) => ListView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          _buildNoticeCard(notice),
          AppSpacing.h24,
          _buildCommentSection(commentsAsync),
        ],
      ),
    );
  }

  Widget _buildNoticeCard(Notice notice) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CustomColor.gray900,
        borderRadius: AppRadius.md,
        border: Border.all(color: CustomColor.gray800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Symbols.campaign, color: CustomColor.main, size: 18),
              AppSpacing.w8,
              Text(
                '모임',
                style: CustomTextStyle.body3.copyWith(
                  color: CustomColor.main,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          AppSpacing.h12,
          Text('[${notice.title}]', style: CustomTextStyle.heading2),
          AppSpacing.h8,
          Text(
            '참여자 ${notice.headCount}명',
            style: CustomTextStyle.body3.copyWith(color: CustomColor.gray500),
          ),
          if (notice.description.isNotEmpty) ...[
            AppSpacing.h12,
            const Divider(color: CustomColor.gray800),
            AppSpacing.h12,
            Text(
              '모임 공지:',
              style: CustomTextStyle.body3.copyWith(
                color: CustomColor.main,
                fontWeight: FontWeight.w600,
              ),
            ),
            AppSpacing.h4,
            Text(
              notice.description,
              style: CustomTextStyle.body2.copyWith(height: 1.5),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCommentSection(AsyncValue<List<Comment>> commentsAsync) {
    return commentsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: CustomColor.main),
      ),
      error: (_, __) => Text(
        '댓글을 불러오지 못했습니다.',
        style: CustomTextStyle.body3.copyWith(color: CustomColor.gray500),
      ),
      data: (comments) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '댓글 ${comments.length}',
            style: CustomTextStyle.body2.copyWith(
              color: CustomColor.gray500,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.h8,
          if (comments.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  '첫 댓글을 남겨보세요!',
                  style: CustomTextStyle.body3.copyWith(
                    color: CustomColor.gray600,
                  ),
                ),
              ),
            )
          else
            ...comments.map(_buildCommentItem),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Comment comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: CustomColor.gray800,
            child: Text(
              comment.username.isNotEmpty ? comment.username[0] : '?',
              style: const TextStyle(
                color: CustomColor.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          AppSpacing.w10,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.username,
                      style: CustomTextStyle.body3.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    AppSpacing.w8,
                    Text(
                      _formatDate(comment.createdAt),
                      style: CustomTextStyle.body3.copyWith(
                        color: CustomColor.gray600,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                AppSpacing.h4,
                Text(
                  comment.content,
                  style: CustomTextStyle.body2.copyWith(
                    color: CustomColor.gray500,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    final noticeId = _noticeId;
    final noticeAsync = noticeId != null ? ref.watch(noticeProvider(noticeId)) : null;
    final canWrite = noticeId != null && (noticeAsync?.hasValue ?? false);
    final hintText = switch ((noticeId, noticeAsync)) {
      (null, _) => '공지방 정보 없음',
      (_, AsyncLoading()) => '공지방 확인 중...',
      (_, AsyncError()) => '참여자만 댓글을 작성할 수 있습니다.',
      _ => '댓글 입력...',
    };
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 12,
        top: 10,
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      decoration: const BoxDecoration(
        color: CustomColor.background,
        border: Border(top: BorderSide(color: CustomColor.gray800, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: CustomColor.gray800, width: 1.5),
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              child: TextField(
                controller: _commentController,
                enabled: canWrite,
                maxLength: 255,
                style: CustomTextStyle.body2,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: CustomTextStyle.body2.copyWith(
                    color: CustomColor.gray600,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  counterText: '',
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onSubmitted: (_) => _submitComment(),
              ),
            ),
          ),
          AppSpacing.w8,
          GestureDetector(
            onTap: _isSubmitting || !canWrite ? null : _submitComment,
            child: SizedBox(
              width: 40,
              height: 40,
              child: _isSubmitting
                  ? const CircularProgressIndicator(
                      strokeWidth: 2, color: CustomColor.main)
                  : const Icon(
                      Symbols.send, size: 18, color: CustomColor.main),
            ),
          ),
        ],
      ),
    );
  }
}
