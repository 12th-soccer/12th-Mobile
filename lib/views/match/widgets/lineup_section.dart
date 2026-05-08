import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/features/match/domain/entities/match_lineup.dart';

class LineupSection extends StatelessWidget {
  final AsyncValue<List<MatchLineup>> lineupsAsync;

  const LineupSection({super.key, required this.lineupsAsync});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: CustomColor.gray900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text(
              '라인업',
              style: CustomTextStyle.body1.copyWith(
                color: CustomColor.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          lineupsAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: CircularProgressIndicator(color: CustomColor.white),
              ),
            ),
            error: (_, __) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Text(
                '라인업 정보를 불러오지 못했습니다',
                style: CustomTextStyle.body2.copyWith(color: CustomColor.gray500),
              ),
            ),
            data: (lineups) {
              if (lineups.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: Text(
                    '라인업 정보가 없습니다',
                    style: CustomTextStyle.body2.copyWith(color: CustomColor.gray500),
                  ),
                );
              }

              return Column(
                children: [
                  Stack(
                    children: [
                      const _FieldBackground(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: lineups
                              .map((l) => Expanded(child: _LineupCard(lineup: l)))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LineupCard extends StatelessWidget {
  final MatchLineup lineup;

  const _LineupCard({required this.lineup});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          lineup.formation.isEmpty ? '-' : lineup.formation,
          style: CustomTextStyle.heading1.copyWith(
            color: CustomColor.main,
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          lineup.teamName,
          style: CustomTextStyle.body3.copyWith(
            color: CustomColor.white,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          lineup.coachName.isEmpty ? '' : '감독  ${lineup.coachName}',
          style: CustomTextStyle.body3.copyWith(color: CustomColor.gray500),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _FieldBackground extends StatelessWidget {
  const _FieldBackground();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      width: double.infinity,
      child: CustomPaint(painter: _FieldPainter()),
    );
  }
}

class _FieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final w = size.width;
    final h = size.height;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(8, 8, w - 16, h - 16),
        const Radius.circular(8),
      ),
      paint,
    );
    canvas.drawLine(Offset(w / 2, 8), Offset(w / 2, h - 8), paint);
    canvas.drawCircle(Offset(w / 2, h / 2), 24, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
