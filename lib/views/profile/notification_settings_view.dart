import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twelfth_mobile/common/components/app_bar/twelfth_app_bar.dart';
import 'package:twelfth_mobile/common/providers/notification_settings_provider.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';

class NotificationSettingsView extends ConsumerStatefulWidget {
  const NotificationSettingsView({super.key});

  @override
  ConsumerState<NotificationSettingsView> createState() =>
      _NotificationSettingsViewState();
}

class _NotificationSettingsViewState
    extends ConsumerState<NotificationSettingsView> {
  // 저장 전 로컬 편집 상태
  late bool _masterEnabled;
  late bool _onMatchStart;
  late bool _before1Hour;
  late bool _before30Min;
  late bool _before15Min;

  @override
  void initState() {
    super.initState();
    // 진입 시 provider에서 현재 저장된 값을 읽어옴
    final saved = ref.read(notificationSettingsProvider);
    _masterEnabled = saved.masterEnabled;
    _onMatchStart = saved.onMatchStart;
    _before1Hour = saved.before1Hour;
    _before30Min = saved.before30Min;
    _before15Min = saved.before15Min;
  }

  void _save() {
    final notifier = ref.read(notificationSettingsProvider.notifier);
    notifier.setMaster(_masterEnabled);
    notifier.setOnMatchStart(_onMatchStart);
    notifier.setBefore1Hour(_before1Hour);
    notifier.setBefore30Min(_before30Min);
    notifier.setBefore15Min(_before15Min);
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
              style: CustomTextStyle.body1.copyWith(color: CustomColor.blue),
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
                value: _masterEnabled,
                onChanged: (v) => setState(() => _masterEnabled = v),
              ),
              if (_masterEnabled) ...[
                const SizedBox(height: 8),
                const Divider(color: CustomColor.gray900, height: 1),
                const SizedBox(height: 8),
                _buildRow(
                  label: '경기 시작',
                  value: _onMatchStart,
                  onChanged: (v) => setState(() => _onMatchStart = v),
                  sublabel: '기본 알림으로 끄기 가능합니다.',
                ),
                const SizedBox(height: 4),
                _buildRow(
                  label: '1시간 전',
                  value: _before1Hour,
                  onChanged: (v) => setState(() => _before1Hour = v),
                ),
                _buildRow(
                  label: '30분 전',
                  value: _before30Min,
                  onChanged: (v) => setState(() => _before30Min = v),
                ),
                _buildRow(
                  label: '15분 전',
                  value: _before15Min,
                  onChanged: (v) => setState(() => _before15Min = v),
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
                  style: CustomTextStyle.body3
                      .copyWith(color: CustomColor.gray500),
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
