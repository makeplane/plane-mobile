import 'dart:developer';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plane/models/issues.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/create_view_screen.dart';
import 'package:plane/utils/color_manager.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_button.dart';
import 'package:plane/widgets/custom_expansion_tile.dart';

import 'package:plane/widgets/custom_text.dart';

// ignore: must_be_immutable
class FilterSheet extends ConsumerStatefulWidget {
  FilterSheet(
      {super.key,
      required this.issueCategory,
      this.filtersData,
      this.fromViews = false,
      this.isArchived = false,
      this.fromCreateView = false});
  final Enum issueCategory;
  final bool fromCreateView;
  final bool fromViews;
  final bool isArchived;
  dynamic filtersData;
  @override
  ConsumerState<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<FilterSheet> {
  List priorities = [
    {'icon': Icons.error_outline_rounded, 'text': 'urgent', 'color': '#EF4444'},
    {'icon': Icons.signal_cellular_alt, 'text': 'high', 'color': '#F59E0B'},
    {
      'icon': Icons.signal_cellular_alt_2_bar,
      'text': 'medium',
      'color': '#F59E0B'
    },
    {
      'icon': Icons.signal_cellular_alt_1_bar,
      'text': 'low',
      'color': '#22C55E'
    },
    {'icon': Icons.do_disturb_alt_outlined, 'text': 'none', 'color': '#A3A3A3'}
  ];

  List states = [
    {'id': 'backlog', 'name': 'Backlog', 'color': '#5e6ad2'},
    {'id': 'unstarted', 'name': 'Unstarted', 'color': '#eb5757'},
    {'id': 'started', 'name': 'Started', 'color': '#26b5ce'},
    {'id': 'completed', 'name': 'Completed', 'color': '#f2c94c'},
    {'id': 'cancelled', 'name': 'Cancelled', 'color': '#4cb782'}
  ];

  Filters filters = Filters(
    priorities: [],
    states: [],
    assignees: [],
    createdBy: [],
    labels: [],
    targetDate: [],
    startDate: [],
    stateGroup: [],
    subscriber: [],
  );

  bool isFilterEmpty() {
    return filters.priorities.isEmpty &&
        filters.states.isEmpty &&
        filters.assignees.isEmpty &&
        filters.createdBy.isEmpty &&
        filters.labels.isEmpty &&
        filters.targetDate.isEmpty &&
        filters.startDate.isEmpty &&
        filters.stateGroup.isEmpty &&
        filters.subscriber.isEmpty;
  }

  List<DateTime?> _targetRangeDatePickerValueWithDefaultValue = [];
  List<DateTime?> _startRangeDatePickerValueWithDefaultValue = [];
  bool targetLastWeek = false;
  bool targetTwoWeeks = false;
  bool targetOneMonth = false;
  bool targetTwoMonths = false;
  bool targetCustomDate = false;

  bool startLastWeek = false;
  bool startTwoWeeks = false;
  bool startOneMonth = false;
  bool startTwoMonths = false;
  bool startCustomDate = false;

  targetDatesEnabled() {
    targetLastWeek = filters.targetDate.contains(
            '${DateTime.now().subtract(const Duration(days: 7)).toString().split(' ')[0]};after') &&
        filters.targetDate
            .contains('${DateTime.now().toString().split(' ')[0]};before');

    targetTwoWeeks = filters.targetDate
            .contains('${DateTime.now().toString().split(' ')[0]};after') &&
        filters.targetDate.contains(
            '${DateTime.now().add(const Duration(days: 14)).toString().split(' ')[0]};before');

    targetOneMonth = filters.targetDate
            .contains('${DateTime.now().toString().split(' ')[0]};after') &&
        filters.targetDate.contains(
            '${DateTime.now().add(const Duration(days: 30)).toString().split(' ')[0]};before');

    targetTwoMonths = filters.targetDate
            .contains('${DateTime.now().toString().split(' ')[0]};after') &&
        filters.targetDate.contains(
            '${DateTime.now().add(const Duration(days: 60)).toString().split(' ')[0]};before');

    targetCustomDate =
        (targetLastWeek || targetTwoWeeks || targetOneMonth || targetTwoMonths)
            ? false
            : filters.targetDate.isEmpty
                ? false
                : true;

    if (targetCustomDate) {
      _targetRangeDatePickerValueWithDefaultValue = [
        DateTime.parse(filters.targetDate[0].split(';')[0]),
        DateTime.parse(filters.targetDate[1].split(';')[0])
      ];
    }
  }

  startDatesEnabled() {
    startLastWeek = filters.startDate.contains(
            '${DateTime.now().subtract(const Duration(days: 7)).toString().split(' ')[0]};after') &&
        filters.startDate
            .contains('${DateTime.now().toString().split(' ')[0]};before');

    startTwoWeeks = filters.startDate
            .contains('${DateTime.now().toString().split(' ')[0]};after') &&
        filters.startDate.contains(
            '${DateTime.now().add(const Duration(days: 14)).toString().split(' ')[0]};before');

    startOneMonth = filters.startDate
            .contains('${DateTime.now().toString().split(' ')[0]};after') &&
        filters.startDate.contains(
            '${DateTime.now().add(const Duration(days: 30)).toString().split(' ')[0]};before');

    startTwoMonths = filters.startDate
            .contains('${DateTime.now().toString().split(' ')[0]};after') &&
        filters.startDate.contains(
            '${DateTime.now().add(const Duration(days: 60)).toString().split(' ')[0]};before');

    startCustomDate =
        (startLastWeek || startTwoWeeks || startOneMonth || startTwoMonths)
            ? false
            : filters.startDate.isEmpty
                ? false
                : true;

    if (startCustomDate) {
      _startRangeDatePickerValueWithDefaultValue = [
        DateTime.parse(filters.startDate[0].split(';')[0]),
        DateTime.parse(filters.startDate[1].split(';')[0])
      ];
    }
  }

  @override
  void initState() {
    if (!widget.fromCreateView) {
      if (widget.issueCategory == IssueCategory.myIssues) {
        filters = ref.read(ProviderList.myIssuesProvider).issues.filters;
      } else {
        filters = ref.read(ProviderList.issuesProvider).issues.filters;
      }
    } else {
      filters = Filters.fromJson(widget.filtersData["Filters"]);
    }
    if (filters.startDate.isNotEmpty) {
      log(filters.startDate.toString());
      startDatesEnabled();
    }
    if (filters.targetDate.isNotEmpty) {
      targetDatesEnabled();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var issuesProvider = ref.watch(ProviderList.issuesProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    var myIssuesProvider = ref.watch(ProviderList.myIssuesProvider);

    Widget expandedWidget(
        {required Widget icon,
        required String text,
        Color? color,
        required bool selected}) {
      return Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        //set max width to 150
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            blurRadius: 0.6,
            color: themeProvider.themeManager.borderSubtle01Color,
            spreadRadius: 0,
          )
        ], borderRadius: BorderRadius.circular(5), color: color),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(width: 5),
            Container(
              constraints: const BoxConstraints(maxWidth: 200),
              child: CustomText(
                text.isNotEmpty
                    ? text.replaceFirst(text[0], text[0].toUpperCase())
                    : text,
                color: selected
                    ? Colors.white
                    : themeProvider.themeManager.secondaryTextColor,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            )
          ],
        ),
      );
    }

    Widget horizontalLine() {
      return Container(
        height: 1,
        width: double.infinity,
        color: themeProvider.themeManager.borderDisabledColor,
      );
    }

    return Container(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Stack(
        children: [
          SizedBox(
            child: Row(
              children: [
                const CustomText(
                  'Filter',
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
                    color: themeProvider.themeManager.placeholderTextColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 40, bottom: 80),
            child: SingleChildScrollView(
              child: Wrap(
                children: [
                  CustomExpansionTile(
                    title: 'Priority',
                    child: Wrap(
                        children: priorities
                            .map((e) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (filters.priorities
                                        .contains(e['text'])) {
                                      filters.priorities.remove(e['text']);
                                    } else {
                                      filters.priorities.add(e['text']);
                                    }
                                  });
                                },
                                child: expandedWidget(
                                    icon: Icon(
                                      e['icon'],
                                      size: 15,
                                      color: Color(int.parse(
                                          "FF${e['color'].replaceAll('#', '')}",
                                          radix: 16)),
                                    ),
                                    text: e['text'],
                                    color: filters.priorities
                                            .contains(e['text'])
                                        ? themeProvider
                                            .themeManager.primaryColour
                                        : themeProvider.themeManager
                                            .secondaryBackgroundDefaultColor,
                                    selected: filters.priorities
                                        .contains(e['text']))))
                            .toList()),
                  ),

                  horizontalLine(),

                  CustomExpansionTile(
                    title: 'State',
                    child: Wrap(
                        children:
                            (widget.issueCategory == IssueCategory.myIssues
                                    ? states
                                    : issuesProvider.states.values)
                                .map((e) {
                      String key =
                          widget.issueCategory == IssueCategory.myIssues
                              ? 'id'
                              : 'group';
                      return (widget.isArchived &&
                              (e[key] == 'backlog' ||
                                  e[key] == 'unstarted' ||
                                  e[key] == 'started'))
                          ? Container()
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (filters.states.contains(e['id'])) {
                                    filters.states.remove(e['id']);
                                  } else {
                                    filters.states.add(e['id']);
                                  }
                                });
                              },
                              child: expandedWidget(
                                icon: SvgPicture.asset(
                                  e[key] == 'backlog'
                                      ? 'assets/svg_images/circle.svg'
                                      : e[key] == 'cancelled'
                                          ? 'assets/svg_images/cancelled.svg'
                                          : e[key] == 'started'
                                              ? 'assets/svg_images/in_progress.svg'
                                              : e[key] == 'completed'
                                                  ? 'assets/svg_images/done.svg'
                                                  : 'assets/svg_images/unstarted.svg',
                                  colorFilter: ColorFilter.mode(
                                      filters.states.contains(e['id'])
                                          ? (Colors.white)
                                          : ColorManager
                                              .getColorFromHexaDecimal(
                                                  e['color']),
                                      BlendMode.srcIn),
                                  height: 20,
                                  width: 20,
                                ),
                                text: e['name'],
                                color: filters.states.contains(e['id'])
                                    ? themeProvider.themeManager.primaryColour
                                    : themeProvider.themeManager
                                        .secondaryBackgroundDefaultColor,
                                selected: filters.states.contains(e['id']),
                              ),
                            );
                    }).toList()
                        // children: [
                        //   expandedWidget(
                        //       icon: Icons.dangerous_outlined, text: 'Backlog', selected: false),
                        //   expandedWidget(
                        //       icon: Icons.wifi_calling_3_outlined, text: 'To Do', selected: false),
                        //   expandedWidget(
                        //       icon: Icons.wifi_2_bar_outlined, text: 'In Progress', selected: false),
                        //   expandedWidget(
                        //       icon: Icons.wifi_1_bar_outlined, text: 'Done', selected: false),
                        //   expandedWidget(
                        //       icon: Icons.dangerous_outlined, text: 'Cancelled', selected: false),
                        // ],
                        ),
                  ),

                  widget.issueCategory == IssueCategory.myIssues
                      ? Container()
                      : horizontalLine(),

                  widget.issueCategory == IssueCategory.myIssues
                      ? Container()
                      : CustomExpansionTile(
                          title: 'Assignees',
                          child: Wrap(
                            children: projectProvider.projectMembers
                                .map(
                                  (e) => GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (filters.assignees
                                            .contains(e['member']['id'])) {
                                          filters.assignees
                                              .remove(e['member']['id']);
                                        } else {
                                          filters.assignees
                                              .add(e['member']['id']);
                                        }
                                      });
                                    },
                                    child: expandedWidget(
                                      icon: e['member']['avatar'] != '' &&
                                              e['member']['avatar'] != null
                                          ? CircleAvatar(
                                              radius: 10,
                                              backgroundImage: NetworkImage(
                                                  e['member']['avatar']),
                                            )
                                          : CircleAvatar(
                                              radius: 10,
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      55, 65, 81, 1),
                                              child: Center(
                                                  child: CustomText(
                                                e['member']['display_name'][0]
                                                    .toString()
                                                    .toUpperCase(),
                                                color: Colors.white,
                                                fontWeight: FontWeightt.Medium,
                                                type: FontStyle.overline,
                                              )),
                                            ),
                                      text: e['member']['display_name'] ?? '',
                                      selected: filters.assignees
                                          .contains(e['member']['id']),
                                      color: filters.assignees
                                              .contains(e['member']['id'])
                                          ? themeProvider
                                              .themeManager.primaryColour
                                          : themeProvider.themeManager
                                              .secondaryBackgroundDefaultColor,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),

                  widget.issueCategory == IssueCategory.myIssues
                      ? Container()
                      : horizontalLine(),

                  widget.issueCategory == IssueCategory.myIssues
                      ? Container()
                      : CustomExpansionTile(
                          title: 'Created by',
                          child: Wrap(
                            children: projectProvider.projectMembers
                                .map(
                                  (e) => GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (filters.createdBy
                                            .contains(e['member']['id'])) {
                                          filters.createdBy
                                              .remove(e['member']['id']);
                                        } else {
                                          filters.createdBy
                                              .add(e['member']['id']);
                                        }
                                      });
                                    },
                                    child: expandedWidget(
                                      icon: e['member']['avatar'] != '' &&
                                              e['member']['avatar'] != null
                                          ? CircleAvatar(
                                              radius: 10,
                                              backgroundImage: NetworkImage(
                                                  e['member']['avatar']),
                                            )
                                          : CircleAvatar(
                                              radius: 10,
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      55, 65, 81, 1),
                                              child: Center(
                                                  child: CustomText(
                                                e['member']['display_name'][0]
                                                    .toString()
                                                    .toUpperCase(),
                                                color: Colors.white,
                                                fontWeight: FontWeightt.Medium,
                                                type: FontStyle.overline,
                                              )),
                                            ),
                                      text: e['member']['display_name'] ?? '',
                                      selected: filters.createdBy
                                          .contains(e['member']['id']),
                                      color: filters.createdBy
                                              .contains(e['member']['id'])
                                          ? themeProvider
                                              .themeManager.primaryColour
                                          : themeProvider.themeManager
                                              .secondaryBackgroundDefaultColor,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),

                  horizontalLine(),

                  CustomExpansionTile(
                    title: 'Labels',
                    child: Wrap(
                        children: (widget.issueCategory ==
                                    IssueCategory.myIssues
                                ? myIssuesProvider.labels
                                : issuesProvider.labels)
                            .map((e) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (filters.labels.contains(e['id'])) {
                                        filters.labels.remove(e['id']);
                                      } else {
                                        filters.labels.add(e['id']);
                                      }
                                    });
                                  },
                                  child: expandedWidget(
                                    icon: CircleAvatar(
                                        radius: 5,
                                        backgroundColor: ColorManager
                                            .getColorFromHexaDecimal(
                                                e['color'])),
                                    text: e['name'],
                                    selected: filters.labels.contains(e['id']),
                                    color: filters.labels.contains(e['id'])
                                        ? themeProvider
                                            .themeManager.primaryColour
                                        : themeProvider.themeManager
                                            .secondaryBackgroundDefaultColor,
                                  ),
                                ))
                            .toList()),
                  ),

                  horizontalLine(),

                  //due date\
                  CustomExpansionTile(
                    title: 'Due Date',
                    child: Wrap(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (targetLastWeek) {
                                filters.targetDate = [];
                              } else {
                                filters.targetDate = [
                                  '${DateTime.now().subtract(const Duration(days: 7)).toString().split(' ')[0]};after',
                                  '${DateTime.now().toString().split(' ')[0]};before'
                                ];
                              }
                              targetDatesEnabled();
                            });
                          },
                          child: expandedWidget(
                            icon: Icon(
                              Icons.calendar_today_outlined,
                              size: 15,
                              color: targetLastWeek
                                  ? Colors.white
                                  : themeProvider
                                      .themeManager.placeholderTextColor,
                            ),
                            text: 'Last Week',
                            selected: targetLastWeek,
                            color: targetLastWeek
                                ? themeProvider.themeManager.primaryColour
                                : themeProvider.themeManager
                                    .secondaryBackgroundDefaultColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (targetTwoWeeks) {
                                filters.targetDate = [];
                              } else {
                                filters.targetDate = [
                                  '${DateTime.now().toString().split(' ')[0]};after',
                                  '${DateTime.now().add(const Duration(days: 14)).toString().split(' ')[0]};before'
                                ];
                              }
                              targetDatesEnabled();
                            });
                          },
                          child: expandedWidget(
                            icon: Icon(
                              Icons.calendar_today_outlined,
                              size: 15,
                              color: targetTwoWeeks
                                  ? Colors.white
                                  : themeProvider
                                      .themeManager.placeholderTextColor,
                            ),
                            text: '2 Weeks from now',
                            selected: targetTwoWeeks,
                            color: targetTwoWeeks
                                ? themeProvider.themeManager.primaryColour
                                : themeProvider.themeManager
                                    .secondaryBackgroundDefaultColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (targetOneMonth) {
                                filters.targetDate = [];
                              } else {
                                filters.targetDate = [
                                  '${DateTime.now().toString().split(' ')[0]};after',
                                  '${DateTime.now().add(const Duration(days: 30)).toString().split(' ')[0]};before'
                                ];
                              }

                              targetDatesEnabled();
                            });
                          },
                          child: expandedWidget(
                            icon: Icon(
                              Icons.calendar_today_outlined,
                              size: 15,
                              color: targetOneMonth
                                  ? Colors.white
                                  : themeProvider
                                      .themeManager.placeholderTextColor,
                            ),
                            text: '1 Month from now',
                            selected: targetOneMonth,
                            color: targetOneMonth
                                ? themeProvider.themeManager.primaryColour
                                : themeProvider.themeManager
                                    .secondaryBackgroundDefaultColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (targetTwoMonths) {
                                filters.targetDate = [];
                              } else {
                                filters.targetDate = [
                                  '${DateTime.now().toString().split(' ')[0]};after',
                                  '${DateTime.now().add(const Duration(days: 60)).toString().split(' ')[0]};before'
                                ];
                              }
                              targetDatesEnabled();
                            });
                          },
                          child: expandedWidget(
                            icon: Icon(
                              Icons.calendar_today_outlined,
                              size: 15,
                              color: targetTwoMonths
                                  ? Colors.white
                                  : themeProvider
                                      .themeManager.placeholderTextColor,
                            ),
                            text: '2 Months from now',
                            selected: targetTwoMonths,
                            color: targetTwoMonths
                                ? themeProvider.themeManager.primaryColour
                                : themeProvider.themeManager
                                    .secondaryBackgroundDefaultColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            showModalBottomSheet(
                                isScrollControlled: true,
                                enableDrag: true,
                                constraints: BoxConstraints(
                                    maxHeight:
                                        MediaQuery.of(context).size.height *
                                            0.85),
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
                                                    .themeManager
                                                    .placeholderTextColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      CalendarDatePicker2(
                                        config: CalendarDatePicker2Config(
                                          calendarType:
                                              CalendarDatePicker2Type.range,
                                          selectedDayHighlightColor:
                                              themeProvider
                                                  .themeManager.primaryColour,
                                          weekdayLabelTextStyle: TextStyle(
                                            color: themeProvider
                                                .themeManager.primaryTextColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          controlsTextStyle: TextStyle(
                                            color: themeProvider
                                                .themeManager.primaryTextColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          dayTextStyle: TextStyle(
                                            color: themeProvider.themeManager
                                                .secondaryTextColor,
                                          ),
                                        ),
                                        value:
                                            _targetRangeDatePickerValueWithDefaultValue,
                                        onValueChanged: (dates) => setState(() =>
                                            _targetRangeDatePickerValueWithDefaultValue =
                                                dates),
                                      ),

                                      // two buttons taking up the whole width of the bottom sheet one to cancel and one to apply

                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20, bottom: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                              child: Button(
                                                text: 'Clear',
                                                filledButton: false,
                                                color: themeProvider
                                                    .themeManager
                                                    .primaryBackgroundDefaultColor,
                                                ontap: () {
                                                  filters.targetDate = [];
                                                  Navigator.pop(context);
                                                },
                                                textColor: themeProvider
                                                    .themeManager
                                                    .secondaryTextColor,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Button(
                                                text: 'Apply',
                                                ontap: () {
                                                  if (_targetRangeDatePickerValueWithDefaultValue
                                                          .length !=
                                                      2) {
                                                    CustomToast.showToast(
                                                        context,
                                                        message:
                                                            'Please select a date range',
                                                        toastType:
                                                            ToastType.warning);
                                                    return;
                                                  }
                                                  setState(() {
                                                    filters.targetDate = [
                                                      '${_targetRangeDatePickerValueWithDefaultValue[0].toString().split(' ')[0]};after',
                                                      '${_targetRangeDatePickerValueWithDefaultValue[1].toString().split(' ')[0]};before'
                                                    ];
                                                    targetDatesEnabled();
                                                  });
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
                          child: expandedWidget(
                            icon: Icon(
                              Icons.calendar_today_outlined,
                              size: 15,
                              color: targetCustomDate
                                  ? Colors.white
                                  : themeProvider
                                      .themeManager.secondaryTextColor,
                            ),
                            text: 'Custom Date',
                            selected: targetCustomDate,
                            color: targetCustomDate
                                ? themeProvider.themeManager.primaryColour
                                : themeProvider.themeManager
                                    .secondaryBackgroundDefaultColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  horizontalLine(),

                  //start date
                  CustomExpansionTile(
                    title: 'Start Date',
                    child: Wrap(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (startLastWeek) {
                                filters.startDate = [];
                              } else {
                                filters.startDate = [
                                  '${DateTime.now().subtract(const Duration(days: 7)).toString().split(' ')[0]};after',
                                  '${DateTime.now().toString().split(' ')[0]};before'
                                ];
                              }
                              startDatesEnabled();
                            });
                          },
                          child: expandedWidget(
                            icon: Icon(
                              Icons.calendar_today_outlined,
                              size: 15,
                              color: startLastWeek
                                  ? Colors.white
                                  : themeProvider
                                      .themeManager.placeholderTextColor,
                            ),
                            text: 'Last Week',
                            selected: startLastWeek,
                            color: startLastWeek
                                ? themeProvider.themeManager.primaryColour
                                : themeProvider.themeManager
                                    .secondaryBackgroundDefaultColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (startTwoWeeks) {
                                filters.startDate = [];
                              } else {
                                filters.startDate = [
                                  '${DateTime.now().toString().split(' ')[0]};after',
                                  '${DateTime.now().add(const Duration(days: 14)).toString().split(' ')[0]};before'
                                ];
                              }
                              startDatesEnabled();
                            });
                          },
                          child: expandedWidget(
                            icon: Icon(
                              Icons.calendar_today_outlined,
                              size: 15,
                              color: startTwoWeeks
                                  ? Colors.white
                                  : themeProvider
                                      .themeManager.placeholderTextColor,
                            ),
                            text: '2 Weeks from now',
                            selected: startTwoWeeks,
                            color: startTwoWeeks
                                ? themeProvider.themeManager.primaryColour
                                : themeProvider.themeManager
                                    .secondaryBackgroundDefaultColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (startOneMonth) {
                                filters.startDate = [];
                              } else {
                                filters.startDate = [
                                  '${DateTime.now().toString().split(' ')[0]};after',
                                  '${DateTime.now().add(const Duration(days: 30)).toString().split(' ')[0]};before'
                                ];
                              }
                              startDatesEnabled();
                            });
                          },
                          child: expandedWidget(
                            icon: Icon(
                              Icons.calendar_today_outlined,
                              size: 15,
                              color: startOneMonth
                                  ? Colors.white
                                  : themeProvider
                                      .themeManager.placeholderTextColor,
                            ),
                            text: '1 Month from now',
                            selected: startOneMonth,
                            color: startOneMonth
                                ? themeProvider.themeManager.primaryColour
                                : themeProvider.themeManager
                                    .secondaryBackgroundDefaultColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (startTwoMonths) {
                                filters.startDate = [];
                              } else {
                                filters.startDate = [
                                  '${DateTime.now().toString().split(' ')[0]};after',
                                  '${DateTime.now().add(const Duration(days: 60)).toString().split(' ')[0]};before'
                                ];
                              }
                              startDatesEnabled();
                            });
                          },
                          child: expandedWidget(
                            icon: Icon(
                              Icons.calendar_today_outlined,
                              size: 15,
                              color: startTwoMonths
                                  ? Colors.white
                                  : themeProvider
                                      .themeManager.placeholderTextColor,
                            ),
                            text: '2 Months from now',
                            selected: startTwoMonths,
                            color: startTwoMonths
                                ? themeProvider.themeManager.primaryColour
                                : themeProvider.themeManager
                                    .secondaryBackgroundDefaultColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            showModalBottomSheet(
                                isScrollControlled: true,
                                enableDrag: true,
                                constraints: BoxConstraints(
                                    maxHeight:
                                        MediaQuery.of(context).size.height *
                                            0.85),
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
                                                    .themeManager
                                                    .placeholderTextColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      CalendarDatePicker2(
                                        config: CalendarDatePicker2Config(
                                          calendarType:
                                              CalendarDatePicker2Type.range,
                                          selectedDayHighlightColor:
                                              themeProvider
                                                  .themeManager.primaryColour,
                                          weekdayLabelTextStyle: TextStyle(
                                            color: themeProvider
                                                .themeManager.primaryTextColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          controlsTextStyle: TextStyle(
                                            color: themeProvider
                                                .themeManager.primaryTextColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          dayTextStyle: TextStyle(
                                            color: themeProvider.themeManager
                                                .secondaryTextColor,
                                          ),
                                        ),
                                        value:
                                            _startRangeDatePickerValueWithDefaultValue,
                                        onValueChanged: (dates) => setState(() =>
                                            _startRangeDatePickerValueWithDefaultValue =
                                                dates),
                                      ),

                                      // two buttons taking up the whole width of the bottom sheet one to cancel and one to apply

                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20, bottom: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                              child: Button(
                                                text: 'Clear',
                                                filledButton: false,
                                                color: themeProvider
                                                    .themeManager
                                                    .primaryBackgroundDefaultColor,
                                                ontap: () {
                                                  filters.targetDate = [];
                                                  Navigator.pop(context);
                                                },
                                                textColor: themeProvider
                                                    .themeManager
                                                    .secondaryTextColor,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Button(
                                                text: 'Apply',
                                                ontap: () {
                                                  if (_startRangeDatePickerValueWithDefaultValue
                                                          .length !=
                                                      2) {
                                                    CustomToast.showToast(
                                                        context,
                                                        message:
                                                            'Please select a date range',
                                                        toastType:
                                                            ToastType.warning);
                                                    return;
                                                  }
                                                  setState(() {
                                                    filters.startDate = [
                                                      '${_startRangeDatePickerValueWithDefaultValue[0].toString().split(' ')[0]};after',
                                                      '${_startRangeDatePickerValueWithDefaultValue[1].toString().split(' ')[0]};before'
                                                    ];
                                                    targetDatesEnabled();
                                                  });
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
                          child: expandedWidget(
                            icon: Icon(
                              Icons.calendar_today_outlined,
                              size: 15,
                              color: startCustomDate
                                  ? Colors.white
                                  : themeProvider
                                      .themeManager.secondaryTextColor,
                            ),
                            text: 'Custom Date',
                            selected: startCustomDate,
                            color: startCustomDate
                                ? themeProvider.themeManager.primaryColour
                                : themeProvider.themeManager
                                    .secondaryBackgroundDefaultColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: isFilterEmpty()
                        ? null
                        : () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CreateView(
                                      filtersData: filters,
                                      fromProjectIssues: true,
                                    )));
                            // Navigator.of(context).pop();
                          },
                    child: Container(
                      // width: width * 0.42,
                      width: MediaQuery.of(context).size.width * 0.42,
                      height: 50,
                      margin: const EdgeInsets.only(bottom: 18),
                      child: Container(
                          //blue border, light blue background, blue text

                          decoration: BoxDecoration(
                            color: isFilterEmpty()
                                ? themeProvider.themeManager.borderSubtle01Color
                                    .withOpacity(0.6)
                                : themeProvider.themeManager.primaryColour
                                    .withOpacity(0.2),
                            border: Border.all(
                                color: isFilterEmpty()
                                    ? themeProvider
                                        .themeManager.placeholderTextColor
                                    : themeProvider.themeManager.primaryColour),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Wrap(
                              children: [
                                Icon(
                                  Icons.add,
                                  color: isFilterEmpty()
                                      ? themeProvider
                                          .themeManager.placeholderTextColor
                                      : themeProvider
                                          .themeManager.primaryColour,
                                  size: 24,
                                ),
                                CustomText(
                                  '  Save View',
                                  color: isFilterEmpty()
                                      ? themeProvider
                                          .themeManager.placeholderTextColor
                                      : themeProvider
                                          .themeManager.primaryColour,
                                  fontWeight: FontWeightt.Semibold,
                                  type: FontStyle.Medium,
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                  Container(
                    height: 50,
                    // width: width * 0.42,
                    width: MediaQuery.of(context).size.width * 0.42,
                    margin: const EdgeInsets.only(bottom: 18),
                    child: Button(
                      text:
                          widget.fromCreateView ? 'Add Filter' : 'Apply Filter',
                      ontap: () {
                        log(filters.startDate.toString());
                        if (widget.fromCreateView) {
                          widget.filtersData["Filters"] =
                              Filters.toJson(filters);

                          Navigator.pop(context);
                          return;
                        }
                        widget.issueCategory == IssueCategory.myIssues
                            ? myIssuesProvider.issues.filters = filters
                            : issuesProvider.issues.filters = filters;
                        if (widget.issueCategory == IssueCategory.cycleIssues) {
                          ref
                              .watch(ProviderList.cyclesProvider)
                              .filterCycleIssues(
                                slug: ref
                                    .read(ProviderList.workspaceProvider)
                                    .selectedWorkspace
                                    .workspaceSlug,
                                projectId: ref
                                    .read(ProviderList.projectProvider)
                                    .currentProject["id"],
                              )
                              .then((value) => ref
                                  .watch(ProviderList.cyclesProvider)
                                  .initializeBoard());
                        } else if (widget.issueCategory ==
                            IssueCategory.moduleIssues) {
                          ref
                              .watch(ProviderList.modulesProvider)
                              .filterModuleIssues(
                                slug: ref
                                    .read(ProviderList.workspaceProvider)
                                    .selectedWorkspace
                                    .workspaceSlug,
                                projectId: ref
                                    .read(ProviderList.projectProvider)
                                    .currentProject["id"],
                              )
                              .then((value) => ref
                                  .watch(ProviderList.modulesProvider)
                                  .initializeBoard());
                        } else if (widget.issueCategory ==
                            IssueCategory.myIssues) {
                          ref
                              .watch(ProviderList.myIssuesProvider)
                              .updateMyIssueView();
                          ref
                              .watch(ProviderList.myIssuesProvider)
                              .filterIssues();
                        } else {
                          if (widget.issueCategory == IssueCategory.issues) {
                            issuesProvider.updateProjectView(
                              isArchive: widget.isArchived,
                            );
                          }
                          issuesProvider.filterIssues(
                            fromViews: widget.fromViews,
                            slug: ref
                                .read(ProviderList.workspaceProvider)
                                .selectedWorkspace
                                .workspaceSlug,
                            projID: ref
                                .read(ProviderList.projectProvider)
                                .currentProject["id"],
                            isArchived: widget.isArchived,
                          );
                        }
                        Navigator.of(context).pop();
                      },
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
