// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane/bottom_sheets/assignee_sheet.dart';
import 'package:plane/bottom_sheets/filters/filter_sheet.dart';
import 'package:plane/bottom_sheets/lead_sheet.dart';
import 'package:plane/bottom_sheets/type_sheet.dart';
import 'package:plane/bottom_sheets/views_sheet.dart';
import 'package:plane/kanban/custom/board.dart';
import 'package:plane/kanban/models/inputs.dart';
import 'package:plane/models/chart_model.dart';
import 'package:plane/models/issues.dart';
import 'package:plane/provider/modules_provider.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/provider/theme_provider.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/IssuesTab/create_issue.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/calender_view.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/spreadsheet_view.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/utils/extensions/string_extensions.dart';
import 'package:plane/widgets/completion_percentage.dart';
import 'package:plane/widgets/custom_app_bar.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/empty.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../bottom_sheets/add_link_sheet.dart';
import '../../../../../bottom_sheets/select_cycle_sheet.dart';
import '../IssuesTab/issue_detail.dart';

class CycleDetail extends ConsumerStatefulWidget {
  const CycleDetail(
      {super.key,
      this.cycleId,
      this.cycleName,
      this.moduleId,
      this.moduleName,
      this.fromModule = false,
      this.projId,
      this.from});
  final String? cycleName;
  final String? cycleId;
  final String? moduleName;
  final String? moduleId;
  final String? projId;
  final bool fromModule;
  final PreviousScreen? from;

  @override
  ConsumerState<CycleDetail> createState() => _CycleDetailState();
}

class _CycleDetailState extends ConsumerState<CycleDetail> {
  List<ChartData> chartData = [];
  PageController? pageController = PageController();
  List tempIssuesList = [];

  DateTime? dueDate;
  DateTime? startDate;

  @override
  void initState() {
    final issuesProvider = ref.read(ProviderList.issuesProvider);
    tempIssuesList = issuesProvider.issuesList;
    issuesProvider.tempProjectView = issuesProvider.issues.projectView;
    issuesProvider.tempGroupBy = issuesProvider.issues.groupBY;
    issuesProvider.tempOrderBy = issuesProvider.issues.orderBY;
    issuesProvider.tempIssueType = issuesProvider.issues.issueType;
    issuesProvider.tempFilters = issuesProvider.issues.filters;

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
      startDate: [],
      stateGroup: [],
      subscriber: [],
    );
    issuesProvider.filterIssues(
        cycleId: widget.cycleId,
        moduleId: widget.moduleId,
        slug: ref
            .read(ProviderList.workspaceProvider)
            .selectedWorkspace
            .workspaceSlug,
        issueCategory: widget.fromModule
            ? IssueCategory.moduleIssues
            : IssueCategory.cycleIssues,
        projID: widget.projId ??
            ref.read(ProviderList.projectProvider).currentProject['id']);
    widget.fromModule ? getModuleData() : getCycleData();
    super.initState();
  }

  Future getModuleData() async {
    final modulesProvider = ref.read(ProviderList.modulesProvider);
    final issuesProvider = ref.read(ProviderList.issuesProvider);

    pageController = PageController(
        initialPage: modulesProvider.moduleDetailSelectedIndex,
        keepPage: true,
        viewportFraction: 1);

    await modulesProvider
        .getModuleDetails(
            slug: ref
                .read(ProviderList.workspaceProvider)
                .selectedWorkspace
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
          .selectedWorkspace
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
    final cyclesProvider = ref.read(ProviderList.cyclesProvider);
    final issuesProvider = ref.read(ProviderList.issuesProvider);
    cyclesProvider.cyclesDetailState = StateEnum.loading;
    pageController = PageController(
        initialPage: cyclesProvider.cycleDetailSelectedIndex,
        keepPage: true,
        viewportFraction: 1);

    await cyclesProvider
        .cycleDetailsCrud(
            slug: ref
                .read(ProviderList.workspaceProvider)
                .selectedWorkspace
                .workspaceSlug,
            projectId: widget.projId ??
                ref.read(ProviderList.projectProvider).currentProject['id'],
            method: CRUD.read,
            disableLoading: true,
            cycleId: widget.cycleId!)
        .then((value) => getChartData(cyclesProvider
            .cyclesDetailsData['distribution']['completion_chart']));

    ref
        .read(ProviderList.issuesProvider)
        .getIssueProperties(issueCategory: IssueCategory.cycleIssues);
    cyclesProvider
        .filterCycleIssues(
      cycleID: widget.cycleId!,
      slug: ref
          .read(ProviderList.workspaceProvider)
          .selectedWorkspace
          .workspaceSlug,
      projectId: widget.projId ??
          ref.read(ProviderList.projectProvider).currentProject['id'],
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
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    final cyclesProviderRead = ref.read(ProviderList.cyclesProvider);
    final issueProvider = ref.watch(ProviderList.issuesProvider);
    final modulesProvider = ref.watch(ProviderList.modulesProvider);
    final projectProvider = ref.read(ProviderList.projectProvider);
    final bool isLoading = widget.fromModule
        ? modulesProvider.moduleState == StateEnum.loading
        : cyclesProvider.cyclesState == StateEnum.loading;

    return WillPopScope(
      onWillPop: () async {
        if (widget.from == PreviousScreen.myIssues) return true;
        issueProvider.getIssues(
          slug: ref
              .read(ProviderList.workspaceProvider)
              .selectedWorkspace
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
            issueProvider.issueView['display_filters']["show_empty_groups"];

        issueProvider.setsState();
        issueProvider.filterIssues(
            slug: ref
                .read(ProviderList.workspaceProvider)
                .selectedWorkspace
                .workspaceSlug,
            projID: projectProvider.currentProject['id']);
        return true;
      },
      child: Scaffold(
        floatingActionButton: isLoading &&
                !widget.fromModule &&
                DateTime.parse(cyclesProvider.cyclesDetailsData['end_date'])
                    .isBefore(DateTime.now()) &&
                (cyclesProvider.cyclesDetailsData['backlog_issues'] != 0 &&
                    cyclesProvider.cyclesDetailsData['started_issues'] != 0 &&
                    cyclesProvider.cyclesDetailsData['unstarted_issues'] != 0)
            ? FloatingActionButton(
                backgroundColor: themeProvider.themeManager.primaryColour,
                onPressed: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      enableDrag: true,
                      constraints: BoxConstraints(
                          maxHeight: height * 0.8, minHeight: 250),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                      context: context,
                      builder: (ctx) {
                        return const SelectCycleSheet();
                      });
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: themeProvider.themeManager.primaryColour,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.error_outline_outlined,
                    color: Colors.white,
                  ),
                ),
              )
            : null,
        appBar: CustomAppBar(
          centerTitle: true,
          onPressed: () {
            if (widget.from == PreviousScreen.myIssues) {
              Navigator.pop(context);
              return;
            }
            issueProvider.getIssues(
              slug: ref
                  .read(ProviderList.workspaceProvider)
                  .selectedWorkspace
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
                issueProvider.issueView['display_filters']["show_empty_groups"];

            issueProvider.setsState();
            issueProvider.filterIssues(
                slug: ref
                    .read(ProviderList.workspaceProvider)
                    .selectedWorkspace
                    .workspaceSlug,
                projID: projectProvider.currentProject['id']);
            Navigator.pop(context);
          },
          text: widget.projId == null
              ? projectProvider.currentProject['name']
              : projectProvider.projects.firstWhere(
                  (element) => element['id'] == widget.projId)['name'],
        ),
        body: isLoading
            ? Center(
                child: SizedBox(
                    width: 30,
                    height: 30,
                    child: LoadingIndicator(
                      indicatorType: Indicator.lineSpinFadeLoader,
                      colors: [themeProvider.themeManager.primaryTextColor],
                      strokeWidth: 1.0,
                      backgroundColor: Colors.transparent,
                    )),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25, top: 20),
                          child: CustomText(
                            widget.fromModule
                                ? widget.moduleName!
                                : widget.cycleName!,
                            type: FontStyle.H5,
                            fontWeight: FontWeightt.Semibold,
                          ),
                        ),
                      ),
                    ],
                  ),
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
                                  overrride: true,
                                  'Issues',
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
                                ),
                              ),
                              Container(
                                height: 7,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: (widget.fromModule
                                          ? modulesProvider
                                                  .moduleDetailSelectedIndex ==
                                              0
                                          : cyclesProviderRead
                                                  .cycleDetailSelectedIndex ==
                                              0)
                                      ? themeProvider.themeManager.primaryColour
                                      : Colors.transparent,
                                ),
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
                                    overrride: true,
                                    type: FontStyle.Large,
                                    fontWeight: FontWeightt.Medium,
                                    color: (widget.fromModule
                                            ? modulesProvider
                                                    .moduleDetailSelectedIndex ==
                                                0
                                            : cyclesProviderRead
                                                    .cycleDetailSelectedIndex ==
                                                0)
                                        ? themeProvider
                                            .themeManager.placeholderTextColor
                                        : (widget.fromModule
                                                ? modulesProvider
                                                        .moduleDetailSelectedIndex ==
                                                    0
                                                : cyclesProviderRead
                                                        .cycleDetailSelectedIndex ==
                                                    0)
                                            ? themeProvider.themeManager
                                                .placeholderTextColor
                                            : themeProvider
                                                .themeManager.primaryColour),
                              ),
                              Container(
                                height: 7,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: (widget.fromModule
                                          ? modulesProvider
                                                  .moduleDetailSelectedIndex ==
                                              1
                                          : cyclesProviderRead
                                                  .cycleDetailSelectedIndex ==
                                              1)
                                      ? themeProvider.themeManager.primaryColour
                                      : Colors.transparent,
                                ),
                              ),
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
                                                          StateEnum
                                                              .loading))) ||
                                          issueProvider.projectViewState ==
                                              StateEnum.loading
                                      ? Center(
                                          child: SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: LoadingIndicator(
                                                indicatorType: Indicator
                                                    .lineSpinFadeLoader,
                                                colors: [
                                                  themeProvider.themeManager
                                                      .primaryTextColor
                                                ],
                                                strokeWidth: 1.0,
                                                backgroundColor: themeProvider
                                                    .themeManager
                                                    .primaryBackgroundDefaultColor,
                                              )),
                                        )
                                      : ((!widget.fromModule && cyclesProvider.isIssuesEmpty) ||
                                              (widget.fromModule &&
                                                  modulesProvider
                                                      .isIssuesEmpty))
                                          ? EmptyPlaceholder.emptyIssues(context,
                                              cycleId: widget.cycleId,
                                              moduleId: widget.moduleId,
                                              projectId: widget.projId,
                                              type: IssueCategory.cycleIssues,
                                              ref: ref)
                                          : ((!widget.fromModule && issueProvider.issues.projectView == ProjectView.list) ||
                                                  (widget.fromModule &&
                                                      issueProvider.issues.projectView ==
                                                          ProjectView.list))
                                              ? Container(
                                                  color: themeProvider
                                                      .themeManager
                                                      .secondaryBackgroundDefaultColor,
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
                                                                                  fontWeight: FontWeightt.Medium,
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                alignment: Alignment.center,
                                                                                margin: const EdgeInsets.only(
                                                                                  left: 15,
                                                                                ),
                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: themeProvider.themeManager.secondaryBackgroundDefaultColor),
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
                                                                                    }
                                                                                    Navigator.of(context).push(MaterialPageRoute(
                                                                                        builder: (ctx) => CreateIssue(
                                                                                              moduleId: widget.moduleId,
                                                                                              cycleId: widget.cycleId,
                                                                                            )));
                                                                                  },
                                                                                  icon: Icon(
                                                                                    Icons.add,
                                                                                    color: themeProvider.themeManager.primaryColour,
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
                                                                                color: themeProvider.themeManager.primaryBackgroundDefaultColor,
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
                                              : ((!widget.fromModule && issueProvider.issues.projectView == ProjectView.kanban) || (widget.fromModule && issueProvider.issues.projectView == ProjectView.kanban))
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
                                                        boardID: widget.fromModule?'module-board':'cycle-board',
                                                        onItemReorder: (
                                                            {newCardIndex,
                                                            newListIndex,
                                                            oldCardIndex,
                                                            oldListIndex}) {
                                                          if (widget
                                                              .fromModule) {
                                                            modulesProvider
                                                                .reorderIssue(
                                                              newCardIndex:
                                                                  newCardIndex!,
                                                              newListIndex:
                                                                  newListIndex!,
                                                              oldCardIndex:
                                                                  oldCardIndex!,
                                                              oldListIndex:
                                                                  oldListIndex!,
                                                            )
                                                                .catchError(
                                                                    (err) {
                                                              CustomToast.showToast(
                                                                  context,
                                                                  message:
                                                                      'Failed to update issue',
                                                                  toastType:
                                                                      ToastType
                                                                          .failure);
                                                            });
                                                          } else {
                                                            cyclesProvider
                                                                .reorderIssue(
                                                              newCardIndex:
                                                                  newCardIndex!,
                                                              newListIndex:
                                                                  newListIndex!,
                                                              oldCardIndex:
                                                                  oldCardIndex!,
                                                              oldListIndex:
                                                                  oldListIndex!,
                                                            )
                                                                .catchError(
                                                                    (err) {
                                                              log(err
                                                                  .toString());
                                                              CustomToast.showToast(
                                                                  context,
                                                                  message:
                                                                      'Failed to update issue',
                                                                  toastType:
                                                                      ToastType
                                                                          .failure);
                                                            });
                                                          }
                                                        },
                                                        isCardsDraggable:
                                                            issueProvider
                                                                .checkIsCardsDaraggable(),
                                                        groupEmptyStates: !(widget
                                                                .fromModule
                                                            ? modulesProvider
                                                                .showEmptyStates
                                                            : issueProvider
                                                                .showEmptyStates),
                                                        cardPlaceHolderColor:
                                                            themeProvider
                                                                .themeManager
                                                                .primaryBackgroundDefaultColor,
                                                        cardPlaceHolderDecoration:
                                                            BoxDecoration(
                                                                color: themeProvider
                                                                    .themeManager
                                                                    .primaryBackgroundDefaultColor,
                                                                boxShadow: [
                                                              BoxShadow(
                                                                blurRadius: 2,
                                                                color: themeProvider
                                                                    .themeManager
                                                                    .borderSubtle01Color,
                                                                spreadRadius: 0,
                                                              )
                                                            ]),
                                                        backgroundColor:
                                                            themeProvider
                                                                .themeManager
                                                                .secondaryBackgroundDefaultColor,
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
                                decoration: BoxDecoration(
                                    color: themeProvider.themeManager
                                        .primaryBackgroundDefaultColor,
                                    boxShadow: themeProvider.themeManager
                                        .shadowBottomControlButtons),
                                child: Row(
                                  children: [
                                    projectProvider.role == Role.admin ||
                                            projectProvider.role == Role.member
                                        ? Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CreateIssue(
                                                      projectId: widget
                                                              .projId ??
                                                          projectProvider
                                                                  .currentProject[
                                                              'id'],
                                                      fromMyIssues: true,
                                                      moduleId: widget.moduleId,
                                                      cycleId: widget.cycleId,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: SizedBox(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.add,
                                                      color: themeProvider
                                                          .themeManager
                                                          .primaryTextColor,
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
                                      color: themeProvider
                                          .themeManager.borderSubtle01Color,
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
                                      child: SizedBox(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.menu,
                                              color: themeProvider.themeManager
                                                  .primaryTextColor,
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
                                      color: themeProvider
                                          .themeManager.borderSubtle01Color,
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
                                                      projectView: issueProvider
                                                          .issues.projectView,
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
                                            child: SizedBox(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.wysiwyg_outlined,
                                                    color: themeProvider
                                                        .themeManager
                                                        .primaryTextColor,
                                                    size: 19,
                                                  ),
                                                  const CustomText(
                                                    ' Display',
                                                    type: FontStyle.Medium,
                                                  )
                                                ],
                                              ),
                                            ),
                                          )),
                                    Container(
                                      height: 50,
                                      width: 0.5,
                                      color: themeProvider
                                          .themeManager.borderSubtle01Color,
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
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                topRight: Radius.circular(30),
                                              )),
                                              context: context,
                                              builder: (ctx) {
                                                return FilterSheet(
                                                  issueCategory:
                                                      widget.fromModule
                                                          ? IssueCategory
                                                              .moduleIssues
                                                          : IssueCategory
                                                              .cycleIssues,
                                                );
                                              });
                                        },
                                        child: SizedBox(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.filter_list_outlined,
                                                color: themeProvider
                                                    .themeManager
                                                    .primaryTextColor,
                                                size: 19,
                                              ),
                                              const CustomText(
                                                ' Filters',
                                                type: FontStyle.Medium,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        widget.fromModule
                            ? Container(
                                color: themeProvider.themeManager
                                    .secondaryBackgroundDefaultColor,
                                padding: const EdgeInsets.all(25),
                                child: activeCycleDetails(fromModule: true),
                              )
                            : Container(
                                color: themeProvider.themeManager
                                    .secondaryBackgroundDefaultColor,
                                padding: const EdgeInsets.only(
                                    top: 25, left: 25, right: 25),
                                child: activeCycleDetails(),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget activeCycleDetails({bool fromModule = false}) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    final modulesProvider = ref.watch(ProviderList.modulesProvider);

    if (widget.fromModule
        ? modulesProvider.moduleDetailState == StateEnum.loading
        : cyclesProvider.cyclesDetailState == StateEnum.loading) {
      return Center(
        child: SizedBox(
          width: 30,
          height: 30,
          child: LoadingIndicator(
            indicatorType: Indicator.lineSpinFadeLoader,
            colors: [themeProvider.themeManager.primaryTextColor],
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
          const SizedBox(height: 30),
          widget.fromModule ? links() : Container()
        ],
      );
    }
  }

  Widget links() {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final ModuleProvider moduleProvider =
        ref.watch(ProviderList.modulesProvider);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            'Links',
            type: FontStyle.Medium,
            fontWeight: FontWeightt.Medium,
            color: themeProvider.themeManager.primaryTextColor,
          ),
          GestureDetector(
              onTap: () {
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
                    return SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: const AddLinkSheet(),
                      ),
                    );
                  },
                );
              },
              child: Icon(
                Icons.add,
                color: themeProvider.themeManager.primaryTextColor,
              ))
        ],
      ),
      const SizedBox(height: 10),
      moduleProvider.moduleDetailsData['link_module'].isNotEmpty
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: themeProvider.themeManager.primaryBackgroundDefaultColor,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: getBorderColor(themeProvider),
                ),
              ),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount:
                      moduleProvider.moduleDetailsData['link_module'].length,
                  itemBuilder: (ctx, index) {
                    return SizedBox(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            child: Transform.rotate(
                              angle: -20,
                              child: Icon(
                                Icons.link,
                                color:
                                    themeProvider.themeManager.primaryTextColor,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              moduleProvider.moduleDetailsData['link_module']
                                          [index]['title'] !=
                                      null
                                  ? CustomText(
                                      moduleProvider
                                          .moduleDetailsData['link_module']
                                              [index]['title']
                                          .toString(),
                                      type: FontStyle.Medium,
                                    )
                                  : Container(),
                              CustomText(
                                'by ${moduleProvider.moduleDetailsData['link_module'][index]['created_by_detail']['display_name']}',
                                type: FontStyle.Small,
                                color: themeProvider
                                    .themeManager.placeholderTextColor,
                              )
                            ],
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
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
                                  return SingleChildScrollView(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: AddLinkSheet(
                                        id: moduleProvider.moduleDetailsData[
                                            'link_module'][index]['id'],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Icon(
                              Icons.edit_outlined,
                              color: themeProvider
                                  .themeManager.placeholderTextColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              moduleProvider.handleLinks(
                                  linkID: moduleProvider
                                          .moduleDetailsData['link_module']
                                      [index]['id'],
                                  data: {},
                                  method: HttpMethod.delete,
                                  context: context);
                            },
                            child: Icon(
                              Icons.delete_outline,
                              color: themeProvider
                                  .themeManager.placeholderTextColor,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            )
          : Container()
    ]);
  }

  Widget datePart() {
    final cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    final modulesProvider = ref.watch(ProviderList.modulesProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final detailData = widget.fromModule
        ? modulesProvider.moduleDetailsData
        : cyclesProvider.cyclesDetailsData;

    startDate = DateFormat('yyyy-MM-dd').parse(
        detailData['start_date'] == null || detailData['start_date'] == ''
            ? DateTime.now().toString()
            : detailData['start_date']!);

    dueDate = DateFormat('yyyy-MM-dd').parse(
        detailData[widget.fromModule ? 'target_date' : 'end_date'] == null ||
                detailData[widget.fromModule ? 'target_date' : 'end_date'] == ''
            ? DateTime.now().toString()
            : detailData[widget.fromModule ? 'target_date' : 'end_date']!);

    return Wrap(
      runSpacing: 20,
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
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                      width: 1, color: getBorderColor(themeProvider)),
                ),
                child: const CustomText(
                  'Draft',
                  type: FontStyle.Small,
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
                        ? themeProvider
                            .themeManager.tertiaryBackgroundDefaultColor
                        : checkDate(
                                    startDate: detailData['start_date'],
                                    endDate: detailData[widget.fromModule
                                        ? 'target_date'
                                        : 'end_date']) ==
                                'Completed'
                            ? themeProvider
                                .themeManager.secondaryBackgroundActiveColor
                            : themeProvider.themeManager.successBackgroundColor,
                    borderRadius: BorderRadius.circular(5)),
                child: CustomText(
                  checkDate(
                    startDate: detailData['start_date'],
                    endDate: detailData[
                        widget.fromModule ? 'target_date' : 'end_date'],
                  ),
                  type: FontStyle.Small,
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
                          ? themeProvider.themeManager.primaryColour
                          : greenHighLight,
                ),
              ),
        const SizedBox(width: 20),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () async {
                final date = await showDatePicker(
                  builder: (context, child) => Theme(
                    data: themeProvider.themeManager.datePickerThemeData,
                    child: child!,
                  ),
                  context: context,
                  initialDate: startDate!,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2025),
                );
                if (date != null) {
                  final bool dateNotConflicted = dueDate == null
                      ? true
                      : widget.fromModule
                          ? true
                          : await cyclesProvider.dateCheck(
                              slug: ref
                                  .read(ProviderList.workspaceProvider)
                                  .selectedWorkspace
                                  .workspaceSlug,
                              projectId: ref
                                  .read(ProviderList.projectProvider)
                                  .currentProject["id"],
                              data: {
                                "cycle_id": widget.cycleId!,
                                "start_date":
                                    DateFormat('yyyy-MM-dd').format(date),
                                "end_date":
                                    DateFormat('yyyy-MM-dd').format(dueDate!),
                              },
                            );
                  if (dateNotConflicted) {
                    if (dueDate != null && date.isAfter(dueDate!)) {
                      CustomToast.showToast(context,
                          message: 'Start date cannot be after end date',
                          toastType: ToastType.failure);
                      return;
                    }
                    setState(() {
                      startDate = date;
                    });
                  } else {
                    CustomToast.showToast(context,
                        message: 'Date is conflicted with other cycle',
                        toastType: ToastType.failure);
                    return;
                  }
                }

                if (date != null) {
                  if (widget.fromModule) {
                    modulesProvider.updateModules(
                        disableLoading: true,
                        slug: ref
                            .read(ProviderList.workspaceProvider)
                            .selectedWorkspace
                            .workspaceSlug,
                        projId: ref
                            .read(ProviderList.projectProvider)
                            .currentProject["id"],
                        moduleId: widget.moduleId!,
                        data: {
                          'start_date': DateFormat('yyyy-MM-dd').format(date)
                        },
                        ref: ref);
                  } else {
                    cyclesProvider.cycleDetailsCrud(
                      disableLoading: true,
                      slug: ref
                          .read(ProviderList.workspaceProvider)
                          .selectedWorkspace
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
                  color:
                      themeProvider.themeManager.primaryBackgroundDefaultColor,
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
                        type: FontStyle.Small,
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
                            type: FontStyle.Small,
                            fontWeight: FontWeightt.Regular,
                            color:
                                themeProvider.themeManager.secondaryTextColor,
                          ),
                        ],
                      ),
              ),
            ),
            //arrow
            const SizedBox(width: 5),
            Icon(
              Icons.arrow_forward,
              size: 15,
              color: themeProvider.themeManager.placeholderTextColor,
            ),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: () async {
                final date = await showDatePicker(
                  builder: (context, child) => Theme(
                    data: themeProvider.themeManager.datePickerThemeData,
                    child: child!,
                  ),
                  context: context,
                  initialDate: dueDate!,
                  firstDate: startDate ?? DateTime.now(),
                  lastDate: DateTime(2025),
                );

                if (date != null) {
                  if (!date.isAfter(DateTime.now())) {
                    CustomToast.showToast(context,
                        message: 'Due date not valid ',
                        toastType: ToastType.failure);
                    return;
                  }
                  if (date.isAfter(startDate!)) {
                    final bool dateNotConflicted = widget.fromModule
                        ? true
                        : await cyclesProvider.dateCheck(
                            slug: ref
                                .read(ProviderList.workspaceProvider)
                                .selectedWorkspace
                                .workspaceSlug,
                            projectId: ref
                                .read(ProviderList.projectProvider)
                                .currentProject["id"],
                            data: {
                              "cycle_id": widget.cycleId!,
                              "start_date":
                                  DateFormat('yyyy-MM-dd').format(startDate!),
                              "end_date": DateFormat('yyyy-MM-dd').format(date),
                            },
                          );

                    if (dateNotConflicted) {
                      setState(() {
                        dueDate = date;
                      });
                      if (widget.fromModule) {
                        modulesProvider.updateModules(
                            disableLoading: true,
                            slug: ref
                                .read(ProviderList.workspaceProvider)
                                .selectedWorkspace
                                .workspaceSlug,
                            projId: ref
                                .read(ProviderList.projectProvider)
                                .currentProject["id"],
                            moduleId: widget.moduleId!,
                            data: {
                              'target_date':
                                  DateFormat('yyyy-MM-dd').format(date)
                            },
                            ref: ref);
                        modulesProvider.changeTabIndex(1);
                      } else {
                        cyclesProvider.cycleDetailsCrud(
                          disableLoading: true,
                          slug: ref
                              .read(ProviderList.workspaceProvider)
                              .selectedWorkspace
                              .workspaceSlug,
                          projectId: ref
                              .read(ProviderList.projectProvider)
                              .currentProject["id"],
                          method: CRUD.update,
                          cycleId: widget.cycleId!,
                          data: {
                            'end_date': DateFormat('yyyy-MM-dd').format(date)
                          },
                        );
                        cyclesProvider.changeTabIndex(1);
                      }
                    } else {
                      CustomToast.showToast(context,
                          message: 'Date is conflicted with other cycle ',
                          toastType: ToastType.failure);
                    }
                  } else {
                    CustomToast.showToast(context,
                        message: 'Start date cannot be after end date ',
                        toastType: ToastType.failure);
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color:
                      themeProvider.themeManager.primaryBackgroundDefaultColor,
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
                        type: FontStyle.Small,
                        fontWeight: FontWeightt.Regular,
                        color: themeProvider.themeManager.secondaryTextColor)
                    : Row(
                        children: [
                          Icon(Icons.calendar_today_outlined,
                              size: 15,
                              color: themeProvider
                                  .themeManager.placeholderTextColor),
                          const SizedBox(width: 5),
                          CustomText(
                              '${dateFormating(detailData[widget.fromModule ? 'target_date' : 'end_date'])} ',
                              type: FontStyle.Small,
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
    final themeProvider = ref.watch(ProviderList.themeProvider);
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
    final themeProvider = ref.watch(ProviderList.themeProvider);
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
        const SizedBox(height: 10),
        Container(
          padding:
              const EdgeInsets.only(left: 20, right: 30, top: 35, bottom: 20),
          decoration: BoxDecoration(
            color: themeProvider.themeManager.primaryBackgroundDefaultColor,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: getBorderColor(themeProvider),
            ),
          ),
          child: SizedBox(
            height: 200,
            child: SfCartesianChart(
              plotAreaBorderColor: Colors.transparent,
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
                        themeProvider.themeManager.primaryColour
                            .withOpacity(0.2),
                        themeProvider.themeManager.primaryColour
                            .withOpacity(0.3),
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
        ),
      ],
    );
  }

  Widget assigneesPart({bool fromModule = false}) {
    final cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    final modulesProvider = ref.watch(ProviderList.modulesProvider);
    final issuesProvider = ref.watch(ProviderList.issuesProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);

    final detailData = widget.fromModule
        ? modulesProvider.moduleDetailsData
        : cyclesProvider.cyclesDetailsData;

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
        detailData['distribution']['assignees'].length == 0
            ? const CustomText('No data found.')
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color:
                      themeProvider.themeManager.primaryBackgroundDefaultColor,
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
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          decoration: BoxDecoration(
                            color: (issuesProvider.issues.filters.assignees
                                    .contains(detailData['distribution']
                                        ['assignees'][idx]['assignee_id'])
                                ? themeProvider.themeManager
                                    .secondaryBackgroundDefaultColor
                                : themeProvider.themeManager
                                    .primaryBackgroundDefaultColor),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: detailData['distribution']
                                                          ['assignees'][idx]
                                                      ['avatar'] !=
                                                  null &&
                                              detailData['distribution']
                                                          ['assignees'][idx]
                                                      ['avatar'] !=
                                                  ''
                                          ? CircleAvatar(
                                              radius: 10,
                                              backgroundImage: NetworkImage(
                                                  detailData['distribution']
                                                          ['assignees'][idx]
                                                      ['avatar']),
                                            )
                                          : CircleAvatar(
                                              radius: 10,
                                              backgroundColor: themeProvider
                                                  .themeManager
                                                  .tertiaryBackgroundDefaultColor,
                                              child: Center(
                                                child: CustomText(
                                                  detailData['distribution'][
                                                                      'assignees']
                                                                  [idx]
                                                              ['first_name'] !=
                                                          null
                                                      ? detailData['distribution']
                                                                      [
                                                                      'assignees']
                                                                  [idx]
                                                              ['first_name'][0]
                                                          .toString()
                                                          .toUpperCase()
                                                      : '',
                                                  type: FontStyle.Small,
                                                ),
                                              ),
                                            )),
                                  CustomText(
                                    detailData['distribution']['assignees'][idx]
                                            ['display_name'] ??
                                        'No Assignees',
                                    color: themeProvider
                                        .themeManager.secondaryTextColor,
                                  ),
                                ],
                              ),
                              CompletionPercentage(
                                  value: detailData['distribution']['assignees']
                                      [idx]['completed_issues'],
                                  totalValue: detailData['distribution']
                                      ['assignees'][idx]['total_issues'])
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
      ],
    );
  }

  Widget statesPart() {
    final List states = [
      "Backlog",
      "Unstarted",
      "Started",
      "Cancelled",
      "Completed",
    ];
    final cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    final modulesProvider = ref.watch(ProviderList.modulesProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);

    final detailData = widget.fromModule
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
            color: themeProvider.themeManager.primaryBackgroundDefaultColor,
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
                      color: themeProvider.themeManager.secondaryTextColor,
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
    final cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    final issuesProvider = ref.watch(ProviderList.issuesProvider);
    final modulesProvider = ref.watch(ProviderList.modulesProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);

    final detailData = widget.fromModule
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
        detailData['distribution']['labels'].isNotEmpty
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color:
                      themeProvider.themeManager.primaryBackgroundDefaultColor,
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
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: issuesProvider.issues.filters.labels.contains(
                                  detailData['distribution']['labels'][index]
                                      ['label_id'])
                              ? themeProvider
                                  .themeManager.secondaryBackgroundDefaultColor
                              : themeProvider
                                  .themeManager.primaryBackgroundDefaultColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 20,
                                  color: detailData['distribution']['labels']
                                                  [index]['color'] ==
                                              '' ||
                                          detailData['distribution']['labels']
                                                  [index]['color'] ==
                                              null
                                      ? themeProvider
                                          .themeManager.placeholderTextColor
                                      : detailData['distribution']['labels']
                                              [index]['color']
                                          .toString()
                                          .toColor(),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                CustomText(
                                  detailData['distribution']['labels'][index]
                                          ['label_name'] ??
                                      'No Label',
                                  maxLines: 2,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                CompletionPercentage(
                                    value: detailData['distribution']['labels']
                                        [index]['completed_issues'],
                                    totalValue: detailData['distribution']
                                        ['labels'][index]['total_issues'])
                              ],
                            )
                          ],
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
    final cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    final modulesProvider = ref.watch(ProviderList.modulesProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    return Container(
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        color: themeProvider.themeManager.primaryBackgroundDefaultColor,
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
                Icons.timelapse_rounded,
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
    final modulesProvider = ref.watch(ProviderList.modulesProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    return GestureDetector(
      onTap: () {
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
          builder: (context) => AssigneeSheet(
            fromModuleDetail: widget.fromModule,
          ),
        );
      },
      child: Container(
        height: 45,
        width: double.infinity,
        decoration: BoxDecoration(
          color: themeProvider.themeManager.primaryBackgroundDefaultColor,
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
              CustomText(
                'Members',
                type: FontStyle.Medium,
                fontWeight: FontWeightt.Regular,
                color: themeProvider.themeManager.placeholderTextColor,
              ),
              Expanded(child: Container()),
              (modulesProvider.currentModule['members_detail'] == null ||
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
                                color: themeProvider.themeManager
                                    .primaryBackgroundDefaultColor),
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
                      ))
            ],
          ),
        ),
      ),
    );
  }

  Widget assigneeWidget() {
    final cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    final modulesProvider = ref.watch(ProviderList.modulesProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final detailData = widget.fromModule
        ? modulesProvider.moduleDetailsData
        : cyclesProvider.cyclesDetailsData;

    return GestureDetector(
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
      child: Container(
        height: 45,
        width: double.infinity,
        decoration: BoxDecoration(
          color: themeProvider.themeManager.primaryBackgroundDefaultColor,
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
              detailData[widget.fromModule ? 'lead_detail' : 'owned_by'] == null
                  ? CustomText(
                      'No lead',
                      type: FontStyle.Medium,
                      fontWeight: FontWeightt.Regular,
                      color: themeProvider.themeManager.primaryTextColor,
                    )
                  : Row(
                      children: [
                        (detailData[widget.fromModule
                                            ? 'lead_detail'
                                            : 'owned_by'] !=
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
                                                        : 'owned_by']
                                                    ['display_name'] !=
                                                null)
                                        ? detailData[widget.fromModule
                                                ? 'lead_detail'
                                                : 'owned_by']['display_name'][0]
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
                                            : 'owned_by']['display_name'] !=
                                        null)
                                ? detailData[widget.fromModule
                                        ? 'lead_detail'
                                        : 'owned_by']['display_name'] ??
                                    ''
                                : '',
                            type: FontStyle.Small,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  String dateFormating(String date) {
    final DateTime formatedDate = DateTime.parse(date);
    final String finalDate = DateFormat('dd MMM').format(formatedDate);
    return finalDate;
  }

  String checkDate({required String startDate, required String endDate}) {
    final DateTime now = DateTime.now();
    if ((startDate.isEmpty) || (endDate.isEmpty)) {
      return 'Draft';
    } else {
      if (DateTime.parse(startDate).isAfter(now)) {
        final Duration difference =
            DateTime.parse(startDate.split('+').first).difference(now);
        if (difference.inDays == 0) {
          return 'Today';
        } else {
          return '${difference.inDays.abs() + 1} Days Left';
        }
      }
      if (DateTime.parse(startDate).isBefore(now) &&
          DateTime.parse(endDate).isAfter(now)) {
        final Duration difference = DateTime.parse(endDate).difference(now);
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
      themeProvider.themeManager.borderSubtle01Color;

  String checkTimeDifferenc(String dateTime) {
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(DateTime.parse(dateTime));
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
