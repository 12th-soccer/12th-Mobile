import 'package:flutter/material.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';

class LineupSection extends StatelessWidget {
  const LineupSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 480,
      decoration: BoxDecoration(
        color: CustomColor.gray900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          const _FieldBackground(),
          Center(
            child: Text(
              '라인업 정보가 없습니다',
              style: CustomTextStyle.body1.copyWith(
                color: CustomColor.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldBackground extends StatelessWidget {
  const _FieldBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _FieldPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _FieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final w = size.width;
    final h = size.height;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(8, 8, w - 16, h - 16),
        const Radius.circular(8),
      ),
      paint,
    );

    canvas.drawLine(Offset(8, h / 2), Offset(w - 8, h / 2), paint);

    canvas.drawCircle(Offset(w / 2, h / 2), 40, paint);
    canvas.drawCircle(
      Offset(w / 2, h / 2),
      3,
      paint..style = PaintingStyle.fill,
    );
    paint.style = PaintingStyle.stroke;

    final penBoxW = w * 0.55;
    final penBoxH = h * 0.15;
    canvas.drawRect(
      Rect.fromLTWH((w - penBoxW) / 2, 8, penBoxW, penBoxH),
      paint,
    );

    final goalBoxW = w * 0.3;
    final goalBoxH = h * 0.07;
    canvas.drawRect(
      Rect.fromLTWH((w - goalBoxW) / 2, 8, goalBoxW, goalBoxH),
      paint,
    );

    canvas.drawRect(
      Rect.fromLTWH((w - penBoxW) / 2, h - 8 - penBoxH, penBoxW, penBoxH),
      paint,
    );

    canvas.drawRect(
      Rect.fromLTWH((w - goalBoxW) / 2, h - 8 - goalBoxH, goalBoxW, goalBoxH),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
