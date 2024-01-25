// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane/bottom-sheets/filters/filter_sheet.dart';
import 'package:plane/bottom-sheets/type_sheet.dart';
import 'package:plane/bottom-sheets/views_sheet.dart';
import 'package:plane/kanban/custom/board.dart';
import 'package:plane/kanban/models/inputs.dart';
import 'package:plane/models/chart_model.dart';
import 'package:plane/models/issues.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/project/cycles/cycle-detail/cycle_details_page.dart';
import 'package:plane/screens/project/issue-layouts/calender_view.dart';
import 'package:plane/screens/project/issue-layouts/spreadsheet_view.dart';
import 'package:plane/screens/project/issues/create_issue.dart';
import 'package:plane/screens/project/issues/issue_detail.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_app_bar.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/empty.dart';
import '../../../../../bottom-sheets/select_cycle_sheet.dart';

class CycleDetail extends ConsumerStatefulWidget {
  const CycleDetail(
      {super.key, this.cycleId, this.cycleName, this.projId, this.from});
  final String? cycleName;
  final String? cycleId;
  final String? projId;
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
      getCycleData();
    });
    super.initState();
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
        .getIssueDisplayProperties(issueCategory: IssueCategory.cycleIssues);
    await cyclesProvider.getCycleView(cycleId: widget.cycleId!);
    cyclesProvider
        .filterCycleIssues(
            cycleID: widget.cycleId!,
            slug: ref
                .read(ProviderList.workspaceProvider)
                .selectedWorkspace
                .workspaceSlug,
            projectId: widget.projId ??
                ref.read(ProviderList.projectProvider).currentProject['id'],
            ref: ref)
        .then((value) {
      if (issuesProvider.issues.projectView == IssueLayout.list) {
        cyclesProvider.initializeBoard();
      }
    });
  }

  Future getChartData(Map<String, dynamic> data) async {
    data.forEach((key, value) {
      chartData.add(
          ChartData(DateTime.parse(key), value != null ? value.toDouble() : 0));
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    final cyclesProviderRead = ref.read(ProviderList.cyclesProvider.notifier);
    final issueProvider = ref.watch(ProviderList.issuesProvider);
    final projectProvider = ref.read(ProviderList.projectProvider);
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        floatingActionButton: cyclesProvider.cyclesIssueState ==
                    StateEnum.loading &&
                (cyclesProvider.cyclesDetailsData['backlog_issues'] != 0 &&
                    cyclesProvider.cyclesDetailsData['started_issues'] != 0 &&
                    cyclesProvider.cyclesDetailsData['unstarted_issues'] != 0)
            ? FloatingActionButton(
                backgroundColor: themeProvider.themeManager.primaryColour,
                onPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    enableDrag: true,
                    constraints:
                        BoxConstraints(maxHeight: height * 0.8, minHeight: 250),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    context: context,
                    builder: (ctx) {
                      return const SelectCycleSheet();
                    },
                  );
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
            cyclesProvider.changeTabIndex(0);
            cyclesProvider.changeState(StateEnum.empty);
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
                      widget.cycleName!,
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
                      cyclesProvider.changeTabIndex(0);
                      pageController!.animateToPage(
                        0,
                        duration: const Duration(milliseconds: 200),
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
                                cyclesProviderRead.cycleDetailSelectedIndex == 1
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
                                cyclesProviderRead.cycleDetailSelectedIndex == 0
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
                      cyclesProvider.changeTabIndex(1);
                      pageController!.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 200),
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
                                cyclesProviderRead.cycleDetailSelectedIndex == 0
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
                                cyclesProviderRead.cycleDetailSelectedIndex == 1
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
                    cyclesProvider.changeTabIndex(0);
                  } else {
                    cyclesProvider.changeTabIndex(1);
                  }
                },
                children: [
                  Column(
                    children: [
                      Expanded(
                        child:
                            (cyclesProvider.cyclesIssueState ==
                                            StateEnum.loading ||
                                        cyclesProvider.cyclesDetailState ==
                                            StateEnum.loading) ||
                                    cyclesProvider.cycleViewState ==
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
                                : (cyclesProvider.isIssuesEmpty)
                                    ? EmptyPlaceholder.emptyIssues(context,
                                        cycleId: widget.cycleId,
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
                                                  children: cyclesProvider
                                                      .issues.issues
                                                      .map((state) => state
                                                                  .items
                                                                  .isEmpty &&
                                                              !cyclesProvider
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
                                                                              Navigator.of(context).push(
                                                                                MaterialPageRoute(
                                                                                  builder: (ctx) => CreateIssue(
                                                                                    cycleId: widget.cycleId,
                                                                                  ),
                                                                                ),
                                                                              );
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
                                                  cyclesProvider
                                                      .initializeBoard(),
                                                  boardID: 'cycle-board',
                                                  onItemReorder: (
                                                      {newCardIndex,
                                                      newListIndex,
                                                      oldCardIndex,
                                                      oldListIndex}) {
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
                                                      !cyclesProvider
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
                                                    duration: const Duration(
                                                      milliseconds: 100,
                                                    ),
                                                    curve: Curves.linear,
                                                  ),
                                                  listTransitionDuration:
                                                      const Duration(
                                                    milliseconds: 200,
                                                  ),
                                                  cardTransitionDuration:
                                                      const Duration(
                                                    milliseconds: 400,
                                                  ),
                                                  textStyle: TextStyle(
                                                    fontSize: 19,
                                                    height: 1.3,
                                                    color: Colors.grey.shade800,
                                                    fontWeight: FontWeight.w500,
                                                  ),
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
                                              IssueCategory.cycleIssues,
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
                                                    IssueCategory.cycleIssues,
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
                                                IssueCategory.cycleIssues,
                                            cycleOrModuleId: widget.cycleId,
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
                  CycleDetailsPage(
                    cycleId: widget.cycleId!,
                    chartData: chartData,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
