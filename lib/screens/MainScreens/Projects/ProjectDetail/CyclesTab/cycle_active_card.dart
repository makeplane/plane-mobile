import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:plane_startup/models/chart_model.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/CyclesTab/cycle_detail.dart';
import 'package:plane_startup/utils/color_manager.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/widgets/completion_percentage.dart';
import 'package:plane_startup/widgets/custom_progress_bar.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import 'package:plane_startup/widgets/profile_circle_avatar_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '/utils/enums.dart';

class CycleActiveCard extends ConsumerStatefulWidget {
  final int index;
  const CycleActiveCard({required this.index, super.key});

  @override
  ConsumerState<CycleActiveCard> createState() => _CycleActiveCardState();
}

class _CycleActiveCardState extends ConsumerState<CycleActiveCard> {
  List states = [
    "Backlog",
    "Unstarted",
    "Started",
    "Cancelled",
    "Completed",
  ];
  List<ChartData> chartData = [];
  bool isFavorite = false;

  @override
  void initState() {
    isFavorite = ref
                .read(ProviderList.cyclesProvider)
                .cyclesActiveData[widget.index]['is_favorite'] ==
            true
        ? true
        : false;
    var cyclesProvider = ref.read(ProviderList.cyclesProvider);
    getChartData(
        cyclesProvider.cyclesActiveData[0]['distribution']['completion_chart']);
    super.initState();
  }

  getChartData(Map<String, dynamic> data) {
    data.forEach((key, value) {
      chartData.add(ChartData(DateTime.parse(key), value.toDouble()));
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    return Container(
      width: double.infinity,
      //height: 1300,
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 1,
            color: themeProvider.themeManager.borderSubtle01Color,
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          firstPart(widget.index),
          Divider(
            thickness: 1,
            color: themeProvider.themeManager.borderSubtle01Color,
          ),
          secondPart(widget.index),
          Divider(
            thickness: 1,
            color: themeProvider.themeManager.borderSubtle01Color,
          ),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              iconColor: themeProvider.themeManager.primaryTextColor,
              collapsedIconColor: themeProvider.themeManager.primaryTextColor,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    'Progress',
                    type: FontStyle.Medium,
                    fontWeight: FontWeightt.Medium,
                  ),
                  CustomProgressBar(width: width * 0.5, itemValue: [
                    cyclesProvider.cyclesActiveData[0]['backlog_issues'] ?? 0,
                    cyclesProvider.cyclesActiveData[0]['unstarted_issues'] ?? 0,
                    cyclesProvider.cyclesActiveData[0]['started_issues'] ?? 0,
                    cyclesProvider.cyclesActiveData[0]['cancelled_issues'] ?? 0,
                    cyclesProvider.cyclesActiveData[0]['completed_issues'] ?? 0,
                  ])
                ],
              ),
              children: [
                thirdPart(),
              ],
            ),
          ),
          Divider(
            thickness: 1,
            color: themeProvider.themeManager.borderSubtle01Color,
          ),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              iconColor: themeProvider.themeManager.primaryTextColor,
              collapsedIconColor: themeProvider.themeManager.primaryTextColor,
              title: const Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    'Assignees',
                    type: FontStyle.Medium,
                    fontWeight: FontWeightt.Medium,
                  )),
              children: [
                fourthPart(),
              ],
            ),
          ),
          Divider(
            thickness: 1,
            color: themeProvider.themeManager.borderSubtle01Color,
          ),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              iconColor: themeProvider.themeManager.primaryTextColor,
              collapsedIconColor: themeProvider.themeManager.primaryTextColor,
              title: const Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    'Lables',
                    type: FontStyle.Medium,
                    fontWeight: FontWeightt.Medium,
                  )),
              children: [
                fifthPart(),
              ],
            ),
          ),
          Divider(
            thickness: 1,
            color: themeProvider.themeManager.borderSubtle01Color,
          ),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              iconColor: themeProvider.themeManager.primaryTextColor,
              collapsedIconColor: themeProvider.themeManager.primaryTextColor,
              title: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    'Pending Issues - ${cyclesProvider.cyclesActiveData[widget.index]['total_issues'] - cyclesProvider.cyclesActiveData[widget.index]['completed_issues']}',
                    type: FontStyle.Medium,
                    fontWeight: FontWeightt.Medium,
                  )),
              children: [
                sixthPart(),
              ],
            ),
          ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }

  Widget firstPart(int index) {
    var cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset('assets/svg_images/cycles_icon.svg',
                  height: 25,
                  width: 25,
                  colorFilter: ColorFilter.mode(
                      themeProvider.themeManager.textSuccessColor,
                      BlendMode.srcIn)),
              const SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    cyclesProvider.cyclesActiveData[index]['name'],
                    type: FontStyle.Large,
                    fontWeight: FontWeightt.Medium,
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        color: checkDate(
                                    startDate: cyclesProvider
                                        .cyclesActiveData[index]['start_date'],
                                    endDate: cyclesProvider
                                        .cyclesActiveData[index]['end_date']) ==
                                'Draft'
                            ? themeProvider.themeManager.successBackgroundColor
                            : checkDate(
                                        startDate: cyclesProvider
                                                .cyclesActiveData[index]
                                            ['start_date'],
                                        endDate: cyclesProvider
                                                .cyclesActiveData[index]
                                            ['end_date']) ==
                                    'Completed'
                                ? themeProvider
                                    .themeManager.successBackgroundColor
                                : themeProvider
                                    .themeManager.successBackgroundColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: CustomText(
                      checkDate(
                        startDate: cyclesProvider.cyclesActiveData[index]
                            ['start_date'],
                        endDate: cyclesProvider.cyclesActiveData[index]
                            ['end_date'],
                      ),
                      color: checkDate(
                                startDate: cyclesProvider
                                    .cyclesActiveData[index]['start_date'],
                                endDate: cyclesProvider.cyclesActiveData[index]
                                    ['end_date'],
                              ) ==
                              'Draft'
                          ? themeProvider.themeManager.tertiaryTextColor
                          : checkDate(
                                    startDate: cyclesProvider
                                        .cyclesActiveData[index]['start_date'],
                                    endDate: cyclesProvider
                                        .cyclesActiveData[index]['end_date'],
                                  ) ==
                                  'Completed'
                              ? themeProvider.themeManager.placeholderTextColor
                              : themeProvider.themeManager.textSuccessColor,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              InkWell(
                  onTap: () {
                    if (isFavorite) {
                      isFavorite = false;
                    } else {
                      isFavorite = true;
                    }
                    setState(() {});

                    cyclesProvider.updateCycle(
                      disableLoading: true,
                      slug: ref
                          .read(ProviderList.workspaceProvider)
                          .selectedWorkspace!
                          .workspaceSlug,
                      projectId: ref
                          .read(ProviderList.projectProvider)
                          .currentProject['id'],
                      data: {
                        'cycle': cyclesProvider.cyclesActiveData[index]['id'],
                      },
                      query: 'current',
                      cycleId: cyclesProvider.cyclesActiveData[index]['id'],
                      isFavorite: cyclesProvider.cyclesActiveData[index]
                                  ['is_favorite'] ==
                              true
                          ? true
                          : false,
                    );
                  },
                  child: isFavorite == true
                      ? Icon(Icons.star,
                          color: themeProvider.themeManager.tertiaryTextColor)
                      : Icon(
                          Icons.star_outline,
                          color:
                              themeProvider.themeManager.placeholderTextColor,
                        )),
            ],
          ),
        ],
      ),
    );
  }

  Widget secondPart(int index) {
    var cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    var cyclesProviderRead = ref.read(ProviderList.cyclesProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
      //height: 330,
      child: Column(
        children: [
          SizedBox(
            // this right padding is added to reduce the space btw the children of the row below
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          size: 20,
                          color:
                              themeProvider.themeManager.placeholderTextColor,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        CustomText(
                          DateFormat("MMM d, yyyy").format(DateTime.parse(
                            cyclesProvider.cyclesActiveData[index]
                                ['start_date'],
                          )),
                          type: FontStyle.Medium,
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          cyclesProvider.cyclesActiveData[index]['owned_by']
                                          ['avatar'] !=
                                      '' &&
                                  cyclesProvider.cyclesActiveData[index]
                                          ['owned_by']['avatar'] !=
                                      null
                              ? CircleAvatar(
                                  radius: 10,
                                  backgroundImage: Image.network(
                                          cyclesProvider.cyclesActiveData[index]
                                              ['owned_by']['avatar'])
                                      .image,
                                )
                              : CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.amber,
                                  child: Center(
                                    child: CustomText(
                                      cyclesProvider.cyclesActiveData[index]
                                              ['owned_by']['first_name'][0]
                                          .toString()
                                          .toUpperCase(),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: width * 0.3,
                            child: CustomText(
                              cyclesProvider.cyclesActiveData[index]['owned_by']
                                      ['first_name'] ??
                                  '',
                              // color: themeProvider.secondaryTextColor,
                              type: FontStyle.Medium,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset('assets/svg_images/issues_icon.svg',
                            height: 15,
                            width: 15,
                            colorFilter: const ColorFilter.mode(
                                greyColor, BlendMode.srcIn)),
                        const SizedBox(
                          width: 10,
                        ),
                        CustomText(
                          cyclesProvider.cyclesActiveData[index]['total_issues']
                              .toString(),
                        )
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          // color: themeProvider.secondaryTextColor,
                          size: 20,
                          color:
                              themeProvider.themeManager.placeholderTextColor,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        CustomText(
                          DateFormat("MMM d, yyyy").format(DateTime.parse(
                            cyclesProvider.cyclesActiveData[index]['end_date'],
                          )),
                          type: FontStyle.Medium,
                        ),
                      ],
                    ),
                    cyclesProvider.cyclesActiveData[index]['assignees'] !=
                                null &&
                            cyclesProvider
                                .cyclesActiveData[index]['assignees'].isNotEmpty
                        ? Row(
                            children: [
                              ProfileCircleAvatarsWidget(
                                  details: cyclesProvider
                                      .cyclesActiveData[index]['assignees']),
                              const SizedBox(
                                width: 5,
                              ),
                              cyclesProvider
                                          .cyclesActiveData[index]['assignees']
                                          .length >
                                      3
                                  ? CustomText(
                                      '+ ${cyclesProvider.cyclesActiveData[index]['assignees'].length - 3}',
                                      type: FontStyle.Small,
                                    )
                                  : Container()
                            ],
                          )
                        : Icon(Icons.groups_3_outlined,
                            color: themeProvider
                                .themeManager.placeholderTextColor),
                    Row(
                      children: [
                        SvgPicture.asset('assets/svg_images/done.svg',
                            height: 20,
                            width: 20,
                            colorFilter: const ColorFilter.mode(
                                Colors.blue, BlendMode.srcIn)),
                        const SizedBox(
                          width: 10,
                        ),
                        CustomText(
                          cyclesProvider.cyclesActiveData[index]
                                  ['completed_issues']
                              .toString(),
                          type: FontStyle.Medium,
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          // Align(
          //   alignment: Alignment.centerLeft,
          //   child: CustomText('Estimates Scope'),
          // ),
          // const SizedBox(height: 10),
          // Row(
          //   children: [
          //     ...List.generate(
          //       3,
          //       (index) => Container(
          //         margin: const EdgeInsets.only(
          //           right: 10,
          //         ),
          //         width: 70,
          //         height: 24,
          //         decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(20),
          //             border: Border.all(width: 1, color: Colors.amber),
          //             color: Colors.amber.shade50),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //           children: [
          //             const Icon(
          //               Icons.circle_outlined,
          //               size: 20,
          //               color: Colors.amber,
          //             ),
          //             const Icon(
          //               Icons.add_box_outlined,
          //               size: 20,
          //               color: Colors.amber,
          //             ),
          //             CustomText(
          //               '24',
          //               color: Colors.amber,
          //             )
          //           ],
          //         ),
          //       ),
          //     ),
          //   ],
          // ),

          Align(
            alignment: Alignment.topLeft,
            child: InkWell(
              onTap: () {
                cyclesProviderRead.currentCycle =
                    cyclesProvider.cyclesActiveData[index];
                cyclesProviderRead.setState();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CycleDetail(
                            cycleName: cyclesProvider
                                .cyclesActiveData[widget.index]['name'],
                            cycleId: cyclesProvider
                                .cyclesActiveData[widget.index]['id'])));
              },
              child: Container(
                padding: const EdgeInsets.all(7),
                child: Row(
                  children: [
                    const CustomText(
                      'View Cycle',
                      color: Colors.blueAccent,
                      type: FontStyle.Medium,
                      fontWeight: FontWeightt.Semibold,
                    ),
                    const SizedBox(width: 8),
                    SvgPicture.asset(
                      'assets/svg_images/arrow_forward.svg',
                      height: 20,
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget thirdPart() {
    var cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          ...List.generate(
            states.length,
            (index) => Row(
              children: [
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SvgPicture.asset(
                      states[index] == 'Backlog'
                          ? 'assets/svg_images/circle.svg'
                          : states[index] == 'Unstarted'
                              ? 'assets/svg_images/in_progress.svg'
                              : states[index] == 'Started'
                                  ? 'assets/svg_images/done.svg'
                                  : states[index] == 'Cancelled'
                                      ? 'assets/svg_images/cancelled.svg'
                                      : 'assets/svg_images/circle.svg',
                      height: 22,
                      width: 22,
                      colorFilter: ColorFilter.mode(
                          index == 0
                              ? const Color(0xFFCED4DA)
                              : index == 1
                                  ? const Color(0xFF26B5CE)
                                  : index == 2
                                      ? const Color(0xFFF7AE59)
                                      : index == 3
                                          ? const Color(0xFFD687FF)
                                          : greenHighLight,
                          BlendMode.srcIn)),
                ),
                CustomText(
                  states[index],
                  color: themeProvider.themeManager.secondaryTextColor,
                  type: FontStyle.Large,
                  fontWeight: FontWeightt.Regular,
                ),
                const Spacer(),
                index == 0
                    ? CompletionPercentage(
                        value: cyclesProvider.cyclesActiveData[0]
                            ['backlog_issues'],
                        totalValue: cyclesProvider.cyclesActiveData[0]
                            ['total_issues'])
                    : index == 1
                        ? CompletionPercentage(
                            value: cyclesProvider.cyclesActiveData[0]
                                ['unstarted_issues'],
                            totalValue: cyclesProvider.cyclesActiveData[0]
                                ['total_issues'])
                        : index == 2
                            ? CompletionPercentage(
                                value: cyclesProvider.cyclesActiveData[0]
                                    ['started_issues'],
                                totalValue: cyclesProvider.cyclesActiveData[0]
                                    ['total_issues'])
                            : index == 3
                                ? CompletionPercentage(
                                    value: cyclesProvider.cyclesActiveData[0]
                                        ['cancelled_issues'],
                                    totalValue: cyclesProvider
                                        .cyclesActiveData[0]['total_issues'])
                                : CompletionPercentage(
                                    value: cyclesProvider.cyclesActiveData[0]
                                        ['completed_issues'],
                                    totalValue: cyclesProvider
                                        .cyclesActiveData[0]['total_issues'],
                                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget fourthPart() {
    var cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          // Align(
          //     alignment: Alignment.centerLeft,
          //     child: CustomText(
          //       'Assignees',
          //       type: FontStyle.H5,
          //     )),
          // const SizedBox(height: 10),
          ...List.generate(
            cyclesProvider
                .cyclesActiveData[widget.index]['distribution']['assignees']
                .length,
            (idx) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: cyclesProvider.cyclesActiveData[widget.index]
                                            ['distribution']['assignees'][idx]
                                        ['avatar'] !=
                                    null &&
                                cyclesProvider.cyclesActiveData[widget.index]
                                            ['distribution']['assignees'][idx]
                                        ['avatar'] !=
                                    ''
                            ? CircleAvatar(
                                radius: 10,
                                backgroundImage: NetworkImage(cyclesProvider
                                            .cyclesActiveData[widget.index]
                                        ['distribution']['assignees'][idx]
                                    ['avatar']),
                              )
                            : CircleAvatar(
                                radius: 10,
                                backgroundColor: darkSecondaryBGC,
                                child: Center(
                                  child: CustomText(
                                    cyclesProvider.cyclesActiveData[widget
                                                        .index]['distribution']
                                                    ['assignees'][idx]
                                                ['first_name'] ==
                                            null
                                        ? ''
                                        : cyclesProvider
                                            .cyclesActiveData[widget.index]
                                                ['distribution']['assignees']
                                                [idx]['first_name'][0]
                                            .toString()
                                            .toUpperCase(),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                      CustomText(
                        cyclesProvider.cyclesActiveData[widget.index]
                                    ['distribution']['assignees'][idx]
                                ['first_name'] ??
                            '',
                        fontWeight: FontWeightt.Regular,
                        color: themeProvider.themeManager.secondaryTextColor,
                        type: FontStyle.Large,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CompletionPercentage(
                          value: cyclesProvider.cyclesActiveData[widget.index]
                                  ['distribution']['assignees'][idx]
                              ['completed_issues'],
                          totalValue:
                              cyclesProvider.cyclesActiveData[widget.index]
                                      ['distribution']['assignees'][idx]
                                  ['total_issues']),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget fifthPart() {
    var cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          // Align(
          //   alignment: Alignment.centerLeft,
          //   child: CustomText(
          //     'Labels',
          //     type: FontStyle.H5,
          //   ),
          // ),
          // const SizedBox(height: 15),
          cyclesProvider
                          .cyclesActiveData[widget.index]['distribution']
                              ['labels']
                          .length ==
                      1 &&
                  cyclesProvider.cyclesActiveData[widget.index]['distribution']
                          ['labels'][0]['label_id'] ==
                      null
              ? const CustomText(
                  'No labels found',
                  type: FontStyle.Medium,
                )
              : cyclesProvider.cyclesActiveData[widget.index]['distribution']
                          ['labels'] ==
                      null
                  ? const CustomText(
                      'No labels found',
                      type: FontStyle.Medium,
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: cyclesProvider
                          .cyclesActiveData[widget.index]['distribution']
                              ['labels']
                          .length,
                      itemBuilder: (context, idx) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 10,
                                    color: cyclesProvider.cyclesActiveData[
                                                            widget.index]
                                                        ['distribution']
                                                    ['labels'][idx]['color'] ==
                                                '' ||
                                            cyclesProvider.cyclesActiveData[
                                                            widget.index]
                                                        ['distribution']
                                                    ['labels'][idx]['color'] ==
                                                null
                                        ? greyColor
                                        : ColorManager.getColorFromHexaDecimal(cyclesProvider.cyclesActiveData[widget.index]['distribution']['labels'][idx]['color'].toString()),
                                        
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    child: CustomText(
                                      cyclesProvider.cyclesActiveData[
                                                  widget.index]['distribution']
                                              ['labels'][idx]['label_name'] ??
                                          '',
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  CircularPercentIndicator(
                                      radius: 10,
                                      lineWidth: 2,
                                      progressColor: primaryColor,
                                      percent: convertToRatio((cyclesProvider
                                                              .cyclesActiveData[
                                                          widget.index]
                                                      ['distribution']['labels']
                                                  [idx]['completed_issues'] *
                                              100) /
                                          cyclesProvider
                                                      .cyclesActiveData[widget.index]
                                                  ['distribution']['labels']
                                              [idx]['total_issues'])),
                                  const SizedBox(width: 5),
                                  CustomText(
                                      '${((cyclesProvider.cyclesActiveData[widget.index]['distribution']['labels'][idx]['completed_issues'] * 100) / cyclesProvider.cyclesActiveData[widget.index]['distribution']['labels'][idx]['total_issues']).toString().split('.').first}% of ${cyclesProvider.cyclesActiveData[widget.index]['distribution']['labels'][idx]['total_issues']}')
                                ],
                              )
                            ],
                          ),
                        );
                      })
        ],
      ),
    );
  }

  Widget sixthPart() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      alignment: Alignment.center,
      child: Column(children: [
        // Align(
        //   alignment: Alignment.centerLeft,
        //   child: CustomText('Pending Issues - ${cyclesProvider.cycleFavoriteData[widget.index]['backlog_issues'] ?? '0'}', type: FontStyle.H5),
        // ),
        const SizedBox(height: 10),
        SizedBox(
            //width: 300,
            height: 200,
            child: SfCartesianChart(
                primaryYAxis: NumericAxis(
                  majorGridLines:
                      const MajorGridLines(width: 0), // Remove major grid lines
                ),
                primaryXAxis: CategoryAxis(
                    labelPlacement:
                        LabelPlacement.betweenTicks, // Adjust label placement
                    interval: chartData.length > 5 ? 3 : 1,
                    majorGridLines: const MajorGridLines(
                      width: 0,
                    ), // Remove major grid lines
                    minorGridLines: const MinorGridLines(width: 0),
                    axisLabelFormatter: (axisLabelRenderArgs) {
                      return ChartAxisLabel(
                          DateFormat('dd MMM')
                              .format(DateTime.parse(axisLabelRenderArgs.text)),
                          const TextStyle(fontWeight: FontWeight.normal));
                    }),
                series: <ChartSeries>[
                  // Renders area chart
                  AreaSeries<ChartData, DateTime>(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.white.withOpacity(0.5),
                            Colors.white.withOpacity(0.2),
                            primaryColor.withOpacity(0.2),
                            primaryColor.withOpacity(0.3),
                          ]),
                      dataSource: chartData,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y),
                  LineSeries<ChartData, DateTime>(
                    dashArray: [5.0, 5.0],
                    dataSource: <ChartData>[
                      ChartData(chartData.first.x,
                          chartData.first.y), // First data point
                      ChartData(chartData.last.x,
                          0.0), // Data point at current time with Y-value of last data point
                    ],
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                  ),
                ])),
      ]),
    );
  }

  String checkDate({required String startDate, required String endDate}) {
    DateTime now = DateTime.now();
    if ((startDate.isEmpty) || (endDate.isEmpty)) {
      return 'Draft';
    } else {
      if (DateTime.parse(startDate).isAfter(now)) {
        Duration difference = DateTime.parse(startDate).difference(now);
        if (difference.inDays == 0) {
          return 'Today';
        } else {
          return '${difference.inDays.abs() + 1} Days Left';
        }
      }
      if (DateTime.parse(startDate).isBefore(now) &&
          DateTime.parse(endDate).isAfter(now)) {
        Duration difference = DateTime.parse(endDate).difference(now);
        if (difference.inDays == 0) {
          return 'Today';
        } else {
          return '${difference.inDays.abs() + 1} Days Left';
        }
      } else {
        return 'Completed';
      }
    }
  }

  double convertToRatio(double? decimalValue) {
    if (decimalValue == null) return 0.0;
    double value = decimalValue / 100;
    return value == 10 ? 1.0 : value;
  }
}
