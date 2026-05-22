import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/core/constants/color.dart';

class DatePickerBottomSheet extends StatefulWidget {
  final DateTime? initialDate;

  const DatePickerBottomSheet({super.key, this.initialDate});

  static Future<DateTime?> show(BuildContext context,
      {DateTime? initialDate}) async {
    return showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DatePickerBottomSheet(initialDate: initialDate),
    );
  }

  @override
  State<DatePickerBottomSheet> createState() => _DatePickerBottomSheetState();
}

class _DatePickerBottomSheetState extends State<DatePickerBottomSheet> {
  late DateTime _focusedMonth;
  DateTime? _selected;

  static const _weekdays = ['일', '월', '화', '수', '목', '금', '토'];

  @override
  void initState() {
    super.initState();
    final base = widget.initialDate ?? DateTime.now();
    _selected = widget.initialDate;
    _focusedMonth = DateTime(base.year, base.month);
  }

  String _dayOfWeekKo(DateTime d) => _weekdays[d.weekday % 7];

  String get _selectedLabel {
    if (_selected == null) return '공지방이 삭제될 날짜를 선택하세요.';
    final d = _selected!;
    return '${d.month}월 ${d.day}일(${_dayOfWeekKo(d)}) 선택';
  }

  String get _headerLabel =>
      '${_focusedMonth.year}년 ${_focusedMonth.month}월';

  List<DateTime?> _buildCalendarDays() {
    final firstDay = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final lastDay = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);
    final startOffset = firstDay.weekday % 7;

    final days = <DateTime?>[];
    for (int i = 0; i < startOffset; i++) {
      days.add(null);
    }
    for (int i = 1; i <= lastDay.day; i++) {
      days.add(DateTime(_focusedMonth.year, _focusedMonth.month, i));
    }
    return days;
  }

  bool _isSameDay(DateTime? a, DateTime? b) =>
      a != null &&
      b != null &&
      a.year == b.year &&
      a.month == b.month &&
      a.day == b.day;

  bool _isBeforeToday(DateTime d) {
    final today = DateTime.now();
    return d.isBefore(DateTime(today.year, today.month, today.day));
  }

  @override
  Widget build(BuildContext context) {
    final days = _buildCalendarDays();
    final today = DateTime.now();

    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: CustomColor.gray950,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppSpacing.h12,
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: CustomColor.gray500,
                borderRadius: AppRadius.xs,
              ),
            ),
            AppSpacing.h12,
            Padding(
              padding: AppPadding.pageH,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _focusedMonth =
                        DateTime(_focusedMonth.year, _focusedMonth.month - 1)),
                    child: const Icon(Symbols.chevron_left,
                        color: CustomColor.white),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        _headerLabel,
                        style: CustomTextStyle.heading2
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _focusedMonth =
                        DateTime(_focusedMonth.year, _focusedMonth.month + 1)),
                    child: const Icon(Symbols.chevron_right,
                        color: CustomColor.white),
                  ),
                ],
              ),
            ),
            AppSpacing.h12,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: List.generate(7, (i) {
                  final isSun = i == 0;
                  final isSat = i == 6;
                  return Expanded(
                    child: Center(
                      child: Text(
                        _weekdays[i],
                        style: CustomTextStyle.body2.copyWith(
                          color: isSun
                              ? CustomColor.red
                              : isSat
                              ? CustomColor.blue
                              : CustomColor.white,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            AppSpacing.h4,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1,
                ),
                itemCount: days.length,
                itemBuilder: (_, i) {
                  final date = days[i];
                  if (date == null) return const SizedBox();

                  final isSelected = _isSameDay(date, _selected);
                  final isToday = _isSameDay(date, today);
                  final isPast = _isBeforeToday(date);
                  final isSun = date.weekday % 7 == 0;

                  Color textColor;
                  if (isSelected) {
                    textColor = CustomColor.white;
                  } else if (isPast) {
                    textColor = CustomColor.gray500;
                  } else if (isSun) {
                    textColor = CustomColor.red;
                  } else {
                    textColor = CustomColor.white;
                  }

                  return GestureDetector(
                    onTap: isPast
                        ? null
                        : () => setState(() => _selected = date),
                    child: Center(
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? CustomColor.main
                              : isToday
                                  ? CustomColor.main.withValues(alpha: 0.12)
                                  : null,
                          border: isToday && !isSelected
                              ? Border.all(
                                  color: CustomColor.main, width: 1.5)
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            '${date.day}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected || isToday
                                  ? FontWeight.w700
                                  : FontWeight.normal,
                              color: textColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            AppSpacing.h16,
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selected != null
                      ? () => Navigator.pop(context, _selected)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColor.main,
                    disabledBackgroundColor: CustomColor.gray500.withValues(alpha: 0.3),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.md,
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _selectedLabel,
                    style: const TextStyle(
                      color: CustomColor.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
