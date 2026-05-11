import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/common/components/button/elevated_button.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/core/constants/spacing.dart';
import 'package:twelfth_mobile/core/extensions/snackbar_extension.dart';
import 'package:twelfth_mobile/features/recruitment/domain/entities/recruitment.dart';
import 'package:twelfth_mobile/features/recruitment/domain/entities/recruitment_enums.dart';
import 'package:twelfth_mobile/features/recruitment/presentation/providers/recruitment_provider.dart';
import 'package:twelfth_mobile/features/recruitment/presentation/providers/team_list_provider.dart';
import 'package:twelfth_mobile/views/fan_finder/fan_finder_constants.dart';
import 'package:twelfth_mobile/views/fan_finder/widgets/date_picker_bottom_sheet.dart';

class FanFinderWriteView extends ConsumerStatefulWidget {
  const FanFinderWriteView({super.key});

  @override
  ConsumerState<FanFinderWriteView> createState() => _FanFinderWriteViewState();
}

class _FanFinderWriteViewState extends ConsumerState<FanFinderWriteView> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  int _headCount = FanFinderConstants.minParticipants;
  AgeGroup? _ageGroup;
  GenderGroup? _genderGroup;
  TeamGroup? _teamGroup;
  DateTime? _expiryDate;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _titleController.text.trim().isNotEmpty &&
      _contentController.text.trim().isNotEmpty &&
      _ageGroup != null &&
      _genderGroup != null &&
      _teamGroup != null &&
      !_isSubmitting;

  Future<void> _submit() async {
    if (!_canSubmit) return;
    setState(() => _isSubmitting = true);
    try {
      await createRecruitment(
        ref,
        Recruitment(
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          headCount: _headCount,
          ageGroup: _ageGroup!,
          genderGroup: _genderGroup!,
          teamGroup: _teamGroup!,
          expiryDate: _expiryDate,
        ),
      );
      if (!mounted) return;
      await ref.read(recruitmentListProvider.notifier).refresh();
      context.pop();
    } catch (_) {
      if (!mounted) return;
      context.showErrorSnackBar('모집글 등록에 실패했습니다. 다시 시도해 주세요.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showPickerSheet<T>({
    required String title,
    required List<T> options,
    required T? selected,
    required String Function(T) label,
    required void Function(T) onSelect,
    String? subtitle,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: CustomColor.gray900,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: CustomColor.gray600,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
              child: Row(
                children: [
                  Text(title, style: CustomTextStyle.heading2),
                  if (subtitle != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      subtitle,
                      style: CustomTextStyle.body3.copyWith(
                        color: CustomColor.gray500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: options.map((opt) {
                  final isSel = selected == opt;
                  return ListTile(
                    dense: true,
                    title: Text(
                      label(opt),
                      style: CustomTextStyle.body2.copyWith(
                        color: isSel ? CustomColor.main : CustomColor.white,
                        fontWeight: isSel ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    trailing: isSel
                        ? const Icon(
                            Symbols.check,
                            color: CustomColor.main,
                            size: 18,
                          )
                        : null,
                    onTap: () {
                      onSelect(opt);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showK1Sheet(List<TeamItem> teams) {
    showModalBottomSheet(
      context: context,
      backgroundColor: CustomColor.gray900,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: CustomColor.gray600,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
              child: Text('K1 구단', style: CustomTextStyle.heading2),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: teams.map((t) {
                  final isSel = _teamGroup == t.group;
                  return ListTile(
                    dense: true,
                    title: Text(
                      t.group.displayTag,
                      style: CustomTextStyle.body2.copyWith(
                        color: isSel ? CustomColor.main : CustomColor.white,
                        fontWeight: isSel ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    trailing: isSel
                        ? const Icon(
                            Symbols.check,
                            color: CustomColor.main,
                            size: 18,
                          )
                        : null,
                    onTap: () {
                      setState(() => _teamGroup = t.group);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showK2Sheet(List<TeamItem> teams) {
    showModalBottomSheet(
      context: context,
      backgroundColor: CustomColor.gray900,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: CustomColor.gray600,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
              child: Text('K2 구단', style: CustomTextStyle.heading2),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: teams.map((t) {
                  final isSel = _teamGroup == t.group;
                  return ListTile(
                    dense: true,
                    title: Text(
                      t.group.displayTag,
                      style: CustomTextStyle.body2.copyWith(
                        color: isSel ? CustomColor.main : CustomColor.white,
                        fontWeight: isSel ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    trailing: isSel
                        ? const Icon(
                            Symbols.check,
                            color: CustomColor.main,
                            size: 18,
                          )
                        : null,
                    onTap: () {
                      setState(() => _teamGroup = t.group);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await DatePickerBottomSheet.show(
      context,
      initialDate: _expiryDate,
    );
    if (picked != null) setState(() => _expiryDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final teamAsync = ref.watch(teamListProvider);

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
              maxLength: 50,
            ),
            AppSpacing.h8,
            _buildTextField(
              controller: _contentController,
              hint: '내용을 입력하세요',
              maxLines: 5,
              maxLength: 255,
            ),
            AppSpacing.h20,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _CategoryChip(
                  label: _ageGroup?.displayTag ?? '나이대',
                  isSelected: _ageGroup != null,
                  onTap: () => _showPickerSheet(
                    title: '나이대',
                    options: AgeGroup.values,
                    selected: _ageGroup,
                    label: (v) => v.displayTag,
                    onSelect: (v) => setState(() => _ageGroup = v),
                  ),
                ),
                _CategoryChip(
                  label: _genderGroup?.displayTag ?? '성별',
                  isSelected: _genderGroup != null,
                  onTap: () => _showPickerSheet(
                    title: '성별',
                    options: GenderGroup.values,
                    selected: _genderGroup,
                    label: (v) => v.displayTag,
                    onSelect: (v) => setState(() => _genderGroup = v),
                  ),
                ),
                teamAsync.when(
                  loading: () => _CategoryChip(
                    label: 'K1 구단',
                    isSelected: _teamGroup?.isK1 == true,
                    onTap: () {},
                  ),
                  error: (_, __) => _CategoryChip(
                    label: 'K1 구단',
                    isSelected: _teamGroup?.isK1 == true,
                    onTap: () => _showK1Sheet(
                      TeamGroup.values
                          .where((t) => t.isK1)
                          .map(
                            (t) =>
                                TeamItem(group: t, displayName: t.displayTag),
                          )
                          .toList(),
                    ),
                  ),
                  data: (state) => _CategoryChip(
                    label: (_teamGroup?.isK1 == true)
                        ? _teamGroup!.displayTag
                        : 'K1 구단',
                    isSelected: _teamGroup?.isK1 == true,
                    onTap: () => _showK1Sheet(state.k1Teams),
                  ),
                ),
                teamAsync.when(
                  loading: () => _CategoryChip(
                    label: 'K2 구단',
                    isSelected: _teamGroup?.isK1 == false,
                    onTap: () {},
                  ),
                  error: (_, __) => _CategoryChip(
                    label: 'K2 구단',
                    isSelected: _teamGroup?.isK1 == false,
                    onTap: () => _showK2Sheet(
                      TeamGroup.values
                          .where((t) => !t.isK1)
                          .map(
                            (t) =>
                                TeamItem(group: t, displayName: t.displayTag),
                          )
                          .toList(),
                    ),
                  ),
                  data: (state) => _CategoryChip(
                    label: (_teamGroup != null && !_teamGroup!.isK1)
                        ? _teamGroup!.displayTag
                        : 'K2 구단',
                    isSelected: _teamGroup != null && !_teamGroup!.isK1,
                    onTap: () => _showK2Sheet(state.k2Teams),
                  ),
                ),
              ],
            ),
            AppSpacing.h20,
            _buildParticipantsStepper(),
            AppSpacing.h20,
            _buildDatePicker(),
            AppSpacing.h6,
            Text(
              '선택한 날짜가 지나면 채팅방이 자동으로 삭제됩니다.',
              style: CustomTextStyle.body3.copyWith(color: CustomColor.gray600),
            ),

            AppSpacing.h24,
            TwelfthElevatedButton(
              onPressed: _canSubmit ? _submit : null,
              backgroundColor: CustomColor.main,
              textColor: CustomColor.black,
              child: _isSubmitting
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: CustomColor.black,
                      ),
                    )
                  : const Text('작성하기'),
            ),
            AppSpacing.h16,
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantsStepper() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '최대 인원',
          style: CustomTextStyle.body2.copyWith(
            color: CustomColor.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        Row(
          children: [
            _StepperButton(
              icon: Symbols.remove,
              onPressed: _headCount > FanFinderConstants.minParticipants
                  ? () => setState(() => _headCount--)
                  : null,
            ),
            SizedBox(
              width: 48,
              child: Text(
                '$_headCount명',
                textAlign: TextAlign.center,
                style: CustomTextStyle.body2.copyWith(color: CustomColor.white),
              ),
            ),
            _StepperButton(
              icon: Symbols.add,
              onPressed: _headCount < FanFinderConstants.maxParticipants
                  ? () => setState(() => _headCount++)
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    final label = _expiryDate == null
        ? '경기 날짜 선택'
        : '만료: ${_expiryDate!.year}.${_expiryDate!.month.toString().padLeft(2, '0')}.${_expiryDate!.day.toString().padLeft(2, '0')}';

    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: CustomColor.gray800,
          borderRadius: FanFinderConstants.buttonRadius,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: CustomTextStyle.body2.copyWith(
                  color: _expiryDate == null
                      ? CustomColor.gray500
                      : CustomColor.white,
                ),
              ),
            ),
            if (_expiryDate != null)
              GestureDetector(
                onTap: () => setState(() => _expiryDate = null),
                child: const Icon(
                  Symbols.close,
                  size: 16,
                  color: CustomColor.gray600,
                ),
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
    int? maxLength,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      style: CustomTextStyle.body1.copyWith(color: CustomColor.white),
      cursorColor: CustomColor.main,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: CustomTextStyle.body2.copyWith(color: CustomColor.gray600),
        filled: true,
        fillColor: CustomColor.gray800,
        contentPadding: const EdgeInsets.all(14),
        counterStyle: CustomTextStyle.body3.copyWith(
          color: CustomColor.gray600,
        ),
        border: OutlineInputBorder(
          borderRadius: FanFinderConstants.buttonRadius,
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (_) => setState(() {}),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? CustomColor.main.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? CustomColor.main : CustomColor.gray600,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: CustomTextStyle.body3.copyWith(
                color: isSelected ? CustomColor.main : CustomColor.gray500,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 3),
            Icon(
              Symbols.keyboard_arrow_down,
              size: 13,
              color: isSelected ? CustomColor.main : CustomColor.gray500,
            ),
          ],
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _StepperButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: CustomColor.gray800,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 18,
          color: onPressed != null ? CustomColor.white : CustomColor.gray600,
        ),
      ),
    );
  }
}
