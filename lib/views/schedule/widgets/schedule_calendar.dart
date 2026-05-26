import 'package:twelfth_mobile/core/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';

class ScheduleCalendar extends StatelessWidget {
  const ScheduleCalendar({
    super.key,
    required this.focusedMonth,
    required this.selectedDate,
    required this.onPrevMonth,
    required this.onNextMonth,
    required this.onDateSelected,
    required this.onHeaderTap,
    this.matchDates = const {},
  });

  final DateTime focusedMonth;
  final DateTime selectedDate;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback? onHeaderTap;
  final Set<String> matchDates; // "YYYY-MM-DD" 형식의 경기 날짜들

  static const _weekLabels = ['일', '월', '화', '수', '목', '금', '토'];

  @override
  Widget build(BuildContext context) {
    final year = focusedMonth.year;
    final month = focusedMonth.month;
    final firstWeekday = DateTime(year, month, 1).weekday % 7;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final prevMonthDays = DateTime(year, month, 0).day;

    return Padding(
      padding: AppPadding.cardH,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: onPrevMonth,
                  behavior: HitTestBehavior.opaque,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: CustomColor.white,
                      size: 12,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onHeaderTap,
                  child: Text('$year년 $month월', style: CustomTextStyle.heading2),
                ),
                GestureDetector(
                  onTap: onNextMonth,
                  behavior: HitTestBehavior.opaque,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: CustomColor.white,
                      size: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: List.generate(7, (i) {
              final color = i == 0
                  ? CustomColor.red
                  : i == 6
                  ? CustomColor.blue
                  : CustomColor.gray600;
              return Expanded(
                child: Center(
                  child: Text(
                    _weekLabels[i],
                    style: CustomTextStyle.body3.copyWith(color: color),
                  ),
                ),
              );
            }),
          ),
          ...List.generate(6, (row) {
            return Row(
              children: List.generate(7, (col) {
                final cellIndex = row * 7 + col;
                int day;
                bool isCurrentMonth;

                if (cellIndex < firstWeekday) {
                  day = prevMonthDays - firstWeekday + cellIndex + 1;
                  isCurrentMonth = false;
                } else {
                  final d = cellIndex - firstWeekday + 1;
                  if (d > daysInMonth) {
                    day = d - daysInMonth;
                    isCurrentMonth = false;
                  } else {
                    day = d;
                    isCurrentMonth = true;
                  }
                }

                final date = isCurrentMonth
                    ? DateTime(year, month, day)
                    : (cellIndex < firstWeekday
                          ? DateTime(year, month - 1, day)
                          : DateTime(year, month + 1, day));

                final isSelected =
                    selectedDate.year == date.year &&
                    selectedDate.month == date.month &&
                    selectedDate.day == date.day;

                final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                final hasMatch = matchDates.contains(dateKey);

                Color textColor;
                if (!isCurrentMonth) {
                  textColor = CustomColor.gray900;
                } else if (isSelected) {
                  textColor = CustomColor.black;
                } else if (col == 0) {
                  textColor = CustomColor.red;
                } else if (col == 6) {
                  textColor = CustomColor.blue;
                } else {
                  textColor = CustomColor.white;
                }

                return Expanded(
                  child: GestureDetector(
                    onTap: isCurrentMonth ? () => onDateSelected(date) : null,
                    child: SizedBox(
                      height: 34,
                      child: Center(
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: isSelected
                              ? const BoxDecoration(
                                  color: CustomColor.main,
                                  shape: BoxShape.circle,
                                )
                              : null,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$day',
                                  style: CustomTextStyle.body2.copyWith(
                                    color: textColor,
                                  ),
                                ),
                                if (hasMatch && isCurrentMonth) ...[
                                  const SizedBox(height: 2),
                                  Container(
                                    width: 4,
                                    height: 4,
                                    decoration: const BoxDecoration(
                                      color: CustomColor.main,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }
}
