part of '../filter_sheet.dart';

class _DueDateFilter extends ConsumerStatefulWidget {
  const _DueDateFilter({required this.state});
  final _FilterState state;

  @override
  ConsumerState<_DueDateFilter> createState() => __DueDateFilterState();
}

class __DueDateFilterState extends ConsumerState<_DueDateFilter> {
  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = ref.read(ProviderList.themeProvider);
    return CustomExpansionTile(
      title: 'Due Date',
      child: Wrap(
        children: [
          GestureDetector(
            onTap: () {
              if (widget.state.targetLastWeek) {
                widget.state.filters.targetDate = [];
              } else {
                widget.state.filters.targetDate = [
                  '${DateTime.now().subtract(const Duration(days: 7)).toString().split(' ')[0]};after',
                  '${DateTime.now().toString().split(' ')[0]};before'
                ];
              }
              widget.state.targetDatesEnabled();
              widget.state.setState();
            },
            child: RectangularChip(
              ref: ref,
              icon: Icon(
                Icons.calendar_today_outlined,
                size: 15,
                color: widget.state.targetLastWeek
                    ? Colors.white
                    : themeProvider.themeManager.placeholderTextColor,
              ),
              text: 'Last Week',
              selected: widget.state.targetLastWeek,
              color: widget.state.targetLastWeek
                  ? themeProvider.themeManager.primaryColour
                  : themeProvider.themeManager.secondaryBackgroundDefaultColor,
            ),
          ),
          GestureDetector(
            onTap: () {
              if (widget.state.targetTwoWeeks) {
                widget.state.filters.targetDate = [];
              } else {
                widget.state.filters.targetDate = [
                  '${DateTime.now().toString().split(' ')[0]};after',
                  '${DateTime.now().add(const Duration(days: 14)).toString().split(' ')[0]};before'
                ];
              }
              widget.state.targetDatesEnabled();
              widget.state.setState();
            },
            child: RectangularChip(
              ref: ref,
              icon: Icon(
                Icons.calendar_today_outlined,
                size: 15,
                color: widget.state.targetTwoWeeks
                    ? Colors.white
                    : themeProvider.themeManager.placeholderTextColor,
              ),
              text: '2 Weeks from now',
              selected: widget.state.targetTwoWeeks,
              color: widget.state.targetTwoWeeks
                  ? themeProvider.themeManager.primaryColour
                  : themeProvider.themeManager.secondaryBackgroundDefaultColor,
            ),
          ),
          GestureDetector(
            onTap: () {
              if (widget.state.targetOneMonth) {
                widget.state.filters.targetDate = [];
              } else {
                widget.state.filters.targetDate = [
                  '${DateTime.now().toString().split(' ')[0]};after',
                  '${DateTime.now().add(const Duration(days: 30)).toString().split(' ')[0]};before'
                ];
              }

              widget.state.targetDatesEnabled();
              widget.state.setState();
            },
            child: RectangularChip(
              ref: ref,
              icon: Icon(
                Icons.calendar_today_outlined,
                size: 15,
                color: widget.state.targetOneMonth
                    ? Colors.white
                    : themeProvider.themeManager.placeholderTextColor,
              ),
              text: '1 Month from now',
              selected: widget.state.targetOneMonth,
              color: widget.state.targetOneMonth
                  ? themeProvider.themeManager.primaryColour
                  : themeProvider.themeManager.secondaryBackgroundDefaultColor,
            ),
          ),
          GestureDetector(
            onTap: () {
              if (widget.state.targetTwoMonths) {
                widget.state.filters.targetDate = [];
              } else {
                widget.state.filters.targetDate = [
                  '${DateTime.now().toString().split(' ')[0]};after',
                  '${DateTime.now().add(const Duration(days: 60)).toString().split(' ')[0]};before'
                ];
              }
              widget.state.targetDatesEnabled();
              widget.state.setState();
            },
            child: RectangularChip(
              ref: ref,
              icon: Icon(
                Icons.calendar_today_outlined,
                size: 15,
                color: widget.state.targetTwoMonths
                    ? Colors.white
                    : themeProvider.themeManager.placeholderTextColor,
              ),
              text: '2 Months from now',
              selected: widget.state.targetTwoMonths,
              color: widget.state.targetTwoMonths
                  ? themeProvider.themeManager.primaryColour
                  : themeProvider.themeManager.secondaryBackgroundDefaultColor,
            ),
          ),
          GestureDetector(
            onTap: () async {
              showModalBottomSheet(
                  isScrollControlled: true,
                  enableDrag: true,
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.85),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
                  context: context,
                  builder: (ctx) {
                    return Wrap(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              top: 15, left: 15, right: 15),
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
                                  color: themeProvider
                                      .themeManager.placeholderTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CalendarDatePicker2(
                          config: CalendarDatePicker2Config(
                            calendarType: CalendarDatePicker2Type.range,
                            selectedDayHighlightColor:
                                themeProvider.themeManager.primaryColour,
                            weekdayLabelTextStyle: TextStyle(
                              color:
                                  themeProvider.themeManager.primaryTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                            controlsTextStyle: TextStyle(
                              color:
                                  themeProvider.themeManager.primaryTextColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            dayTextStyle: TextStyle(
                              color:
                                  themeProvider.themeManager.secondaryTextColor,
                            ),
                          ),
                          value: widget.state
                              ._targetRangeDatePickerValueWithDefaultValue,
                          onValueChanged: (dates) => setState(() => widget.state
                                  ._targetRangeDatePickerValueWithDefaultValue =
                              dates),
                        ),

                        // two buttons taking up the whole width of the bottom sheet one to cancel and one to apply

                        Container(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Button(
                                  text: 'Clear',
                                  filledButton: false,
                                  color: themeProvider.themeManager
                                      .primaryBackgroundDefaultColor,
                                  ontap: () {
                                    widget.state.filters.targetDate = [];
                                    widget.state.targetDatesEnabled();
                                    widget.state.setState();
                                    Navigator.pop(context);
                                  },
                                  textColor: themeProvider
                                      .themeManager.secondaryTextColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Button(
                                  text: 'Apply',
                                  ontap: () {
                                    if (widget
                                            .state
                                            ._targetRangeDatePickerValueWithDefaultValue
                                            .length !=
                                        2) {
                                      CustomToast.showToast(context,
                                          message: 'Please select a date range',
                                          toastType: ToastType.warning);
                                      return;
                                    }

                                    widget.state.filters.targetDate = [
                                      '${widget.state._targetRangeDatePickerValueWithDefaultValue[0].toString().split(' ')[0]};after',
                                      '${widget.state._targetRangeDatePickerValueWithDefaultValue[1].toString().split(' ')[0]};before'
                                    ];
                                    widget.state.targetDatesEnabled();

                                    widget.state.setState();
                                    Navigator.pop(context);
                                  },
                                  textColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  });
            },
            child: RectangularChip(
              ref: ref,
              icon: Icon(
                Icons.calendar_today_outlined,
                size: 15,
                color: widget.state.targetCustomDate
                    ? Colors.white
                    : themeProvider.themeManager.secondaryTextColor,
              ),
              text: 'Custom Date',
              selected: widget.state.targetCustomDate,
              color: widget.state.targetCustomDate
                  ? themeProvider.themeManager.primaryColour
                  : themeProvider.themeManager.secondaryBackgroundDefaultColor,
            ),
          ),
        ],
      ),
    );
  }
}
