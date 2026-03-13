import 'package:flutter/material.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';

class TwelfthAccentTitle extends StatelessWidget {
  final String text;

  const TwelfthAccentTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(color: CustomColor.main, width: 12),
            ),
          ),
          padding: const EdgeInsets.only(left: 12),
          child: Text(text, style: CustomTextStyle.heading1),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
