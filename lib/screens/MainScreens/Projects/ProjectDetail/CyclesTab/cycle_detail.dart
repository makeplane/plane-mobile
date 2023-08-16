import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane_startup/bottom_sheets/assignee_sheet.dart';
import 'package:plane_startup/bottom_sheets/filter_sheet.dart';
import 'package:plane_startup/bottom_sheets/lead_sheet.dart';
import 'package:plane_startup/bottom_sheets/type_sheet.dart';
import 'package:plane_startup/bottom_sheets/views_sheet.dart';
import 'package:plane_startup/kanban/custom/board.dart';
import 'package:plane_startup/kanban/models/inputs.dart';
import 'package:plane_startup/models/chart_model.dart';
import 'package:plane_startup/models/issues.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/provider/theme_provider.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/IssuesTab/create_issue.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/calender_view.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/spreadsheet_view.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/completion_percentage.dart';
import 'package:plane_startup/widgets/custom_app_bar.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import 'package:plane_startup/widgets/empty.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CycleDetail extends ConsumerStatefulWidget {
  const CycleDetail({
    super.key,
    this.cycleId,
    this.cycleName,
    this.moduleId,
    this.moduleName,
    this.fromModule = false,
  });
  final String? cycleName;
  final String? cycleId;
  final String? moduleName;
  final String? moduleId;
  final bool fromModule;

  @override
  ConsumerState<CycleDetail> createState() => _CycleDetailState();
}

class _CycleDetailState extends ConsumerState<CycleDetail> {
  List<ChartData> chartData = [];
  PageController? pageController = PageController();
  List tempIssuesList = [];

  @override
  void initState() {
    log('Grouped By: ${ref.read(ProviderList.issuesProvider).issues.groupBY}');
    log('Cycle Id: ${widget.cycleId}');
    log('Module Id: ${widget.moduleId}');

    var issuesProvider = ref.read(ProviderList.issuesProvider);
    tempIssuesList = issuesProvider.issuesList;
    issuesProvider.issues.projectView = ProjectView.kanban;
    issuesProvider.issues.groupBY = GroupBY.state;

    issuesProvider.issues.orderBY = OrderBY.lastCreated;
    issuesProvider.issues.issueType = IssueType.all;
    issuesProvider.showEmptyStates = true;
    issuesProvider.issues.filters = Filters(
      assignees: [],
      createdBy: [],
      labels: [],
      priorities: [],
      states: [],
      targetDate: [],
    );
    widget.fromModule ? getModuleData() : getCycleData();
    super.initState();
  }

  Future getModuleData() async {
    var modulesProvider = ref.read(ProviderList.modulesProvider);
    var issuesProvider = ref.read(ProviderList.issuesProvider);

    pageController = PageController(
        initialPage: modulesProvider.moduleDetailSelectedIndex,
        keepPage: true,
        viewportFraction: 1);

    await modulesProvider
        .getModuleDetails(
            slug: ref
                .read(ProviderList.workspaceProvider)
                .selectedWorkspace!
                .workspaceSlug,
            projId: ref.read(ProviderList.projectProvider).currentProject['id'],
            moduleId: widget.moduleId!,
            disableLoading: true)
        .then((value) => getChartData(modulesProvider
            .moduleDetailsData['distribution']['completion_chart']));

    issuesProvider.getIssueProperties(
        issueCategory: IssueCategory.moduleIssues);

    modulesProvider
        .filterModuleIssues(
      slug: ref
          .read(ProviderList.workspaceProvider)
          .selectedWorkspace!
          .workspaceSlug,
      projectId: ref.read(ProviderList.projectProvider).currentProject['id'],
    )
        .then((value) {
      if (modulesProvider.issues.projectView == ProjectView.list) {
        modulesProvider.initializeBoard();
      }
    });
  }

  Future getCycleData() async {
    var cyclesProvider = ref.read(ProviderList.cyclesProvider);
    var issuesProvider = ref.read(ProviderList.issuesProvider);

    cyclesProvider.changeStateToLoading(cyclesProvider.cyclesDetailState);

    log(cyclesProvider.cycleDetailSelectedIndex.toString());

    pageController = PageController(
        initialPage: cyclesProvider.cycleDetailSelectedIndex,
        keepPage: true,
        viewportFraction: 1);

    await cyclesProvider
        .cycleDetailsCrud(
            slug: ref
                .read(ProviderList.workspaceProvider)
                .selectedWorkspace!
                .workspaceSlug,
            projectId:
                ref.read(ProviderList.projectProvider).currentProject['id'],
            method: CRUD.read,
            cycleId: widget.cycleId!)
        .then((value) => getChartData(cyclesProvider
            .cyclesDetailsData['distribution']['completion_chart']));

    ref
        .read(ProviderList.issuesProvider)
        .getIssueProperties(issueCategory: IssueCategory.cycleIssues);
    // ref.read(ProviderList.issuesProvider).getProjectView().then((value) {
    cyclesProvider
        .filterCycleIssues(
      slug: ref
          .read(ProviderList.workspaceProvider)
          .selectedWorkspace!
          .workspaceSlug,
      projectId: ref.read(ProviderList.projectProvider).currentProject['id'],
    )
        .then((value) {
      if (issuesProvider.issues.projectView == ProjectView.list) {
        cyclesProvider.initializeBoard();
      }
    });
  }

  Future getChartData(Map<String, dynamic> data) async {
    data.forEach((key, value) {
      chartData.add(ChartData(DateTime.parse(key), value.toDouble()));
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    var cyclesProviderRead = ref.read(ProviderList.cyclesProvider);
    var issueProvider = ref.watch(ProviderList.issuesProvider);
    var modulesProvider = ref.watch(ProviderList.modulesProvider);
    var projectProvider = ref.read(ProviderList.projectProvider);

    bool isLoading = widget.fromModule
        ? modulesProvider.moduleState == StateEnum.loading
        : cyclesProvider.cyclesState == StateEnum.loading;

    log(isLoading.toString());
    return WillPopScope(
      onWillPop: () async {
        // await issueProvider.getProjectView();
        // issueProvider.issuesList = tempIssuesList;
        issueProvider.getIssues(
          slug: ref
              .read(ProviderList.workspaceProvider)
              .selectedWorkspace!
              .workspaceSlug,
          projID: projectProvider.currentProject['id'],
        );
        modulesProvider.selectedIssues = [];
        cyclesProvider.selectedIssues = [];
        issueProvider.issues.projectView = issueProvider.tempProjectView;
        log(issueProvider.tempProjectView.toString());
        issueProvider.issues.groupBY = issueProvider.tempGroupBy;

        issueProvider.issues.orderBY = issueProvider.tempOrderBy;
        issueProvider.issues.issueType = issueProvider.tempIssueType;

        issueProvider.issues.filters = issueProvider.tempFilters;

        issueProvider.showEmptyStates =
            issueProvider.issueView["showEmptyGroups"];
        log('Temp Grouped By: ${ref.read(ProviderList.issuesProvider).tempGroupBy}');
        return true;
      },
      child: Scaffold(
        // backgroundColor: themeProvider.secondaryBackgroundColor,
        appBar: CustomAppBar(
          // backgroundColor: themeProvider.isDarkThemeEnabled
          //     ? darkPrimaryBackgroundDefaultColor
          //     : lightPrimaryBackgroundDefaultColor,
          // elevation: 0,
          centerTitle: true,
          elevation: false,

          onPressed: () {
            // issueProvider.issuesList = tempIssuesList;
            issueProvider.getIssues(
              slug: ref
                  .read(ProviderList.workspaceProvider)
                  .selectedWorkspace!
                  .workspaceSlug,
              projID: projectProvider.currentProject['id'],
            );
            modulesProvider.selectedIssues = [];
            cyclesProvider.selectedIssues = [];
            issueProvider.issues.projectView = issueProvider.tempProjectView;
            issueProvider.issues.groupBY = issueProvider.tempGroupBy;

            issueProvider.issues.orderBY = issueProvider.tempOrderBy;
            issueProvider.issues.issueType = issueProvider.tempIssueType;

            issueProvider.issues.filters = issueProvider.tempFilters;

            issueProvider.showEmptyStates =
                issueProvider.issueView["showEmptyGroups"];
            log('Temp Grouped By: ${ref.read(ProviderList.issuesProvider).tempGroupBy}');
            Navigator.pop(context);
          },

          text: widget.fromModule ? widget.moduleName! : widget.cycleName!,
          // color: themeProvider.primaryTextColor,
        ),
        body: isLoading
            ? Center(
                child: SizedBox(
                    width: 30,
                    height: 30,
                    child: LoadingIndicator(
                      indicatorType: Indicator.lineSpinFadeLoader,
                      colors: themeProvider.isDarkThemeEnabled
                          ? [Colors.white]
                          : [Colors.black],
                      strokeWidth: 1.0,
                      backgroundColor: Colors.transparent,
                    )),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Container(
                  //   height: 1,
                  //   width: width,
                  //   color: strokeColor,
                  // ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            widget.fromModule
                                ? {
                                    modulesProvider.changeTabIndex(0),
                                    pageController!.animateToPage(0,
                                        duration:
                                            const Duration(milliseconds: 100),
                                        curve: Curves.easeIn)
                                  }
                                : {
                                    cyclesProvider.changeTabIndex(0),
                                    pageController!.animateToPage(0,
                                        duration:
                                            const Duration(milliseconds: 100),
                                        curve: Curves.easeIn)
                                  };
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: CustomText(
                                  'Issues',
                                  // color: selected == 0
                                  //     ? primaryColor
                                  // : themeProvider.strokeColor,
                                  type: FontStyle.Large,
                                  fontWeight: FontWeightt.Medium,
                                  color: (widget.fromModule
                                          ? modulesProvider
                                                  .moduleDetailSelectedIndex ==
                                              1
                                          : cyclesProviderRead
                                                  .cycleDetailSelectedIndex ==
                                              1)
                                      ? themeProvider
                                          .themeManager.placeholderTextColor
                                      : (widget.fromModule
                                              ? modulesProvider
                                                      .moduleDetailSelectedIndex ==
                                                  1
                                              : cyclesProviderRead
                                                      .cycleDetailSelectedIndex ==
                                                  1)
                                          ? themeProvider
                                              .themeManager.placeholderTextColor
                                          : themeProvider
                                              .themeManager.primaryColour,
                                  // !themeProvider.isDarkThemeEnabled &&
                                  //         (widget.fromModule
                                  //             ? modulesProvider
                                  //                     .moduleDetailSelectedIndex ==
                                  //                 1
                                  //             : cyclesProviderRead
                                  //                     .cycleDetailSelectedIndex ==
                                  //                 1)
                                  //     ? lightSecondaryTextColor
                                  //     : themeProvider.isDarkThemeEnabled &&
                                  //             (widget.fromModule
                                  //                 ? modulesProvider
                                  //                         .moduleDetailSelectedIndex ==
                                  //                     1
                                  //                 : cyclesProviderRead
                                  //                         .cycleDetailSelectedIndex ==
                                  //                     1)
                                  //         ? darkSecondaryTextColor
                                  //         : primaryColor,
                                ),
                              ),
                              Container(
                                height: 7,
                                color: (widget.fromModule
                                        ? modulesProvider
                                                .moduleDetailSelectedIndex ==
                                            0
                                        : cyclesProviderRead
                                                .cycleDetailSelectedIndex ==
                                            0)
                                    ? primaryColor
                                    : Colors.transparent,
                              ),
                            ],
                          ),
                        )),
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            widget.fromModule
                                ? {
                                    modulesProvider.changeTabIndex(1),
                                    pageController!.animateToPage(1,
                                        duration:
                                            const Duration(milliseconds: 100),
                                        curve: Curves.easeIn)
                                  }
                                : {
                                    cyclesProvider.changeTabIndex(1),
                                    pageController!.animateToPage(1,
                                        duration:
                                            const Duration(milliseconds: 100),
                                        curve: Curves.easeIn)
                                  };
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: CustomText('Details',
                                    // color: selected == 1
                                    //     ? primaryColor
                                    // : themeProvider.strokeColor,
                                    type: FontStyle.Small,
                                    color: !themeProvider.isDarkThemeEnabled &&
                                            (widget.fromModule
                                                ? modulesProvider
                                                        .moduleDetailSelectedIndex ==
                                                    0
                                                : cyclesProviderRead
                                                        .cycleDetailSelectedIndex ==
                                                    0)
                                        ? lightSecondaryTextColor
                                        : themeProvider.isDarkThemeEnabled &&
                                                (widget.fromModule
                                                    ? modulesProvider
                                                            .moduleDetailSelectedIndex ==
                                                        0
                                                    : cyclesProviderRead
                                                            .cycleDetailSelectedIndex ==
                                                        0)
                                            ? darkSecondaryTextColor
                                            : primaryColor),
                              ),
                              Container(
                                height: 7,
                                color: (widget.fromModule
                                        ? modulesProvider
                                                .moduleDetailSelectedIndex ==
                                            1
                                        : cyclesProviderRead
                                                .cycleDetailSelectedIndex ==
                                            1)
                                    ? primaryColor
                                    : Colors.transparent,
                              )
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                  Container(
                    height: 2,
                    width: MediaQuery.of(context).size.width,
                    color: themeProvider.themeManager.borderSubtle01Color,
                  ),
                  Expanded(
                    child: PageView(
                      controller: pageController,
                      onPageChanged: (value) {
                        if (value == 0) {
                          widget.fromModule
                              ? modulesProvider.changeTabIndex(0)
                              : cyclesProvider.changeTabIndex(0);
                        } else {
                          widget.fromModule
                              ? modulesProvider.changeTabIndex(1)
                              : cyclesProvider.changeTabIndex(1);
                        }
                      },
                      children: [
                        Column(
                          children: [
                            Expanded(
                              child:
                                  ((widget.fromModule &&
                                              (modulesProvider.moduleIssueState ==
                                                      StateEnum.loading ||
                                                  modulesProvider.moduleDetailState ==
                                                      StateEnum.loading)) ||
                                          (!widget.fromModule &&
                                              (cyclesProvider.cyclesIssueState ==
                                                      StateEnum.loading ||
                                                  cyclesProvider.cyclesDetailState ==
                                                      StateEnum.loading)))
                                      ? Center(
                                          child: SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: LoadingIndicator(
                                                indicatorType: Indicator
                                                    .lineSpinFadeLoader,
                                                colors: themeProvider
                                                        .isDarkThemeEnabled
                                                    ? [Colors.white]
                                                    : [Colors.black],
                                                strokeWidth: 1.0,
                                                backgroundColor:
                                                    Colors.transparent,
                                              )),
                                        )
                                      : ((!widget.fromModule && cyclesProvider.isIssuesEmpty) ||
                                              (widget.fromModule &&
                                                  modulesProvider
                                                      .isIssuesEmpty))
                                          ? EmptyPlaceholder.emptyIssues(context,
                                              cycleId: widget.cycleId,
                                              moduleId: widget.moduleId,
                                              ref: ref)
                                          : ((!widget.fromModule && issueProvider.issues.projectView == ProjectView.list) ||
                                                  (widget.fromModule &&
                                                      issueProvider.issues.projectView ==
                                                          ProjectView.list))
                                              ? Container(
                                                  color: themeProvider
                                                      .themeManager
                                                      .primaryBackgroundDefaultColor,
                                                  margin: const EdgeInsets.only(
                                                      top: 5),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: (widget
                                                                    .fromModule
                                                                ? modulesProvider
                                                                    .issues
                                                                    .issues
                                                                : cyclesProvider
                                                                    .issues
                                                                    .issues)
                                                            .map((state) => state
                                                                        .items
                                                                        .isEmpty &&
                                                                    (widget
                                                                            .fromModule
                                                                        ? !modulesProvider
                                                                            .showEmptyStates
                                                                        : !cyclesProvider
                                                                            .showEmptyStates)
                                                                ? Container()
                                                                : SizedBox(
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                          padding:
                                                                              const EdgeInsets.only(left: 15),
                                                                          margin:
                                                                              const EdgeInsets.only(bottom: 10),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              state.leading ?? Container(),
                                                                              Container(
                                                                                padding: const EdgeInsets.only(
                                                                                  left: 10,
                                                                                ),
                                                                                child: CustomText(
                                                                                  state.title!,
                                                                                  type: FontStyle.Small,
                                                                                  color: themeProvider.isDarkThemeEnabled ? Colors.white : Colors.black,
                                                                                  fontWeight: FontWeightt.Medium,
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                alignment: Alignment.center,
                                                                                margin: const EdgeInsets.only(
                                                                                  left: 15,
                                                                                ),
                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: themeProvider.isDarkThemeEnabled ? const Color.fromRGBO(39, 42, 45, 1) : const Color.fromRGBO(222, 226, 230, 1)),
                                                                                height: 25,
                                                                                width: 30,
                                                                                child: CustomText(
                                                                                  state.items.length.toString(),
                                                                                  type: FontStyle.Medium,
                                                                                ),
                                                                              ),
                                                                              const Spacer(),
                                                                              IconButton(
                                                                                  onPressed: () {
                                                                                    if (issueProvider.issues.groupBY == GroupBY.state) {
                                                                                      issueProvider.createIssuedata['state'] = state.id;
                                                                                    } else {
                                                                                      issueProvider.createIssuedata['priority'] = 'de3c90cd-25cd-42ec-ac6c-a66caf8029bc';
                                                                                      // createIssuedata['s'] = element.id;
                                                                                    }
                                                                                    Navigator.of(context).push(MaterialPageRoute(
                                                                                        builder: (ctx) => CreateIssue(
                                                                                              moduleId: widget.moduleId,
                                                                                              cycleId: widget.cycleId,
                                                                                            )));
                                                                                  },
                                                                                  icon: const Icon(
                                                                                    Icons.add,
                                                                                    color: primaryColor,
                                                                                  )),
                                                                              const SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: state.items.map((e) => e).toList()),
                                                                        state.items.isEmpty
                                                                            ? Container(
                                                                                margin: const EdgeInsets.only(bottom: 10),
                                                                                width: MediaQuery.of(context).size.width,
                                                                                color: themeProvider.isDarkThemeEnabled ? darkBackgroundColor : Colors.white,
                                                                                padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15),
                                                                                child: const CustomText(
                                                                                  'No issues.',
                                                                                  type: FontStyle.Small,
                                                                                  maxLines: 10,
                                                                                  textAlign: TextAlign.start,
                                                                                ),
                                                                              )
                                                                            : Container(
                                                                                margin: const EdgeInsets.only(bottom: 10),
                                                                              )
                                                                      ],
                                                                    ),
                                                                  ))
                                                            .toList()),
                                                  ),
                                                )
                                              : ((!widget.fromModule && issueProvider.issues.projectView == ProjectView.kanban) ||
                                                      (widget.fromModule &&
                                                          issueProvider.issues.projectView == ProjectView.kanban))
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8),
                                                      child: KanbanBoard(
                                                        widget.fromModule
                                                            ? modulesProvider
                                                                .initializeBoard()
                                                            : cyclesProvider
                                                                .initializeBoard(),
                                                        groupEmptyStates: !(widget
                                                                .fromModule
                                                            ? modulesProvider
                                                                .showEmptyStates
                                                            : issueProvider
                                                                .showEmptyStates),
                                                        backgroundColor:
                                                            themeProvider
                                                                .themeManager
                                                                .primaryBackgroundDefaultColor,
                                                        listScrollConfig: ScrollConfig(
                                                            offset: 65,
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        100),
                                                            curve:
                                                                Curves.linear),
                                                        listTransitionDuration:
                                                            const Duration(
                                                                milliseconds:
                                                                    200),
                                                        cardTransitionDuration:
                                                            const Duration(
                                                                milliseconds:
                                                                    400),
                                                        textStyle: TextStyle(
                                                            fontSize: 19,
                                                            height: 1.3,
                                                            color: Colors
                                                                .grey.shade800,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    )
                                                  : ((!widget.fromModule && issueProvider.issues.projectView == ProjectView.calendar) || (widget.fromModule && issueProvider.issues.projectView == ProjectView.calendar))
                                                      ? const CalendarView()
                                                      : SpreadSheetView(
                                                          issueCategory:
                                                              widget.fromModule
                                                                  ? IssueCategory
                                                                      .moduleIssues
                                                                  : IssueCategory
                                                                      .cycleIssues,
                                                        ),
                            ),
                            SafeArea(
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                color: darkBackgroundColor,
                                child: Row(
                                  children: [
                                    projectProvider.role == Role.admin ||
                                            projectProvider.role == Role.member
                                        ? Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                // showModalBottomSheet(
                                                //     isScrollControlled: true,
                                                //     enableDrag: true,
                                                //     constraints: BoxConstraints(
                                                //         maxHeight:
                                                //             MediaQuery.of(context).size.height *
                                                //                 0.85),
                                                //     shape: const RoundedRectangleBorder(
                                                //         borderRadius: BorderRadius.only(
                                                //       topLeft: Radius.circular(30),
                                                //       topRight: Radius.circular(30),
                                                //     )),
                                                //     context: context,
                                                //     builder: (ctx) {
                                                //       return const FilterSheet();
                                                //     });
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CreateIssue(
                                                      moduleId: widget.moduleId,
                                                      cycleId: widget.cycleId,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: const SizedBox(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                      size: 20,
                                                    ),
                                                    CustomText(
                                                      ' Issue',
                                                      type: FontStyle.Medium,
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
                                        child: GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                            isScrollControlled: true,
                                            enableDrag: true,
                                            constraints: BoxConstraints(
                                                maxHeight:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.85),
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              topRight: Radius.circular(30),
                                            )),
                                            context: context,
                                            builder: (ctx) {
                                              return TypeSheet(
                                                issueCategory: widget.fromModule
                                                    ? IssueCategory.moduleIssues
                                                    : IssueCategory.cycleIssues,
                                              );
                                            });
                                      },
                                      child: const SizedBox(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.menu,
                                              color: Colors.white,
                                              size: 19,
                                            ),
                                            CustomText(
                                              ' Layout',
                                              type: FontStyle.Medium,
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
                                    issueProvider.issues.projectView ==
                                            ProjectView.calendar
                                        ? Container()
                                        : Expanded(
                                            child: GestureDetector(
                                            onTap: () {
                                              showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  enableDrag: true,
                                                  constraints: BoxConstraints(
                                                      maxHeight:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.9),
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(30),
                                                    topRight:
                                                        Radius.circular(30),
                                                  )),
                                                  context: context,
                                                  builder: (ctx) {
                                                    return ViewsSheet(
                                                      issueCategory:
                                                          widget.fromModule
                                                              ? IssueCategory
                                                                  .moduleIssues
                                                              : IssueCategory
                                                                  .cycleIssues,
                                                      cycleId: widget.cycleId,
                                                    );
                                                  });
                                            },
                                            child: const SizedBox(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.view_sidebar,
                                                    color: Colors.white,
                                                    size: 19,
                                                  ),
                                                  CustomText(
                                                    ' Views',
                                                    type: FontStyle.Medium,
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
                                    Expanded(
                                        child: GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                            isScrollControlled: true,
                                            enableDrag: true,
                                            constraints: BoxConstraints(
                                                maxHeight:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.85),
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              topRight: Radius.circular(30),
                                            )),
                                            context: context,
                                            builder: (ctx) {
                                              return FilterSheet(
                                                issueCategory: widget.fromModule
                                                    ? IssueCategory.moduleIssues
                                                    : IssueCategory.cycleIssues,
                                              );
                                            });
                                      },
                                      child: const SizedBox(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.filter_alt,
                                              color: Colors.white,
                                              size: 19,
                                            ),
                                            CustomText(
                                              ' Filters',
                                              type: FontStyle.Medium,
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        widget.fromModule
                            ? Container(
                                color: themeProvider.isDarkThemeEnabled
                                    ? darkSecondaryBackgroundDefaultColor
                                    : lightSecondaryBackgroundDefaultColor,
                                padding: const EdgeInsets.all(25),
                                child: activeCycleDetails(fromModule: true),
                              )
                            : Container(
                                color: themeProvider.isDarkThemeEnabled
                                    ? darkSecondaryBackgroundDefaultColor
                                    : lightSecondaryBackgroundDefaultColor,
                                padding: const EdgeInsets.all(25),
                                child: activeCycleDetails(),
                              ),
                      ],
                    ),
                  ),
                  // Expanded(
                  //     child: (widget.fromModule
                  //             ? modulesProvider.moduleDetailSelectedIndex == 0
                  //             : cyclesProviderRead.cycleDetailSelectedIndex ==
                  //                 0)
                  //         ? Container()
                  //         : Container()),
                  // ((!widget.fromModule &&
                  //             cyclesProviderRead.cycleDetailSelectedIndex ==
                  //                 0) ||
                  //         (widget.fromModule &&
                  //             modulesProvider.moduleDetailSelectedIndex == 0))
                  //     ? Container()
                  //     : Container()
                ],
              ),
      ),
    );
  }

  Widget activeCycleDetails({bool fromModule = false}) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    var modulesProvider = ref.watch(ProviderList.modulesProvider);

    if (widget.fromModule
        ? modulesProvider.moduleDetailState == StateEnum.loading
        : cyclesProvider.cyclesDetailState == StateEnum.loading) {
      return Center(
        child: SizedBox(
          width: 30,
          height: 30,
          child: LoadingIndicator(
            indicatorType: Indicator.lineSpinFadeLoader,
            colors: themeProvider.isDarkThemeEnabled
                ? [Colors.white]
                : [Colors.black],
            strokeWidth: 1.0,
            backgroundColor: Colors.transparent,
          ),
        ),
      );
    } else {
      return ListView(
        children: [
          datePart(),
          const SizedBox(height: 30),
          detailsPart(),
          const SizedBox(height: 30),
          progressPart(),
          const SizedBox(height: 30),
          assigneesPart(fromModule: widget.fromModule),
          const SizedBox(height: 30),
          statesPart(),
          const SizedBox(height: 30),
          labelsPart(fromModule: widget.fromModule),
        ],
      );
    }
  }

  Widget datePart() {
    var cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    var modulesProvider = ref.watch(ProviderList.modulesProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var detailData = widget.fromModule
        ? modulesProvider.moduleDetailsData
        : cyclesProvider.cyclesDetailsData;
    return Row(
      children: [
        (detailData['start_date'] == null || detailData['start_date'] == '') ||
                (detailData[widget.fromModule ? 'target_date' : 'end_date'] ==
                        null ||
                    detailData[
                            widget.fromModule ? 'target_date' : 'end_date'] ==
                        '')
            ? Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: themeProvider.isDarkThemeEnabled
                        ? greenWithOpacity
                        : lightGreeyColor,
                    borderRadius: BorderRadius.circular(5)),
                child: const CustomText(
                  'Draft',
                  color: greyColor,
                ),
              )
            : Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: checkDate(
                                startDate: detailData['start_date'],
                                endDate: detailData[widget.fromModule
                                    ? 'target_date'
                                    : 'end_date']) ==
                            'Draft'
                        ? lightGreeyColor
                        : checkDate(
                                    startDate: detailData['start_date'],
                                    endDate: detailData[widget.fromModule
                                        ? 'target_date'
                                        : 'end_date']) ==
                                'Completed'
                            ? primaryLightColor
                            : greenWithOpacity,
                    borderRadius: BorderRadius.circular(5)),
                child: CustomText(
                  checkDate(
                    startDate: detailData['start_date'],
                    endDate: detailData[
                        widget.fromModule ? 'target_date' : 'end_date'],
                  ),
                  color: checkDate(
                            startDate: detailData['start_date'],
                            endDate: detailData[
                                widget.fromModule ? 'target_date' : 'end_date'],
                          ) ==
                          'Draft'
                      ? greyColor
                      : checkDate(
                                startDate: detailData['start_date'],
                                endDate: detailData[widget.fromModule
                                    ? 'target_date'
                                    : 'end_date'],
                              ) ==
                              'Completed'
                          ? primaryColor
                          : greenHighLight,
                ),
              ),
        const SizedBox(width: 20),
        Row(
          children: [
            GestureDetector(
              onTap: () async {
                var date = await showDatePicker(
                  builder: (context, child) => Theme(
                    data: themeProvider.isDarkThemeEnabled
                        ? ThemeData.dark().copyWith(
                            colorScheme: const ColorScheme.dark(
                              primary: primaryColor,
                            ),
                          )
                        : ThemeData.light().copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: primaryColor,
                            ),
                          ),
                    child: child!,
                  ),
                  context: context,
                  initialDate: DateFormat('yyyy-MM-dd').parse(
                      detailData['start_date'] == null ||
                              detailData['start_date'] == ''
                          ? DateTime.now().toString()
                          : detailData['start_date']!),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2025),
                );
                if (date != null) {
                  if (widget.fromModule) {
                    modulesProvider.updateModules(
                        disableLoading: true,
                        slug: ref
                            .read(ProviderList.workspaceProvider)
                            .selectedWorkspace!
                            .workspaceSlug,
                        projId: ref
                            .read(ProviderList.projectProvider)
                            .currentProject["id"],
                        moduleId: widget.moduleId!,
                        data: {
                          'start_date': DateFormat('yyyy-MM-dd').format(date)
                        });
                  } else {
                    cyclesProvider.cycleDetailsCrud(
                      disableLoading: true,
                      slug: ref
                          .read(ProviderList.workspaceProvider)
                          .selectedWorkspace!
                          .workspaceSlug,
                      projectId: ref
                          .read(ProviderList.projectProvider)
                          .currentProject["id"],
                      method: CRUD.update,
                      cycleId: widget.cycleId!,
                      data: {
                        'start_date': DateFormat('yyyy-MM-dd').format(date)
                      },
                    );
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                      width: 1, color: getBorderColor(themeProvider)),
                ),
                child: (detailData['start_date'] == null ||
                            detailData['start_date'] == '') ||
                        (detailData[widget.fromModule
                                    ? 'target_date'
                                    : 'end_date'] ==
                                null ||
                            detailData[widget.fromModule
                                    ? 'target_date'
                                    : 'end_date'] ==
                                '')
                    ? CustomText(
                        'Start Date',
                        type: FontStyle.Medium,
                        fontWeight: FontWeightt.Regular,
                        color: themeProvider.themeManager.secondaryTextColor,
                      )
                    : Row(
                        children: [
                          Icon(Icons.calendar_today_outlined,
                              size: 15,
                              color: themeProvider
                                  .themeManager.placeholderTextColor),
                          const SizedBox(width: 7),
                          CustomText(
                            '${dateFormating(detailData['start_date'])} ',
                            type: FontStyle.Medium,
                            fontWeight: FontWeightt.Regular,
                            color:
                                themeProvider.themeManager.secondaryTextColor,
                          ),
                        ],
                      ),
              ),
            ),
            //arrow
            const SizedBox(width: 7),
            Icon(
              Icons.arrow_forward,
              size: 15,
              color: themeProvider.themeManager.placeholderTextColor,
            ),
            const SizedBox(width: 7),
            GestureDetector(
              onTap: () async {
                var date = await showDatePicker(
                  builder: (context, child) => Theme(
                    data: themeProvider.isDarkThemeEnabled
                        ? ThemeData.dark().copyWith(
                            colorScheme: const ColorScheme.dark(
                              primary: primaryColor,
                            ),
                          )
                        : ThemeData.light().copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: primaryColor,
                            ),
                          ),
                    child: child!,
                  ),
                  context: context,
                  initialDate: DateFormat('yyyy-MM-dd').parse(detailData[
                                  widget.fromModule
                                      ? 'target_date'
                                      : 'end_date'] ==
                              null ||
                          detailData[widget.fromModule
                                  ? 'target_date'
                                  : 'end_date'] ==
                              ''
                      ? DateTime.now().toString()
                      : detailData[
                          widget.fromModule ? 'target_date' : 'end_date']!),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2025),
                );

                if (date != null) {
                  if (widget.fromModule) {
                    modulesProvider.updateModules(
                        disableLoading: true,
                        slug: ref
                            .read(ProviderList.workspaceProvider)
                            .selectedWorkspace!
                            .workspaceSlug,
                        projId: ref
                            .read(ProviderList.projectProvider)
                            .currentProject["id"],
                        moduleId: widget.moduleId!,
                        data: {
                          'target_date': DateFormat('yyyy-MM-dd').format(date)
                        });
                  } else {
                    cyclesProvider.cycleDetailsCrud(
                      disableLoading: true,
                      slug: ref
                          .read(ProviderList.workspaceProvider)
                          .selectedWorkspace!
                          .workspaceSlug,
                      projectId: ref
                          .read(ProviderList.projectProvider)
                          .currentProject["id"],
                      method: CRUD.update,
                      cycleId: widget.cycleId!,
                      data: {'end_date': DateFormat('yyyy-MM-dd').format(date)},
                    );
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  // color: Colors.white,
                  border: Border.all(
                      width: 1, color: getBorderColor(themeProvider)),
                ),
                child: (detailData['start_date'] == null ||
                            detailData['start_date'] == '') ||
                        (detailData[widget.fromModule
                                    ? 'target_date'
                                    : 'end_date'] ==
                                null ||
                            detailData[widget.fromModule
                                    ? 'target_date'
                                    : 'end_date'] ==
                                '')
                    ? CustomText('End Date',
                        type: FontStyle.Medium,
                        fontWeight: FontWeightt.Regular,
                        color: themeProvider.themeManager.secondaryTextColor)
                    : Row(
                        children: [
                          Icon(Icons.calendar_today_outlined,
                              size: 15,
                              color: themeProvider
                                  .themeManager.placeholderTextColor),
                          const SizedBox(width: 7),
                          CustomText(
                              '${dateFormating(detailData[widget.fromModule ? 'target_date' : 'end_date'])} ',
                              type: FontStyle.Medium,
                              fontWeight: FontWeightt.Regular,
                              color: themeProvider
                                  .themeManager.secondaryTextColor),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget detailsPart() {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              'Details',
              type: FontStyle.Medium,
              fontWeight: FontWeightt.Medium,
              color: themeProvider.themeManager.primaryTextColor,
            )),
        const SizedBox(height: 10),
        stateWidget(),
        const SizedBox(height: 10),
        assigneeWidget(),
        widget.fromModule
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  membersWidget(),
                ],
              )
            : Container(),
      ],
    );
  }

  Widget progressPart() {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              'Progress',
              type: FontStyle.Medium,
              fontWeight: FontWeightt.Medium,
              color: themeProvider.themeManager.primaryTextColor,
            )),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: SfCartesianChart(
            margin: EdgeInsets.zero,
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
              },
            ),
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
                yValueMapper: (ChartData data, _) => data.y,
              ),
              LineSeries<ChartData, DateTime>(
                dashArray: [5.0, 5.0],
                dataSource: chartData.isNotEmpty
                    ? <ChartData>[
                        ChartData(chartData.first.x,
                            chartData.first.y), // First data point
                        ChartData(chartData.last.x,
                            0.0), // Data point at current time with Y-value of last data point
                      ]
                    : [],
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget assigneesPart({bool fromModule = false}) {
    var cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    var cyclesProviderRead = ref.read(ProviderList.cyclesProvider);
    var modulesProvider = ref.watch(ProviderList.modulesProvider);
    var issuesProvider = ref.watch(ProviderList.issuesProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);

    var detailData = widget.fromModule
        ? modulesProvider.moduleDetailsData
        : cyclesProvider.cyclesDetailsData;

    log("assignees : ${detailData['distribution']['assignees']}");

    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              'Assignees',
              type: FontStyle.Medium,
              fontWeight: FontWeightt.Medium,
              color: themeProvider.themeManager.primaryTextColor,
            )),
        const SizedBox(height: 10),
        detailData['distribution']['assignees'].length == 0 ||
                (detailData['distribution']['assignees'].length == 1 &&
                    detailData['distribution']['assignees'][0]['assignee_id'] ==
                        null)
            ? const CustomText('No data found.')
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: themeProvider.isDarkThemeEnabled
                      ? darkBackgroundColor
                      : lightBackgroundColor,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: getBorderColor(themeProvider),
                  ),
                ),
                child: Column(
                  children: [
                    ...List.generate(
                      detailData['distribution']['assignees'].length,
                      (idx) {
                        return detailData['distribution']['assignees'][idx]
                                    ['first_name'] !=
                                null
                            ? InkWell(
                                onTap: () async {
                                  {
                                    setState(
                                      () {
                                        if (issuesProvider
                                            .issues.filters.assignees
                                            .contains(detailData['distribution']
                                                    ['assignees'][idx]
                                                ['assignee_id'])) {
                                          issuesProvider
                                              .issues.filters.assignees
                                              .remove(detailData['distribution']
                                                      ['assignees'][idx]
                                                  ['assignee_id']);
                                        } else {
                                          issuesProvider
                                              .issues.filters.assignees
                                              .add(detailData['distribution']
                                                      ['assignees'][idx]
                                                  ['assignee_id']);
                                        }
                                      },
                                    );
                                  }
                                  pageController!.animateTo(
                                    0,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                  if (fromModule) {
                                    modulesProvider.changeTabIndex(0);

                                    await modulesProvider.filterModuleIssues(
                                      slug: ref
                                          .read(ProviderList.workspaceProvider)
                                          .selectedWorkspace!
                                          .workspaceSlug,
                                      projectId: ref
                                          .read(ProviderList.projectProvider)
                                          .currentProject["id"],
                                    );
                                    modulesProvider.initializeBoard();
                                  } else {
                                    cyclesProviderRead.changeTabIndex(0);
                                    await cyclesProviderRead.filterCycleIssues(
                                      slug: ref
                                          .read(ProviderList.workspaceProvider)
                                          .selectedWorkspace!
                                          .workspaceSlug,
                                      projectId: ref
                                          .read(ProviderList.projectProvider)
                                          .currentProject["id"],
                                    );
                                    cyclesProviderRead.initializeBoard();
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 8),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  decoration: BoxDecoration(
                                    color: themeProvider.isDarkThemeEnabled
                                        ? (issuesProvider
                                                .issues.filters.assignees
                                                .contains(
                                                    detailData['distribution']
                                                            ['assignees'][idx]
                                                        ['assignee_id'])
                                            ? darkThemeBorder
                                            : darkBackgroundColor)
                                        : (issuesProvider
                                                .issues.filters.assignees
                                                .contains(
                                                    detailData['distribution']
                                                            ['assignees'][idx]
                                                        ['assignee_id'])
                                            ? lightGreeyColor
                                            : lightBackgroundColor),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              child: detailData['distribution']
                                                                  ['assignees']
                                                              [idx]['avatar'] !=
                                                          null &&
                                                      detailData['distribution']
                                                                  ['assignees']
                                                              [idx]['avatar'] !=
                                                          ''
                                                  ? CircleAvatar(
                                                      radius: 10,
                                                      backgroundImage:
                                                          NetworkImage(detailData[
                                                                      'distribution']
                                                                  ['assignees']
                                                              [idx]['avatar']),
                                                    )
                                                  : CircleAvatar(
                                                      radius: 10,
                                                      backgroundColor:
                                                          darkSecondaryBGC,
                                                      child: Center(
                                                        child: CustomText(
                                                          detailData['distribution']
                                                                              ['assignees']
                                                                          [idx][
                                                                      'first_name'] !=
                                                                  null
                                                              ? detailData['distribution']
                                                                              [
                                                                              'assignees']
                                                                          [idx][
                                                                      'first_name'][0]
                                                                  .toString()
                                                                  .toUpperCase()
                                                              : '',
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    )),
                                          CustomText(detailData['distribution']
                                                      ['assignees'][idx]
                                                  ['first_name'] ??
                                              'Without Assignees'),
                                        ],
                                      ),
                                      CompletionPercentage(
                                          value: detailData['distribution']
                                                  ['assignees'][idx]
                                              ['completed_issues'],
                                          totalValue: detailData['distribution']
                                                  ['assignees'][idx]
                                              ['total_issues'])
                                    ],
                                  ),
                                ),
                              )
                            : Container(height: 25);
                      },
                    ),
                  ],
                ),
              ),
      ],
    );
  }

  Widget statesPart() {
    List states = [
      "Backlog",
      "Unstarted",
      "Started",
      "Cancelled",
      "Completed",
    ];
    var cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    var modulesProvider = ref.watch(ProviderList.modulesProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);

    var detailData = widget.fromModule
        ? modulesProvider.moduleDetailsData
        : cyclesProvider.cyclesDetailsData;

    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              'States',
              type: FontStyle.Medium,
              fontWeight: FontWeightt.Medium,
              color: themeProvider.themeManager.primaryTextColor,
            )),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: themeProvider.isDarkThemeEnabled
                ? darkBackgroundColor
                : lightBackgroundColor,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: getBorderColor(themeProvider),
            ),
          ),
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
                      type: FontStyle.Large,
                      fontWeight: FontWeightt.Regular,
                    ),
                    const Spacer(),
                    index == 0
                        ? CompletionPercentage(
                            value: detailData['backlog_issues'],
                            totalValue: detailData['total_issues'])
                        : index == 1
                            ? CompletionPercentage(
                                value: detailData['unstarted_issues'],
                                totalValue: detailData['total_issues'])
                            : index == 2
                                ? CompletionPercentage(
                                    value: detailData['started_issues'],
                                    totalValue: detailData['total_issues'])
                                : index == 3
                                    ? CompletionPercentage(
                                        value: detailData['cancelled_issues'],
                                        totalValue: detailData['total_issues'])
                                    : CompletionPercentage(
                                        value: detailData['completed_issues'],
                                        totalValue: detailData['total_issues'],
                                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget labelsPart({bool fromModule = false}) {
    var cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    var cyclesProviderRead = ref.read(ProviderList.cyclesProvider);
    var issuesProvider = ref.watch(ProviderList.issuesProvider);
    var modulesProvider = ref.watch(ProviderList.modulesProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);

    var detailData = widget.fromModule
        ? modulesProvider.moduleDetailsData
        : cyclesProvider.cyclesDetailsData;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              'Labels',
              type: FontStyle.Medium,
              fontWeight: FontWeightt.Medium,
              color: themeProvider.themeManager.primaryTextColor,
            )),
        const SizedBox(height: 10),
        detailData['distribution']['labels'].length == 1 &&
                detailData['distribution']['labels'][0]['label_id'] == null
            ? const Align(
                alignment: Alignment.center,
                child: CustomText('No data found'),
              )
            : detailData['distribution']['labels'].isNotEmpty
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: themeProvider.isDarkThemeEnabled
                          ? darkBackgroundColor
                          : lightBackgroundColor,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: getBorderColor(themeProvider),
                      ),
                    ),
                    child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: detailData['distribution']['labels'].length,
                        itemBuilder: (context, index) {
                          log('index $index');
                          return detailData['distribution']['labels'][index]
                                      ['label_id'] ==
                                  null
                              ? Container()
                              : InkWell(
                                  onTap: () async {
                                    setState(() {
                                      if (issuesProvider.issues.filters.labels
                                          .contains(detailData['distribution']
                                              ['labels'][index]['label_id'])) {
                                        issuesProvider.issues.filters.labels
                                            .remove(detailData['distribution']
                                                ['labels'][index]['label_id']);
                                      } else {
                                        issuesProvider.issues.filters.labels
                                            .add(detailData['distribution']
                                                ['labels'][index]['label_id']);
                                      }
                                    });
                                    pageController!.animateTo(0,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut);
                                    if (fromModule) {
                                      modulesProvider.changeTabIndex(0);
                                      await modulesProvider.filterModuleIssues(
                                        slug: ref
                                            .read(
                                                ProviderList.workspaceProvider)
                                            .selectedWorkspace!
                                            .workspaceSlug,
                                        projectId: ref
                                            .read(ProviderList.projectProvider)
                                            .currentProject["id"],
                                      );
                                      modulesProvider.initializeBoard();
                                    }
                                    cyclesProviderRead.changeTabIndex(0);
                                    await cyclesProviderRead.filterCycleIssues(
                                      slug: ref
                                          .read(ProviderList.workspaceProvider)
                                          .selectedWorkspace!
                                          .workspaceSlug,
                                      projectId: ref
                                          .read(ProviderList.projectProvider)
                                          .currentProject["id"],
                                    );
                                    cyclesProviderRead.initializeBoard();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 8),
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    decoration: BoxDecoration(
                                      color: themeProvider.isDarkThemeEnabled
                                          ? (issuesProvider
                                                  .issues.filters.labels
                                                  .contains(
                                                      detailData['distribution']
                                                              ['labels'][index]
                                                          ['label_id'])
                                              ? darkThemeBorder
                                              : darkBackgroundColor)
                                          : (issuesProvider
                                                  .issues.filters.labels
                                                  .contains(
                                                      detailData['distribution']
                                                              ['labels'][index]
                                                          ['label_id'])
                                              ? lightGreeyColor
                                              : lightBackgroundColor),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              size: 10,
                                              color: detailData['distribution']
                                                                      ['labels']
                                                                  [index]
                                                              ['color'] ==
                                                          '' ||
                                                      detailData['distribution']
                                                                      ['labels']
                                                                  [index]
                                                              ['color'] ==
                                                          null
                                                  ? greyColor
                                                  : Color(
                                                      int.parse(
                                                        "FF${detailData['distribution']['labels'][index]['color'].toString().toUpperCase().replaceAll("#", "")}",
                                                        radix: 16,
                                                      ),
                                                    ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            CustomText(
                                              detailData['distribution']
                                                          ['labels'][index]
                                                      ['label_name'] ??
                                                  '',
                                              maxLines: 2,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            CompletionPercentage(
                                                value:
                                                    detailData['distribution']
                                                            ['labels'][index]
                                                        ['completed_issues'],
                                                totalValue:
                                                    detailData['distribution']
                                                            ['labels'][index]
                                                        ['total_issues'])
                                            //   CircularPercentIndicator(
                                            //       radius: 10,
                                            //       lineWidth: 2,
                                            //       progressColor: primaryColor,
                                            //       percent: detailData['distribution']['labels'][index]['completed_issues'] == null ||
                                            //               detailData['distribution']
                                            //                               ['labels']
                                            //                           [index][
                                            //                       'completed_issues'] ==
                                            //                   null
                                            //           ? 1.0
                                            //           : convertToRatio(
                                            //               detailData['distribution']
                                            //                           ['labels']
                                            //                       [index][
                                            //                   'completed_issues'],
                                            //               detailData['distribution']
                                            //                       ['labels'][index]
                                            //                   ['total_issues'])),
                                            //   const SizedBox(width: 5),
                                            //   CustomText(
                                            //       '${((detailData['distribution']['labels'][index]['completed_issues'] * 100) / detailData['distribution']['labels'][index]['total_issues']).toString().split('.').first}% of ${detailData['distribution']['labels'][index]['total_issues']}')
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                        }),
                  )
                : const Align(
                    alignment: Alignment.center,
                    child: CustomText('No data found'),
                  )
      ],
    );
  }

  Widget stateWidget({bool fromModule = false}) {
    var cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    var modulesProvider = ref.watch(ProviderList.modulesProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Container(
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        color: themeProvider.isDarkThemeEnabled
            ? darkBackgroundColor
            : lightBackgroundColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: getBorderColor(themeProvider),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: [
            //icon
            Icon(
                //four squares icon
                Icons.grid_view_outlined,
                color: themeProvider.themeManager.placeholderTextColor),
            const SizedBox(width: 15),
            CustomText(
              'Progress',
              type: FontStyle.Medium,
              fontWeight: FontWeightt.Regular,
              color: themeProvider.themeManager.placeholderTextColor,
            ),
            Expanded(child: Container()),

            CompletionPercentage(
                value: widget.fromModule
                    ? modulesProvider.moduleDetailsData['completed_issues']
                    : cyclesProvider.cyclesDetailsData['completed_issues'],
                totalValue: widget.fromModule
                    ? modulesProvider.moduleDetailsData['total_issues']
                    : cyclesProvider.cyclesDetailsData['total_issues'])
          ],
        ),
      ),
    );
  }

  Widget membersWidget() {
    var modulesProvider = ref.watch(ProviderList.modulesProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Container(
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        color: themeProvider.isDarkThemeEnabled
            ? darkBackgroundColor
            : lightBackgroundColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: getBorderColor(themeProvider),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: [
            //icon
            Icon(
              //two people icon
              Icons.people_alt_rounded,
              color: themeProvider.themeManager.placeholderTextColor,
            ),
            const SizedBox(width: 15),
            // const Text(
            //   'Assignees',
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.w400,
            //     color: Color.fromRGBO(143, 143, 147, 1),
            //   ),
            // ),
            CustomText(
              'Members',
              type: FontStyle.Medium,
              fontWeight: FontWeightt.Regular,
              color: themeProvider.themeManager.placeholderTextColor,
            ),
            Expanded(child: Container()),
            GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  showBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (ctx) => const AssigneeSheet(
                            fromModuleDetail: true,
                          ));
                },
                child: (modulesProvider.currentModule['members_detail'] ==
                            null ||
                        modulesProvider.currentModule['members_detail'].isEmpty)
                    ? Row(
                        children: [
                          CustomText(
                            'No members',
                            type: FontStyle.Medium,
                            fontWeight: FontWeightt.Regular,
                            color: themeProvider.themeManager.primaryTextColor,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: themeProvider.themeManager.primaryTextColor,
                          ),
                        ],
                      )
                    : SizedBox(
                        height: 30,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: themeProvider.isDarkThemeEnabled
                                      ? darkThemeBorder
                                      : lightGreeyColor),
                              borderRadius: BorderRadius.circular(5)),
                          height: 30,
                          margin: const EdgeInsets.only(right: 5),
                          width: (modulesProvider
                                      .currentModule['members_detail'].length *
                                  22.0) +
                              ((modulesProvider.currentModule['members_detail']
                                          .length) ==
                                      1
                                  ? 15
                                  : 0),
                          child: Stack(
                            alignment: Alignment.center,
                            fit: StackFit.passthrough,
                            children: (modulesProvider
                                    .currentModule['members_detail'] as List)
                                .map((e) => Positioned(
                                      right: ((modulesProvider.currentModule[
                                                      'members_detail'] as List)
                                                  .indexOf(e) *
                                              15) +
                                          10,
                                      child: Container(
                                        height: 20,
                                        alignment: Alignment.center,
                                        width: 20,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color.fromRGBO(55, 65, 81, 1),
                                          // image: DecorationImage(
                                          //   image: NetworkImage(
                                          //       e['profileUrl']),
                                          //   fit: BoxFit.cover,
                                          // ),
                                        ),
                                        child: CustomText(
                                          e['first_name'][0]
                                              .toString()
                                              .toUpperCase(),
                                          type: FontStyle.Small,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        )))
          ],
        ),
      ),
    );
  }

  Widget assigneeWidget() {
    var cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    var modulesProvider = ref.watch(ProviderList.modulesProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var detailData = widget.fromModule
        ? modulesProvider.moduleDetailsData
        : cyclesProvider.cyclesDetailsData;

    log(detailData.toString());

    return Container(
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        color: themeProvider.isDarkThemeEnabled
            ? darkBackgroundColor
            : lightBackgroundColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: getBorderColor(themeProvider),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //icon
            Icon(
              //two people icon
              Icons.people_outline_outlined,
              color: themeProvider.themeManager.placeholderTextColor,
            ),
            const SizedBox(width: 15),
            CustomText(
              'Lead',
              type: FontStyle.Medium,
              fontWeight: FontWeightt.Regular,
              color: themeProvider.themeManager.placeholderTextColor,
            ),
            Expanded(child: Container()),
            GestureDetector(
              onTap: widget.fromModule
                  ? () {
                      showModalBottomSheet(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.5,
                        ),
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        context: context,
                        builder: (context) => LeadSheet(
                          fromModuleDetail: widget.fromModule,
                        ),
                      );
                    }
                  : () {},
              child: Row(
                children: [
                  (detailData[widget.fromModule ? 'lead_detail' : 'owned_by'] !=
                                  null &&
                              detailData[widget.fromModule
                                      ? 'lead_detail'
                                      : 'owned_by']['avatar'] !=
                                  null) &&
                          detailData[widget.fromModule
                                  ? 'lead_detail'
                                  : 'owned_by']['avatar'] !=
                              ''
                      ? CircleAvatar(
                          backgroundImage: Image.network(detailData[
                                  widget.fromModule
                                      ? 'lead_detail'
                                      : 'owned_by']['avatar'])
                              .image,
                          radius: 10,
                        )
                      : CircleAvatar(
                          radius: 10,
                          backgroundColor: darkSecondaryBGC,
                          child: Center(
                            child: CustomText(
                              (detailData[widget.fromModule
                                              ? 'lead_detail'
                                              : 'owned_by'] !=
                                          null &&
                                      detailData[widget.fromModule
                                              ? 'lead_detail'
                                              : 'owned_by']['email'] !=
                                          null)
                                  ? detailData[widget.fromModule
                                          ? 'lead_detail'
                                          : 'owned_by']['first_name'][0]
                                      .toString()
                                      .toUpperCase()
                                  : '',
                              type: FontStyle.Small,
                              textAlign: TextAlign.center,
                              color: lightSecondaryBackgroundColor,
                            ),
                          ),
                        ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    constraints: BoxConstraints(maxWidth: width * 0.4),
                    child: CustomText(
                      (detailData[widget.fromModule
                                      ? 'lead_detail'
                                      : 'owned_by'] !=
                                  null &&
                              detailData[widget.fromModule
                                      ? 'lead_detail'
                                      : 'owned_by']['first_name'] !=
                                  null)
                          ? detailData[widget.fromModule
                                  ? 'lead_detail'
                                  : 'owned_by']['first_name'] ??
                              ''
                          : '',
                      type: FontStyle.Small,
                      maxLines: 1,
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

  String dateFormating(String date) {
    DateTime formatedDate = DateTime.parse(date);
    String finalDate = DateFormat('dd MMM').format(formatedDate);
    return finalDate;
  }

  String checkDate({required String startDate, required String endDate}) {
    DateTime now = DateTime.now();
    if ((startDate.isEmpty) || (endDate.isEmpty)) {
      return 'Draft';
    } else {
      if (DateTime.parse(startDate).isAfter(now)) {
        Duration difference =
            DateTime.parse(startDate.split('+').first).difference(now);
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

  Color getBorderColor(ThemeProvider themeProvider) =>
      themeProvider.isDarkThemeEnabled ? darkThemeBorder : Colors.grey.shade200;

  String checkTimeDifferenc(String dateTime) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(DateTime.parse(dateTime));
    String? format;

    if (difference.inDays > 0) {
      format = '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      format = '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      format = '${difference.inMinutes} minutes ago';
    } else {
      format = '${difference.inSeconds} seconds ago';
    }

    return format;
  }
}
