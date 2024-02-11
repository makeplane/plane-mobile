import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_button.dart';
import 'package:plane/widgets/custom_text.dart';

class CustomDateRangePickerSheet extends ConsumerStatefulWidget {
  const CustomDateRangePickerSheet(
      {required this.clearDate, required this.applyDate, super.key});
  final VoidCallback clearDate;
  final Function(List<String> selectedRange) applyDate;
  @override
  ConsumerState<CustomDateRangePickerSheet> createState() =>
      _CustomDateRangePickerSheetState();
}

class _CustomDateRangePickerSheetState
    extends ConsumerState<CustomDateRangePickerSheet> {
  List<DateTime?> selectedRange = [];

  void applyDates() {
    if (selectedRange.length != 2) {
      CustomToast.showToast(context,
          message: 'Please select a date range', toastType: ToastType.warning);
      return;
    }
    widget.applyDate([
      '${selectedRange[0].toString().split(' ')[0]};after',
      '${selectedRange[1].toString().split(' ')[0]};before'
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ref.read(ProviderList.themeProvider).themeManager;
    return Wrap(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
          child: Row(
            children: [
              const CustomText(
                'Custom Date',
                type: FontStyle.H4,
                fontWeight: FontWeightt.Semibold,
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  size: 27,
                  color: themeManager.placeholderTextColor,
                ),
              ),
            ],
          ),
        ),
        CalendarDatePicker2(
          config: CalendarDatePicker2Config(
            calendarType: CalendarDatePicker2Type.range,
            selectedDayHighlightColor: themeManager.primaryColour,
            weekdayLabelTextStyle: TextStyle(
              color: themeManager.primaryTextColor,
              fontWeight: FontWeight.bold,
            ),
            controlsTextStyle: TextStyle(
              color: themeManager.primaryTextColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            dayTextStyle: TextStyle(
              color: themeManager.secondaryTextColor,
            ),
          ),
          value: selectedRange,
          onValueChanged: (dates) => setState(() => selectedRange = dates),
        ),
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Button(
                  text: 'Clear',
                  filledButton: false,
                  color: themeManager.primaryBackgroundDefaultColor,
                  ontap: widget.clearDate,
                  textColor: themeManager.secondaryTextColor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Button(
                  text: 'Apply',
                  ontap: applyDates,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
