import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/screens/MainScreens/Home/custom_analytics.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_rich_text.dart';
import 'package:plane_startup/widgets/custom_text.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  int selectedTab = 0;
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    getAnalytics();
  }

  void getAnalytics() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        ref
            .read(ProviderList.workspaceAnalyticsProvider.notifier)
            .getWorkspaceAnalytics(
              slug: ref
                  .watch(ProviderList.workspaceProvider)
                  .selectedWorkspace!
                  .workspaceSlug,
            );
        ref
            .read(ProviderList.workspaceCustomAnalyticsProvider.notifier)
            .getWorkspaceCustomAnalytics(
              slug: ref
                  .watch(ProviderList.workspaceProvider)
                  .selectedWorkspace!
                  .workspaceSlug,
            );
      },
    );
  }

  List pages = [
    const ScopeAndDemandWidget(),
    const CustomAnalyticsWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    var workspaceAnalyticsProvider =
        ref.watch(ProviderList.workspaceAnalyticsProvider);
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: height,
          width: width,
          child: workspaceAnalyticsProvider.analyticsState == StateEnum.loading
              ? Container()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(
                        'Analytics',
                        type: FontStyle.mainHeading,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: width,
                        child: Row(
                          children: [
                            Expanded(
                                child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedTab = 0;
                                });
                                pageController.animateToPage(0,
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.easeInOut);
                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: CustomText(
                                      'Scope and Demand',
                                      color: selectedTab == 0
                                          ? primaryColor
                                          : strokeColor,
                                      type: FontStyle.subheading,
                                    ),
                                  ),
                                  Container(
                                    color: selectedTab == 0
                                        ? primaryColor
                                        : Colors.transparent,
                                    height: 7,
                                  ),
                                ],
                              ),
                            )),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedTab = 1;
                                  });
                                  pageController.animateToPage(1,
                                      duration:
                                          const Duration(milliseconds: 250),
                                      curve: Curves.easeInOut);
                                },
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: CustomText(
                                        'Custom Analytics',
                                        color: selectedTab == 1
                                            ? primaryColor
                                            : strokeColor,
                                        type: FontStyle.subheading,
                                      ),
                                    ),
                                    Container(
                                      color: selectedTab == 1
                                          ? primaryColor
                                          : Colors.transparent,
                                      height: 7,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: PageView.builder(
                          onPageChanged: (value) => setState(() {
                            selectedTab = value;
                          }),
                          controller: pageController,
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            return pages[index];
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class ScopeAndDemandWidget extends ConsumerStatefulWidget {
  const ScopeAndDemandWidget({super.key});

  @override
  ConsumerState<ScopeAndDemandWidget> createState() =>
      _ScopeAndDemandWidgetState();
}

class _ScopeAndDemandWidgetState extends ConsumerState<ScopeAndDemandWidget> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var workspaceAnalyticsProvider =
        ref.watch(ProviderList.workspaceAnalyticsProvider);
    return workspaceAnalyticsProvider.analyticsState == StateEnum.loading
        ? Container()
        : ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: width,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: themeProvider.isDarkThemeEnabled
                        ? darkThemeBorder
                        : strokeColor,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      'DEMAND',
                      color: Colors.red,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const CustomText(
                      'Total open tasks',
                      type: FontStyle.heading2,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomText(
                      workspaceAnalyticsProvider.data!.openIssues.toString(),
                      type: FontStyle.heading,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: workspaceAnalyticsProvider
                          .data!.openIssuesClassified.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 5,
                                        backgroundColor: workspaceAnalyticsProvider
                                                    .data!
                                                    .openIssuesClassified[index]
                                                    .stateGroup ==
                                                'backlog'
                                            ? lightGreeyColor
                                            : workspaceAnalyticsProvider
                                                        .data!
                                                        .openIssuesClassified[
                                                            index]
                                                        .stateGroup ==
                                                    'started'
                                                ? Colors.yellow
                                                : workspaceAnalyticsProvider
                                                            .data!
                                                            .openIssuesClassified[
                                                                index]
                                                            .stateGroup ==
                                                        'unstarted'
                                                    ? Colors.blue
                                                    : Colors.orange,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      CustomText(
                                        workspaceAnalyticsProvider
                                            .data!
                                            .openIssuesClassified[index]
                                            .stateGroup
                                            .replaceFirst(
                                          workspaceAnalyticsProvider
                                              .data!
                                              .openIssuesClassified[index]
                                              .stateGroup[0],
                                          workspaceAnalyticsProvider
                                              .data!
                                              .openIssuesClassified[index]
                                              .stateGroup[0]
                                              .toUpperCase(),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: themeProvider
                                                    .isDarkThemeEnabled
                                                ? darkSecondaryBGC
                                                : lightSecondaryBackgroundColor),
                                        child: CustomText(
                                          workspaceAnalyticsProvider
                                              .data!
                                              .openIssuesClassified[index]
                                              .stateCount
                                              .toString(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  CustomText(
                                      '${(workspaceAnalyticsProvider.data!.openIssuesClassified[index].stateCount * 100 / workspaceAnalyticsProvider.data!.totalIssues).toString().split('.').first}%')
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              LinearPercentIndicator(
                                padding: EdgeInsets.zero,
                                barRadius: const Radius.circular(5),
                                progressColor: workspaceAnalyticsProvider
                                            .data!
                                            .openIssuesClassified[index]
                                            .stateGroup ==
                                        'backlog'
                                    ? lightStrokeColor
                                    : workspaceAnalyticsProvider
                                                .data!
                                                .openIssuesClassified[index]
                                                .stateGroup ==
                                            'started'
                                        ? Colors.yellow
                                        : workspaceAnalyticsProvider
                                                    .data!
                                                    .openIssuesClassified[index]
                                                    .stateGroup ==
                                                'unstarted'
                                            ? Colors.blue
                                            : Colors.orange,
                                backgroundColor:
                                    themeProvider.isDarkThemeEnabled
                                        ? darkThemeBorder
                                        : strokeColor,
                                percent: convertToRatio(
                                    (workspaceAnalyticsProvider
                                                .data!
                                                .openIssuesClassified[index]
                                                .stateCount *
                                            100) /
                                        workspaceAnalyticsProvider
                                            .data!.totalIssues),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: themeProvider.isDarkThemeEnabled
                                  ? darkThemeBorder
                                  : strokeColor),
                          color: themeProvider.isDarkThemeEnabled
                              ? darkSecondaryBGC
                              : lightSecondaryBackgroundColor),
                      child: CustomRichText(
                        widgets: [
                          WidgetSpan(
                              child: Icon(
                            Icons.change_history_rounded,
                            color: themeProvider.isDarkThemeEnabled
                                ? darkSecondaryTextColor
                                : greyColor,
                          )),
                          const WidgetSpan(
                              child: SizedBox(
                            width: 5,
                          )),
                          const TextSpan(text: 'Estimate Demand: '),
                          WidgetSpan(
                            child: CustomText(
                              '${workspaceAnalyticsProvider.data!.openEstimateSum}/${workspaceAnalyticsProvider.data!.totalEstimateSum}',
                              type: FontStyle.description,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              mostIssuesWidget(
                // data: workspaceAnalyticsProvider.data!.mostIssueCreatedUser,
                type: 'Created',
              ),
              const SizedBox(
                height: 20,
              ),
              mostIssuesWidget(
                // data: workspaceAnalyticsProvider.data!.mostIssueCreatedUser,
                type: 'Closed',
              ),
              const SizedBox(
                height: 20,
              ),
              chartWidget(),
              const SizedBox(
                height: 20,
              ),
              columnChartWidgt()
            ],
          );
  }

  Widget mostIssuesWidget({required String? type}) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var workspaceAnalyticsProvider =
        ref.watch(ProviderList.workspaceAnalyticsProvider);

    return Container(
      width: width,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color:
              themeProvider.isDarkThemeEnabled ? darkThemeBorder : strokeColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            'Most issues $type',
            type: FontStyle.heading2,
          ),
          const SizedBox(
            height: 10,
          ),
          ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: type == 'Created'
                ? workspaceAnalyticsProvider.data!.mostIssueCreatedUser.length
                : workspaceAnalyticsProvider.data!.mostIssueClosedUser.length,
            itemBuilder: (context, index) {
              String avatar = type == 'Created'
                  ? workspaceAnalyticsProvider
                      .data!.mostIssueCreatedUser[index].createdByAvatar
                  : workspaceAnalyticsProvider
                      .data!.mostIssueClosedUser[index].assigneesAvatar;
              return Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        avatar != ''
                            ? CircleAvatar(
                                radius: 10,
                                backgroundImage: NetworkImage(avatar),
                              )
                            : CircleAvatar(
                                radius: 10,
                                backgroundColor: darkSecondaryBGC,
                                child: Center(
                                  child: CustomText(type == 'Created'
                                      ? workspaceAnalyticsProvider
                                          .data!
                                          .mostIssueCreatedUser[index]
                                          .createdByEmail
                                          .toString()
                                          .toUpperCase()
                                      : workspaceAnalyticsProvider
                                          .data!
                                          .mostIssueClosedUser[index]
                                          .assigneesEmail
                                          .toString()
                                          .toUpperCase()),
                                ),
                              ),
                        const SizedBox(
                          width: 10,
                        ),
                        CustomText(type == 'Created'
                            ? workspaceAnalyticsProvider.data!
                                .mostIssueCreatedUser[index].createdByFirstName
                            : workspaceAnalyticsProvider.data!
                                .mostIssueClosedUser[index].assigneesFirstName)
                      ],
                    ),
                    CustomText(
                      type == 'Created'
                          ? workspaceAnalyticsProvider
                              .data!.mostIssueCreatedUser[index].count
                              .toString()
                          : workspaceAnalyticsProvider
                              .data!.mostIssueClosedUser[index].count
                              .toString(),
                      type: FontStyle.description,
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget chartWidget() {
    var workspaceAnalyticsProvider =
        ref.watch(ProviderList.workspaceAnalyticsProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    int largestCount = 0;
    final List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    Widget getBottomTiles(double value, TitleMeta meta) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: CustomText(
          months[value.toInt()],
          type: FontStyle.title,
          fontSize: 12,
        ),
      );
    }

    List<Map<String, dynamic>> chartData = [];
    if (workspaceAnalyticsProvider.analyticsState == StateEnum.success) {
      Map<int, int> monthCounts = {};
      for (var item
          in workspaceAnalyticsProvider.data!.issueCompletedMonthWise) {
        monthCounts[item.month] = item.count;
      }

      for (int month = 1; month <= 12; month++) {
        int count =
            monthCounts[month] ?? 0; // If month not found, set count to 0
        chartData.add({
          'month': month,
          'count': count,
        });
      }
    }

    for (var item in chartData) {
      int count = item["count"]; // Get the count from each item
      if (count > largestCount) {
        largestCount =
            count; // Update the largest count if a larger value is found
      }
    }

    // return SfCartesianChart(
    //   primaryYAxis: NumericAxis(
    //     majorGridLines:
    //         const MajorGridLines(width: 0), // Remove major grid lines
    //   ),
    //   primaryXAxis: CategoryAxis(
    //       labelPlacement: LabelPlacement.betweenTicks, // Adjust label placement
    //       interval: chartData.length > 5 ? 3 : 1,
    //       majorGridLines: const MajorGridLines(
    //         width: 0,
    //       ), // Remove major grid lines
    //       minorGridLines: const MinorGridLines(width: 0),
    //       axisLabelFormatter: (axisLabelRenderArgs) {
    //         return ChartAxisLabel(
    //             DateFormat('dd MMM')
    //                 .format(DateTime.parse(axisLabelRenderArgs.text)),
    //             const TextStyle(fontWeight: FontWeight.normal));
    //       }),
    //   series: <ChartSeries>[
    //     // Renders area chart
    //     AreaSeries<ChartData, DateTime>(
    //         gradient: LinearGradient(
    //             begin: Alignment.bottomCenter,
    //             end: Alignment.topCenter,
    //             colors: [
    //               Colors.white.withOpacity(0.5),
    //               Colors.white.withOpacity(0.2),
    //               primaryColor.withOpacity(0.2),
    //               primaryColor.withOpacity(0.3),
    //             ]),
    //         dataSource: chartData,
    //         xValueMapper: (ChartData data, _) => data.x,
    //         yValueMapper: (ChartData data, _) => data.y),
    //     LineSeries<ChartData, DateTime>(
    //       dashArray: [5.0, 5.0],
    //       dataSource: <ChartData>[
    //         ChartData(chartData.first.x, chartData.first.y), // First data point
    //         ChartData(chartData.last.x,
    //             0.0), // Data point at current time with Y-value of last data point
    //       ],
    //       xValueMapper: (ChartData data, _) => data.x,
    //       yValueMapper: (ChartData data, _) => data.y,
    //     ),
    //   ],
    // );
    return
        // SfCartesianChart(
        //   // X-axis representing 12 months
        //   primaryXAxis: CategoryAxis(
        //       // To display the labels inside the axis line
        //       labelPlacement: LabelPlacement.onTicks,
        //       // To avoid label overlapping
        //       labelIntersectAction: AxisLabelIntersectAction.rotate45,
        //       majorGridLines: const MajorGridLines(color: Colors.grey)),
        //   // Y-axis ranging from 0 to 200
        //   primaryYAxis: NumericAxis(
        //       ),
        //   series: <ChartSeries>[
        //     SplineSeries<Map<String, dynamic>, String>(
        //       color: Colors.blue,
        //       // Bind the data source
        //       dataSource: chartData,
        //       // Map the 'month' property to the X-axis, and 'count' property to the Y-axis
        //       xValueMapper: (data, _) => months[data['month'] - 1],
        //       yValueMapper: (data, _) => data['count'],
        //     ),
        //   ],
        // );
        Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color:
              themeProvider.isDarkThemeEnabled ? darkThemeBorder : strokeColor,
        ),
      ),
      padding: const EdgeInsets.all(15),
      height: 250,
      // width: width,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 11,
          maxY: largestCount.toDouble(),
          minY: 0,
          gridData: FlGridData(
            show: true,
            getDrawingHorizontalLine: (vale) {
              return const FlLine(
                strokeWidth: 1,
                color: Color.fromARGB(180, 216, 216, 216),
              );
            },
            drawVerticalLine: false,
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true, getTitlesWidget: getBottomTiles)),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                reservedSize: 30,
                showTitles: true,
                interval: 20,
                getTitlesWidget: (value, meta) {
                  return CustomText(
                    value == largestCount
                        ? ''
                        : value.toString().split('.').first,
                    type: FontStyle.title,
                    fontSize: 12,
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [
                ...chartData.map((e) => FlSpot(
                    double.parse(e['month'].toString()),
                    double.parse(e['count'].toString())))
              ],
              isCurved: true,
              curveSmoothness: 0.5,
              preventCurveOverShooting: true,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              color: Colors.blue,
              belowBarData: BarAreaData(
                show: true,
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 67, 141, 202),
                    Color.fromARGB(0, 33, 149, 243)
                  ],
                  stops: [0.1, 0.9],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget columnChartWidgt() {
    var workspaceAnalyticsProvider =
        ref.watch(ProviderList.workspaceAnalyticsProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    int largestCount = 0;

    List<Map<String, dynamic>> chartData = [];
    for (var issue in workspaceAnalyticsProvider.data!.pendingIssueUser) {
      Map<String, dynamic> convertedIssue = {
        "assignees__first_name": issue.assigneesFirstName,
        "assignees__last_name": issue.assigneesLastName,
        "assignees__avatar": issue.assigneesAvatar,
        "assignees__email": issue.assigneesEmail,
        "count": issue.count,
      };
      chartData.add(convertedIssue);
    }

    for (var entry in chartData) {
      int count = entry['count'] ?? 0;
      if (count > largestCount) {
        largestCount = count;
      }
    }

    Widget getBottomTiles(double value, TitleMeta meta) {
      return SideTitleWidget(
        space: 5,
        axisSide: meta.axisSide,
        child: chartData[value.toInt()]['assignees__avatar'] != null &&
                chartData[value.toInt()]['assignees__avatar'] != ''
            ? CircleAvatar(
                radius: 10,
                backgroundImage: NetworkImage(
                  chartData[value.toInt()]['assignees__avatar'],
                ),
              )
            : CircleAvatar(
                radius: 10,
                backgroundColor: darkSecondaryBGC,
                child: Center(
                  child: CustomText(
                    chartData[value.toInt()]['assignees__email']
                        .toString()[0]
                        .toUpperCase(),
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
      );
    }

    // return SfCartesianChart(
    //   primaryXAxis: CategoryAxis(
    //     majorGridLines: const MajorGridLines(width: 0),
    //     // isVisible: false
    //   ),
    //   series: <ColumnSeries<Map<String, dynamic>, String>>[
    //     ColumnSeries<Map<String, dynamic>, String>(
    //       dataSource: chartData,
    //       xValueMapper: (Map<String, dynamic> issue, _) =>
    //           issue['assignees__first_name'],
    //       yValueMapper: (Map<String, dynamic> issue, _) => issue['count'],
    //       width: 0.2,
    //       spacing: 0.2,
    //     ),
    //   ],
    // );
    return SizedBox(
      height: 250,
      width: width,
      child: BarChart(
        BarChartData(
          maxY: largestCount.toDouble(),
          minY: 0,
          gridData: FlGridData(
              show: true,
              getDrawingHorizontalLine: (vale) {
                return const FlLine(
                    strokeWidth: 1, color: Color.fromARGB(180, 216, 216, 216));
              },
              drawVerticalLine: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true, getTitlesWidget: getBottomTiles)),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                reservedSize: 30,
                showTitles: true,
                interval: largestCount >= 100 ? 80 : 4,
                getTitlesWidget: (value, meta) {
                  return CustomText(
                    value.toString().split('.').first,
                    type: FontStyle.title,
                    fontSize: 12,
                  );
                },
              ),
            ),
          ),
          barGroups: [
            ...chartData.map(
              (data) => BarChartGroupData(
                x: chartData.indexOf(data),
                barRods: [
                  BarChartRodData(
                    color: Colors.orange,
                    width: 4,
                    toY: double.parse(data['count'].toString()),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: largestCount.toDouble(),
                      color: const Color.fromARGB(95, 183, 183, 183),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double convertToRatio(double? decimalValue) {
    if (decimalValue == null) return 0.0;
    double value = decimalValue / 100;
    return value == 10 ? 1.0 : value;
  }
}
