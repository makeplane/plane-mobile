// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plane/bottom_sheets/select_month_sheet.dart';
import 'package:plane/screens/MainScreens/Home/Dashboard/activity_graph_wdiget.dart';
import 'package:plane/utils/string_manager.dart';
import 'package:plane/widgets/workspace_logo_for_diffrent_extensions.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:plane/bottom_sheets/global_search_sheet.dart';
import 'package:plane/bottom_sheets/select_workspace.dart';
import 'package:plane/provider/dashboard_provider.dart';
import 'package:plane/provider/profile_provider.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/provider/theme_provider.dart';
import 'package:plane/screens/MainScreens/Projects/create_project_screen.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/utils/global_functions.dart';
import 'package:plane/utils/time_manager.dart';
import 'package:plane/widgets/custom_text.dart';

import '../../../on_boarding/auth/setup_workspace.dart';

class DashBoardScreen extends ConsumerStatefulWidget {
  final bool fromSignUp;
  const DashBoardScreen({required this.fromSignUp, super.key});

  @override
  ConsumerState<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends ConsumerState<DashBoardScreen> {
  @override
  void initState() {
    super.initState();
  }

  int sizeToMultiplayForEachIssue = 40;
  int constantValueToAdd = 50;

  final gridCards = [
    'Issues assigned to you',
    'Pending Issues',
    'Completed Issues',
    'Due by this week'
  ];
  final gridCardKeys = [
    'assigned_issues_count',
    'pending_issues_count',
    'completed_issues_count',
    'issues_due_week_count'
  ];
  final List<int> flexForUpcomingAndOverdueWidgets = [1, 2, 1];
  final EdgeInsets paddingForIssueInUpcomingAndOverdueWidgets =
      const EdgeInsets.only(right: 10);

  Future<void> refresh() async {
    ref.read(ProviderList.dashboardProvider).getDashboard();
    ref.read(ProviderList.workspaceProvider).getWorkspaces();
  }

  ScrollController parentScrollController = ScrollController();
  ScrollController upComingScrollController = ScrollController();
  ScrollController overDueScrollController = ScrollController();

  Offset globalPosition = const Offset(0, 0);
  ScrollPhysics physics = const ClampingScrollPhysics();

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final profileProvider = ref.watch(ProviderList.profileProvider);
    final projectProvider = ref.watch(ProviderList.projectProvider);
    final dashboardProvider = ref.watch(ProviderList.dashboardProvider);
    final List? overdueIssues =
        dashboardProvider.dashboardData['overdue_issues'];
    final List? upcomingIssues =
        dashboardProvider.dashboardData['upcoming_issues'];
    final List? stateDistribution =
        dashboardProvider.dashboardData['state_distribution'];
    final List? issuesCompleted =
        dashboardProvider.issuesClosedByMonth['completed_issues'];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 15),
        child: RefreshIndicator(
          color: themeProvider.themeManager.primaryColour,
          backgroundColor:
              themeProvider.themeManager.primaryBackgroundDefaultColor,
          onRefresh: refresh,
          child: SizedBox(
            height: height,
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: headerWidget(),
                ),
                Expanded(
                  child: ListView(
                    controller: parentScrollController,
                    children: [
                      const SizedBox(height: 20),
                      greetingAndDateTimeWidget(
                          context, profileProvider, themeProvider),
                      const SizedBox(height: 20),
                      dashboardProvider.hideGithubBlock == false
                          ? starUsOnGitHubWidget(
                              themeProvider, context, dashboardProvider)
                          : Container(),
                      const SizedBox(height: 20),
                      projectProvider.projects.isEmpty &&
                              projectProvider.getProjectState ==
                                  StateEnum.success
                          ? createProjectWidget(themeProvider, context)
                          : Container(),
                      projectProvider.projects.isNotEmpty
                          ? quichInfoWidget(
                              context, themeProvider, dashboardProvider)
                          : Container(),
                      const SizedBox(height: 20),
                      const ActivityGraphWidget(),
                      const SizedBox(height: 20),
                      // overdueIssues.isEmpty || overdueIssues.isNull
                      overdueIssues == null || overdueIssues.isEmpty
                          ? Container()
                          : Column(
                              children: [
                                overDueIssuesWidget(
                                    themeProvider, overdueIssues),
                                const SizedBox(height: 20),
                              ],
                            ),
                      upcomingIssues == null || upcomingIssues.isEmpty
                          ? Container()
                          : Column(
                              children: [
                                upcomingIssuesWidget(
                                    themeProvider, upcomingIssues),
                                const SizedBox(height: 20),
                              ],
                            ),
                      stateDistribution == null || stateDistribution.isEmpty
                          ? Container()
                          : Column(
                              children: [
                                issuesByStatesWidget(
                                    themeProvider, stateDistribution),
                                const SizedBox(height: 20),
                              ],
                            ),
                      issuesCompleted == null
                          ? Container()
                          : Column(
                              children: [
                                issuesClosedByYouWidget(themeProvider,
                                    dashboardProvider, issuesCompleted),
                                const SizedBox(height: 20),
                              ],
                            ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String greetAtTime(int hourIn24HourFormate) {
    if (hourIn24HourFormate < 12) {
      return 'Good Morning';
    } else if (hourIn24HourFormate < 17) {
      // 17 = 5 pm
      return 'Good Afternoon';
    } else {
      return 'Good evening';
    }
  }

  Widget greetingImageAtTime(int hourIn24HourFormate) {
    String whatImageToShow = '';
    if (hourIn24HourFormate < 5) {
      whatImageToShow = 'assets/images/moon.png';
    } else if (hourIn24HourFormate < 19) {
      whatImageToShow = 'assets/images/sun.png';
    } else {
      whatImageToShow = 'assets/images/moon.png';
    }

    return Image.asset(
      whatImageToShow,
      width: 20,
      height: 20,
    );
  }

  Row greetingAndDateTimeWidget(BuildContext context,
      ProfileProvider profileProvider, ThemeProvider themeProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width:
              MediaQuery.of(context).size.width * 0.85, //ToDo : make it better
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                '${greetAtTime(DateTime.now().hour)}, ${profileProvider.userProfile.firstName!.contains(' ') ? profileProvider.userProfile.firstName!.split(' ').first : profileProvider.userProfile.firstName ?? ''}',
                type: FontStyle.H5,
                fontWeight: FontWeightt.Semibold,
                maxLines: 1,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  greetingImageAtTime(DateTime.now().hour),
                  const SizedBox(width: 5),
                  CustomText(
                    DateFormat('EEEE, MMM dd,').add_jm().format(DateTime.now()),
                    type: FontStyle.XSmall,
                    fontWeight: FontWeightt.Medium,
                    color: themeProvider.themeManager.placeholderTextColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Stack starUsOnGitHubWidget(ThemeProvider themeProvider, BuildContext context,
      DashBoardProvider dashboardProvider) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color:
                  themeProvider.themeManager.secondaryBackgroundDefaultColor),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: CustomText(
                      'Plane is open source, support us by staring us on GitHub.',
                      type: FontStyle.Medium,
                      fontWeight: FontWeightt.Medium,
                      textAlign: TextAlign.start,
                      color: themeProvider.themeManager.primaryTextColor,
                      overflow: TextOverflow.visible,
                      maxLines: 5,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        dashboardProvider.hideGithubBlock = true;
                      });
                    },
                    child: Icon(
                      Icons.close,
                      color: themeProvider.themeManager.placeholderTextColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                      height: 40,
                      width: 150,
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () async {
                          //redirect to github using url launcher.
                          try {
                            final url = Uri.parse(
                                'https://github.com/makeplane/plane-mobile');

                            await launchUrl(url);
                            postHogService(
                                eventName: 'STAR_US_ON_GITHIB',
                                properties: {},
                                ref: ref);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.redAccent,
                                content: Text('Something went wrong !',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            );
                          }
                        },
                        child: Container(
                          height: 40,
                          width: 150,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: themeProvider.theme == THEME.custom
                                ? themeProvider
                                    .themeManager.tertiaryBackgroundDefaultColor
                                : themeProvider.themeManager.primaryTextColor,
                          ),
                          child: CustomText(
                            'Star us on GitHub',
                            type: FontStyle.Small,
                            fontWeight: FontWeightt.Medium,
                            color: themeProvider.themeManager.theme ==
                                        THEME.dark ||
                                    themeProvider.themeManager.theme ==
                                        THEME.darkHighContrast
                                ? Colors.black
                                : themeProvider.theme == THEME.custom
                                    ? themeProvider.themeManager
                                        .secondaryBackgroundDefaultColor
                                    : Colors.white,
                          ),
                        ),
                      )),
                ],
              )
            ],
          ),
        ),
        Positioned(
          bottom: 20,
          right: 35,
          child: Image.asset(
            themeProvider.themeManager.theme == THEME.dark ||
                    themeProvider.themeManager.theme == THEME.darkHighContrast
                ? 'assets/images/github.png'
                : 'assets/images/github_black.png',
            width: 70,
            height: 70,
          ),
        ),
      ],
    );
  }

  Container createProjectWidget(
      ThemeProvider themeProvider, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromRGBO(63, 118, 255, 0.05),
          borderRadius: BorderRadius.circular(6)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            'Create a project',
            type: FontStyle.H5,
            fontWeight: FontWeightt.Semibold,
          ),
          const SizedBox(height: 10),
          CustomText(
            'Manage your projects by creating issues, cycles, modules, views and pages.',
            type: FontStyle.Small,
            color: themeProvider.themeManager.tertiaryTextColor,
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateProject()));
            },
            child: Container(
              height: 40,
              width: 150,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: themeProvider.themeManager.primaryColour,
              ),
              child: const CustomText(
                'Create Project',
                type: FontStyle.Small,
                fontWeight: FontWeightt.Medium,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  GridView quichInfoWidget(BuildContext context, ThemeProvider themeProvider,
      DashBoardProvider dashboardProvider) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height * 0.20)),
      itemBuilder: (context, index) {
        return Container(
          //padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(
                color: themeProvider.themeManager.borderSubtle01Color),
            borderRadius: BorderRadius.circular(6),
          ),
          child: FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    gridCards[index],
                    type: FontStyle.XSmall,
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  CustomText(
                    dashboardProvider.dashboardData[gridCardKeys[index]] != null
                        ? '${dashboardProvider.dashboardData[gridCardKeys[index]]}'
                        : '0',
                    type: FontStyle.H4,
                    fontWeight: FontWeightt.Bold,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Column overDueIssuesWidget(ThemeProvider themeProvider, List overdueIssues) {
    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              'Overdue Issues',
              type: FontStyle.Medium,
              fontWeight: FontWeightt.Medium,
              color: themeProvider.themeManager.primaryTextColor,
            )),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: themeProvider.themeManager.primaryBackgroundDefaultColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: themeProvider.themeManager.borderSubtle01Color,
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(8),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: themeProvider.themeManager.toastErrorColor,
                ),
                child: Row(
                  children: [
                    Expanded(
                        flex: flexForUpcomingAndOverdueWidgets[0],
                        child: CustomText(
                          'Overdue',
                          height: 1,
                          color: themeProvider.themeManager.primaryTextColor,
                          fontWeight: FontWeightt.Semibold,
                        )),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        flex: flexForUpcomingAndOverdueWidgets[1],
                        child: CustomText(
                          'Issue',
                          height: 1,
                          color: themeProvider.themeManager.primaryTextColor,
                          fontWeight: FontWeightt.Semibold,
                        )),
                    Expanded(
                      flex: flexForUpcomingAndOverdueWidgets[2],
                      child: CustomText(
                        'Due Date',
                        height: 1,
                        color: themeProvider.themeManager.primaryTextColor,
                        fontWeight: FontWeightt.Semibold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onVerticalDragUpdate: (details) {
                  if (overDueScrollController.offset >=
                      overDueScrollController.position.maxScrollExtent) {
                    overDueScrollController.jumpTo(
                        overDueScrollController.offset -
                            (details.delta.dy - (details.delta.dy - 1)));
                    parentScrollController.jumpTo(
                        parentScrollController.offset - details.delta.dy);
                  } else {
                    overDueScrollController.jumpTo(
                        overDueScrollController.offset - details.delta.dy);
                  }
                  if (overDueScrollController.offset <=
                      overDueScrollController.position.minScrollExtent) {
                    parentScrollController.jumpTo(
                        parentScrollController.offset - details.delta.dy);
                    overDueScrollController.jumpTo(
                        overDueScrollController.offset + details.delta.dy);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    controller: overDueScrollController,
                    itemCount: overdueIssues.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => SizedBox(
                      height: sizeToMultiplayForEachIssue.toDouble(),
                      child: Row(
                        children: [
                          Expanded(
                            flex: flexForUpcomingAndOverdueWidgets[0],
                            child: CustomText(
                              '${DateTimeManager.diffrenceInDays(startDate: overdueIssues[index]['target_date'], endDate: DateTime.now().toString()).abs()}d',
                              color: themeProvider.themeManager.textErrorColor,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            flex: flexForUpcomingAndOverdueWidgets[1],
                            child: Padding(
                              padding:
                                  paddingForIssueInUpcomingAndOverdueWidgets,
                              child: CustomText(
                                overdueIssues[index]['name'],
                                maxLines: 1,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: flexForUpcomingAndOverdueWidgets[2],
                            child: CustomText(
                              DateFormat.MMMd().format(
                                DateTime.parse(
                                  overdueIssues[index]['target_date'],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column upcomingIssuesWidget(
      ThemeProvider themeProvider, List upcomingIssues) {
    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              'Upcoming Issues',
              type: FontStyle.Medium,
              fontWeight: FontWeightt.Medium,
              color: themeProvider.themeManager.primaryTextColor,
            )),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: themeProvider.themeManager.primaryBackgroundDefaultColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: themeProvider.themeManager.borderSubtle01Color,
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(8),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color:
                      themeProvider.themeManager.tertiaryBackgroundDefaultColor,
                ),
                child: Row(
                  children: [
                    Expanded(
                        flex: flexForUpcomingAndOverdueWidgets[0],
                        child: CustomText(
                          'Time',
                          fontWeight: FontWeightt.Semibold,
                          color: themeProvider.themeManager.primaryTextColor,
                        )),
                    Expanded(
                        flex: flexForUpcomingAndOverdueWidgets[1],
                        child: CustomText(
                          'Issue',
                          fontWeight: FontWeightt.Semibold,
                          color: themeProvider.themeManager.primaryTextColor,
                        )),
                    Expanded(
                      flex: flexForUpcomingAndOverdueWidgets[2],
                      child: CustomText(
                        'Start Date',
                        fontWeight: FontWeightt.Semibold,
                        color: themeProvider.themeManager.primaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onVerticalDragUpdate: (details) {
                  if (upComingScrollController.offset >=
                      upComingScrollController.position.maxScrollExtent) {
                    upComingScrollController.jumpTo(
                        upComingScrollController.offset -
                            (details.delta.dy - (details.delta.dy - 1)));
                    parentScrollController.jumpTo(
                        parentScrollController.offset - details.delta.dy);
                  } else {
                    upComingScrollController.jumpTo(
                        upComingScrollController.offset - details.delta.dy);
                  }
                  if (upComingScrollController.offset <=
                      upComingScrollController.position.minScrollExtent) {
                    parentScrollController.jumpTo(
                        parentScrollController.offset - details.delta.dy);
                    upComingScrollController.jumpTo(
                        upComingScrollController.offset + details.delta.dy);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    controller: upComingScrollController,
                    // primary: allowScroll,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: upcomingIssues.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) =>
                        // CustomText(upcomingIssues[index]['name']
                        SizedBox(
                      height: sizeToMultiplayForEachIssue.toDouble(),
                      child: Row(
                        children: [
                          Expanded(
                            flex: flexForUpcomingAndOverdueWidgets[0],
                            child: CustomText(
                              '${DateTimeManager.diffrenceInDays(startDate: upcomingIssues[index]['start_date'], endDate: DateTime.now().toString()).abs()}d',
                              color:
                                  themeProvider.themeManager.textSuccessColor,
                            ),
                          ),
                          Expanded(
                            flex: flexForUpcomingAndOverdueWidgets[1],
                            child: Padding(
                              padding:
                                  paddingForIssueInUpcomingAndOverdueWidgets,
                              child: CustomText(
                                upcomingIssues[index]['name'],
                                maxLines: 1,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: flexForUpcomingAndOverdueWidgets[2],
                            child: CustomText(
                              DateFormat.MMMd().format(
                                DateTime.parse(
                                  upcomingIssues[index]['start_date'],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column issuesByStatesWidget(
      ThemeProvider themeProvider, List stateDistribution) {
    final TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);

    final List<IssuesByState> data = List.generate(
      stateDistribution.length,
      (index) => IssuesByState(
        stateDistribution[index]['state_group'],
        stateDistribution[index]['state_count'],
      ),
    );
    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              'Issues by states',
              type: FontStyle.Medium,
              fontWeight: FontWeightt.Medium,
              color: themeProvider.themeManager.primaryTextColor,
            )),
        const SizedBox(height: 10),
        Container(
            padding:
                const EdgeInsets.only(right: 16, left: 8, top: 8, bottom: 8),
            height: 200,
            decoration: BoxDecoration(
              color: themeProvider.themeManager.primaryBackgroundDefaultColor,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: themeProvider.themeManager.borderSubtle01Color,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: SfCircularChart(
                    // margin: EdgeInsets.zero,
                    tooltipBehavior: tooltipBehavior,
                    series: <CircularSeries>[
                      DoughnutSeries<IssuesByState, String>(
                        radius: '100%',
                        innerRadius: '70%',
                        dataSource: data,
                        strokeWidth: 3,
                        strokeColor: themeProvider
                            .themeManager.primaryBackgroundDefaultColor,
                        xValueMapper: (datum, index) => datum.state,
                        yValueMapper: (datum, index) => datum.issues,
                        pointColorMapper: (datum, index) =>
                            IssuesByState.getColorForState(datum.state),
                        enableTooltip: true,
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                    child: Center(
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 15,
                            width: 15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: IssuesByState.getColorForState(
                                  data[index].state),
                            ),
                          ),
                          const SizedBox(width: 8),
                          CustomText(StringManager.capitalizeFirstLetter(
                              data[index].state)),
                          const Spacer(),
                          CustomText(data[index].issues.toString()),
                        ],
                      );
                    },
                  ),
                ))
              ],
            )),
      ],
    );
  }

  Column issuesClosedByYouWidget(ThemeProvider themeProvider,
      DashBoardProvider dashboardProvider, List issuesClosedOnMonth) {
    const Color widgetPrimaryColor = Color.fromRGBO(250, 147, 252, 1);
    final TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);
    final Map<int, int> issuesClosedPerMonthMap = {};
    final List<IssuesClosedPerMonth> data =
        List.generate(5, (index) => IssuesClosedPerMonth(index, index));

    for (final index in issuesClosedOnMonth) {
      issuesClosedPerMonthMap[index['week_in_month']] =
          index['completed_count'];
    }

    for (int i = 0; i < 5; i++) {
      if (!issuesClosedPerMonthMap.containsKey(i + 1)) {
        issuesClosedPerMonthMap[i + 1] = 0;
      }
      data[i] = IssuesClosedPerMonth(i + 1, issuesClosedPerMonthMap[i + 1]!);
    }

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomText(
              'Issues closed by you',
              type: FontStyle.Medium,
              fontWeight: FontWeightt.Medium,
              color: themeProvider.themeManager.primaryTextColor,
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  enableDrag: true,
                  constraints: BoxConstraints(
                      minHeight: height * 0.5,
                      maxHeight: MediaQuery.of(context).size.height * 0.8),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
                  context: context,
                  builder: (ctx) {
                    return const SelectMonthSheet();
                  },
                );
              },
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color:
                              themeProvider.themeManager.borderSubtle01Color)),
                  child: Row(
                    children: [
                      CustomText(
                        DateTimeManager.getMonthFromNumber(
                          dashboardProvider
                                  .selectedMonthForissuesClosedByMonthWidget -
                              1,
                        ),
                        type: FontStyle.Small,
                        height: 1,
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: themeProvider.themeManager.primaryTextColor,
                        size: 16,
                      ),
                    ],
                  )),
            )
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding:
              const EdgeInsets.only(right: 16, left: 16, top: 8, bottom: 8),
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            color: themeProvider.themeManager.primaryBackgroundDefaultColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: themeProvider.themeManager.borderSubtle01Color,
            ),
          ),
          child: issuesClosedOnMonth.isEmpty
              ? Center(
                  child: CustomText(
                  'No issues closed this month',
                  fontWeight: FontWeightt.Semibold,
                  type: FontStyle.Medium,
                  color: themeProvider.themeManager.placeholderTextColor,
                ))
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: widgetPrimaryColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const CustomText('Completed issues')
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: SfCartesianChart(
                        tooltipBehavior: tooltipBehavior,
                        backgroundColor: themeProvider
                            .themeManager.primaryBackgroundDefaultColor,
                        borderColor: Colors.transparent,
                        plotAreaBackgroundColor: Colors.transparent,
                        plotAreaBorderColor: Colors.transparent,
                        series: <ChartSeries>[
                          LineSeries<IssuesClosedPerMonth, int>(
                              width: 1,
                              name: 'Completed issues',
                              markerSettings: const MarkerSettings(
                                  isVisible: true,
                                  width: 3,
                                  height: 3,
                                  borderWidth: 3),
                              color: widgetPrimaryColor,
                              dataSource: data,
                              xValueMapper: (datum, index) => datum.week,
                              yValueMapper: (datum, index) =>
                                  datum.issuesClosed,
                              enableTooltip: true)
                        ],
                        primaryXAxis: NumericAxis(
                          majorTickLines: const MajorTickLines(width: 0),
                          minorTickLines: const MinorTickLines(width: 0),
                          minorGridLines: MinorGridLines(
                              color: themeProvider
                                  .themeManager.borderDisabledColor),
                          majorGridLines: MajorGridLines(
                              color: themeProvider
                                  .themeManager.borderDisabledColor),
                          axisLine: AxisLine(
                              color: themeProvider
                                  .themeManager.borderDisabledColor),
                          labelFormat: 'Week {value}',
                        ),
                        primaryYAxis: NumericAxis(
                            // maximumLabels: 2,
                            interval: issuesClosedOnMonth.length < 2 ? 1 : null,
                            numberFormat: NumberFormat(),
                            majorTickLines: const MajorTickLines(width: 0),
                            minorTickLines: const MinorTickLines(width: 0),
                            minorGridLines: MinorGridLines(
                                color: themeProvider
                                    .themeManager.borderDisabledColor),
                            majorGridLines: MajorGridLines(
                                color: themeProvider
                                    .themeManager.borderDisabledColor),
                            axisLine: AxisLine(
                                color: themeProvider
                                    .themeManager.borderDisabledColor),
                            anchorRangeToVisiblePoints: true),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget headerWidget() {
    final workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        border: Border(
          bottom:
              BorderSide(color: themeProvider.themeManager.borderDisabledColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                enableDrag: true,
                constraints: BoxConstraints(
                    minHeight: height * 0.5,
                    maxHeight: MediaQuery.of(context).size.height * 0.8),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )),
                context: context,
                builder: (ctx) {
                  return const SelectWorkspace();
                },
              ).then((value) {});
            },
            child: Row(
              children: [
                !workspaceProvider.selectedWorkspace.workspaceId.isNotEmpty
                    ? Container()
                    : workspaceProvider.selectedWorkspace.workspaceLogo != ''
                        ? WorkspaceLogoForDiffrentExtensions(
                            imageUrl: workspaceProvider
                                .selectedWorkspace.workspaceLogo,
                            themeProvider: themeProvider,
                            workspaceName: workspaceProvider
                                .selectedWorkspace.workspaceName)
                        : Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: themeProvider.themeManager.primaryColour,
                            ),
                            child: Center(
                              child: CustomText(
                                workspaceProvider
                                    .selectedWorkspace.workspaceName[0]
                                    .toUpperCase(),
                                type: FontStyle.Medium,
                                fontWeight: FontWeightt.Bold,
                                color: Colors.white,
                                overrride: true,
                              ),
                            ),
                          ),
                const SizedBox(
                  width: 10,
                ),
                CustomText(
                  workspaceProvider.selectedWorkspace.workspaceName,
                  type: FontStyle.H4,
                  fontWeight: FontWeightt.Semibold,
                ),
              ],
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SetupWorkspace(
                                fromHomeScreen: true,
                              )));
                },
                child: CircleAvatar(
                  backgroundColor: themeProvider
                      .themeManager.primaryBackgroundSelectedColour,
                  radius: 20,
                  child: Icon(
                    size: 20,
                    Icons.add,
                    color: themeProvider.themeManager.secondaryTextColor,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GlobalSearchSheet()));
                },
                child: CircleAvatar(
                  backgroundColor: themeProvider
                      .themeManager.primaryBackgroundSelectedColour,
                  radius: 20,
                  child: Icon(
                    size: 20,
                    Icons.search,
                    color: themeProvider.themeManager.secondaryTextColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class IssuesByState {
  IssuesByState(this.state, this.issues);
  final String state;
  final int issues;

  static Color getColorForState(String state) {
    const Color colorToReturn = Colors.red;

    switch (state) {
      case 'backlog':
        return const Color.fromRGBO(217, 217, 217, 1);
      case 'started':
        return const Color.fromRGBO(245, 158, 11, 1);
      case 'unstarted':
        return const Color.fromRGBO(63, 118, 255, 1);
      case 'completed':
        return const Color.fromRGBO(22, 163, 74, 1);
      case 'cancelled':
        return const Color.fromRGBO(220, 38, 38, 1);
    }
    return colorToReturn;
  }
}

class IssuesClosedPerMonth {
  IssuesClosedPerMonth(
    this.week,
    this.issuesClosed,
  );

  @override
  String toString() {
    return '$week : $issuesClosed';
  }

  int week;
  int issuesClosed;
}
