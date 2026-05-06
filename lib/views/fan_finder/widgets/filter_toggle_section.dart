import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/core/constants/spacing.dart';
import 'package:twelfth_mobile/views/fan_finder/fan_finder_constants.dart';

class FilterToggleSection extends StatefulWidget {
  final String title;
  final List<String> options;
  final Set<String> selectedItems;
  final ValueChanged<String> onToggleItem;
  final bool initiallyExpanded;

  const FilterToggleSection({
    super.key,
    required this.title,
    required this.options,
    required this.selectedItems,
    required this.onToggleItem,
    this.initiallyExpanded = false,
  });

  @override
  State<FilterToggleSection> createState() => _FilterToggleSectionState();
}

class _FilterToggleSectionState extends State<FilterToggleSection>
    with SingleTickerProviderStateMixin {
  late bool _expanded;
  late AnimationController _controller;
  late Animation<double> _arrowTurn;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      value: _expanded ? 1.0 : 0.0,
    );
    _arrowTurn = Tween<double>(begin: 0, end: 0.25).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    if (_expanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  int get _selectedCount =>
      widget.options.where((o) => widget.selectedItems.contains(o)).length;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _toggle,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                RotationTransition(
                  turns: _arrowTurn,
                  child: const Icon(
                    Symbols.chevron_right,
                    color: CustomColor.gray500,
                    size: 18,
                  ),
                ),
                AppSpacing.w6,
                Text(
                  widget.title,
                  style: CustomTextStyle.heading3.copyWith(
                    color: CustomColor.white,
                  ),
                ),
                if (_selectedCount > 0) ...[
                  AppSpacing.w6,
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: CustomColor.main,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$_selectedCount',
                      style: CustomTextStyle.body3.copyWith(
                        color: CustomColor.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: _expanded
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: SizedBox(
                    height: FanFinderConstants.tagRowHeight,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.options.length,
                      separatorBuilder: (_, __) => AppSpacing.w8,
                      itemBuilder: (context, index) {
                        final item = widget.options[index];
                        final selected = widget.selectedItems.contains(item);
                        return GestureDetector(
                          onTap: () => widget.onToggleItem(item),
                          child: Container(
                            alignment: Alignment.center,
                            padding: FanFinderConstants.tagChipPadding,
                            decoration: BoxDecoration(
                              color: selected
                                  ? CustomColor.main
                                  : Colors.transparent,
                              border: Border.all(
                                color: selected
                                    ? CustomColor.main
                                    : CustomColor.gray600,
                              ),
                              borderRadius: FanFinderConstants.tagChipRadius,
                            ),
                            child: Text(
                              item,
                              style: CustomTextStyle.body2.copyWith(
                                color: selected
                                    ? CustomColor.black
                                    : CustomColor.gray500,
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
