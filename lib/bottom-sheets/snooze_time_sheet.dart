import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/provider/theme_provider.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/widgets/custom_divider.dart';
import 'package:plane/widgets/custom_text.dart';

import '../utils/enums.dart';

class SnoozeTimeSheet extends ConsumerStatefulWidget {
  const SnoozeTimeSheet({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SnoozeTimeSheetState();
}

class _SnoozeTimeSheetState extends ConsumerState<SnoozeTimeSheet> {
  bool isPmSelected = false;
  DateTime? selectedDateTime = DateTime.now();

  List<DateTime> dateTimeList = [
    DateTime.now().copyWith(hour: 12, minute: 0),
    DateTime.now().copyWith(hour: 12, minute: 30),
    //
    DateTime.now().copyWith(hour: 1, minute: 0),
    DateTime.now().copyWith(hour: 1, minute: 30),
    //
    DateTime.now().copyWith(hour: 2, minute: 0),
    DateTime.now().copyWith(hour: 2, minute: 30),
    //
    DateTime.now().copyWith(hour: 3, minute: 0),
    DateTime.now().copyWith(hour: 3, minute: 30),
    //
    DateTime.now().copyWith(hour: 4, minute: 0),
    DateTime.now().copyWith(hour: 4, minute: 30),
    //
    DateTime.now().copyWith(hour: 5, minute: 0),
    DateTime.now().copyWith(hour: 5, minute: 30),
    //
    DateTime.now().copyWith(hour: 6, minute: 0),
    DateTime.now().copyWith(hour: 6, minute: 30),
    //
    DateTime.now().copyWith(hour: 7, minute: 0),
    DateTime.now().copyWith(hour: 7, minute: 30),
    //
    DateTime.now().copyWith(hour: 8, minute: 0),
    DateTime.now().copyWith(hour: 8, minute: 30),
    //
    DateTime.now().copyWith(hour: 9, minute: 0),
    DateTime.now().copyWith(hour: 9, minute: 30),
    //
    DateTime.now().copyWith(hour: 10, minute: 0),
    DateTime.now().copyWith(hour: 10, minute: 30),
    //
    DateTime.now().copyWith(hour: 11, minute: 0),
    DateTime.now().copyWith(hour: 11, minute: 30),
  ];

  @override
  Widget build(BuildContext context) {
    final notificationProvider = ref.watch(ProviderList.notificationProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 23, left: 23, right: 23),
      child: Wrap(
        children: [
          Row(
            children: [
              const CustomText(
                'Snooze until...',
                type: FontStyle.H6,
                fontWeight: FontWeightt.Semibold,
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  //add 1 day to date time now
                  notificationProvider.snoozedDate = null;

                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  size: 27,
                  color: themeProvider.themeManager.placeholderTextColor,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 50,
            width: double.infinity,
            child: InkWell(
              onTap: () {
                notificationProvider.snoozedDate = DateTime.now().add(
                  const Duration(days: 1),
                );
                Navigator.pop(context);
              },
              child: const CustomText(
                '1 day',
                type: FontStyle.Small,
              ),
            ),
          ),
          CustomDivider(themeProvider: themeProvider),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 50,
            width: double.infinity,
            child: InkWell(
              onTap: () {
                notificationProvider.snoozedDate = DateTime.now().add(
                  const Duration(days: 2),
                );
                Navigator.pop(context);
              },
              child: const CustomText(
                '2 days',
                type: FontStyle.Small,
              ),
            ),
          ),
          CustomDivider(themeProvider: themeProvider),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 50,
            width: double.infinity,
            child: InkWell(
              onTap: () {
                notificationProvider.snoozedDate = DateTime.now().add(
                  const Duration(days: 5),
                );
                Navigator.pop(context);
              },
              child: const CustomText(
                '5 days',
                type: FontStyle.Small,
              ),
            ),
          ),
          CustomDivider(themeProvider: themeProvider),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 50,
            width: double.infinity,
            child: InkWell(
              onTap: () {
                notificationProvider.snoozedDate = DateTime.now().add(
                  const Duration(days: 7),
                );
                Navigator.pop(context);
              },
              child: const CustomText(
                '1 week',
                type: FontStyle.Small,
              ),
            ),
          ),
          CustomDivider(themeProvider: themeProvider),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 50,
            width: double.infinity,
            child: InkWell(
              onTap: () {
                notificationProvider.snoozedDate = DateTime.now().add(
                  const Duration(days: 14),
                );
                Navigator.pop(context);
              },
              child: const CustomText(
                '2 weeks',
                type: FontStyle.Small,
              ),
            ),
          ),
          CustomDivider(themeProvider: themeProvider),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 50,
            width: double.infinity,
            child: InkWell(
              onTap: () async {
                //show date time picker
                DateTime? date = await showDatePicker(
                  builder: (context, child) => Theme(
                    data: themeProvider.themeManager.datePickerThemeData,
                    child: child!,
                  ),
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2025),
                );

                // final time = await showTimePicker(
                //   builder: (context, child) => Theme(
                //     data: themeProvider.themeManager.timePickerThemeData,
                //     child: child!,
                //   ),
                //   context: context,
                //   initialTime: TimeOfDay.now(),
                // );

                // ignore: use_build_context_synchronously
                await showDialog(
                  context: context,
                  builder: (context) {
                    return customTimePicker(themeProvider);
                  },
                );
                if (isPmSelected && selectedDateTime != null) {
                  selectedDateTime = selectedDateTime!
                      .copyWith(hour: selectedDateTime!.hour + 12);
                }

                if (date != null) {
                  date = date.copyWith(
                      hour: selectedDateTime!.hour,
                      minute: selectedDateTime!.minute);
                  notificationProvider.snoozedDate = date;
                }

                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: const CustomText(
                'Custom',
                type: FontStyle.Small,
              ),
            ),
          ),
          Container(height: bottomSheetConstBottomPadding),
        ],
      ),
    );
  }

  AlertDialog customTimePicker(ThemeProvider themeProvider) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
              color: themeProvider.themeManager.borderSubtle01Color)),
      backgroundColor: themeProvider.themeManager.primaryBackgroundDefaultColor,
      title: const CustomText('Pick a time'),
      content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.75,
          height: MediaQuery.of(context).size.height * 0.5,
          color: themeProvider.themeManager.primaryBackgroundDefaultColor,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isPmSelected = false;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        height: 40,
                        color: !isPmSelected
                            ? themeProvider.themeManager.primaryColour
                            : themeProvider
                                .themeManager.tertiaryBackgroundDefaultColor,
                        child: Center(
                            child: CustomText(
                          'AM',
                          color: !isPmSelected
                              ? Colors.white
                              : themeProvider.themeManager.primaryTextColor,
                        )),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isPmSelected = true;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        height: 40,
                        color: isPmSelected
                            ? themeProvider.themeManager.primaryColour
                            : themeProvider
                                .themeManager.tertiaryBackgroundDefaultColor,
                        child: Center(
                          child: CustomText(
                            'PM',
                            color: isPmSelected
                                ? Colors.white
                                : themeProvider.themeManager.primaryTextColor,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: dateTimeList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedDateTime = dateTimeList[index].toUtc();
                          Navigator.pop(context);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: CustomText(
                            DateFormat.Hm().format(dateTimeList[index])),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
