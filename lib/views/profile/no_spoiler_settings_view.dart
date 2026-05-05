import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twelfth_mobile/common/components/app_bar/twelfth_app_bar.dart';
import 'package:twelfth_mobile/common/providers/no_spoiler_provider.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';

class NoSpoilerSettingsView extends ConsumerStatefulWidget {
  const NoSpoilerSettingsView({super.key});

  @override
  ConsumerState<NoSpoilerSettingsView> createState() =>
      _NoSpoilerSettingsViewState();
}

class _NoSpoilerSettingsViewState extends ConsumerState<NoSpoilerSettingsView> {
  bool? _noSpoilerEnabled;

  Future<void> _save() async {
    if (_noSpoilerEnabled == null) return;
    await ref.read(noSpoilerProvider.notifier).save(_noSpoilerEnabled!);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(noSpoilerProvider);

    return settingsAsync.when(
      loading: () => Scaffold(
        backgroundColor: CustomColor.background,
        appBar: const TwelfthAppBar(),
        body: const Center(
          child: CircularProgressIndicator(color: CustomColor.white),
        ),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: CustomColor.background,
        appBar: const TwelfthAppBar(),
        body: Center(
          child: Text(
            '설정을 불러오지 못했습니다',
            style: CustomTextStyle.body2.copyWith(color: CustomColor.gray500),
          ),
        ),
      ),
      data: (enabled) {
        _noSpoilerEnabled ??= enabled;
        return Scaffold(
          backgroundColor: CustomColor.background,
          appBar: TwelfthAppBar(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('노 스포일러', style: CustomTextStyle.body1),
                      _GradientSwitch(
                        value: _noSpoilerEnabled!,
                        onChanged: (v) => setState(() => _noSpoilerEnabled = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: CustomColor.gray900, height: 1),
                  const SizedBox(height: 16),
                  Text(
                    '설정 시 경기 결과가 바로 보이지 않고 거기 넣세 미서 하면으로 몰리서 결과가 보여집니다. 현재만 경기만 결과가 보여지며 여러의 경기에는 영향을 끼치 않습니다.',
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
