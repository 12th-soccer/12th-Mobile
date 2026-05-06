import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/common/components/button/elevated_button.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/core/constants/spacing.dart';
import 'package:twelfth_mobile/views/fan_finder/fan_finder_constants.dart';
import 'package:twelfth_mobile/views/fan_finder/widgets/filter_toggle_section.dart';

class FanFinderWriteView extends StatefulWidget {
  const FanFinderWriteView({super.key});

  @override
  State<FanFinderWriteView> createState() => _FanFinderWriteViewState();
}

class _FanFinderWriteViewState extends State<FanFinderWriteView> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final Set<String> _selectedTags = {};

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _titleController.text.trim().isNotEmpty &&
      _contentController.text.trim().isNotEmpty;

  void _onToggleTag(String tag) =>
      setState(() => _selectedTags.contains(tag)
          ? _selectedTags.remove(tag)
          : _selectedTags.add(tag));

  void _submit() {
    if (!_canSubmit) return;
    // TODO: 백엔드에 글 등록 API 호출
    context.pop();
  }

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
      ),
      body: SingleChildScrollView(
        padding: FanFinderConstants.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              controller: _titleController,
              hint: '제목을 입력하세요',
              maxLines: 1,
            ),
            AppSpacing.h8,
            _buildTextField(
              controller: _contentController,
              hint: '내용을 입력하세요',
              maxLines: 6,
            ),
            AppSpacing.h24,
            const Divider(color: CustomColor.gray800, height: 1),
            FilterToggleSection(
              title: '나이',
              options: FanFinderConstants.ageOptions,
              selectedItems: _selectedTags,
              onToggleItem: _onToggleTag,
              initiallyExpanded: true,
            ),
            const Divider(color: CustomColor.gray800, height: 1),
            FilterToggleSection(
              title: '성별',
              options: FanFinderConstants.genderOptions,
              selectedItems: _selectedTags,
              onToggleItem: _onToggleTag,
              initiallyExpanded: true,
            ),
            const Divider(color: CustomColor.gray800, height: 1),
            FilterToggleSection(
              title: 'K1',
              options: FanFinderConstants.k1Teams,
              selectedItems: _selectedTags,
              onToggleItem: _onToggleTag,
            ),
            const Divider(color: CustomColor.gray800, height: 1),
            FilterToggleSection(
              title: 'K2',
              options: FanFinderConstants.k2Teams,
              selectedItems: _selectedTags,
              onToggleItem: _onToggleTag,
            ),
            const Divider(color: CustomColor.gray800, height: 1),
            AppSpacing.h8,
            Text(
              '최소 인원은 5명이며, 최소 인원 달성 시 자동으로 채팅방이 생성됩니다.',
              style: CustomTextStyle.body3.copyWith(color: CustomColor.gray600),
            ),
            AppSpacing.h16,
            TwelfthElevatedButton(
              onPressed: _canSubmit ? _submit : null,
              backgroundColor: CustomColor.main,
              textColor: CustomColor.white,
              child: const Text('작성하기'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required int maxLines,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: CustomTextStyle.body1.copyWith(color: CustomColor.white),
      cursorColor: CustomColor.main,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: CustomTextStyle.body2.copyWith(color: CustomColor.gray600),
        filled: true,
        fillColor: CustomColor.gray800,
        contentPadding: const EdgeInsets.all(14),
        border: OutlineInputBorder(
          borderRadius: FanFinderConstants.buttonRadius,
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (_) => setState(() {}),
    );
  }
}
