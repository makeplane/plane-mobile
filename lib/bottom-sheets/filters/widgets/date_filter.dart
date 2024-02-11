import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/bottom-sheets/custom_date.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/bottom_sheet.helper.dart';
import 'package:plane/widgets/custom_expansion_tile.dart';
import 'package:plane/widgets/rectangular_chip.dart';

class DateFilter extends ConsumerStatefulWidget {
  const DateFilter(
      {required this.title,
      required this.filterDates,
      required this.onChange,
      super.key});
  final String title;
  final List<String> filterDates;
  final Function(String date) onChange;
  @override
  ConsumerState<DateFilter> createState() => _DateFilterState();
}

class _DateFilterState extends ConsumerState<DateFilter> {
  List<String> selectedFilters = [];
  List<Map<String, dynamic>> options = [];

  /// For custom date range picker
  void clearDate() {
    setState(() {
      selectedFilters = [];
    });
  }

  void applyDate(List<String> selectedRange) {
    // widget.onChange(selectedRange);
  }

  @override
  void initState() {
    options = [
      {'title': '1 Week from now', 'value': '1_weeks;after;fromnow'},
      {'title': '2 Weeks from now', 'value': '2_weeks;after;fromnow'},
      {'title': '1 Month from now', 'value': '1_months;after;fromnow'},
      {'title': '2 Month from now', 'value': '2_months;after;fromnow'},
      {'title': 'Custom Date', 'value': ''}
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ref.read(ProviderList.themeProvider).themeManager;
    return CustomExpansionTile(
      title: widget.title,
      child: Wrap(
          children: options.map((option) {
        final isSelected = widget.filterDates.contains(option['value']);
        return GestureDetector(
          onTap: () {
            if (option['title'] == 'Custom Date') {
              BottomSheetHelper.showBottomSheet(
                  context,
                  CustomDateRangePickerSheet(
                    applyDate: applyDate,
                    clearDate: clearDate,
                  ));
            } else {
              widget.onChange(option['value']);
            }
          },
          child: RectangularChip(
            ref: ref,
            icon: Icon(
              Icons.calendar_today_outlined,
              size: 15,
              color:
                  isSelected ? Colors.white : themeManager.placeholderTextColor,
            ),
            text: 'Last Week',
            selected: isSelected,
            color: isSelected
                ? themeManager.primaryColour
                : themeManager.secondaryBackgroundDefaultColor,
          ),
        );
      }).toList()),
    );
  }
}
