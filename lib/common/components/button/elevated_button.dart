import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';

class TwelfthElevatedButton extends StatefulWidget {
  final void Function()? onPressed;
  final double? height;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? textColor;
  final String? imgPath;
  final Widget child;

  const TwelfthElevatedButton({
    super.key,
    this.onPressed,
    this.height,
    this.gradient,
    this.backgroundColor,
    this.textColor,
    this.imgPath,
    required this.child,
  });

  @override
  State<TwelfthElevatedButton> createState() => _TwelfthElevatedButtonState();
}

class _TwelfthElevatedButtonState extends State<TwelfthElevatedButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = widget.onPressed != null;
    final Color defaultBackgroundColor =
        widget.backgroundColor ?? TwelfthColor.gray900;
    final bool showPressedOutline = _isPressed;
    final Gradient enabledGradient = TwelfthGradient.horizontal(
      TwelfthColor.silverGradient,
    );
    final Color disabledColor = defaultBackgroundColor;
    final Gradient? containerGradient;
    final Color? containerColor;

    if (showPressedOutline) {
      containerGradient = null;
      containerColor = defaultBackgroundColor;
    } else if (isEnabled) {
      containerGradient = enabledGradient;
      containerColor = null;
    } else {
      containerGradient = null;
      containerColor = disabledColor;
    }

    Widget? svgWidget() {
      if (widget.imgPath != null) {
        return SvgPicture.asset(widget.imgPath!, width: 24, height: 24);
      }
      return null;
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        if (isEnabled) {
          widget.onPressed!();
        }
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          gradient: containerGradient,
          color: containerColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            if (showPressedOutline)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: TwelfthGradient.horizontal(
                    TwelfthColor.silverGradient,
                  ),
                ),
                padding: const EdgeInsets.all(1),
                child: Container(
                  decoration: BoxDecoration(
                    color: defaultBackgroundColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

            ElevatedButton(
              onPressed: isEnabled ? widget.onPressed : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                disabledBackgroundColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: DefaultTextStyle(
                style: TwelfthTextStyle.heading2.copyWith(
                  color: isEnabled
                      ? (widget.textColor ?? TwelfthColor.black)
                      : TwelfthColor.white,
                ),
                textAlign: TextAlign.center,
                child: svgWidget() != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          svgWidget()!,
                          const SizedBox(width: 8),
                          widget.child,
                        ],
                      )
                    : widget.child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
