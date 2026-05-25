import 'package:twelfth_mobile/core/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/constants/color.dart';

class AgeVerificationDialog extends StatelessWidget {
  const AgeVerificationDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierColor: CustomColor.black.withValues(alpha: 0.7),
      builder: (_) => const AgeVerificationDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: CustomColor.gray800,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '나이 인증 필요',
              style: CustomTextStyle.heading2,
            ),
            AppSpacing.h12,
            Text(
              '해당 서비스를 사용하기 위해서는 나이 인증이 필요합니다.\n안전을 위해 만 19세 이상만 사용이 가능합니다.',
              style: CustomTextStyle.body1
            ),
            AppSpacing.h24,
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: CustomColor.gray600),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.sm,
                      ),
                    ),
                    child: Text(
                      '취소',
                      style: CustomTextStyle.body1.copyWith(
                        color: CustomColor.gray500,
                      ),
                    ),
                  ),
                ),
                AppSpacing.w12,
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColor.main,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.sm,
                      ),
                    ),
                    child: Text(
                      '인증하기',
                      style: CustomTextStyle.body1.copyWith(
                        color: CustomColor.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
