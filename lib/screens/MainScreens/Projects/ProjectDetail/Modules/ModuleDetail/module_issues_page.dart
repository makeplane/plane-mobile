// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane/bottom_sheets/filters/filter_sheet.dart';
import 'package:plane/bottom_sheets/type_sheet.dart';
import 'package:plane/bottom_sheets/views_sheet.dart';
import 'package:plane/kanban/custom/board.dart';
import 'package:plane/kanban/models/inputs.dart';
import 'package:plane/models/chart_model.dart';
import 'package:plane/models/issues.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/Issues/CreateIssue/create_issue.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/Modules/ModuleDetail/module_detail_page.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/calender_view.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/spreadsheet_view.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_app_bar.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/empty.dart';
import '../../../../../../bottom_sheets/select_cycle_sheet.dart';
import '../../Issues/issue_detail.dart';

class ModuleDetail extends ConsumerStatefulWidget {
  const ModuleDetail(
      {super.key, this.moduleId, this.moduleName, this.projId, this.from});
  final String? moduleName;
  final String? moduleId;
  final String? projId;
  final PreviousScreen? from;

  @override
  ConsumerState<ModuleDetail> createState() => _ModuleDetailState();
}

class _ModuleDetailState extends ConsumerState<ModuleDetail> {
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

    issuesProvider.issues.projectView = IssueLayout.kanban;
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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getModuleData();
    });
    super.initState();
  }

  Future getModuleData() async {
    final modulesProvider = ref.read(ProviderList.modulesProvider);
    final issuesProvider = ref.read(ProviderList.issuesProvider);
    modulesProvider.moduleDetailState = StateEnum.loading;
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
            projId: widget.projId ??
                ref.read(ProviderList.projectProvider).currentProject['id'],
            disableLoading: true,
            moduleId: widget.moduleId!)
        .then((value) => getChartData(modulesProvider
            .moduleDetailsData['distribution']['completion_chart']));

    ref
        .read(ProviderList.issuesProvider)
        .getIssueDisplayProperties(issueCategory: IssueCategory.cycleIssues);
    await modulesProvider.getModuleView(moduleId: widget.moduleId!);
    modulesProvider
        .filterModuleIssues(
            moduleID: widget.moduleId!,
            slug: ref
                .read(ProviderList.workspaceProvider)
                .selectedWorkspace
                .workspaceSlug,
            projectId: widget.projId ??
                ref.read(ProviderList.projectProvider).currentProject['id'],
            ref: ref)
        .then((value) {
      if (issuesProvider.issues.projectView == IssueLayout.list) {
        modulesProvider.initializeBoard();
      }
    });
  }

  Future getChartData(Map<String, dynamic> data) async {
    data.forEach((key, value) {
      chartData.add(ChartData(DateTime.parse(key), value != null ? value.toDouble() : 0.0));
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final issueProvider = ref.watch(ProviderList.issuesProvider);
    final modulesProvider = ref.watch(ProviderList.modulesProvider);
    final projectProvider = ref.read(ProviderList.projectProvider);
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        floatingActionButton: modulesProvider.moduleIssueState ==
                    StateEnum.loading &&
                (modulesProvider.moduleDetailsData['backlog_issues'] != 0 &&
                    modulesProvider.moduleDetailsData['started_issues'] != 0 &&
                    modulesProvider.moduleDetailsData['unstarted_issues'] != 0)
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
            modulesProvider.changeTabIndex(0);
            modulesProvider.changeState(StateEnum.empty);
            Navigator.pop(context);
          },
          text: widget.projId == null
              ? projectProvider.currentProject['name']
              : projectProvider.projects.firstWhere(
                  (element) => element['id'] == widget.projId)['name'],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, top: 20),
                    child: CustomText(
                      widget.moduleName!,
                      maxLines: 1,
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
                      modulesProvider.changeTabIndex(0);
                      pageController!.animateToPage(
                        0,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeIn,
                      );
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: CustomText(
                            overrride: true,
                            'Issues',
                            type: FontStyle.Large,
                            fontWeight: FontWeightt.Medium,
                            color:
                                modulesProvider.moduleDetailSelectedIndex == 1
                                    ? themeProvider
                                        .themeManager.placeholderTextColor
                                    : themeProvider.themeManager.primaryColour,
                          ),
                        ),
                        Container(
                          height: 7,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:
                                modulesProvider.moduleDetailSelectedIndex == 0
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
                      modulesProvider.changeTabIndex(1);
                      pageController!.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeIn,
                      );
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: CustomText(
                            'Details',
                            overrride: true,
                            type: FontStyle.Large,
                            fontWeight: FontWeightt.Medium,
                            color:
                                modulesProvider.moduleDetailSelectedIndex == 0
                                    ? themeProvider
                                        .themeManager.placeholderTextColor
                                    : themeProvider.themeManager.primaryColour,
                          ),
                        ),
                        Container(
                          height: 7,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:
                                modulesProvider.moduleDetailSelectedIndex == 1
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
                    modulesProvider.changeTabIndex(0);
                  } else {
                    modulesProvider.changeTabIndex(1);
                  }
                },
                children: [
                  Column(
                    children: [
                      Expanded(
                        child:
                            (modulesProvider.moduleIssueState ==
                                            StateEnum.loading ||
                                        modulesProvider.moduleDetailState ==
                                            StateEnum.loading) ||
                                    modulesProvider.moduleViewState ==
                                        StateEnum.loading
                                ? Center(
                                    child: SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: LoadingIndicator(
                                          indicatorType:
                                              Indicator.lineSpinFadeLoader,
                                          colors: [
                                            themeProvider
                                                .themeManager.primaryTextColor
                                          ],
                                          strokeWidth: 1.0,
                                          backgroundColor: themeProvider
                                              .themeManager
                                              .primaryBackgroundDefaultColor,
                                        )),
                                  )
                                : (modulesProvider.isIssuesEmpty)
                                    ? EmptyPlaceholder.emptyIssues(context,
                                        moduleId: widget.moduleId,
                                        projectId: widget.projId,
                                        type: IssueCategory.cycleIssues,
                                        ref: ref)
                                    : (issueProvider.issues.projectView ==
                                            IssueLayout.list)
                                        ? Container(
                                            color: themeProvider.themeManager
                                                .secondaryBackgroundDefaultColor,
                                            margin:
                                                const EdgeInsets.only(top: 5),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: modulesProvider
                                                      .issues.issues
                                                      .map((state) => state
                                                                  .items
                                                                  .isEmpty &&
                                                              !modulesProvider
                                                                  .showEmptyStates
                                                          ? Container()
                                                          : SizedBox(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            15),
                                                                    margin: const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            10),
                                                                    child: Row(
                                                                      children: [
                                                                        state.leading ??
                                                                            Container(),
                                                                        Container(
                                                                          padding:
                                                                              const EdgeInsets.only(
                                                                            left:
                                                                                10,
                                                                          ),
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.6,
                                                                          child:
                                                                              CustomText(
                                                                            state.title!,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            maxLines:
                                                                                1,
                                                                            type:
                                                                                FontStyle.Small,
                                                                            fontWeight:
                                                                                FontWeightt.Medium,
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          margin:
                                                                              const EdgeInsets.only(
                                                                            left:
                                                                                15,
                                                                          ),
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(15),
                                                                              color: themeProvider.themeManager.secondaryBackgroundDefaultColor),
                                                                          height:
                                                                              25,
                                                                          width:
                                                                              30,
                                                                          child:
                                                                              CustomText(
                                                                            state.items.length.toString(),
                                                                            type:
                                                                                FontStyle.Medium,
                                                                          ),
                                                                        ),
                                                                        const Spacer(),
                                                                        IconButton(
                                                                            onPressed:
                                                                                () {
                                                                              if (issueProvider.issues.groupBY == GroupBY.state) {
                                                                                issueProvider.createIssuedata['state'] = state.id;
                                                                              } else {
                                                                                issueProvider.createIssuedata['priority'] = 'de3c90cd-25cd-42ec-ac6c-a66caf8029bc';
                                                                              }
                                                                              Navigator.of(context).push(MaterialPageRoute(
                                                                                  builder: (ctx) => CreateIssue(
                                                                                        moduleId: widget.moduleId,
                                                                                      )));
                                                                            },
                                                                            icon:
                                                                                Icon(
                                                                              Icons.add,
                                                                              color: themeProvider.themeManager.primaryColour,
                                                                            )),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: state
                                                                          .items
                                                                          .map((e) =>
                                                                              e)
                                                                          .toList()),
                                                                  state.items
                                                                          .isEmpty
                                                                      ? Container(
                                                                          margin: const EdgeInsets
                                                                              .only(
                                                                              bottom: 10),
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          color: themeProvider
                                                                              .themeManager
                                                                              .primaryBackgroundDefaultColor,
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              top: 15,
                                                                              bottom: 15,
                                                                              left: 15),
                                                                          child:
                                                                              const CustomText(
                                                                            'No issues.',
                                                                            type:
                                                                                FontStyle.Small,
                                                                            maxLines:
                                                                                10,
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                          ),
                                                                        )
                                                                      : Container(
                                                                          margin: const EdgeInsets
                                                                              .only(
                                                                              bottom: 10),
                                                                        )
                                                                ],
                                                              ),
                                                            ))
                                                      .toList()),
                                            ),
                                          )
                                        : issueProvider.issues.projectView ==
                                                IssueLayout.kanban
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8),
                                                child: KanbanBoard(
                                                  modulesProvider
                                                      .initializeBoard(),
                                                  boardID: 'cycle-board',
                                                  onItemReorder: (
                                                      {newCardIndex,
                                                      newListIndex,
                                                      oldCardIndex,
                                                      oldListIndex}) {
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
                                                        log(err.toString());
                                                        CustomToast.showToast(
                                                          context,
                                                          message:
                                                              'Failed to update issue',
                                                          toastType:
                                                              ToastType.failure,
                                                        );
                                                      },
                                                    );
                                                  },
                                                  isCardsDraggable: issueProvider
                                                      .checkIsCardsDaraggable(),
                                                  groupEmptyStates:
                                                      !modulesProvider
                                                          .showEmptyStates,
                                                  cardPlaceHolderColor:
                                                      themeProvider.themeManager
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
                                                    ],
                                                  ),
                                                  backgroundColor: themeProvider
                                                      .themeManager
                                                      .secondaryBackgroundDefaultColor,
                                                  listScrollConfig:
                                                      ScrollConfig(
                                                          offset: 65,
                                                          duration:
                                                              const Duration(
                                                            milliseconds: 100,
                                                          ),
                                                          curve: Curves.linear),
                                                  listTransitionDuration:
                                                      const Duration(
                                                          milliseconds: 200),
                                                  cardTransitionDuration:
                                                      const Duration(
                                                          milliseconds: 400),
                                                  textStyle: TextStyle(
                                                      fontSize: 19,
                                                      height: 1.3,
                                                      color:
                                                          Colors.grey.shade800,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              )
                                            : issueProvider
                                                        .issues.projectView ==
                                                    IssueLayout.calendar
                                                ? const CalendarView()
                                                : const SpreadSheetView(
                                                    issueCategory: IssueCategory
                                                        .cycleIssues,
                                                  ),
                      ),
                      SafeArea(
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: themeProvider
                                  .themeManager.primaryBackgroundDefaultColor,
                              boxShadow: themeProvider
                                  .themeManager.shadowBottomControlButtons),
                          child: Row(
                            children: [
                              projectProvider.role == Role.admin ||
                                      projectProvider.role == Role.member
                                  ? Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => CreateIssue(
                                                projectId: widget.projId ??
                                                    projectProvider
                                                        .currentProject['id'],
                                                fromMyIssues: true,
                                                moduleId: widget.moduleId,
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
                                          maxHeight: MediaQuery.of(context)
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
                                        return const TypeSheet(
                                          issueCategory:
                                              IssueCategory.moduleIssues,
                                        );
                                      });
                                },
                                child: SizedBox(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.menu,
                                        color: themeProvider
                                            .themeManager.primaryTextColor,
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
                                      IssueLayout.calendar
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
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              topRight: Radius.circular(30),
                                            )),
                                            context: context,
                                            builder: (ctx) {
                                              return ViewsSheet(
                                                projectView: issueProvider
                                                    .issues.projectView,
                                                issueCategory:
                                                    IssueCategory.moduleIssues,
                                                moduleId: widget.moduleId,
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
                                              color: themeProvider.themeManager
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
                                            maxHeight: MediaQuery.of(context)
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
                                            issueCategory:
                                                IssueCategory.moduleIssues,
                                            cycleOrModuleId: widget.moduleId,
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
                                              .themeManager.primaryTextColor,
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
                  ModuleDetailsPage(
                    moduleId: widget.moduleId!,
                    chartData: chartData,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
