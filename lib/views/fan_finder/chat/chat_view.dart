import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/views/fan_finder/model/fan_post.dart';

class _Message {
  final String text;
  final bool isMine;
  final String sender;
  final DateTime time;
  final bool isSystem;

  const _Message({
    required this.text,
    required this.isMine,
    required this.sender,
    required this.time,
    this.isSystem = false,
  });
}

class ChatView extends StatefulWidget {
  final FanPost post;

  const ChatView({super.key, required this.post});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<_Message> _messages = [
    _Message(
      text: '채팅방이 생성되었습니다',
      isMine: false,
      sender: '시스템',
      time: DateTime.now().subtract(const Duration(minutes: 2)),
      isSystem: true,
    ),
    _Message(
      text: '반갑습니다~ 같이 응원해요!',
      isMine: false,
      sender: '참가자1',
      time: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(
        _Message(
          text: text,
          isMine: true,
          sender: '나',
          time: DateTime.now(),
        ),
      );
    });
    _controller.clear();
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
      '${d.year}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final isExpired = widget.post.isExpired;

    return Scaffold(
      backgroundColor: CustomColor.background,
      appBar: AppBar(
        backgroundColor: CustomColor.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back_ios, color: CustomColor.white),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: CustomColor.gray800,
              child: Text(
                widget.post.title.isNotEmpty ? widget.post.title[0] : '?',
                style: CustomTextStyle.body2.copyWith(color: CustomColor.white),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.post.title,
                    style: CustomTextStyle.body1.copyWith(
                      color: CustomColor.white,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${widget.post.maxParticipants}명 참여',
                    style: CustomTextStyle.body3.copyWith(
                      color: CustomColor.gray500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          const Divider(color: CustomColor.gray800, height: 1),
          _buildNoticeBanner(isExpired),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _buildBubble(_messages[i]),
            ),
          ),
          if (isExpired) _buildExpiredBar() else _buildInput(),
        ],
      ),
    );
  }

  Widget _buildNoticeBanner(bool isExpired) {
    final expiryDate = widget.post.expiryDate;
    final dateText = expiryDate != null ? ' (${_formatDate(expiryDate)})' : '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isExpired
            ? CustomColor.red.withOpacity(0.12)
            : CustomColor.gray800.withOpacity(0.7),
        border: Border(
          bottom: BorderSide(
            color: isExpired
                ? CustomColor.red.withOpacity(0.3)
                : CustomColor.gray800,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 14,
            color: isExpired ? CustomColor.red : CustomColor.gray500,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              isExpired
                  ? '채팅방이 만료되어 더 이상 메시지를 보낼 수 없습니다$dateText.'
                  : '채팅방은 해당 날짜가 지나면 자동으로 삭제됩니다$dateText. 채팅 내에서 개인정보 유출에 대해 주의하세요.',
              style: CustomTextStyle.body3.copyWith(
                color: isExpired ? CustomColor.red : CustomColor.gray500,
                fontSize: 11,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpiredBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 14,
        bottom: MediaQuery.of(context).padding.bottom + 14,
      ),
      decoration: const BoxDecoration(
        color: CustomColor.background,
        border: Border(top: BorderSide(color: CustomColor.gray800, width: 0.5)),
      ),
      child: Center(
        child: Text(
          '종료된 채팅방입니다',
          style: CustomTextStyle.body2.copyWith(color: CustomColor.gray600),
        ),
      ),
    );
  }

  Widget _buildBubble(_Message msg) {
    if (msg.isSystem) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: CustomColor.gray800.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              msg.text,
              style: CustomTextStyle.body3.copyWith(
                color: CustomColor.gray500,
                fontSize: 11,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment:
            msg.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!msg.isMine) ...[
            CircleAvatar(
              radius: 15,
              backgroundColor: CustomColor.gray800,
              child: Text(
                msg.sender[0],
                style: const TextStyle(
                  color: CustomColor.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 7),
          ],
          if (msg.isMine)
            Padding(
              padding: const EdgeInsets.only(right: 6, bottom: 2),
              child: Text(
                _formatTime(msg.time),
                style: CustomTextStyle.body3.copyWith(
                  color: CustomColor.gray600,
                  fontSize: 10,
                ),
              ),
            ),
          Container(
            constraints: const BoxConstraints(maxWidth: 240),
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: msg.isMine
                  ? CustomColor.blue
                  : CustomColor.gray800,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(msg.isMine ? 20 : 4),
                bottomRight: Radius.circular(msg.isMine ? 4 : 20),
              ),
            ),
            child: Text(
              msg.text,
              style: CustomTextStyle.body2.copyWith(
                color: CustomColor.white,
                fontSize: 14,
              ),
            ),
          ),
          if (!msg.isMine)
            Padding(
              padding: const EdgeInsets.only(left: 6, bottom: 2),
              child: Text(
                _formatTime(msg.time),
                style: CustomTextStyle.body3.copyWith(
                  color: CustomColor.gray600,
                  fontSize: 10,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInput() {
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
                controller: _controller,
                style: CustomTextStyle.body2.copyWith(color: CustomColor.white),
                decoration: InputDecoration(
                  hintText: '메시지 입력...',
                  hintStyle: CustomTextStyle.body2.copyWith(
                    color: CustomColor.gray600,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onSubmitted: (_) => _send(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _send,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Symbols.send,
                size: 18,
                color: CustomColor.main,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}
