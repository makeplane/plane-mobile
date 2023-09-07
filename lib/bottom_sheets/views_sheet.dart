import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/models/issues.dart';
import 'package:plane_startup/widgets/custom_button.dart';
import 'package:plane_startup/widgets/custom_expansion_tile.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/widgets/custom_text.dart';

class ViewsSheet extends ConsumerStatefulWidget {
  final Enum issueCategory;
  final bool fromView;
  final String? cycleId;
  const ViewsSheet({
    required this.issueCategory,
    this.cycleId,
    this.fromView = false,
    super.key,
  });

  @override
  ConsumerState<ViewsSheet> createState() => _ViewsSheetState();
}

class _ViewsSheetState extends ConsumerState<ViewsSheet> {
  String groupBy = '';
  String orderBy = '';
  String issueType = '';
  List displayProperties = [
    {
      'name': 'Assignee',
      'selected': false,
    },
    {
      'name': 'ID',
      'selected': false,
    },
    {
      'name': 'Due Date',
      'selected': false,
    },
    {
      'name': 'Label',
      'selected': false,
    },
    {
      'name': 'Priority',
      'selected': false,
    },
    {
      'name': 'State',
      'selected': false,
    },
    {
      'name': 'Sub Issue Count',
      'selected': false,
    },
    {
      'name': 'Attachment Count',
      'selected': false,
    },
    {
      'name': 'Link',
      'selected': false,
    },
    {
      'name': 'Estimate',
      'selected': false,
    },
    {
      'name': 'Created on',
      'selected': false,
    },
    {
      'name': 'Updated on',
      'selected': false,
    },
    {
      'name': 'Start Date',
      'selected': false,
    }
  ];

  bool isTagsEnabled() {
    for (var i = 0; i < displayProperties.length; i++) {
      if (displayProperties[i]['selected']) {
        return true;
      }
    }
    return false;
  }

  bool showEmptyStates = true;
  @override
  void initState() {
    dynamic issueProvider;
    if (widget.issueCategory == IssueCategory.cycleIssues) {
      issueProvider = ref.read(ProviderList.cyclesProvider);
    } else if (widget.issueCategory == IssueCategory.moduleIssues) {
      issueProvider = ref.read(ProviderList.modulesProvider);
    } else if (widget.issueCategory == IssueCategory.myIssues) {
      issueProvider = ref.read(ProviderList.myIssuesProvider);
    } else {
      issueProvider = ref.read(ProviderList.issuesProvider);
    }
    groupBy = Issues.fromGroupBY(issueProvider.issues.groupBY);
    orderBy = Issues.fromOrderBY(issueProvider.issues.orderBY);
    issueType = Issues.fromIssueType(issueProvider.issues.issueType);
    displayProperties[0]['selected'] =
        issueProvider.issues.displayProperties.assignee;
    displayProperties[1]['selected'] =
        issueProvider.issues.displayProperties.id;
    displayProperties[2]['selected'] =
        issueProvider.issues.displayProperties.dueDate;
    displayProperties[3]['selected'] =
        issueProvider.issues.displayProperties.label;
    displayProperties[4]['selected'] =
        issueProvider.issues.displayProperties.priority;
    displayProperties[5]['selected'] =
        issueProvider.issues.displayProperties.state;
    displayProperties[6]['selected'] =
        issueProvider.issues.displayProperties.subIsseCount;
    displayProperties[7]['selected'] =
        issueProvider.issues.displayProperties.attachmentCount;
    displayProperties[8]['selected'] =
        issueProvider.issues.displayProperties.linkCount;
    displayProperties[9]['selected'] =
        issueProvider.issues.displayProperties.estimate;
    displayProperties[10]['selected'] =
        issueProvider.issues.displayProperties.createdOn;
    displayProperties[11]['selected'] =
        issueProvider.issues.displayProperties.updatedOn;
    displayProperties[12]['selected'] =
        issueProvider.issues.displayProperties.startDate;
    showEmptyStates = issueProvider.showEmptyStates;
    super.initState();
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var issueProvider = ref.watch(ProviderList.issuesProvider);
    var myIssuesProvider = ref.watch(ProviderList.myIssuesProvider);
    var cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    var modulesProvider = ref.watch(ProviderList.modulesProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    Widget customHorizontalLine() {
      return Container(
        color: themeProvider.themeManager.borderDisabledColor,
        height: 1,
      );
    }

    return Container(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Stack(
        // shrinkWrap: true,
        children: [
          ListView(
            shrinkWrap: true,
            // crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Column(
                children: [
                  issueProvider.issues.projectView != ProjectView.spreadsheet
                      ? const SizedBox(
                          height: 40,
                        )
                      : Container(),
                  issueProvider.issues.projectView != ProjectView.spreadsheet
                      ? CustomExpansionTile(
                          title: 'Group by',
                          child: Wrap(
                            children: [
                              RadioListTile(
                                  fillColor: groupBy == 'state'
                                      ? null
                                      : MaterialStateProperty.all<Color>(
                                          themeProvider.themeManager
                                              .borderSubtle01Color),
                                  visualDensity: const VisualDensity(
                                    horizontal: VisualDensity.minimumDensity,
                                    vertical: VisualDensity.minimumDensity,
                                  ),
                                  // dense: true,
                                  groupValue: groupBy,
                                  title: CustomText(
                                    'State',
                                    type: FontStyle.Small,
                                    color: themeProvider
                                        .themeManager.primaryTextColor,
                                    textAlign: TextAlign.start,
                                  ),
                                  value: 'state',
                                  onChanged: (newValue) {
                                    setState(() {
                                      groupBy = 'state';
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  activeColor:
                                      themeProvider.themeManager.primaryColour),
                              RadioListTile(
                                  fillColor: groupBy == 'priority'
                                      ? null
                                      : MaterialStateProperty.all<Color>(
                                          themeProvider.themeManager
                                              .borderSubtle01Color),
                                  visualDensity: const VisualDensity(
                                    horizontal: VisualDensity.minimumDensity,
                                    vertical: VisualDensity.minimumDensity,
                                  ),
                                  // dense: true,
                                  groupValue: groupBy,
                                  title: const CustomText(
                                    'Priority',
                                    type: FontStyle.Small,
                                    textAlign: TextAlign.start,
                                  ),
                                  value: 'priority',
                                  onChanged: (newValue) {
                                    setState(() {
                                      groupBy = 'priority';
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  activeColor:
                                      themeProvider.themeManager.primaryColour),
                              RadioListTile(
                                  fillColor: groupBy == 'labels'
                                      ? null
                                      : MaterialStateProperty.all<Color>(
                                          themeProvider.themeManager
                                              .borderSubtle01Color),
                                  visualDensity: const VisualDensity(
                                    horizontal: VisualDensity.minimumDensity,
                                    vertical: VisualDensity.minimumDensity,
                                  ),
                                  // dense: true,
                                  groupValue: groupBy,
                                  title: const CustomText(
                                    'Labels',
                                    type: FontStyle.Small,
                                    textAlign: TextAlign.start,
                                  ),
                                  value: 'labels',
                                  onChanged: (newValue) {
                                    setState(() {
                                      groupBy = 'labels';
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  activeColor:
                                      themeProvider.themeManager.primaryColour),
                              widget.issueCategory == IssueCategory.myIssues
                                  ? Container()
                                  : RadioListTile(
                                      fillColor: groupBy == 'created_by'
                                          ? null
                                          : MaterialStateProperty.all<Color>(
                                              themeProvider.themeManager
                                                  .borderSubtle01Color),
                                      visualDensity: const VisualDensity(
                                        horizontal:
                                            VisualDensity.minimumDensity,
                                        vertical: VisualDensity.minimumDensity,
                                      ),
                                      // dense: true,
                                      groupValue: groupBy,
                                      title: const CustomText(
                                        'Created by',
                                        type: FontStyle.Small,
                                        textAlign: TextAlign.start,
                                      ),
                                      value: 'created_by',
                                      onChanged: (newValue) {
                                        setState(() {
                                          groupBy = 'created_by';
                                        });
                                      },
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      activeColor: themeProvider
                                          .themeManager.primaryColour),

                              //project
                              widget.issueCategory != IssueCategory.myIssues
                                  ? Container()
                                  : RadioListTile(
                                      fillColor: groupBy == 'project'
                                          ? null
                                          : MaterialStateProperty.all<Color>(
                                              themeProvider.themeManager
                                                  .borderSubtle01Color),
                                      visualDensity: const VisualDensity(
                                        horizontal:
                                            VisualDensity.minimumDensity,
                                        vertical: VisualDensity.minimumDensity,
                                      ),
                                      // dense: true,
                                      groupValue: groupBy,
                                      title: const CustomText(
                                        'Project',
                                        type: FontStyle.Small,
                                        textAlign: TextAlign.start,
                                      ),
                                      value: 'project',
                                      onChanged: (newValue) {
                                        setState(() {
                                          groupBy = 'project';
                                        });
                                      },
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      activeColor: themeProvider
                                          .themeManager.primaryColour),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),

              issueProvider.issues.projectView != ProjectView.spreadsheet
                  ? customHorizontalLine()
                  : Container(),

              //expansion tile for order by having two checkboxes last created and last updated
              issueProvider.issues.projectView != ProjectView.spreadsheet
                  ? CustomExpansionTile(
                      title: 'Order by',
                      child: Wrap(
                        children: [
                          RadioListTile(
                              fillColor: orderBy == 'sort_order'
                                  ? null
                                  : MaterialStateProperty.all<Color>(
                                      themeProvider
                                          .themeManager.borderSubtle01Color),
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              groupValue: orderBy,
                              title: const CustomText(
                                'Manual',
                                type: FontStyle.Small,
                                textAlign: TextAlign.start,
                              ),
                              value: 'sort_order',
                              onChanged: (newValue) {
                                setState(() {
                                  orderBy = 'sort_order';
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor:
                                  themeProvider.themeManager.primaryColour),
                          RadioListTile(
                              fillColor: orderBy == '-created_at'
                                  ? null
                                  : MaterialStateProperty.all<Color>(
                                      themeProvider
                                          .themeManager.borderSubtle01Color),
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              groupValue: orderBy,
                              title: const CustomText(
                                'Last created',
                                type: FontStyle.Small,
                                textAlign: TextAlign.start,
                              ),
                              value: '-created_at',
                              onChanged: (newValue) {
                                setState(() {
                                  orderBy = '-created_at';
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor:
                                  themeProvider.themeManager.primaryColour),
                          RadioListTile(
                              fillColor: orderBy == '-updated_at'
                                  ? null
                                  : MaterialStateProperty.all<Color>(
                                      themeProvider
                                          .themeManager.borderSubtle01Color),
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              groupValue: orderBy,
                              title: const CustomText(
                                'Last updated',
                                type: FontStyle.Small,
                                textAlign: TextAlign.start,
                              ),
                              value: '-updated_at',
                              onChanged: (newValue) {
                                setState(() {
                                  orderBy = '-updated_at';
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor:
                                  themeProvider.themeManager.primaryColour),

                          //start date
                          RadioListTile(
                              fillColor: orderBy == 'start_date'
                                  ? null
                                  : MaterialStateProperty.all<Color>(
                                      themeProvider
                                          .themeManager.borderSubtle01Color),
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              groupValue: orderBy,
                              title: const CustomText(
                                'Start date',
                                type: FontStyle.Small,
                                textAlign: TextAlign.start,
                              ),
                              value: 'start_date',
                              onChanged: (newValue) {
                                setState(() {
                                  orderBy = 'start_date';
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor:
                                  themeProvider.themeManager.primaryColour),
                        ],
                      ),
                    )
                  : Container(),

              issueProvider.issues.projectView != ProjectView.spreadsheet
                  ? customHorizontalLine()
                  : Container(),

              //expansion tile for issue type having three checkboxes all issues, active issues and backlog issues
              issueProvider.issues.projectView != ProjectView.spreadsheet
                  ? CustomExpansionTile(
                      title: 'Issue type',
                      child: Wrap(
                        children: [
                          RadioListTile(
                              fillColor: issueType == 'all'
                                  ? null
                                  : MaterialStateProperty.all<Color>(
                                      themeProvider
                                          .themeManager.borderSubtle01Color),
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              groupValue: issueType,
                              title: const CustomText(
                                'All issues',
                                type: FontStyle.Small,
                                textAlign: TextAlign.start,
                              ),
                              value: 'all',
                              onChanged: (newValue) {
                                setState(() {
                                  issueType = 'all';
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor:
                                  themeProvider.themeManager.primaryColour),
                          RadioListTile(
                              fillColor: issueType == 'active'
                                  ? null
                                  : MaterialStateProperty.all<Color>(
                                      themeProvider
                                          .themeManager.borderSubtle01Color),
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              groupValue: issueType,
                              title: const CustomText(
                                'Active issues',
                                type: FontStyle.Small,
                                textAlign: TextAlign.start,
                              ),
                              value: 'active',
                              onChanged: (newValue) {
                                setState(() {
                                  issueType = 'active';
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor:
                                  themeProvider.themeManager.primaryColour),
                          RadioListTile(
                              fillColor: issueType == 'backlog'
                                  ? null
                                  : MaterialStateProperty.all<Color>(
                                      themeProvider
                                          .themeManager.borderSubtle01Color),
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              groupValue: issueType,
                              title: const CustomText(
                                'Backlog issues',
                                type: FontStyle.Small,
                                textAlign: TextAlign.start,
                              ),
                              value: 'backlog',
                              onChanged: (newValue) {
                                setState(() {
                                  issueType = 'backlog';
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor:
                                  themeProvider.themeManager.primaryColour),
                        ],
                      ),
                    )
                  : Container(),

              issueProvider.issues.projectView != ProjectView.spreadsheet
                  ? customHorizontalLine()
                  : Container(),

              issueProvider.issues.projectView != ProjectView.spreadsheet
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          showEmptyStates = !showEmptyStates;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Wrap(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const CustomText(
                                  'Show empty states',
                                  type: FontStyle.Small,
                                ),
                                Container(
                                  width: 10,
                                ),
                                Container(
                                  width: 30,
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: showEmptyStates
                                          ? themeProvider
                                              .themeManager.textSuccessColor
                                          : themeProvider.themeManager
                                              .tertiaryBackgroundDefaultColor),
                                  child: Align(
                                    alignment: showEmptyStates
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: const CircleAvatar(
                                      radius: 6,
                                      backgroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),

              issueProvider.issues.projectView != ProjectView.spreadsheet
                  ? customHorizontalLine()
                  : Container(),

              issueProvider.issues.projectView != ProjectView.spreadsheet
                  ? Container(
                      height: 20,
                    )
                  : Container(),

              issueProvider.issues.projectView == ProjectView.spreadsheet
                  ? Container(
                      height: 45,
                    )
                  : Container(),

              Container(height: 15),

              const CustomText('Display Properties',
                  type: FontStyle.Large,
                  fontWeight: FontWeightt.Semibold,
                  textAlign: TextAlign.start),

              Container(height: 20),

              //rectangular grid of multiple tags to filter
              Wrap(
                  //spacing: 10,
                  runSpacing: 10,
                  children: displayProperties
                      .map((tag) => (tag['name'] == 'Estimate' &&
                              projectProvider.currentProject['estimate'] ==
                                  null)
                          ?
                          //////////////
                          // Container(
                          //     color: Colors.amber,
                          //     height: 0,
                          //     width: 0,
                          //   )
                          const SizedBox()
                          : (((tag['name'] == 'Created on' ||
                                          tag['name'] == 'Updated on') &&
                                      issueProvider.issues.projectView !=
                                          ProjectView.spreadsheet) ||
                                  ((tag['name'] == 'ID' ||
                                          tag['name'] == 'Attachment Count' ||
                                          tag['name'] == 'Link' ||
                                          tag['name'] == 'Sub Issue Count') &&
                                      issueProvider.issues.projectView ==
                                          ProjectView.spreadsheet))
                              ?
                              ///////////////////
                              // Container(
                              //     color: Colors.amber,
                              //     height: 0,
                              //     width: 0,
                              //   )
                              const SizedBox()
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      tag['selected'] =
                                          !(tag['selected'] ?? false);
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: tag['selected'] ?? false
                                          ? themeProvider
                                              .themeManager.primaryColour
                                          : themeProvider.themeManager
                                              .primaryBackgroundDefaultColor,
                                      border: Border.all(
                                        color: tag['selected'] ?? false
                                            ? Colors.transparent
                                            : themeProvider.themeManager
                                                .borderSubtle01Color,
                                      ),
                                    ),
                                    child: CustomText(tag['name'],
                                        textAlign: TextAlign.center,
                                        type: FontStyle.Medium,
                                        overrride: true,
                                        fontWeight: FontWeightt.Regular,
                                        color: tag['selected'] ?? false
                                            ? Colors.white
                                            : themeProvider
                                                .themeManager.primaryTextColor),
                                  ),
                                ))
                      .toList()),

              Container(
                margin: const EdgeInsets.only(bottom: 20, top: 30),
                child: Button(
                  text: 'Apply View',
                  ontap: () async {
                    if (orderBy == '' &&
                        groupBy == '' &&
                        issueType == '' &&
                        !isTagsEnabled() &&
                        issueProvider.showEmptyStates == showEmptyStates) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red[400],
                          content: const Text(
                            'Please select atleast one filter',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                      return;
                    }
                    if (widget.issueCategory == IssueCategory.myIssues) {
                      if (myIssuesProvider.issues.groupBY !=
                              Issues.toGroupBY(groupBy) ||
                          myIssuesProvider.issues.orderBY !=
                              Issues.toOrderBY(orderBy) ||
                          myIssuesProvider.issues.issueType !=
                              Issues.toIssueType(issueType)) {
                        setState(() {
                          myIssuesProvider.issues.orderBY =
                              Issues.toOrderBY(orderBy);
                          myIssuesProvider.issues.groupBY =
                              Issues.toGroupBY(groupBy);
                          myIssuesProvider.issues.issueType =
                              Issues.toIssueType(issueType);
                        });
                        myIssuesProvider.filterIssues();
                      }
                    } else if (issueProvider.issues.groupBY !=
                            Issues.toGroupBY(groupBy) ||
                        issueProvider.issues.orderBY !=
                            Issues.toOrderBY(orderBy) ||
                        issueProvider.issues.issueType !=
                            Issues.toIssueType(issueType)) {
                      //   print(orderBy);
                      //   print(' it is if');
                      setState(() {
                        issueProvider.issues.orderBY =
                            Issues.toOrderBY(orderBy);
                        issueProvider.issues.groupBY =
                            Issues.toGroupBY(groupBy);
                        issueProvider.issues.issueType =
                            Issues.toIssueType(issueType);
                      });
                      if (widget.issueCategory == IssueCategory.cycleIssues) {
                        cyclesProvider.filterCycleIssues(
                          slug: ref
                              .read(ProviderList.workspaceProvider)
                              .selectedWorkspace!
                              .workspaceSlug,
                          projectId: ref
                              .read(ProviderList.projectProvider)
                              .currentProject["id"],
                        );
                      } else if (widget.issueCategory ==
                          IssueCategory.moduleIssues) {
                        modulesProvider.filterModuleIssues(
                          slug: ref
                              .read(ProviderList.workspaceProvider)
                              .selectedWorkspace!
                              .workspaceSlug,
                          projectId: ref
                              .read(ProviderList.projectProvider)
                              .currentProject["id"],
                        );
                      } else {
                        log('filtering issues=============================${widget.fromView}');
                        issueProvider.filterIssues(
                            fromViews: widget.fromView,
                            slug: ref
                                .read(ProviderList.workspaceProvider)
                                .selectedWorkspace!
                                .workspaceSlug,
                            projID: ref
                                .read(ProviderList.projectProvider)
                                .currentProject["id"],
                            issueCategory: IssueCategory.issues);
                      }
                    }

                    DisplayProperties properties = DisplayProperties(
                      estimate:
                          projectProvider.currentProject['estimate'] == null
                              ? false
                              : displayProperties[9]['selected'],
                      assignee: displayProperties[0]['selected'],
                      dueDate: displayProperties[2]['selected'],
                      id: displayProperties[1]['selected'],
                      label: displayProperties[3]['selected'],
                      state: displayProperties[5]['selected'],
                      subIsseCount: displayProperties[6]['selected'],
                      linkCount: displayProperties[8]['selected'],
                      attachmentCount: displayProperties[7]['selected'],
                      priority: displayProperties[4]['selected'],
                      createdOn: displayProperties[10]['selected'],
                      updatedOn: displayProperties[11]['selected'],
                      startDate: displayProperties[12]['selected'],
                    );

                    if (widget.issueCategory == IssueCategory.myIssues) {
                      myIssuesProvider.issues.displayProperties = properties;
                      myIssuesProvider.showEmptyStates = showEmptyStates;
                      myIssuesProvider.updateMyIssueView();
                    } else {
                      if (widget.issueCategory == IssueCategory.cycleIssues) {
                        issueProvider.updateIssueProperties(
                          properties: properties,
                          issueCategory: widget.issueCategory,
                        );
                        cyclesProvider.issues.displayProperties = properties;
                        cyclesProvider.showEmptyStates = showEmptyStates;
                      } else if (widget.issueCategory ==
                          IssueCategory.moduleIssues) {
                        issueProvider.updateIssueProperties(
                          properties: properties,
                          issueCategory: widget.issueCategory,
                        );
                        modulesProvider.issues.displayProperties = properties;

                        modulesProvider.showEmptyStates = showEmptyStates;
                      } else {
                        issueProvider.updateIssueProperties(
                          properties: properties,
                          issueCategory: widget.issueCategory,
                        );
                        issueProvider.issues.displayProperties = properties;
                        issueProvider.showEmptyStates = showEmptyStates;
                      }
                      // if (widget.issueCategory == IssueCategory.issues) {
                      if (widget.issueCategory == IssueCategory.issues) {
                        issueProvider.updateProjectView();
                      }
                      // }
                    }

                    log(displayProperties.toString());

                    Navigator.of(context).pop();
                  },
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
          Container(
            color: themeProvider.themeManager.primaryBackgroundDefaultColor,
            height: 50,
            child: Row(
              children: [
                const CustomText(
                  'Views',
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
        ],
      ),
    );
  }
}
