import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/constants/color.dart';

class TwelfthElevatedButton extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Gradient? gradient;
  final Gradient? borderGradient;
  final Color? textColor;
  final String? imgPath;
  final VoidCallback? onPressed;
  final double height;
  final double borderRadius;
  final bool isOutlined;

  const TwelfthElevatedButton({
    super.key,
    required this.child,
    this.backgroundColor,
    this.gradient,
    this.borderGradient,
    this.textColor,
    this.imgPath,
    this.onPressed,
    this.height = 48,
    this.borderRadius = 20,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null;

    Color effectiveBgColor;
    Gradient? effectiveGradient = gradient;

    if (isOutlined) {
      effectiveBgColor = Colors.transparent;
    } else if (!isEnabled) {
      effectiveBgColor = CustomColor.gray900.withValues(alpha: 0.5);
      effectiveGradient = null;
    } else if (effectiveGradient != null) {
      effectiveBgColor = Colors.transparent;
    } else {
      effectiveBgColor = backgroundColor ?? CustomColor.gray900;
    }

    final effectiveTextColor =
        textColor ?? (isOutlined ? CustomColor.white : CustomColor.white);

    Widget buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (imgPath != null) ...[
          SvgPicture.asset(imgPath!, width: 20, height: 20),
          const SizedBox(width: 8),
        ],
        DefaultTextStyle(
          style: CustomTextStyle.heading2.copyWith(color: effectiveTextColor),
          child: child,
        ),
      ],
    );

    if (isOutlined && borderGradient != null) {
      return GestureDetector(
        onTap: isEnabled ? onPressed : null,
        child: Opacity(
          opacity: isEnabled ? 1.0 : 0.5,
          child: Container(
            width: double.infinity,
            height: height,
            decoration: BoxDecoration(
              gradient: borderGradient,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Container(
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: CustomColor.background,
                borderRadius: BorderRadius.circular(borderRadius - 1),
              ),
              child: Center(child: buttonChild),
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: isEnabled ? onPressed : null,
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.5,
        child: Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            color: effectiveGradient == null ? effectiveBgColor : null,
            gradient: effectiveGradient,
            borderRadius: BorderRadius.circular(borderRadius),
            border: isOutlined
                ? Border.all(color: CustomColor.gray900, width: 1)
                : null,
          ),
          child: Center(child: buttonChild),
        ),
      ),
    );
  }
}
