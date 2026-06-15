import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:twelfth_mobile/common/components/image/network_avatar.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/core/constants/spacing.dart';
import 'package:twelfth_mobile/features/live_chat/domain/entities/chat_message.dart';
import 'package:twelfth_mobile/features/live_chat/presentation/providers/live_chat_provider.dart';
import 'package:twelfth_mobile/features/match/presentation/providers/match_provider.dart';

class LiveChatExtra {
  final int matchId;
  final String homeTeam;
  final String awayTeam;
  final String? homeImageUrl;
  final String? awayImageUrl;
  final int? homeScore;
  final int? awayScore;

  const LiveChatExtra({
    required this.matchId,
    required this.homeTeam,
    required this.awayTeam,
    this.homeImageUrl,
    this.awayImageUrl,
    this.homeScore,
    this.awayScore,
  });
}

class LiveChatView extends ConsumerStatefulWidget {
  final LiveChatExtra extra;

  const LiveChatView({super.key, required this.extra});

  @override
  ConsumerState<LiveChatView> createState() => _LiveChatViewState();
}

class _LiveChatViewState extends ConsumerState<LiveChatView> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    ref
        .read(liveChatMessagesProvider(widget.extra.matchId).notifier)
        .send(text);
    _controller.clear();
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

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(liveChatMessagesProvider(widget.extra.matchId));

    ref.listen(liveChatMessagesProvider(widget.extra.matchId), (_, __) {
      _scrollToBottom();
    });

    return Scaffold(
      backgroundColor: CustomColor.background,
      appBar: AppBar(
        backgroundColor: CustomColor.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: CustomColor.white,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text('실시간 채팅', style: CustomTextStyle.heading2),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: CustomColor.gray900),
        ),
      ),
      body: Column(
        children: [
          _buildScoreHeader(),
          const Divider(height: 1, thickness: 1, color: CustomColor.gray900),
          _buildNoticeBox(),
          Expanded(child: _buildMessageList(messages)),
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildScoreHeader() {
    final scoreAsync = ref.watch(liveMatchScoreProvider(widget.extra.matchId));
    final match = scoreAsync.valueOrNull;

    final homeScore = match?.homeTeamScore ?? widget.extra.homeScore;
    final awayScore = match?.awayTeamScore ?? widget.extra.awayScore;
    final isLive = match != null && !match.isFinished;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: _TeamColumn(
              name: widget.extra.homeTeam,
              imageUrl: widget.extra.homeImageUrl,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLive) ...[
                Text(
                  'Live',
                  style: CustomTextStyle.body2.copyWith(
                    color: CustomColor.green,
                  ),
                ),
                AppSpacing.h4,
              ],
              Text(
                homeScore != null && awayScore != null
                    ? '$homeScore : $awayScore'
                    : '- : -',
                style: CustomTextStyle.heading1,
              ),
            ],
          ),
          Expanded(
            child: _TeamColumn(
              name: widget.extra.awayTeam,
              imageUrl: widget.extra.awayImageUrl,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeBox() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: CustomColor.gray800,
        borderRadius: AppRadius.sm,
      ),
      child: Text(
        '이 공간은 해당 경기에 대해 실시간으로 팬들의 반응이 올라오는 곳입니다.\n'
        '모두가 이용하는 공간이기 때문에 비속어, 욕설, 비하하는 말은 삼가주시기 바랍니다.\n',
        style: CustomTextStyle.body3.copyWith(
          color: CustomColor.gray500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildMessageList(List<ChatMessage> messages) {
    if (messages.isEmpty) {
      return Center(
        child: Text(
          '첫 응원 메시지를 남겨보세요!',
          style: CustomTextStyle.body2.copyWith(color: CustomColor.gray600),
        ),
      );
    }
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: messages.length,
      itemBuilder: (context, index) => _MessageItem(message: messages[index]),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 10,
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      decoration: const BoxDecoration(
        color: CustomColor.background,
        border: Border(top: BorderSide(color: CustomColor.gray900, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: CustomColor.gray800,
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              child: TextField(
                controller: _controller,
                maxLength: 500,
                style: CustomTextStyle.body2,
                cursorColor: CustomColor.main,
                decoration: InputDecoration(
                  hintText: '상대를 존중하며 글을 작성해주세요.',
                  hintStyle: CustomTextStyle.body2.copyWith(
                    color: CustomColor.gray500,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  counterText: '',
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onSubmitted: (_) => _send(),
              ),
            ),
          ),
          AppSpacing.w8,
          GestureDetector(
            onTap: _send,
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Icon(Icons.send, size: 20, color: CustomColor.main),
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamColumn extends StatelessWidget {
  final String name;
  final String? imageUrl;

  const _TeamColumn({required this.name, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NetworkAvatar(imageUrl: imageUrl, size: 40),
        AppSpacing.h6,
        Text(
          name,
          style: CustomTextStyle.body3,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _MessageItem extends StatelessWidget {
  final ChatMessage message;

  const _MessageItem({required this.message});

  String _relativeTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return '방금 전';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    return '${diff.inDays}일 전';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NetworkAvatar(imageUrl: message.profileImageUrl, size: 32),
          AppSpacing.w10,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        message.nickname,
                        style: CustomTextStyle.body3.copyWith(
                          color: CustomColor.white,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    AppSpacing.w8,
                    Text(
                      _relativeTime(message.createdAt),
                      style: CustomTextStyle.body3.copyWith(
                        color: CustomColor.gray600,
                      ),
                    ),
                  ],
                ),
                AppSpacing.h4,
                Text(
                  message.content,
                  style: CustomTextStyle.body2.copyWith(
                    color: CustomColor.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
