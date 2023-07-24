import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/models/issues.dart';
import 'package:plane_startup/widgets/custom_button.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/widgets/custom_expansion_tile.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/widgets/custom_text.dart';

class ViewsSheet extends ConsumerStatefulWidget {
  final Enum issueCategory;
  final String? cycleId;
  const ViewsSheet({required this.issueCategory, this.cycleId, super.key});

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
    showEmptyStates = issueProvider.showEmptyStates;
    super.initState();
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var issueProvider = ref.watch(ProviderList.issuesProvider);
    var cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    var modulesProvider = ref.watch(ProviderList.modulesProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    Widget customHorizontalLine() {
      return Container(
        color: themeProvider.isDarkThemeEnabled
            ? darkThemeBorder
            : Colors.grey[300],
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
                  const SizedBox(
                    height: 40,
                  ),
                  CustomExpansionTile(
                    title: 'Group by',
                    child: Wrap(
                      children: [
                        RadioListTile(
                            visualDensity: const VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                              vertical: VisualDensity.minimumDensity,
                            ),
                            // dense: true,
                            groupValue: groupBy,
                            title: const CustomText(
                              'State',
                              type: FontStyle.subheading,
                              textAlign: TextAlign.start,
                            ),
                            value: 'state',
                            onChanged: (newValue) {
                              setState(() {
                                groupBy = 'state';
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: primaryColor),
                        RadioListTile(
                            visualDensity: const VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                              vertical: VisualDensity.minimumDensity,
                            ),
                            // dense: true,
                            groupValue: groupBy,
                            title: const CustomText(
                              'Priority',
                              type: FontStyle.subheading,
                              textAlign: TextAlign.start,
                            ),
                            value: 'priority',
                            onChanged: (newValue) {
                              setState(() {
                                groupBy = 'priority';
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: primaryColor),
                        RadioListTile(
                            visualDensity: const VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                              vertical: VisualDensity.minimumDensity,
                            ),
                            // dense: true,
                            groupValue: groupBy,
                            title: const CustomText(
                              'Labels',
                              type: FontStyle.subheading,
                              textAlign: TextAlign.start,
                            ),
                            value: 'labels',
                            onChanged: (newValue) {
                              setState(() {
                                groupBy = 'labels';
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: primaryColor),
                        RadioListTile(
                            visualDensity: const VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                              vertical: VisualDensity.minimumDensity,
                            ),
                            // dense: true,
                            groupValue: groupBy,
                            title: const CustomText(
                              'Created by',
                              type: FontStyle.subheading,
                              textAlign: TextAlign.start,
                            ),
                            value: 'created_by',
                            onChanged: (newValue) {
                              setState(() {
                                groupBy = 'created_by';
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: primaryColor),
                      ],
                    ),
                  ),
                ],
              ),

              customHorizontalLine(),

              //expansion tile for order by having two checkboxes last created and last updated
              CustomExpansionTile(
                title: 'Order by',
                child: Wrap(
                  children: [
                    RadioListTile(
                        visualDensity: const VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity,
                        ),
                        groupValue: orderBy,
                        title: const CustomText(
                          'Manual',
                          type: FontStyle.subheading,
                          textAlign: TextAlign.start,
                        ),
                        value: 'sort_order',
                        onChanged: (newValue) {
                          setState(() {
                            orderBy = 'sort_order';
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: primaryColor),
                    RadioListTile(
                        visualDensity: const VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity,
                        ),
                        groupValue: orderBy,
                        title: const CustomText(
                          'Last created',
                          type: FontStyle.subheading,
                          textAlign: TextAlign.start,
                        ),
                        value: '-created_at',
                        onChanged: (newValue) {
                          setState(() {
                            orderBy = '-created_at';
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: primaryColor),
                    RadioListTile(
                        visualDensity: const VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity,
                        ),
                        groupValue: orderBy,
                        title: const CustomText(
                          'Last updated',
                          type: FontStyle.subheading,
                          textAlign: TextAlign.start,
                        ),
                        value: 'updated_at',
                        onChanged: (newValue) {
                          setState(() {
                            orderBy = 'updated_at';
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: primaryColor),
                  ],
                ),
              ),

              customHorizontalLine(),

              //expansion tile for issue type having three checkboxes all issues, active issues and backlog issues
              CustomExpansionTile(
                title: 'Issue type',
                child: Wrap(
                  children: [
                    RadioListTile(
                        visualDensity: const VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity,
                        ),
                        groupValue: issueType,
                        title: const CustomText(
                          'All issues',
                          type: FontStyle.subheading,
                          textAlign: TextAlign.start,
                        ),
                        value: 'all',
                        onChanged: (newValue) {
                          setState(() {
                            issueType = 'all';
                          });
                        },
                        
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: primaryColor),
                    RadioListTile(
                        visualDensity: const VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity,
                        ),
                        groupValue: issueType,
                        title: const CustomText(
                          'Active issues',
                          type: FontStyle.subheading,
                          textAlign: TextAlign.start,
                        ),
                        value: 'active',
                        onChanged: (newValue) {
                          setState(() {
                            issueType = 'active';
                          });
                        },

                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: primaryColor),
                    RadioListTile(
                        visualDensity: const VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity,
                        ),
                        groupValue: issueType,
                        title: const CustomText(
                          'Backlog issues',
                          type: FontStyle.subheading,
                          textAlign: TextAlign.start,
                        ),
                        value: 'backlog',
                        onChanged: (newValue) {
                          setState(() {
                            issueType = 'backlog';
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: primaryColor),
                  ],
                ),
              ),

              customHorizontalLine(),

              InkWell(
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
                            type: FontStyle.subheading,
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
                                    ? greenHighLight
                                    : Colors.grey[300]),
                            child: Align(
                              alignment: showEmptyStates
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: const CircleAvatar(radius: 6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              customHorizontalLine(),

              Container(
                height: 20,
              ),

              Container(height: 15),

              const CustomText('Display Properties',
                  type: FontStyle.subheading,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.start),

              Container(height: 20),
              //rectangular grid of multiple tags to filter
              Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: displayProperties
                      .map((tag) => (tag['name'] == 'Estimate' &&
                              projectProvider.currentProject['estimate'] ==
                                  null)
                          ? const SizedBox()
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  tag['selected'] = !(tag['selected'] ?? false);
                                });
                              },
                              child: Container(
                                height: 40,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 7),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: tag['selected'] ?? false
                                      ? primaryColor
                                    :  themeProvider.isDarkThemeEnabled
                                            ? darkBackgroundColor
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: tag['selected'] ?? false
                                        ? Colors.transparent
                                        : themeProvider.isDarkThemeEnabled
                                            ? Colors.transparent
                                            : const Color.fromARGB(
                                                255, 193, 192, 192),
                                  ),
                                ),
                                child: CustomText(tag['name'],
                                    type: FontStyle.title,
                                    color: themeProvider.isDarkThemeEnabled &&
                                            (tag['selected'] ?? false)
                                        ? Colors.white
                                        : themeProvider.isDarkThemeEnabled &&
                                                !(tag['selected'] ?? false)
                                            ? Colors.white
                                            : !themeProvider
                                                        .isDarkThemeEnabled &&
                                                    (tag['selected'] ?? false)
                                                ? Colors.white
                                                : !themeProvider
                                                            .isDarkThemeEnabled &&
                                                        !(tag['selected'] ??
                                                            false)
                                                    ? Colors.black
                                                    : Colors.black),
                              ),
                            ))
                      .toList()),
              Container(
                margin: const EdgeInsets.only(bottom: 20, top: 30),
                child: Button(
                  text: 'Apply Filter',
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
                    if (issueProvider.issues.groupBY !=
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
                      }
                      if (widget.issueCategory == IssueCategory.moduleIssues) {
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
                        issueProvider.filterIssues(
                            slug: ref
                                .read(ProviderList.workspaceProvider)
                                .selectedWorkspace!
                                .workspaceSlug,
                            projID: ref
                                .read(ProviderList.projectProvider)
                                .currentProject["id"],
                            issueCategory: widget.issueCategory);
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
                        priority: displayProperties[4]['selected']);

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
                    if (widget.issueCategory == IssueCategory.issues) {
                      issueProvider.updateProjectView();
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
            color: themeProvider.isDarkThemeEnabled
                ? const Color.fromRGBO(29, 30, 32, 1)
                : Colors.white,
            height: 50,
            child: Row(
              children: [
                // const Text(
                //   'Views',
                //   style: TextStyle(
                //     fontSize: 24,
                //     fontWeight: FontWeight.w600,
                //   ),
                // ),
                const CustomText(
                  'Views',
                  type: FontStyle.heading,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    size: 27,
                    color: Color.fromRGBO(143, 143, 147, 1),
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
