import 'package:flutter/material.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/constants/color.dart';

class TwelfthAccentTitle extends StatelessWidget {
  final String text;
  final Widget spacing;

  const TwelfthAccentTitle(
    this.text, {
    super.key,
    this.spacing = const SizedBox(height: 32),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        spacing,
        Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: CustomColor.main, width: 12),
            ),
          ),
          padding: const EdgeInsets.only(left: 12),
          child: Text(text, style: CustomTextStyle.heading1),
        ),
        spacing,
      ],
    );
  }
}
