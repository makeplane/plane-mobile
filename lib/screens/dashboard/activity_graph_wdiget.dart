import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/dashboard/dates_model.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';

class ActivityGraphWidget extends ConsumerStatefulWidget {
  const ActivityGraphWidget({super.key});

  @override
  ConsumerState<ActivityGraphWidget> createState() =>
      _ActivityGraphWidgetState();
}

class _ActivityGraphWidgetState extends ConsumerState<ActivityGraphWidget> {
  ScrollController gridScrollController = ScrollController();
  ScrollController listScrollController = ScrollController();
  List<MonthData>? monthsData;
  List data = [];
  List defaultDays = [
    'Sun',
    'Tue',
    'Thu',
    'Sat',
  ];

  @override
  void initState() {
    super.initState();
    gridScrollController.addListener(() {
      listScrollController.jumpTo(
        gridScrollController.offset,
      );
    });
    monthsData = getMonthsData(6);
    allMonthsData();
  }

  @override
  void dispose() {
    gridScrollController.dispose();
    listScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final List activityRangeColors = [
      themeProvider.themeManager.tertiaryBackgroundDefaultColor,
      themeProvider.themeManager.primaryColour.withOpacity(0.2),
      themeProvider.themeManager.primaryColour.withOpacity(0.4),
      themeProvider.themeManager.primaryColour.withOpacity(0.8),
      themeProvider.themeManager.primaryColour,
    ];

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            'Activity Graph',
            type: FontStyle.Medium,
            fontWeight: FontWeightt.Medium,
            color: themeProvider.themeManager.primaryTextColor,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                  color: themeProvider.themeManager.borderSubtle01Color),
            ),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 25,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 45,
                      ),
                      Expanded(
                        child: ListView.builder(
                          controller: listScrollController,
                          shrinkWrap: true,
                          primary: false,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: monthsData!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: 75,
                              child: CustomText(
                                monthsData![index]
                                    .month
                                    .split(' ')
                                    .first
                                    .substring(0, 3),
                                textAlign: TextAlign.start,
                                type: FontStyle.XSmall,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 150,
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: defaultDays
                            .map((e) => CustomText(
                                  e,
                                  type: FontStyle.XSmall,
                                ))
                            .toList(),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: GridView.builder(
                          controller: gridScrollController,
                          scrollDirection: Axis.horizontal,
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 6,
                            childAspectRatio: 1.1,
                          ),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return data[index] == 'Empty'
                                ? Container()
                                : Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: getColor(data[index]),
                                    ),
                                  );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 25,
                  child: Row(
                    children: [
                      const CustomText(
                        'Less',
                        type: FontStyle.XSmall,
                      ),
                      SizedBox(
                        height: 16,
                        child: ListView.builder(
                          itemCount: activityRangeColors.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          itemBuilder: (context, index) {
                            return Container(
                              height: 10,
                              width: 15,
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: activityRangeColors[index],
                              ),
                            );
                          },
                        ),
                      ),
                      const CustomText(
                        'More',
                        type: FontStyle.XSmall,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<MonthData> getMonthsData(int count) {
    final List<MonthData> monthsData = [];

    DateTime currentDate = DateTime.now();
    for (int i = 0; i < count; i++) {
      // Get the first day of the current month
      final DateTime firstDayOfMonth =
          DateTime(currentDate.year, currentDate.month, 1);

      final List<String> days = [];
      for (int day = 1; day <= currentDate.day; day++) {
        final DateTime date =
            DateTime(currentDate.year, currentDate.month, day);

        final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
        // String dayOfWeek = DateFormat('EEEE').format(date);
        if (i == (count - 1) && day == 1) {
          final int weekDay = date.weekday;
          // print('THIS IS WEEKDAY: $weekDay');
          for (int emptyDays = 0; emptyDays < weekDay; emptyDays++) {
            days.add('Empty');
          }
        }
        days.add(formattedDate);
      }

      final String formattedMonth = DateFormat('MMMM yyyy').format(currentDate);
      monthsData.add(MonthData(formattedMonth, days));

      // Move to the previous month
      currentDate = firstDayOfMonth.subtract(const Duration(days: 1));
    }
    return monthsData.reversed
        .toList(); // Reverse the list to start with the earliest month
  }

  void allMonthsData() {
    for (final element in monthsData!) {
      for (final element in element.days) {
        setState(() {
          data.add(element);
        });
      }
    }
  }

  Color getColor(String date) {
    final dashboardProvider = ref.watch(ProviderList.dashboardProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    Color color = themeProvider.themeManager.tertiaryBackgroundDefaultColor;
    if (dashboardProvider.getDashboardState == DataState.success) {
      for (final element
          in dashboardProvider.dashboardData['issue_activities']) {
        if (element['created_date'] == date) {
          if (element['activity_count'] <= 3) {
            color = themeProvider.themeManager.primaryColour.withOpacity(0.2);
          } else if (element['activity_count'] > 3 &&
              element['activity_count'] <= 6) {
            color = themeProvider.themeManager.primaryColour.withOpacity(0.4);
          } else if (element['activity_count'] > 6 &&
              element['activity_count'] <= 9) {
            color = themeProvider.themeManager.primaryColour.withOpacity(0.8);
          } else {
            color = themeProvider.themeManager.primaryColour;
          }
        }
      }
    } else {
      color = themeProvider.themeManager.tertiaryBackgroundDefaultColor;
    }
    return color;
  }
}
