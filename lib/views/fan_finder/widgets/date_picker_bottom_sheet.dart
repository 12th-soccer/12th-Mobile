import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/core/constants/color.dart';

class DatePickerBottomSheet extends StatefulWidget {
  final DateTime? initialDate;

  const DatePickerBottomSheet({super.key, this.initialDate});

  static Future<DateTime?> show(
    BuildContext context, {
    DateTime? initialDate,
  }) async {
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
  static const _timeItemExtent = 44.0;
  static const _timePickerHeight = 220.0;

  late DateTime _focusedMonth;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  late final FixedExtentScrollController _hourController;
  late final FixedExtentScrollController _minuteController;

  static const _weekdays = ['일', '월', '화', '수', '목', '금', '토'];

  @override
  void initState() {
    super.initState();
    final base = widget.initialDate ?? DateTime.now();
    _selectedDate = widget.initialDate != null
        ? DateTime(base.year, base.month, base.day)
        : null;
    _selectedTime = widget.initialDate != null
        ? TimeOfDay(hour: base.hour, minute: base.minute)
        : const TimeOfDay(hour: 18, minute: 0);
    _focusedMonth = DateTime(base.year, base.month);
    _hourController = FixedExtentScrollController(
      initialItem: _selectedTime!.hour,
    );
    _minuteController = FixedExtentScrollController(
      initialItem: _selectedTime!.minute,
    );
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  String _dayOfWeekKo(DateTime d) => _weekdays[d.weekday % 7];

  DateTime? get _selectedDateTime {
    final date = _selectedDate;
    final time = _selectedTime;
    if (date == null || time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  String get _selectedLabel {
    final date = _selectedDate;
    final time = _selectedTime;
    if (date == null) return '만료 날짜를 선택하세요.';
    if (time == null) return '만료 시간을 선택하세요.';
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '${date.month}월 ${date.day}일(${_dayOfWeekKo(date)}) $hour:$minute';
  }

  String get _headerLabel => '${_focusedMonth.year}년 ${_focusedMonth.month}월';

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

  bool get _canSubmit {
    final selected = _selectedDateTime;
    return selected != null && selected.isAfter(DateTime.now());
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  Widget _buildTimeWheel({
    required FixedExtentScrollController controller,
    required int itemCount,
    required int selectedIndex,
    required ValueChanged<int> onSelectedItemChanged,
    required String Function(int index) labelBuilder,
    required bool enabled,
  }) {
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: _timeItemExtent,
      diameterRatio: 1.4,
      perspective: 0.01,
      physics: enabled
          ? const FixedExtentScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      onSelectedItemChanged: onSelectedItemChanged,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: itemCount,
        builder: (context, index) {
          final isSelected = index == selectedIndex;
          return Center(
            child: Text(
              labelBuilder(index),
              style: CustomTextStyle.heading2.copyWith(
                color: isSelected ? CustomColor.black : CustomColor.gray500,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimePicker() {
    final enabled = _selectedDate != null;
    final selectedHour = _selectedTime?.hour ?? 18;
    final selectedMinute = _selectedTime?.minute ?? 0;
    final overlayColor = enabled ? CustomColor.main : CustomColor.gray800;

    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: IgnorePointer(
        ignoring: !enabled,
        child: Container(
          height: _timePickerHeight,
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 0,
                right: 0,
                child: Container(
                  height: _timeItemExtent + 8,
                  decoration: BoxDecoration(
                    color: overlayColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildTimeWheel(
                      controller: _hourController,
                      itemCount: 24,
                      selectedIndex: selectedHour,
                      enabled: enabled,
                      labelBuilder: _twoDigits,
                      onSelectedItemChanged: (hour) {
                        setState(() {
                          final minute = _selectedTime?.minute ?? 0;
                          _selectedTime = TimeOfDay(hour: hour, minute: minute);
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      '시',
                      style: CustomTextStyle.heading2.copyWith(
                        color: CustomColor.gray950,
                      ),
                    ),
                  ),
                  AppSpacing.w10,
                  Expanded(
                    child: _buildTimeWheel(
                      controller: _minuteController,
                      itemCount: 60,
                      selectedIndex: selectedMinute,
                      enabled: enabled,
                      labelBuilder: _twoDigits,
                      onSelectedItemChanged: (minute) {
                        setState(() {
                          final hour = _selectedTime?.hour ?? 18;
                          _selectedTime = TimeOfDay(hour: hour, minute: minute);
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      '분',
                      style: CustomTextStyle.heading2.copyWith(
                        color: CustomColor.gray950,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final days = _buildCalendarDays();
    final today = DateTime.now();
    final selectedDateTime = _selectedDateTime;

    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Container(
          decoration: const BoxDecoration(
            color: CustomColor.gray950,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
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
                      onTap: () => setState(
                        () => _focusedMonth = DateTime(
                          _focusedMonth.year,
                          _focusedMonth.month - 1,
                        ),
                      ),
                      child: const Icon(
                        Symbols.chevron_left,
                        color: CustomColor.white,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          _headerLabel,
                          style: CustomTextStyle.heading2,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(
                        () => _focusedMonth = DateTime(
                          _focusedMonth.year,
                          _focusedMonth.month + 1,
                        ),
                      ),
                      child: const Icon(
                        Symbols.chevron_right,
                        color: CustomColor.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
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
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 7,
                                childAspectRatio: 1,
                              ),
                          itemCount: days.length,
                          itemBuilder: (_, i) {
                            final date = days[i];
                            if (date == null) return const SizedBox();

                            final isSelected = _isSameDay(date, _selectedDate);
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
                                  : () => setState(() {
                                      _selectedDate = date;
                                    }),
                              child: Center(
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected
                                        ? CustomColor.main
                                        : isToday
                                        ? CustomColor.main.withValues(
                                            alpha: 0.12,
                                          )
                                        : null,
                                    border: isToday && !isSelected
                                        ? Border.all(
                                            color: CustomColor.main,
                                            width: 1.5,
                                          )
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
                      _buildTimePicker(),
                      if (_selectedDate != null &&
                          selectedDateTime != null &&
                          !selectedDateTime.isAfter(DateTime.now())) ...[
                        AppSpacing.h8,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '현재 시각 이후의 만료 시간을 선택해 주세요.',
                            style: CustomTextStyle.body3.copyWith(
                              color: CustomColor.red,
                            ),
                          ),
                        ),
                      ],
                      AppSpacing.h16,
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _canSubmit
                        ? () => Navigator.pop(context, _selectedDateTime)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColor.main,
                      disabledBackgroundColor: CustomColor.gray500.withValues(
                        alpha: 0.3,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
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
      ),
    );
  }
}
