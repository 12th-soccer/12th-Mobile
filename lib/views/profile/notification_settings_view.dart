import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twelfth_mobile/common/components/app_bar/twelfth_app_bar.dart';
import 'package:twelfth_mobile/common/providers/notification_settings_provider.dart';
import 'package:twelfth_mobile/features/alarm/presentation/providers/alarm_provider.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/extensions/snackbar_extension.dart';

class NotificationSettingsView extends ConsumerWidget {
  const NotificationSettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(notificationSettingsNotifierProvider);

    return settingsAsync.when(
      loading: () => Scaffold(
        backgroundColor: CustomColor.background,
        appBar: const TwelfthAppBar(title: '알림 설정'),
        body: const Center(
          child: CircularProgressIndicator(color: CustomColor.white),
        ),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: CustomColor.background,
        appBar: const TwelfthAppBar(title: '알림 설정'),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '설정을 불러오지 못했습니다',
                style: CustomTextStyle.body2.copyWith(
                  color: CustomColor.gray500,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () =>
                    ref.invalidate(notificationSettingsNotifierProvider),
                child: Text(
                  '다시 시도',
                  style: CustomTextStyle.body2.copyWith(
                    color: CustomColor.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      data: (settings) => _SettingsForm(settings: settings),
    );
  }
}

class _SettingsForm extends ConsumerStatefulWidget {
  final NotificationSettings settings;

  const _SettingsForm({required this.settings});

  @override
  ConsumerState<_SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends ConsumerState<_SettingsForm> {
  late bool _notificationEnabled;
  late bool _matchStartEnabled;
  late bool _oneHourBefore;
  late bool _thirtyMinsBefore;
  late bool _fifteenMinsBefore;

  @override
  void initState() {
    super.initState();
    _notificationEnabled = widget.settings.notificationEnabled;
    _matchStartEnabled = widget.settings.matchStartEnabled;
    _oneHourBefore = widget.settings.oneHourBeforeEnabled;
    _thirtyMinsBefore = widget.settings.thirtyMinutesBeforeEnabled;
    _fifteenMinsBefore = widget.settings.fifteenMinutesBeforeEnabled;
  }

  Future<void> _save() async {
    final updated = NotificationSettings(
      notificationEnabled: _notificationEnabled,
      matchStartEnabled: _matchStartEnabled,
      oneHourBeforeEnabled: _oneHourBefore,
      thirtyMinutesBeforeEnabled: _thirtyMinsBefore,
      fifteenMinutesBeforeEnabled: _fifteenMinsBefore,
    );

    final success = await ref
        .read(notificationSettingsNotifierProvider.notifier)
        .save(updated);

    if (!mounted) return;
    if (!success) {
      context.showErrorSnackBar('알림 설정 저장에 실패했습니다. 다시 시도해 주세요.');
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background,
      appBar: TwelfthAppBar(
        title: '알림 설정',
        actions: [
          TextButton(
            onPressed: _save,
            child: Text(
              '저장',
              style: CustomTextStyle.body1.copyWith(
                color: CustomColor.blue,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _buildRow(
                label: '알림',
                value: _notificationEnabled,
                onChanged: (v) => setState(() => _notificationEnabled = v),
              ),
              if (_notificationEnabled) ...[
                const SizedBox(height: 8),
                const Divider(color: CustomColor.gray900, height: 1),
                const SizedBox(height: 8),
                _buildRow(
                  label: '경기 시작',
                  value: _matchStartEnabled,
                  onChanged: (v) => setState(() => _matchStartEnabled = v),
                  sublabel: '기본 알림으로 끄기 가능합니다.',
                ),
                const SizedBox(height: 4),
                _buildRow(
                  label: '1시간 전',
                  value: _oneHourBefore,
                  onChanged: (v) => setState(() => _oneHourBefore = v),
                ),
                _buildRow(
                  label: '30분 전',
                  value: _thirtyMinsBefore,
                  onChanged: (v) => setState(() => _thirtyMinsBefore = v),
                ),
                _buildRow(
                  label: '15분 전',
                  value: _fifteenMinsBefore,
                  onChanged: (v) => setState(() => _fifteenMinsBefore = v),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
    String? sublabel,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: CustomTextStyle.body1),
              if (sublabel != null)
                Text(
                  sublabel,
                  style: CustomTextStyle.body3.copyWith(
                    color: CustomColor.gray500,
                  ),
                ),
            ],
          ),
          _GradientSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _GradientSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _GradientSwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 51,
        height: 31,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.5),
          gradient: value
              ? TwelfthGradient.horizontal(CustomColor.silverGradient)
              : null,
          color: value ? null : CustomColor.gray900,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.all(3),
            width: 25,
            height: 25,
            decoration: const BoxDecoration(
              color: CustomColor.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
