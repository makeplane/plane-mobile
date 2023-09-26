import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/models/issues.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/project_detail.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/widgets/custom_app_bar.dart';
import 'package:plane/widgets/loading_widget.dart';

import '../../../../../bottom_sheets/filters/filter_sheet.dart';
import '../../../../../bottom_sheets/type_sheet.dart';
import '../../../../../bottom_sheets/views_sheet.dart';
import '../../../../../utils/constants.dart';
import '../../../../../utils/enums.dart';
import '../../../../../widgets/custom_text.dart';
import '../IssuesTab/create_issue.dart';

class ViewsDetail extends ConsumerStatefulWidget {
  const ViewsDetail(
      {required this.index,
      this.fromGlobalSearch = false,
      this.viewID,
      this.projId,
      super.key});
  final int index;
  final bool fromGlobalSearch;
  final String? viewID;
  final String? projId;
  @override
  ConsumerState<ViewsDetail> createState() => _ViewsDetailState();
}

class _ViewsDetailState extends ConsumerState<ViewsDetail> {
  var filtersData = {};
  var issuesData = {};
  int countFilters() {
    // var prov = ref.read(ProviderList.viewsProvider);
    int count = 0;
    viewData["query_data"].forEach((key, value) {
      if (value != null && value.isNotEmpty) count++;
    });
    return count;
  }

  var viewData = {};

  @override
  void initState() {
    var issuesProv = ref.read(ProviderList.issuesProvider);
    var viewsProv = ref.read(ProviderList.viewsProvider);
    issuesProv.orderByState = StateEnum.loading;
    filtersData = Filters.toJson(issuesProv.issues.filters);
    issuesData = json.decode(json.encode(issuesProv.groupByResponse));

    var issuesProvider = ref.read(ProviderList.issuesProvider);

    // tempIssuesList = issuesProvider.issuesList;
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

    if (widget.fromGlobalSearch) {
      viewData = viewsProv.viewDetail;

      var projectProvider = ref.read(ProviderList.projectProvider);

      projectProvider.currentProject = projectProvider.projects
          .firstWhere((element) => element['id'] == widget.projId);
    } else {
      viewData = viewsProv.views[widget.index];
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(ProviderList.projectProvider).initializeProject(
          fromViews: true,
          filters: Filters.fromJson(viewData["query_data"]),
          ref: ref);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var projectProvider = ref.watch(ProviderList.projectProvider);
    var issuesProvider = ref.watch(ProviderList.issuesProvider);
    var viewsProv = ref.watch(ProviderList.viewsProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);

    // viewData = viewsProv.viewDetail;

    log(issuesProvider.issues.filters.priorities.toString());
    return WillPopScope(
      onWillPop: () async {
        if (!widget.fromGlobalSearch) {
          issuesProvider.getIssues(
            slug: ref
                .read(ProviderList.workspaceProvider)
                .selectedWorkspace
                .workspaceSlug,
            projID: projectProvider.currentProject['id'],
          );
          issuesProvider.issues.projectView = issuesProvider.tempProjectView;
          log(issuesProvider.tempProjectView.toString());
          issuesProvider.issues.groupBY = issuesProvider.tempGroupBy;

          issuesProvider.issues.orderBY = issuesProvider.tempOrderBy;
          issuesProvider.issues.issueType = issuesProvider.tempIssueType;

          issuesProvider.issues.filters = issuesProvider.tempFilters;

          issuesProvider.showEmptyStates =
              issuesProvider.issueView['display_filters']['show_empty_groups'];
          log('Temp Grouped By: ${ref.read(ProviderList.issuesProvider).tempGroupBy}');

          issuesProvider.setsState();
          issuesProvider.filterIssues(
              slug: ref
                  .read(ProviderList.workspaceProvider)
                  .selectedWorkspace
                  .workspaceSlug,
              projID: projectProvider.currentProject['id']);
        }

        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
            onPressed: () {
              if (!widget.fromGlobalSearch) {
                issuesProvider.getIssues(
                  slug: ref
                      .read(ProviderList.workspaceProvider)
                      .selectedWorkspace
                      .workspaceSlug,
                  projID: projectProvider.currentProject['id'],
                );
                issuesProvider.issues.projectView =
                    issuesProvider.tempProjectView;
                log(issuesProvider.tempProjectView.toString());
                issuesProvider.issues.groupBY = issuesProvider.tempGroupBy;

                issuesProvider.issues.orderBY = issuesProvider.tempOrderBy;
                issuesProvider.issues.issueType = issuesProvider.tempIssueType;

                issuesProvider.issues.filters = issuesProvider.tempFilters;

                issuesProvider.showEmptyStates = issuesProvider
                    .issueView['display_filters']['show_empty_groups'];
                log('Temp Grouped By: ${ref.read(ProviderList.issuesProvider).tempGroupBy}');

                issuesProvider.setsState();
                issuesProvider.filterIssues(
                    slug: ref
                        .read(ProviderList.workspaceProvider)
                        .selectedWorkspace
                        .workspaceSlug,
                    projID: projectProvider.currentProject['id']);
              }

              Navigator.pop(context);
            },
            text:
                ref.read(ProviderList.projectProvider).currentProject['name']),
        body: LoadingWidget(
          loading: issuesProvider.issuePropertyState == StateEnum.loading ||
              issuesProvider.issueState == StateEnum.loading ||
              issuesProvider.statesState == StateEnum.loading ||
              issuesProvider.projectViewState == StateEnum.loading ||
              issuesProvider.orderByState == StateEnum.loading ||
              viewsProv.viewsState == StateEnum.loading,
          widgetClass: Column(
            children: [
              Container(
                color: themeProvider.themeManager.primaryBackgroundDefaultColor,
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width - 120,
                          child: CustomText(
                            viewData['name'],
                            type: FontStyle.H6,
                            fontWeight: FontWeightt.Semibold,
                          ),
                        ),
                        const Spacer(),
                        (projectProvider.role != Role.admin &&
                                projectProvider.role != Role.member)
                            ? Container()
                            : GestureDetector(
                                onTap: () {
                                  ref
                                      .read(ProviderList.viewsProvider.notifier)
                                      .updateViews(
                                        id: viewData['id'],
                                        data: {
                                          "query_data": {
                                            "state": issuesProvider.issues
                                                    .filters.states.isEmpty
                                                ? null
                                                : issuesProvider
                                                    .issues.filters.states,
                                            "priority": issuesProvider.issues
                                                    .filters.priorities.isEmpty
                                                ? null
                                                : issuesProvider
                                                    .issues.filters.priorities,
                                            "assignees": issuesProvider.issues
                                                    .filters.assignees.isEmpty
                                                ? null
                                                : issuesProvider
                                                    .issues.filters.assignees,
                                            "created_by": issuesProvider.issues
                                                    .filters.createdBy.isEmpty
                                                ? null
                                                : issuesProvider
                                                    .issues.filters.createdBy,
                                            "labels": issuesProvider.issues
                                                    .filters.labels.isEmpty
                                                ? null
                                                : issuesProvider
                                                    .issues.filters.labels,
                                            "target_date": issuesProvider.issues
                                                    .filters.targetDate.isEmpty
                                                ? null
                                                : issuesProvider
                                                    .issues.filters.targetDate,
                                            "start_date": issuesProvider.issues
                                                    .filters.startDate.isEmpty
                                                ? null
                                                : issuesProvider
                                                    .issues.filters.startDate,
                                          }
                                        },
                                        fromGlobalSearch:
                                            widget.fromGlobalSearch,
                                        index: widget.index,
                                      )
                                      .then((value) {
                                    countFilters();
                                    if (viewsProv.viewsState !=
                                        StateEnum.success) {
                                      CustomToast.showToast(context,
                                          message: 'Soething went wrong ',
                                          toastType: ToastType.failure);
                                    } else {
                                      CustomToast.showToast(context,
                                          message: 'View updated successfully',
                                          toastType: ToastType.success);
                                    }
                                  });
                                },
                                child: CustomText(
                                  'Update',
                                  color:
                                      themeProvider.themeManager.primaryColour,
                                  fontSize: 17,
                                  fontWeight: FontWeightt.Medium,
                                ),
                              ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15, bottom: 15),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: themeProvider
                              .themeManager.secondaryBackgroundDefaultColor,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                              color: themeProvider
                                  .themeManager.borderSubtle01Color)),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomText(
                                '# Filters : ',
                                color: themeProvider
                                    .themeManager.placeholderTextColor,
                                fontSize: 17,
                                fontWeight: FontWeightt.Medium,
                              ),
                              CustomText(
                                ' ${countFilters()}',
                                color: themeProvider
                                    .themeManager.placeholderTextColor,
                                fontSize: 17,
                                fontWeight: FontWeightt.Medium,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.close,
                                color: themeProvider
                                    .themeManager.placeholderTextColor,
                                size: 17,
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 1,
                color: themeProvider.themeManager.borderSubtle01Color,
                width: double.infinity,
              ),
              Expanded(child: issues(context, ref, isViews: true)),
              SafeArea(
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: themeProvider
                          .themeManager.primaryBackgroundDefaultColor,
                      boxShadow:
                          themeProvider.themeManager.shadowBottomControlButtons),
                  child: Row(
                    children: [
                      projectProvider.role == Role.admin
                          ? Expanded(
                              child: InkWell(
                                onTap: () {
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
                              constraints:
                                  BoxConstraints(maxHeight: height * 0.5),
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              )),
                              context: context,
                              builder: (ctx) {
                                return const TypeSheet(
                                  issueCategory: IssueCategory.views,
                                );
                              });
                        },
                        child: SizedBox.expand(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.menu,
                                color:
                                    themeProvider.themeManager.primaryTextColor,
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
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              enableDrag: true,
                              constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.9),
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              )),
                              context: context,
                              builder: (ctx) {
                                return ViewsSheet(
                                  projectView: issuesProvider.issues.projectView,
                                  fromView: true,
                                  issueCategory: IssueCategory.views,
                                );
                              });
                        },
                        child: SizedBox.expand(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.wysiwyg_outlined,
                                color:
                                    themeProvider.themeManager.primaryTextColor,
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
                        color: themeProvider.themeManager.borderSubtle01Color,
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
                                return FilterSheet(
                                  fromViews: true,
                                  issueCategory: IssueCategory.views,
                                );
                              });
                        },
                        child: SizedBox.expand(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.filter_list_outlined,
                                color:
                                    themeProvider.themeManager.primaryTextColor,
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}