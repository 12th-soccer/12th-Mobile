import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:twelfth_mobile/common/components/app_bar/twelfth_app_bar.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/core/constants/spacing.dart';
import 'package:twelfth_mobile/core/extensions/snackbar_extension.dart';
import 'package:twelfth_mobile/features/auth/presentation/providers/auth_provider.dart';

class EditUsernameView extends ConsumerStatefulWidget {
  const EditUsernameView({super.key});

  @override
  ConsumerState<EditUsernameView> createState() => _EditUsernameViewState();
}

class _EditUsernameViewState extends ConsumerState<EditUsernameView> {
  late final TextEditingController _controller;
  bool _isSaving = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    final current = ref.read(userInfoProvider).valueOrNull?.validUsername ?? '';
    _controller = TextEditingController(text: current);
    _hasText = current.isNotEmpty;
    _controller.addListener(() {
      final filled = _controller.text.trim().isNotEmpty;
      if (filled != _hasText) setState(() => _hasText = filled);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final username = _controller.text.trim();
    if (username.isEmpty) {
      context.showErrorSnackBar('닉네임을 입력해 주세요.');
      return;
    }

    setState(() => _isSaving = true);
    final success = await ref
        .read(authNotifierProvider.notifier)
        .updateUsername(username);
    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      FocusScope.of(context).unfocus();
      context.pop(username);
    } else {
      final error = ref.read(authNotifierProvider).errorMessage;
      context.showErrorSnackBar(error ?? '닉네임 변경에 실패했습니다.');
      ref.read(authNotifierProvider.notifier).clearError();
    }
  }

  @override
  Widget build(BuildContext context) {
    final canSave = _hasText && !_isSaving;

    return Scaffold(
      backgroundColor: CustomColor.background,
      appBar: TwelfthAppBar(
        actions: [
          TextButton(
            onPressed: canSave ? _save : null,
            child: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: CustomColor.main,
                    ),
                  )
                : Text(
                    '저장',
                    style: CustomTextStyle.body1.copyWith(
                      color: canSave ? CustomColor.blue : CustomColor.gray600,
                    ),
                  ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('닉네임', style: CustomTextStyle.body1),
            AppSpacing.h8,
            TextField(
              controller: _controller,
              autofocus: true,
              maxLength: 5,
              style: CustomTextStyle.body1,
              decoration: InputDecoration(
                hintText: '닉네임을 입력하세요',
                hintStyle: CustomTextStyle.body1.copyWith(
                  color: CustomColor.gray600,
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: CustomColor.gray800),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: CustomColor.main),
                ),
                counterStyle: CustomTextStyle.body3.copyWith(
                  color: CustomColor.gray600,
                ),
              ),
              onSubmitted: (_) => _save(),
            ),
            AppSpacing.h10,
            Text(
              "'팬 찾기' 기능에서 댓글 작성 시 보여지는 이름입니다.\n닉네임은 최대 5글자까지 작성 가능하며 한글과 영어 모두 가능합니다.",
              style: CustomTextStyle.body3.copyWith(color: CustomColor.gray600),
            ),
          ],
        ),
      ),
    );
  }
}
