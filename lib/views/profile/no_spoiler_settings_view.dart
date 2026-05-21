import 'package:twelfth_mobile/core/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twelfth_mobile/common/components/app_bar/twelfth_app_bar.dart';
import 'package:twelfth_mobile/core/extensions/snackbar_extension.dart';
import 'package:twelfth_mobile/features/no_spoiler/presentation/providers/no_spoiler_provider.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';

class NoSpoilerSettingsView extends ConsumerStatefulWidget {
  const NoSpoilerSettingsView({super.key});

  @override
  ConsumerState<NoSpoilerSettingsView> createState() =>
      _NoSpoilerSettingsViewState();
}

class _NoSpoilerSettingsViewState extends ConsumerState<NoSpoilerSettingsView> {
  bool? _original;
  bool? _current;
  bool _initialized = false;

  bool get _hasChanges => _initialized && _current != _original;

  Future<void> _save() async {
    if (_current == null) return;
    try {
      await ref.read(noSpoilerProvider.notifier).save(_current!);
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      context.showErrorSnackBar('설정에 실패했습니다. 다시 시도해주세요.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(noSpoilerProvider);

    return settingsAsync.when(
      loading: () => Scaffold(
        backgroundColor: CustomColor.background,
        appBar: const TwelfthAppBar(title: '노 스포일러'),
        body: const Center(
          child: CircularProgressIndicator(color: CustomColor.white),
        ),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: CustomColor.background,
        appBar: const TwelfthAppBar(title: '노 스포일러'),
        body: Center(
          child: Text(
            '설정을 불러오지 못했습니다',
            style: CustomTextStyle.body2.copyWith(color: CustomColor.gray500),
          ),
        ),
      ),
      data: (enabled) {
        if (!_initialized) {
          _initialized = true;
          _original = enabled;
          _current = enabled;
        }

        return Scaffold(
          backgroundColor: CustomColor.background,
          appBar: TwelfthAppBar(
            title: '노 스포일러',
            actions: [
              TextButton(
                onPressed: _hasChanges ? _save : null,
                child: Text(
                  '저장',
                  style: CustomTextStyle.body1.copyWith(
                    color: _hasChanges ? CustomColor.blue : CustomColor.gray600,
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: AppPadding.cardH,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSpacing.h8,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('노 스포일러', style: CustomTextStyle.body1),
                      _GradientSwitch(
                        value: _current!,
                        onChanged: (v) => setState(() => _current = v),
                      ),
                    ],
                  ),
                  AppSpacing.h16,
                  Text(
                    '설정 시 경기 결과가 바로 보이지 않습니다. 해당 경기를 클릭해야 해당 경기의 스코어가 보여집니다. 한번 본 경기 결과는 계속해서 보여지며, 이외의 경기에는 영향을 주지 않습니다.',
                    style: CustomTextStyle.body2.copyWith(
                      color: CustomColor.gray500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
          borderRadius: BorderRadius.circular(15),
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
