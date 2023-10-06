import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:plane/bottom_sheets/filters/filter_sheet.dart';
import 'package:plane/bottom_sheets/type_sheet.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/IssuesTab/create_issue.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_app_bar.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/square_avatar_widget.dart';
import 'package:table_calendar/table_calendar.dart';

import 'IssuesTab/issue_detail.dart';

class CalendarView extends ConsumerStatefulWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CalendarViewState();
}

class _CalendarViewState extends ConsumerState<CalendarView> {
  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  final List<String> days = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];

  List<Map> dates = [];

  // Page controller for vertical scrolling
  ScrollController _pageController = ScrollController();
  int month = DateTime(DateTime.now().year, 1).month;
  int next = 0;
  int prev = 0;
  @override
  void initState() {
    super.initState();
    final int ind = months.indexOf(DateFormat("MMMM").format(DateTime.now()));
    _pageController = ScrollController(
      initialScrollOffset: ind * 310,
      keepScrollOffset: true,
    );

    _pageController.addListener(() {
      if (_pageController.position.pixels ==
          _pageController.position.maxScrollExtent) {
        next++;
        //add next year months
        getDates(DateTime(DateTime.now().year + next), true);
      }
      if (_pageController.position.pixels ==
          _pageController.position.minScrollExtent) {
        prev++;
        //add previous year months
        getDates(DateTime(DateTime.now().year - prev), false);
      }
    });
    getDates(DateTime(DateTime.now().year), true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void getDates(DateTime date, bool isNextYear) {
    month = date.month;
    if (isNextYear) {
      for (int i = 0; i < months.length; i++) {
        dates.add({
          'firstDayOfMonth':
              DateTime(date.year, i == 0 ? month : (month + 1), 1),
          'lastDayOfMonth':
              DateTime(date.year, i == 0 ? (month + 1) : (month + 2), 0)
        });
        month = (i == 0) ? month : month + 1;
      }
    } else {
      final List temp = [];
      for (int i = 0; i < months.length; i++) {
        temp.add({
          'firstDayOfMonth':
              DateTime(date.year, i == 0 ? month : (month + 1), 1),
          'lastDayOfMonth':
              DateTime(date.year, i == 0 ? (month + 1) : (month + 2), 0)
        });
        month = (i == 0) ? month : month + 1;
      }
      dates = [...temp, ...dates];
      // do not scroll to top when adding previous year months
      _pageController.jumpTo(
        12 * 312,
      );
    }

    setState(() {});
    // log(dates.toString());
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.read(ProviderList.themeProvider);

    return Scaffold(
      body: Column(
        children: [
          Container(
              //horizontaol list of days of week having grey background
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                //bottom border
                border: Border(
                  bottom: BorderSide(
                    color: themeProvider.themeManager.borderSubtle01Color,
                    width: 1,
                  ),
                ),
                color:
                    themeProvider.themeManager.secondaryBackgroundDefaultColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ...days.map((e) {
                    return Expanded(
                      child: Center(
                        child: CustomText(
                          e,
                          type: FontStyle.Small,
                          color:
                              themeProvider.themeManager.placeholderTextColor,
                          overrride: true,
                        ),
                      ),
                    );
                  }).toList(),
                ],
              )),
          Expanded(
            child: ListView.builder(
              // shrinkWrap: true,
              controller: _pageController,
              itemCount: dates.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                //add months of next year when scroll reaches end

                return TableCalendar(
                  daysOfWeekVisible: false,
                  calendarFormat: CalendarFormat.month,
                  focusedDay: dates[index]['lastDayOfMonth'],
                  firstDay: dates[index]['firstDayOfMonth'],
                  lastDay: dates[index]['lastDayOfMonth'],
                  availableGestures: AvailableGestures.none,
                  headerStyle: HeaderStyle(
                      titleTextStyle: GoogleFonts.inter(
                        color: themeProvider.themeManager.tertiaryTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      leftChevronVisible: false, // Hide the left arrow
                      rightChevronVisible: false, // Hide the right arrow
                      titleCentered: false, // Center the title text
                      formatButtonVisible:
                          false, // Hide the week switching button
                      formatButtonShowsNext: false,
                      headerMargin: const EdgeInsets.only(
                          left: 16, bottom: 5) // Hide the week switching button
                      ),
                  selectedDayPredicate: (day) {
                    return isSameDay(day, DateTime.now());
                  },
                  calendarStyle: CalendarStyle(
                      outsideDaysVisible: false,
                      //tablePadding: const EdgeInsets.only(top: 10, bottom: 10),
                      rowDecoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: themeProvider
                                      .themeManager.borderDisabledColor))),
                      weekendTextStyle: TextStyle(
                        color: themeProvider.themeManager.placeholderTextColor,
                      ),
                      defaultTextStyle: TextStyle(
                        color: themeProvider.themeManager.placeholderTextColor,
                      )),
                  eventLoader: (day) {
                    return ref
                        .read(ProviderList.issuesProvider)
                        .issuesList
                        .where((element) {
                      if (element['target_date'] == null) return false;
                      return DateFormat("MMM d, yyyy")
                              .format(DateTime.parse(element['target_date'])) ==
                          DateFormat("MMM d, yyyy").format(day);
                    }).toList();
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DayDetail(
                          selectedDay: selectedDay,
                        ),
                      ),
                    );
                  },
                  calendarBuilders: CalendarBuilders(
                    selectedBuilder: (context, day, focusedDay) {
                      return Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: themeProvider.themeManager.primaryColour,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: 30,
                          width: 30,
                          child: Center(
                            child: Text(
                              day.day.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    },
                    markerBuilder: (context, day, events) {
                      if (events.isNotEmpty) {
                        return Positioned(
                          // bottom: -2,
                          // bottom: -2,
                          child: Container(
                            decoration: BoxDecoration(
                              // color: greyColor,
                              color: themeProvider.themeManager.primaryColour,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            width: 8,
                            height: 8,
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class DayDetail extends ConsumerStatefulWidget {
  DayDetail({
    super.key,
    required this.selectedDay,
  });
  DateTime selectedDay;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DayDetailState();
}

class _DayDetailState extends ConsumerState<DayDetail> {
  bool showFull = true;
  @override
  Widget build(BuildContext context) {
    final issuesProvider = ref.watch(ProviderList.issuesProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    return Scaffold(
      appBar: CustomAppBar(
        icon: Icons.arrow_back,
        onPressed: () {
          Navigator.pop(context);
        },
        centerTitle: false,
        text: ref
            .read(ProviderList.projectProvider)
            .currentProject['name']
            .toString(),
        actions: [
          //dropdown to show full moth calendar
          TextButton(
            onPressed: () {
              setState(() {
                showFull = !showFull;
              });
            },
            child: Row(
              children: [
                CustomText(
                  //month full name
                  DateFormat("MMMM").format(widget.selectedDay),
                  type: FontStyle.Medium,
                ),
                Icon(
                  showFull
                      ? Icons.keyboard_arrow_up_outlined
                      : Icons.keyboard_arrow_down_outlined,
                  size: 25,
                  color: themeProvider.themeManager.tertiaryTextColor,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          showFull
              ? Container(
                  color: themeProvider
                      .themeManager.secondaryBackgroundDefaultColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: TableCalendar(
                    firstDay: DateTime(2022),
                    lastDay: DateTime(2025),
                    selectedDayPredicate: (day) {
                      return isSameDay(day, widget.selectedDay);
                    },
                    focusedDay: widget.selectedDay,
                    calendarFormat: CalendarFormat.month,
                    eventLoader: (day) {
                      return ref
                          .read(ProviderList.issuesProvider)
                          .issuesList
                          .where((element) {
                        if (element['target_date'] == null) return false;
                        return DateFormat("MMM d, yyyy").format(
                                DateTime.parse(element['target_date'])) ==
                            DateFormat("MMM d, yyyy").format(day);
                      }).toList();
                    },
                    headerVisible: false,
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        widget.selectedDay = selectedDay;
                      });
                    },
                    calendarStyle: CalendarStyle(
                      weekendTextStyle: TextStyle(
                        color: themeProvider.themeManager.placeholderTextColor,
                      ),
                      defaultTextStyle: TextStyle(
                        color: themeProvider.themeManager.placeholderTextColor,
                      ),
                      outsideDaysVisible: false,
                    ),
                    calendarBuilders: CalendarBuilders(
                      selectedBuilder: (context, day, focusedDay) {
                        return Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: themeProvider.themeManager.primaryColour,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            height: 30,
                            width: 30,
                            child: Center(
                              child: Text(
                                day.day.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      },
                      markerBuilder: (context, day, events) {
                        if (events.isNotEmpty) {
                          return Positioned(
                            // bottom: -2,
                            bottom: -2,
                            child: Container(
                              decoration: BoxDecoration(
                                color: themeProvider.themeManager.primaryColour,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              width: 8,
                              height: 8,
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                )
              : Container(),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TableCalendar(
              headerVisible: false,
              firstDay: DateTime(2022),
              lastDay: DateTime(2025),
              selectedDayPredicate: (day) {
                return isSameDay(day, widget.selectedDay);
              },
              focusedDay: widget.selectedDay,
              calendarFormat: CalendarFormat.week,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  color: themeProvider.themeManager.placeholderTextColor,
                ),
              ),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  widget.selectedDay = selectedDay;
                });
              },
              calendarStyle: CalendarStyle(
                  isTodayHighlighted: false,
                  tablePadding: const EdgeInsets.all(0),
                  disabledTextStyle: TextStyle(
                    color: themeProvider.themeManager.placeholderTextColor,
                  ),
                  weekendTextStyle: TextStyle(
                    color: themeProvider.themeManager.placeholderTextColor,
                  ),
                  defaultTextStyle: TextStyle(
                    color: themeProvider.themeManager.placeholderTextColor,
                  ),
                  tableBorder: TableBorder(
                      bottom: BorderSide(
                    color: themeProvider.themeManager.borderSubtle01Color,
                    width: 1.0,
                  ))),
              calendarBuilders: CalendarBuilders(
                selectedBuilder: (context, day, focusedDay) {
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      //only bottom border
                      border: Border(
                        bottom: BorderSide(
                          color: themeProvider.themeManager.primaryColour,
                          width: 7.0,
                        ),
                      ),
                    ),
                    child: Text(
                      day.day.toString(),
                      style: TextStyle(
                          color: themeProvider.themeManager.primaryColour),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: issuesProvider.issuesList.length,
              itemBuilder: (context, index) {
                return (issuesProvider.issuesList[index]['target_date'] !=
                            null &&
                        DateFormat("MMM d, yyyy").format(DateTime.parse(
                                issuesProvider.issuesList[index]
                                    ['target_date'])) ==
                            DateFormat("MMM d, yyyy")
                                .format(widget.selectedDay))
                    ? InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => IssueDetail(
                                from: PreviousScreen.projectDetail,
                                appBarTitle:
                                    '${issuesProvider.issuesList[index]['project_detail']['identifier'].toString()} - ${issuesProvider.issuesList[index]['sequence_id']}',
                                issueId: issuesProvider.issuesList[index]['id'],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CustomText(
                                    '${issuesProvider.issuesList[index]['project_detail']['identifier'].toString()} - ${issuesProvider.issuesList[index]['sequence_id']}',
                                    type: FontStyle.Small,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: CustomText(
                                      issuesProvider.issuesList[index]['name'],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      type: FontStyle.Small,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Container(
                                      // alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                              color: themeProvider.themeManager
                                                  .borderSubtle01Color)),
                                      // margin: const EdgeInsets.only(right: 5),
                                      height: 30,
                                      width: 30,
                                      child: issuesProvider.issuesList[index]
                                                  ['priority'] ==
                                              null
                                          ? Icon(
                                              Icons.do_disturb_alt_outlined,
                                              size: 18,
                                              color: themeProvider.themeManager
                                                  .tertiaryTextColor,
                                            )
                                          : issuesProvider.issuesList[index]
                                                      ['priority'] ==
                                                  'high'
                                              ? const Icon(
                                                  Icons.signal_cellular_alt,
                                                  color: Colors.orange,
                                                  size: 18,
                                                )
                                              : issuesProvider.issuesList[index]
                                                          ['priority'] ==
                                                      'medium'
                                                  ? const Icon(
                                                      Icons
                                                          .signal_cellular_alt_2_bar,
                                                      color: Colors.orange,
                                                      size: 18,
                                                    )
                                                  : const Icon(
                                                      Icons
                                                          .signal_cellular_alt_1_bar,
                                                      color: Colors.orange,
                                                      size: 18,
                                                    )),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  (issuesProvider.issuesList[index]
                                                  ['assignee_details'] !=
                                              null &&
                                          issuesProvider
                                              .issuesList[index]
                                                  ['assignee_details']
                                              .isNotEmpty)
                                      ? SquareAvatarWidget(
                                          details:
                                              issuesProvider.issuesList[index]
                                                  ['assignee_details'],
                                        )
                                      : Container(
                                          height: 30,
                                          margin:
                                              const EdgeInsets.only(right: 5),
                                          padding: const EdgeInsets.only(
                                              left: 8,
                                              right: 8,
                                              top: 5,
                                              bottom: 5),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: themeProvider
                                                      .themeManager
                                                      .placeholderTextColor),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: themeProvider.themeManager
                                                  .borderSubtle01Color),
                                          child: Icon(
                                            Icons.groups_2_outlined,
                                            size: 18,
                                            color: themeProvider
                                                .themeManager.tertiaryTextColor,
                                          ),
                                        )
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container();
              },
              separatorBuilder: (context, index) {
                return (issuesProvider.issuesList[index]['target_date'] !=
                            null &&
                        DateFormat("MMM d, yyyy").format(DateTime.parse(
                                issuesProvider.issuesList[index]
                                    ['target_date'])) ==
                            DateFormat("MMM d, yyyy")
                                .format(widget.selectedDay))
                    ? Divider(
                        color: themeProvider.themeManager.borderSubtle01Color,
                      )
                    : Container();
              },
            ),
          ),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: themeProvider.themeManager.primaryBackgroundDefaultColor,
              boxShadow: themeProvider.themeManager.shadowBottomControlButtons,
            ),
            child: Row(
              children: [
                ref.read(ProviderList.projectProvider).role == Role.admin
                    ? Expanded(
                        child: InkWell(
                          onTap: () {
                            issuesProvider.createIssuedata = {
                              'due_date': (widget.selectedDay),
                            };
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const CreateIssue(),
                              ),
                            );
                          },
                          child: SizedBox.expand(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: themeProvider
                                      .themeManager.primaryTextColor,
                                  size: 20,
                                ),
                                const CustomText(
                                  ' Issue',
                                  type: FontStyle.Medium,
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(),
                Container(
                  height: 50,
                  width: 0.5,
                  color: themeProvider.themeManager.borderSubtle01Color,
                ),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        enableDrag: true,
                        constraints: BoxConstraints(maxHeight: height * 0.5),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        )),
                        context: context,
                        builder: (ctx) {
                          return const TypeSheet(
                            issueCategory: IssueCategory.issues,
                          );
                        });
                  },
                  child: SizedBox.expand(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.menu,
                          color: themeProvider.themeManager.primaryTextColor,
                          size: 19,
                        ),
                        const CustomText(
                          ' Layout',
                          type: FontStyle.Medium,
                        )
                      ],
                    ),
                  ),
                )),
                Container(
                  height: 50,
                  width: 0.5,
                  color: themeProvider.themeManager.borderSubtle01Color,
                ),
                // Container(
                //   height: 50,
                //   width: 0.5,
                //   color: greyColor,
                // ),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        enableDrag: true,
                        constraints: BoxConstraints(
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.85),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        )),
                        context: context,
                        builder: (ctx) {
                          return FilterSheet(
                            issueCategory: IssueCategory.issues,
                          );
                        });
                  },
                  child: SizedBox.expand(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.filter_list_outlined,
                          color: themeProvider.themeManager.primaryTextColor,
                          size: 19,
                        ),
                        const CustomText(
                          ' Filters',
                          type: FontStyle.Medium,
                        )
                      ],
                    ),
                  ),
                )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
