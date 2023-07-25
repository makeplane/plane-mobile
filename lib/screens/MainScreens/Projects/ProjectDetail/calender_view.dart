import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plane_startup/bottom_sheets/filter_sheet.dart';
import 'package:plane_startup/bottom_sheets/type_sheet.dart';
import 'package:plane_startup/bottom_sheets/views_sheet.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/IssuesTab/create_issue.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/IssuesTab/issue_detail_screen.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_app_bar.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import 'package:plane_startup/widgets/square_avatar_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends ConsumerStatefulWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CalendarViewState();
}

class _CalendarViewState extends ConsumerState<CalendarView> {
  // @override
  // Widget build(BuildContext context) {
  //   var themeProvider = ref.read(ProviderList.themeProvider);
  //   return Scaffold(
  //       body: SizedBox(
  //     height: MediaQuery.of(context).size.height * 0.65,
  //     child: TableCalendar(
  //       firstDay: DateTime(2022),
  //       lastDay: DateTime(2025),
  //       focusedDay: DateTime.now(),
  //       calendarFormat: CalendarFormat.month,
  //       selectedDayPredicate: (day) {
  //         return isSameDay(day, DateTime.now());
  //       },
  //       headerStyle: HeaderStyle(
  //           formatButtonVisible: false,
  //           titleCentered: true,
  //           leftChevronIcon: Icon(
  //             Icons.keyboard_arrow_left,
  //             color: themeProvider.isDarkThemeEnabled
  //                 ? lightGreeyColor
  //                 : Colors.black,
  //           ),
  //           rightChevronIcon: Icon(
  //             Icons.keyboard_arrow_right,
  //             color: themeProvider.isDarkThemeEnabled
  //                 ? lightGreeyColor
  //                 : Colors.black,
  //           ),
  //           titleTextStyle: TextStyle(
  //             color: themeProvider.isDarkThemeEnabled
  //                 ? lightGreeyColor
  //                 : Colors.black,
  //             fontSize: 18,
  //           )),
  //       calendarStyle: CalendarStyle(
  //           weekendTextStyle: TextStyle(
  //             color: themeProvider.isDarkThemeEnabled
  //                 ? lightGreeyColor.withOpacity(0.7)
  //                 : Colors.black,
  //           ),
  //           defaultTextStyle: TextStyle(
  //             color: themeProvider.isDarkThemeEnabled
  //                 ? lightGreeyColor
  //                 : Colors.black,
  //           )),
  //       eventLoader: (day) {
  //         return ref
  //             .read(ProviderList.issuesProvider)
  //             .issuesList
  //             .where((element) {
  //           if (element['target_date'] == null) return false;
  //           return DateFormat("MMM d, yyyy")
  //                   .format(DateTime.parse(element['target_date'])) ==
  //               DateFormat("MMM d, yyyy").format(day);
  //         }).toList();
  //       },
  //       onDaySelected: (selectedDay, focusedDay) {
  //         Navigator.of(context).push(
  //           MaterialPageRoute(
  //             builder: (context) => DayDetail(
  //               selectedDay: selectedDay,
  //             ),
  //           ),
  //         );
  //       },
  //       calendarBuilders: CalendarBuilders(
  //         selectedBuilder: (context, day, focusedDay) {
  //           return Center(
  //             child: Container(
  //               decoration: BoxDecoration(
  //                 color: primaryColor,
  //                 borderRadius: BorderRadius.circular(20),
  //               ),
  //               height: 30,
  //               width: 30,
  //               child: Center(
  //                 child: Text(
  //                   day.day.toString(),
  //                   style: const TextStyle(color: Colors.white),
  //                 ),
  //               ),
  //             ),
  //           );
  //         },
  //         markerBuilder: (context, day, events) {
  //           if (events.isNotEmpty) {
  //             return Positioned(
  //               // bottom: -2,
  //               bottom: 2,
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                   // color: greyColor,
  //                   color: primaryColor,
  //                   borderRadius: BorderRadius.circular(15),
  //                 ),
  //                 width: 8,
  //                 height: 8,
  //                 // child: Center(
  //                 //   child: Text(
  //                 //     events.length.toString(),
  //                 //     // textAlign: TextAlign.center,
  //                 //     style: const TextStyle(
  //                 //       color: Colors.white,
  //                 //       fontSize: 12,
  //                 //     ),
  //                 //   ),
  //                 // ),
  //               ),
  //             );
  //           }
  //           return Container();
  //         },
  //       ),
  //     ),
  //   ));

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
    int ind = months.indexOf(DateFormat("MMMM").format(DateTime.now()));
    log(ind.toString());
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

    // WidgetsBinding.instance.addPostFrameCallback((_) {

    //   _pageController.animateTo(
    //     6 * 312,
    //     duration: const Duration(milliseconds: 100),
    //     curve: Curves.easeInOut,
    //   );
    // });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  getDates(DateTime date, bool isNextYear) {
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
      List temp = [];
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
    var themeProvider = ref.read(ProviderList.themeProvider);

    return Scaffold(
      body: Column(
        children: [
          Container(
              //horizontaol list of days of week having grey background
              height: 40,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                //bottom border
                border: Border(
                  bottom: BorderSide(
                    color: themeProvider.isDarkThemeEnabled
                        ? darkThemeBorder
                        : lightGreeyColor,
                    width: 1.0,
                  ),
                ),
                color: themeProvider.isDarkThemeEnabled
                    ? Colors.black.withOpacity(0.4)
                    : lightGreeyColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ...days.map((e) {
                    return Expanded(
                      child: Center(
                        child: CustomText(
                          e,
                          type: FontStyle.text,
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
                      titleTextStyle: TextStyle(
                        color: themeProvider.isDarkThemeEnabled
                            ? lightGreeyColor
                            : Colors.black,
                        fontSize: 18,
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
                      weekendTextStyle: TextStyle(
                        color: themeProvider.isDarkThemeEnabled
                            ? lightGreeyColor.withOpacity(0.7)
                            : Colors.black,
                      ),
                      defaultTextStyle: TextStyle(
                        color: themeProvider.isDarkThemeEnabled
                            ? lightGreeyColor
                            : Colors.black,
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
                            color: primaryColor,
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
                          bottom: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              // color: greyColor,
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            width: 8,
                            height: 8,
                            // child: Center(
                            //   child: Text(
                            //     events.length.toString(),
                            //     // textAlign: TextAlign.center,
                            //     style: const TextStyle(
                            //       color: Colors.white,
                            //       fontSize: 12,
                            //     ),
                            //   ),
                            // ),
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
  DateTime selectedDay;
  DayDetail({
    super.key,
    required this.selectedDay,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DayDetailState();
}

class _DayDetailState extends ConsumerState<DayDetail> {
  bool showFull = true;
  @override
  Widget build(BuildContext context) {
    log(widget.selectedDay.toString());
    var issuesProvider = ref.watch(ProviderList.issuesProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Scaffold(
      appBar: CustomAppBar(
        icon: Icons.arrow_back_ios,
        onPressed: () {
          Navigator.pop(context);
        },
        centerTitle: false,
        text: ref
            .read(ProviderList.projectProvider)
            .currentProject['name']
            .toString(),

        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        //   icon: Icon(
        //     Icons.arrow_back_ios,
        //     size: 22,
        //     color: themeProvider.isDarkThemeEnabled
        //         ? lightGreeyColor
        //         : Colors.black,
        //   ),
        // ),
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
                  type: FontStyle.text,
                ),
                Icon(
                  showFull
                      ? Icons.keyboard_arrow_up_outlined
                      : Icons.keyboard_arrow_down_outlined,
                  size: 27,
                  color: const Color.fromRGBO(143, 143, 147, 1),
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
                  color: themeProvider.isDarkThemeEnabled
                      ? Colors.black.withOpacity(0.4)
                      : lightGreyBoxColor,
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
                        color: themeProvider.isDarkThemeEnabled
                            ? lightGreeyColor.withOpacity(0.7)
                            : Colors.black,
                      ),
                      defaultTextStyle: TextStyle(
                        color: themeProvider.isDarkThemeEnabled
                            ? lightGreeyColor
                            : Colors.black,
                      ),
                      outsideDaysVisible: false,
                    ),
                    calendarBuilders: CalendarBuilders(
                      selectedBuilder: (context, day, focusedDay) {
                        return Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: primaryColor,
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
                            bottom: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              width: 8,
                              height: 8,
                              // child: Center(
                              //   child: Text(
                              //     events.length.toString(),
                              //     // textAlign: TextAlign.center,
                              //     style: const TextStyle(
                              //       color: Colors.white,
                              //       fontSize: 12,
                              //     ),
                              //   ),
                              // ),
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
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  widget.selectedDay = selectedDay;
                });
              },
              calendarStyle: CalendarStyle(
                  isTodayHighlighted: false,
                  tablePadding: const EdgeInsets.all(0),
                  weekendTextStyle: TextStyle(
                    color: themeProvider.isDarkThemeEnabled
                        ? lightGreeyColor.withOpacity(0.7)
                        : Colors.black,
                  ),
                  defaultTextStyle: TextStyle(
                    color: themeProvider.isDarkThemeEnabled
                        ? lightGreeyColor
                        : Colors.black,
                  ),
                  tableBorder: TableBorder(
                      bottom: BorderSide(
                    color: greyColor.withOpacity(0.3),
                    width: 1.0,
                  ))),
              calendarBuilders: CalendarBuilders(
                selectedBuilder: (context, day, focusedDay) {
                  return Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      //only bottom border
                      border: Border(
                        bottom: BorderSide(
                          color: primaryColor,
                          width: 7.0,
                        ),
                      ),
                    ),
                    child: Text(
                      day.day.toString(),
                      style: const TextStyle(color: primaryColor),
                    ),
                  );
                },
              ),
            ),
          ),
          // Divider(
          //   color:
          //       themeProvider.isDarkThemeEnabled ? darkThemeBorder : greyColor,
          // ),
          const SizedBox(
            height: 10,
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
                                index: index,
                                appBarTitle:
                                    '${issuesProvider.issuesList[index]['project_detail']['identifier'].toString()} - ${issuesProvider.issuesList[index]['sequence_id']}',
                                issueId: issuesProvider.issuesList[index]['id'],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 30),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CustomText(
                                    '${issuesProvider.issuesList[index]['project_detail']['identifier'].toString()} - ${issuesProvider.issuesList[index]['sequence_id']}',
                                    type: FontStyle.heading2,
                                    fontWeight: FontWeight.normal,
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
                                      type: FontStyle.subheading,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Container(
                                      // alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                              color: themeProvider
                                                      .isDarkThemeEnabled
                                                  ? darkThemeBorder
                                                  : lightGreeyColor)),
                                      // margin: const EdgeInsets.only(right: 5),
                                      height: 30,
                                      width: 30,
                                      child: issuesProvider.issuesList[index]
                                                  ['priority'] ==
                                              null
                                          ? const Icon(
                                              Icons.do_disturb_alt_outlined,
                                              size: 18,
                                              color: greyColor,
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
                                    width: 30,
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
                                                          .isDarkThemeEnabled
                                                      ? darkThemeBorder
                                                      : lightGreeyColor),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: const Icon(
                                            Icons.groups_2_outlined,
                                            size: 18,
                                            color: greyColor,
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
                log('separator');
                return (issuesProvider.issuesList[index]['target_date'] !=
                            null &&
                        DateFormat("MMM d, yyyy").format(DateTime.parse(
                                issuesProvider.issuesList[index]
                                    ['target_date'])) ==
                            DateFormat("MMM d, yyyy")
                                .format(widget.selectedDay))
                    ? Divider(
                        color: themeProvider.isDarkThemeEnabled
                            ? greyColor
                            : greyColor,
                      )
                    : Container();
              },
            ),
          ),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            color: darkBackgroundColor,
            child: Row(
              children: [
                ref.read(ProviderList.projectProvider).role == Role.admin
                    ? Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const CreateIssue(),
                              ),
                            );
                          },
                          child: const SizedBox.expand(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                CustomText(
                                  ' Issue',
                                  type: FontStyle.subtitle,
                                  color: Colors.white,
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
                  color: greyColor,
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
                  child: const SizedBox.expand(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 19,
                        ),
                        CustomText(
                          ' Layout',
                          type: FontStyle.subtitle,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                )),
                Container(
                  height: 50,
                  width: 0.5,
                  color: greyColor,
                ),
                // Expanded(
                //     child: InkWell(
                //   onTap: () {
                //     showModalBottomSheet(
                //         isScrollControlled: true,
                //         enableDrag: true,
                //         constraints: BoxConstraints(
                //             maxHeight:
                //                 MediaQuery.of(context).size.height * 0.9),
                //         shape: const RoundedRectangleBorder(
                //             borderRadius: BorderRadius.only(
                //           topLeft: Radius.circular(30),
                //           topRight: Radius.circular(30),
                //         )),
                //         context: context,
                //         builder: (ctx) {
                //           return const ViewsSheet(
                //             issueCategory: IssueCategory.issues,
                //           );
                //         });
                //   },
                //   child: const SizedBox.expand(
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Icon(
                //           Icons.view_sidebar,
                //           color: Colors.white,
                //           size: 19,
                //         ),
                //         CustomText(
                //           ' Views',
                //           type: FontStyle.subtitle,
                //           color: Colors.white,
                //         )
                //       ],
                //     ),
                //   ),
                // )),
                Container(
                  height: 50,
                  width: 0.5,
                  color: greyColor,
                ),
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
                          return const FilterSheet(
                            issueCategory: IssueCategory.issues,
                          );
                        });
                  },
                  child: const SizedBox.expand(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.filter_alt,
                          color: Colors.white,
                          size: 19,
                        ),
                        CustomText(
                          ' Filters',
                          type: FontStyle.subtitle,
                          color: Colors.white,
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
