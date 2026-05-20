import 'package:twelfth_mobile/core/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:twelfth_mobile/common/components/image/network_avatar.dart';
import 'onboarding_checkbox.dart';
import '../constants/onboarding_constants.dart';

class OnboardingSelectableTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isSelected;
  final String? imageUrl;

  const OnboardingSelectableTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.isSelected,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: OnboardingUI.itemPadding,
      decoration: OnboardingUI.itemBoxDecoration,
      child: Row(
        children: [
          NetworkAvatar(imageUrl: imageUrl, size: 36),
          AppSpacing.w12,
          Expanded(
            child: subtitle == null
                ? Text(title, style: OnboardingUI.itemText)
                : Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: '$title ', style: OnboardingUI.itemText),
                        TextSpan(
                          text: subtitle!,
                          style: OnboardingUI.itemSubText,
                        ),
                      ],
                    ),
                  ),
          ),
          OnboardingCheckbox(isSelected: isSelected),
        ],
      ),
    );
  }
}
