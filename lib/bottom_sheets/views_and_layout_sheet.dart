import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/issues_provider.dart';
import 'package:plane/provider/my_issues_provider.dart';
import 'package:plane/provider/projects_provider.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/models/issues.dart';
import 'package:plane/widgets/custom_button.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/widgets/custom_expansion_tile.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/widgets/custom_text.dart';

class ViewsAndLayoutSheet extends ConsumerStatefulWidget {
  const ViewsAndLayoutSheet(
      {required this.issueCategory, this.cycleId, super.key});
  final Enum issueCategory; //= IssueCategory.myIssues;
  final String? cycleId;
  @override
  ConsumerState<ViewsAndLayoutSheet> createState() =>
      _ViewsAndLayoutSheetState();
}

class _ViewsAndLayoutSheetState extends ConsumerState<ViewsAndLayoutSheet> {
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
    for (int i = 0; i < displayProperties.length; i++) {
      if (displayProperties[i]['selected']) {
        return true;
      }
    }
    return false;
  }

  int selected = 0;

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

    ///////////////////////////////////////////// type sheet

    final dynamic prov = widget.issueCategory == IssueCategory.myIssues
        ? ref.read(ProviderList.myIssuesProvider)
        : ref.read(ProviderList.issuesProvider);
    selected = prov.issues.projectView == ProjectView.kanban
        ? 0
        : prov.issues.projectView == ProjectView.list
            ? 1
            : prov.issues.projectView == ProjectView.calendar
                ? 2
                : 3;

    super.initState();
  }

  ScrollController scrollController = ScrollController();
  PageController pageController = PageController();

  int selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final issueProvider = ref.watch(ProviderList.issuesProvider);
    final myIssuesProvider = ref.watch(ProviderList.myIssuesProvider);
    final projectProvider = ref.watch(ProviderList.projectProvider);
    Widget customHorizontalLine() {
      return Container(
        color: themeProvider.themeManager.borderDisabledColor,
        height: 1,
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 25, top: 25),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  color: themeProvider.themeManager.placeholderTextColor,
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 20),
        Container(
          //bottom border
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: lightGreeyColor,
                width: 1,
              ),
            ),
          ),

          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    pageController.jumpToPage(0);
                  },
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: CustomText(
                          'Layout',
                          color: selectedTab == 0
                              ? themeProvider.themeManager.primaryColour
                              : themeProvider.themeManager.placeholderTextColor,
                          type: FontStyle.H5,
                          fontWeight: FontWeightt.Medium,
                        ),
                      ),
                      selectedTab == 0
                          ? Container(
                              height: 2,
                              color: themeProvider.themeManager.primaryColour,
                            )
                          : Container(
                              height: 2,
                              color: lightGreeyColor,
                            )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    pageController.jumpToPage(1);
                  },
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: CustomText(
                          'Display',
                          color: selectedTab == 1
                              ? themeProvider.themeManager.primaryColour
                              : lightGreyTextColor,
                          type: FontStyle.H5,
                          fontWeight: FontWeightt.Medium,
                        ),
                      ),
                      selectedTab == 1
                          ? Container(
                              height: 2,
                              color: themeProvider.themeManager.primaryColour,
                            )
                          : Container(
                              height: 2,
                              color: lightGreeyColor,
                            )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: PageView(
              onPageChanged: (value) {
                setState(() {
                  selectedTab = value;
                });
              },
              controller: pageController,
              children: [
                //////////////////////////// First Item
                Column(
                  children: [
                    Container(
                      height: 10,
                    ),
                    //
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: InkWell(
                        onTap: () {
                          myIssuesProvider.issues.projectView =
                              ProjectView.list;
                          myIssuesProvider.issues.groupBY = GroupBY.stateGroups;
                          myIssuesProvider.filterIssues();
                          myIssuesProvider.setState();
                          myIssuesProvider.updateMyIssueView();
                          Navigator.of(context).pop();
                        },
                        child: Row(
                          children: [
                            Radio(
                                visualDensity: const VisualDensity(
                                  horizontal: VisualDensity.minimumDensity,
                                  vertical: VisualDensity.minimumDensity,
                                ),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                fillColor: selected == 1
                                    ? null
                                    : MaterialStateProperty.all<Color>(
                                        themeProvider
                                            .themeManager.borderSubtle01Color),
                                groupValue: selected,
                                activeColor:
                                    themeProvider.themeManager.primaryColour,
                                value: 1,
                                onChanged: (val) {
                                  myIssuesProvider.issues.projectView =
                                      ProjectView.list;
                                  myIssuesProvider.issues.groupBY =
                                      GroupBY.stateGroups;
                                  myIssuesProvider.filterIssues();
                                  myIssuesProvider.setState();
                                  myIssuesProvider.updateMyIssueView();
                                  Navigator.of(context).pop();
                                }),
                            const SizedBox(width: 10),
                            CustomText(
                              'List View',
                              type: FontStyle.H6,
                              color:
                                  themeProvider.themeManager.tertiaryTextColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1,
                      width: double.infinity,
                      child: Container(
                        color: themeProvider.themeManager.borderDisabledColor,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: InkWell(
                        onTap: () {
                          myIssuesProvider.issues.projectView =
                              ProjectView.kanban;
                          myIssuesProvider.setState();
                          myIssuesProvider.updateMyIssueView();
                          Navigator.of(context).pop();
                        },
                        child: Row(
                          children: [
                            Radio(
                                visualDensity: const VisualDensity(
                                  horizontal: VisualDensity.minimumDensity,
                                  vertical: VisualDensity.minimumDensity,
                                ),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                fillColor: selected == 0
                                    ? null
                                    : MaterialStateProperty.all<Color>(
                                        themeProvider
                                            .themeManager.borderSubtle01Color),
                                groupValue: selected,
                                activeColor:
                                    themeProvider.themeManager.primaryColour,
                                value: 0,
                                onChanged: (val) {
                                  myIssuesProvider.issues.projectView =
                                      ProjectView.kanban;
                                  myIssuesProvider.setState();
                                  myIssuesProvider.updateMyIssueView();
                                  Navigator.of(context).pop();
                                }),
                            const SizedBox(width: 10),
                            CustomText(
                              'Kanban View',
                              type: FontStyle.H6,
                              color:
                                  themeProvider.themeManager.tertiaryTextColor,
                            ),
                          ],
                        ),
                      ),
                    ),

                    widget.issueCategory == IssueCategory.myIssues
                        ? Container()
                        : SizedBox(
                            height: 1,
                            width: double.infinity,
                            child: Container(
                              color: themeProvider
                                  .themeManager.borderDisabledColor,
                            ),
                          ),
                    widget.issueCategory == IssueCategory.myIssues
                        ? Container()
                        : SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selected = 2;
                                });
                              },
                              child: Row(
                                children: [
                                  Radio(
                                      visualDensity: const VisualDensity(
                                        horizontal:
                                            VisualDensity.minimumDensity,
                                        vertical: VisualDensity.minimumDensity,
                                      ),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      fillColor: selected == 2
                                          ? null
                                          : MaterialStateProperty.all<Color>(
                                              themeProvider.themeManager
                                                  .disabledButtonColor),
                                      groupValue: selected,
                                      activeColor: themeProvider
                                          .themeManager.primaryColour,
                                      value: 2,
                                      onChanged: (val) {}),
                                  const SizedBox(width: 10),
                                  CustomText(
                                    'Calendar View',
                                    type: FontStyle.H6,
                                    color: themeProvider
                                        .themeManager.tertiaryTextColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                    widget.issueCategory == IssueCategory.myIssues
                        ? Container()
                        : SizedBox(
                            height: 1,
                            width: double.infinity,
                            child: Container(
                              color: themeProvider
                                  .themeManager.borderDisabledColor,
                            ),
                          ),
                    widget.issueCategory == IssueCategory.myIssues
                        ? Container()
                        : SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selected = 3;
                                });
                              },
                              child: Row(
                                children: [
                                  Radio(
                                      visualDensity: const VisualDensity(
                                        horizontal:
                                            VisualDensity.minimumDensity,
                                        vertical: VisualDensity.minimumDensity,
                                      ),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      fillColor: selected == 3
                                          ? null
                                          : MaterialStateProperty.all<Color>(
                                              themeProvider.themeManager
                                                  .disabledButtonColor),
                                      groupValue: selected,
                                      activeColor: themeProvider
                                          .themeManager.primaryColour,
                                      value: 3,
                                      onChanged: (val) {}),
                                  const SizedBox(width: 10),
                                  CustomText(
                                    'Spreadsheet View',
                                    type: FontStyle.H6,
                                    color: themeProvider
                                        .themeManager.tertiaryTextColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),

                //////////////////////////// Second Item

                ListView(
                  children: [
                    Column(
                      children: [
                        issueProvider.issues.projectView !=
                                ProjectView.spreadsheet
                            ? CustomExpansionTile(
                                title: 'Group by',
                                child: Wrap(
                                  children: [
                                    RadioListTile(
                                        fillColor: groupBy ==
                                                'state_detail.group'
                                            ? null
                                            : MaterialStateProperty.all<Color>(
                                                themeProvider.themeManager
                                                    .borderSubtle01Color),
                                        visualDensity: const VisualDensity(
                                          horizontal:
                                              VisualDensity.minimumDensity,
                                          vertical:
                                              VisualDensity.minimumDensity,
                                        ),
                                        // dense: true,
                                        groupValue: groupBy,
                                        title: const CustomText(
                                          'State Groups',
                                          type: FontStyle.Small,
                                          textAlign: TextAlign.start,
                                        ),
                                        value: 'state_detail.group',
                                        onChanged: (newValue) {
                                          setState(() {
                                            groupBy = 'state_detail.group';
                                          });
                                        },
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        activeColor: themeProvider
                                            .themeManager.primaryColour),
                                    RadioListTile(
                                        fillColor: groupBy == 'priority'
                                            ? null
                                            : MaterialStateProperty.all<Color>(
                                                themeProvider.themeManager
                                                    .borderSubtle01Color),
                                        visualDensity: const VisualDensity(
                                          horizontal:
                                              VisualDensity.minimumDensity,
                                          vertical:
                                              VisualDensity.minimumDensity,
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
                                        activeColor: themeProvider
                                            .themeManager.primaryColour),
                                    RadioListTile(
                                        fillColor: groupBy == 'labels'
                                            ? null
                                            : MaterialStateProperty.all<Color>(
                                                themeProvider.themeManager
                                                    .borderSubtle01Color),
                                        visualDensity: const VisualDensity(
                                          horizontal:
                                              VisualDensity.minimumDensity,
                                          vertical:
                                              VisualDensity.minimumDensity,
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
                                        activeColor: themeProvider
                                            .themeManager.primaryColour),
                                    widget.issueCategory ==
                                            IssueCategory.myIssues
                                        ? Container()
                                        : RadioListTile(
                                            fillColor: groupBy == 'created_by'
                                                ? null
                                                : MaterialStateProperty
                                                    .all<Color>(themeProvider
                                                        .themeManager
                                                        .borderSubtle01Color),
                                            visualDensity: const VisualDensity(
                                              horizontal:
                                                  VisualDensity.minimumDensity,
                                              vertical:
                                                  VisualDensity.minimumDensity,
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
                                    widget.issueCategory !=
                                            IssueCategory.myIssues
                                        ? Container()
                                        : RadioListTile(
                                            fillColor: groupBy == 'project'
                                                ? null
                                                : MaterialStateProperty
                                                    .all<Color>(themeProvider
                                                        .themeManager
                                                        .borderSubtle01Color),
                                            visualDensity: const VisualDensity(
                                              horizontal:
                                                  VisualDensity.minimumDensity,
                                              vertical:
                                                  VisualDensity.minimumDensity,
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

                                    myIssuesProvider.issues.projectView ==
                                            ProjectView.list
                                        ? RadioListTile(
                                            fillColor: groupBy == 'none'
                                                ? null
                                                : MaterialStateProperty
                                                    .all<Color>(themeProvider
                                                        .themeManager
                                                        .borderSubtle01Color),
                                            visualDensity: const VisualDensity(
                                              horizontal:
                                                  VisualDensity.minimumDensity,
                                              vertical:
                                                  VisualDensity.minimumDensity,
                                            ),
                                            // dense: true,
                                            groupValue: groupBy,
                                            title: CustomText(
                                              'None',
                                              type: FontStyle.Small,
                                              color: themeProvider.themeManager
                                                  .primaryTextColor,
                                              textAlign: TextAlign.start,
                                            ),
                                            value: 'none',
                                            onChanged: (newValue) {
                                              setState(() {
                                                groupBy = 'none';
                                              });
                                            },
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            activeColor: themeProvider
                                                .themeManager.primaryColour)
                                        : Container(),
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
                                            themeProvider.themeManager
                                                .borderSubtle01Color),
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
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    activeColor: themeProvider
                                        .themeManager.primaryColour),
                                RadioListTile(
                                    fillColor: orderBy == '-created_at'
                                        ? null
                                        : MaterialStateProperty.all<Color>(
                                            themeProvider.themeManager
                                                .borderSubtle01Color),
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
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    activeColor: themeProvider
                                        .themeManager.primaryColour),
                                RadioListTile(
                                    fillColor: orderBy == '-updated_at'
                                        ? null
                                        : MaterialStateProperty.all<Color>(
                                            themeProvider.themeManager
                                                .borderSubtle01Color),
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
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    activeColor: themeProvider
                                        .themeManager.primaryColour),

                                //start date
                                RadioListTile(
                                    fillColor: orderBy == 'start_date'
                                        ? null
                                        : MaterialStateProperty.all<Color>(
                                            themeProvider.themeManager
                                                .borderSubtle01Color),
                                    visualDensity: const VisualDensity(
                                      horizontal: VisualDensity.minimumDensity,
                                      vertical: VisualDensity.minimumDensity,
                                    ),
                                    groupValue: orderBy,
                                    title: const CustomText(
                                      'Start Date',
                                      type: FontStyle.Small,
                                      textAlign: TextAlign.start,
                                    ),
                                    value: 'start_date',
                                    onChanged: (newValue) {
                                      setState(() {
                                        orderBy = 'start_date';
                                      });
                                    },
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    activeColor: themeProvider
                                        .themeManager.primaryColour),
                                myIssuesProvider.issues.groupBY !=
                                        GroupBY.priority
                                    ? RadioListTile(
                                        fillColor: orderBy == 'priority'
                                            ? null
                                            : MaterialStateProperty.all<Color>(
                                                themeProvider.themeManager
                                                    .borderSubtle01Color),
                                        visualDensity: const VisualDensity(
                                          horizontal:
                                              VisualDensity.minimumDensity,
                                          vertical:
                                              VisualDensity.minimumDensity,
                                        ),
                                        groupValue: orderBy,
                                        title: const CustomText(
                                          'Priority',
                                          type: FontStyle.Small,
                                          textAlign: TextAlign.start,
                                        ),
                                        value: 'priority',
                                        onChanged: (newValue) {
                                          setState(() {
                                            orderBy = 'priority';
                                          });
                                        },
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        activeColor: themeProvider
                                            .themeManager.primaryColour)
                                    : Container(),
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
                                            themeProvider.themeManager
                                                .borderSubtle01Color),
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
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    activeColor: themeProvider
                                        .themeManager.primaryColour),
                                RadioListTile(
                                    fillColor: issueType == 'active'
                                        ? null
                                        : MaterialStateProperty.all<Color>(
                                            themeProvider.themeManager
                                                .borderSubtle01Color),
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
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    activeColor: themeProvider
                                        .themeManager.primaryColour),
                                RadioListTile(
                                    fillColor: issueType == 'backlog'
                                        ? null
                                        : MaterialStateProperty.all<Color>(
                                            themeProvider.themeManager
                                                .borderSubtle01Color),
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
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    activeColor: themeProvider
                                        .themeManager.primaryColour),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: showEmptyStates
                                                ? greenHighLight
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
                                    projectProvider
                                            .currentProject['estimate'] ==
                                        null)
                                ? const SizedBox()
                                : (((tag['name'] == 'Created on' ||
                                                tag['name'] == 'Updated on') &&
                                            issueProvider.issues.projectView !=
                                                ProjectView.spreadsheet) ||
                                        ((tag['name'] == 'ID' ||
                                                tag['name'] ==
                                                    'Attachment Count' ||
                                                tag['name'] == 'Link' ||
                                                tag['name'] ==
                                                    'Sub Issue Count') &&
                                            issueProvider.issues.projectView ==
                                                ProjectView.spreadsheet))
                                    ? const SizedBox()
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            tag['selected'] =
                                                !(tag['selected'] ?? false);
                                          });
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(right: 8),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 14, vertical: 6),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
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
                                                  : themeProvider.themeManager
                                                      .primaryTextColor),
                                        ),
                                      ))
                            .toList()),

                    const SizedBox(height: 20),
                    applyButton(issueProvider, context, myIssuesProvider,
                        projectProvider),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Container applyButton(IssuesProvider issueProvider, BuildContext context,
      MyIssuesProvider myIssuesProvider, ProjectsProvider projectProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, top: 30),
      child: Button(
        text: 'Apply',
        ontap: () async {
          if (orderBy == '' &&
              groupBy == '' &&
              issueType == '' &&
              !isTagsEnabled() &&
              issueProvider.showEmptyStates == showEmptyStates) {
            CustomToast.showToast(context,
                message: 'Please select atleast one filter',
                toastType: ToastType.warning);

            return;
          }
          if (myIssuesProvider.issues.groupBY != Issues.toGroupBY(groupBy) ||
              myIssuesProvider.issues.orderBY != Issues.toOrderBY(orderBy) ||
              myIssuesProvider.issues.issueType !=
                  Issues.toIssueType(issueType)) {
            setState(() {
              myIssuesProvider.issues.orderBY = Issues.toOrderBY(orderBy);
              myIssuesProvider.issues.groupBY = Issues.toGroupBY(groupBy);
              myIssuesProvider.issues.issueType = Issues.toIssueType(issueType);
            });

            myIssuesProvider.filterIssues();
          }
          final DisplayProperties properties = DisplayProperties(
            estimate: projectProvider.currentProject['estimate'] == null
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

          myIssuesProvider.issues.displayProperties = properties;
          myIssuesProvider.showEmptyStates = showEmptyStates;

          myIssuesProvider.setState();
          myIssuesProvider.updateMyIssueView();
          Navigator.of(context).pop();
        },
        textColor: Colors.white,
      ),
    );
  }
}
