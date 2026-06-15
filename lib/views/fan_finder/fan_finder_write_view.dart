import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:twelfth_mobile/common/components/button/elevated_button.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/core/constants/spacing.dart';
import 'package:twelfth_mobile/core/extensions/snackbar_extension.dart';
import 'package:twelfth_mobile/core/network/api_client.dart';
import 'package:twelfth_mobile/core/network/token_storage.dart';
import 'package:twelfth_mobile/features/auth/presentation/providers/auth_provider.dart';
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
  TeamItem? _selectedTeam;
  DateTime? _expiryDate;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_validateSubmission()) return;

    final userInfo = ref.read(userInfoProvider).valueOrNull;

    final token = await TokenStorage.instance.getAccessToken();

    if (token != null) {

    }
    if (!mounted) return;

    if (userInfo == null) {
      context.showErrorSnackBar('로그인이 필요합니다.');
      return;
    }
    if (!userInfo.hasUsername) {
      context.showErrorSnackBar('닉네임을 설정해야 모집글 작성이 가능합니다.');
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final recruitment = Recruitment(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        headCount: _headCount,
        ageGroup: _ageGroup!,
        genderGroup: _genderGroup!,
        teamCode: _selectedTeam!.code,
        isK1: _selectedTeam!.isK1,
        teamDisplayName: _selectedTeam!.displayName,
        expiryDate: _expiryDate,
      );

      await createRecruitment(ref, recruitment);
      if (!mounted) return;
      await ref.read(recruitmentListProvider.notifier).refresh();
      if (!mounted) return;
      context.pop();
    } on ApiException catch (e) {
      if (!mounted) return;

      final msg = switch (e.statusCode) {
        401 => '로그인이 필요합니다.',
        403 => '모집글 작성 권한이 없습니다. 닉네임 설정을 확인해주세요.',
        400 => '입력된 정보를 확인해주세요.',
        _ => '모집글 등록에 실패했습니다. 다시 시도해 주세요.',
      };
      context.showErrorSnackBar(msg);
    } catch (e) {
      if (!mounted) return;
      context.showErrorSnackBar('모집글 등록에 실패했습니다. 다시 시도해 주세요.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  bool _validateSubmission() {
    if (_titleController.text.trim().isEmpty) {
      context.showErrorSnackBar('제목을 입력해 주세요.');
      return false;
    }
    if (_contentController.text.trim().isEmpty) {
      context.showErrorSnackBar('내용을 입력해 주세요.');
      return false;
    }
    if (_ageGroup == null) {
      context.showErrorSnackBar('연령대를 선택해 주세요.');
      return false;
    }
    if (_genderGroup == null) {
      context.showErrorSnackBar('성별을 선택해 주세요.');
      return false;
    }
    if (_selectedTeam == null) {
      context.showErrorSnackBar('K1 또는 K2 구단을 선택해 주세요.');
      return false;
    }

    if (_expiryDate == null) {
      context.showErrorSnackBar('만료일을 선택해 주세요.');
      return false;
    }
    return true;
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
            AppSpacing.h8,
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: CustomColor.gray600,
                borderRadius: AppRadius.xs,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
              child: Row(
                children: [
                  Text(title, style: CustomTextStyle.heading2),
                  if (subtitle != null) ...[
                    AppSpacing.w8,
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
                            Icons.check,
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
            AppSpacing.h8,
          ],
        ),
      ),
    );
  }

  void _showTeamSheet(String title, List<TeamItem> teams) {
    showModalBottomSheet(
      context: context,
      backgroundColor: CustomColor.gray900,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.5,
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              AppSpacing.h8,
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: CustomColor.gray600,
                  borderRadius: AppRadius.xs,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
                child: Text(title, style: CustomTextStyle.heading2),
              ),
              Expanded(
                child: ListView(
                  children: teams.map((t) {
                    final isSel = _selectedTeam?.displayName == t.displayName;
                    return ListTile(
                      dense: true,
                      title: Text(
                        t.displayName,
                        style: CustomTextStyle.body2.copyWith(
                          color: isSel ? CustomColor.main : CustomColor.white,
                          fontWeight: isSel ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      trailing: isSel
                          ? const Icon(
                              Icons.check,
                              color: CustomColor.main,
                              size: 18,
                            )
                          : null,
                      onTap: () {
                        setState(() => _selectedTeam = t);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              ),
              AppSpacing.h8,
            ],
          ),
        ),
      ),
    );
  }

  void _showK1Sheet(List<TeamItem> teams) => _showTeamSheet('K1 구단', teams);
  void _showK2Sheet(List<TeamItem> teams) => _showTeamSheet('K2 구단', teams);

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
        automaticallyImplyLeading: false,
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
                _CategoryChip(
                  label: (_selectedTeam?.isK1 == true)
                      ? _selectedTeam!.displayName
                      : 'K1 구단',
                  isSelected: _selectedTeam?.isK1 == true,
                  onTap: () => _showK1Sheet(
                    teamAsync.valueOrNull?.k1Teams ?? [],
                  ),
                ),
                _CategoryChip(
                  label: (_selectedTeam != null && _selectedTeam!.isK1 == false)
                      ? _selectedTeam!.displayName
                      : 'K2 구단',
                  isSelected: _selectedTeam != null && _selectedTeam!.isK1 == false,
                  onTap: () => _showK2Sheet(
                    teamAsync.valueOrNull?.k2Teams ?? [],
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
              onPressed: _isSubmitting ? null : _submit,
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
              icon: Icons.remove,
              onPressed: _headCount > FanFinderConstants.minParticipants
                  ? () => setState(() => _headCount--)
                  : null,
            ),
            SizedBox(
              width: 48,
              child: Text(
                '$_headCount명',
                textAlign: TextAlign.center,
                style: CustomTextStyle.body2,
              ),
            ),
            _StepperButton(
              icon: Icons.add,
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
        ? '만료일 선택'
        : '만료: ${_expiryDate!.year}.${_expiryDate!.month.toString().padLeft(2, '0')}.${_expiryDate!.day.toString().padLeft(2, '0')} '
            '${_expiryDate!.hour.toString().padLeft(2, '0')}:${_expiryDate!.minute.toString().padLeft(2, '0')}';

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
                  Icons.close,
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
      style: CustomTextStyle.body1,
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
          borderRadius: AppRadius.lg,
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
              Icons.keyboard_arrow_down,
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
          borderRadius: AppRadius.sm,
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
