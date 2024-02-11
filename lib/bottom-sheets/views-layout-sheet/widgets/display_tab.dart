import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/models/project/issue-filter-properties-and-view/issue_filter_and_properties.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_expansion_tile.dart';
import 'package:plane/widgets/custom_text.dart';
import 'display_properties_list.dart';

class DisplayTab extends ConsumerStatefulWidget {
  const DisplayTab(
      {required this.dProperties,
      required this.onDPropertiesChange,
      required this.groupBy,
      required this.orderBy,
      required this.issueType,
      required this.layout,
      required this.showEmptyGroups,
      required this.onchange,
      required this.issuesCategory,
      super.key});
  final GroupBY groupBy;
  final OrderBY orderBy;
  final IssueType issueType;
  final IssuesLayout layout;
  final bool showEmptyGroups;
  final IssuesCategory issuesCategory;
  final DisplayPropertiesModel dProperties;
  final Function(DisplayPropertiesModel dProperties) onDPropertiesChange;
  final Function(
      {GroupBY? groupBy,
      OrderBY? orderBy,
      IssueType? issueType,
      bool? showEmptyGroups}) onchange;
  @override
  ConsumerState<DisplayTab> createState() => _DisplayTabState();
}

class _DisplayTabState extends ConsumerState<DisplayTab> {
  final groupbyProperties = [
    {
      'name': 'State',
      'value': GroupBY.state,
    },
    {
      'name': 'Priority',
      'value': GroupBY.priority,
    },
    {
      'name': 'Labels',
      'value': GroupBY.labels,
    },
    {
      'name': 'Assignees',
      'value': GroupBY.assignees,
    },
    {
      'name': 'Created by',
      'value': GroupBY.createdBY,
    },
    {
      'name': 'Project',
      'value': GroupBY.project,
    },
    {
      'name': 'None',
      'value': GroupBY.none,
    },
  ];
  final orderbyProperties = [
    {
      'name': 'Manual',
      'value': OrderBY.manual,
    },
    {
      'name': 'Last created',
      'value': OrderBY.lastCreated,
    },
    {
      'name': 'Last updated',
      'value': OrderBY.lastUpdated,
    },
    {
      'name': 'Start Date',
      'value': OrderBY.startDate,
    },
    {
      'name': 'Priority',
      'value': OrderBY.priority,
    },
  ];
  final issueTypeProperties = [
    {
      'name': 'All issues',
      'value': IssueType.all,
    },
    {
      'name': 'Active issues',
      'value': IssueType.active,
    },
    {
      'name': 'Backlog issues',
      'value': IssueType.backlog,
    },
  ];

  bool _shouldHideGroupbyProperty(GroupBY groupby) {
    /// in [global-issues] group by [project, created_by] should be hidden
    if (widget.issuesCategory == IssuesCategory.GLOBAL &&
        (groupby == GroupBY.project || groupby == GroupBY.createdBY)) {
      return true;
    }

    /// in [kanban-layout] group by [none] should be hidden
    else if (widget.layout == IssuesLayout.kanban && groupby == GroupBY.none) {
      return true;
    }

    /// group-by project should only be available in [global-issues]
    else if (widget.issuesCategory != IssuesCategory.GLOBAL &&
        groupby == GroupBY.project) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ref.watch(ProviderList.themeProvider).themeManager;

    return Wrap(
      children: [
        /// expansion tile for [group_by] property
        CustomExpansionTile(
            title: 'Group by',
            child: Wrap(
              children: groupbyProperties
                  .map(
                    (property) => _shouldHideGroupbyProperty(
                            property['value'] as GroupBY)
                        ? Container()
                        : Container(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Column(
                              children: [
                                RadioListTile(
                                    fillColor: widget.groupBy ==
                                            property['value']
                                        ? null
                                        : MaterialStateProperty.all<Color>(
                                            themeManager.borderSubtle01Color),
                                    visualDensity: const VisualDensity(
                                      horizontal: VisualDensity.minimumDensity,
                                      vertical: VisualDensity.minimumDensity,
                                    ),
                                    // dense: true,
                                    groupValue: widget.groupBy,
                                    title: CustomText(
                                      property['name'].toString(),
                                      type: FontStyle.Small,
                                      textAlign: TextAlign.start,
                                    ),
                                    value: property['value'],
                                    onChanged: (newValue) {
                                      setState(() {
                                        widget.onchange(
                                            groupBy:
                                                property['value'] as GroupBY);
                                      });
                                    },
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    activeColor: themeManager.primaryColour),
                                Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    height: 1,
                                    width: double.infinity,
                                    color: themeManager.borderDisabledColor),
                              ],
                            ),
                          ),
                  )
                  .toList(),
            )),

        /// expansion tile for [order_by] property
        CustomExpansionTile(
            title: 'Order by',
            child: Wrap(
              children: orderbyProperties
                  .map(
                    (property) => (widget.groupBy == GroupBY.priority &&
                            property['value'] == OrderBY.priority)
                        ? Container()
                        : Container(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Column(
                              children: [
                                RadioListTile(
                                    fillColor: widget.orderBy ==
                                            property['value']
                                        ? null
                                        : MaterialStateProperty.all<Color>(
                                            themeManager.borderSubtle01Color),
                                    visualDensity: const VisualDensity(
                                      horizontal: VisualDensity.minimumDensity,
                                      vertical: VisualDensity.minimumDensity,
                                    ),
                                    // dense: true,
                                    groupValue: widget.orderBy,
                                    title: CustomText(
                                      property['name'].toString(),
                                      type: FontStyle.Small,
                                      textAlign: TextAlign.start,
                                    ),
                                    value: property['value'],
                                    onChanged: (newValue) {
                                      setState(() {
                                        widget.onchange(
                                            orderBy:
                                                property['value'] as OrderBY);
                                      });
                                    },
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    activeColor: themeManager.primaryColour),
                                Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    height: 1,
                                    width: double.infinity,
                                    color: themeManager.borderDisabledColor),
                              ],
                            ),
                          ),
                  )
                  .toList(),
            )),

        /// expansion tile for [issues_type] property

        CustomExpansionTile(
            title: 'Issues Type',
            child: Wrap(
              children: issueTypeProperties
                  .map(
                    (property) => Container(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Column(
                        children: [
                          RadioListTile(
                              fillColor: widget.issueType == property['value']
                                  ? null
                                  : MaterialStateProperty.all<Color>(
                                      themeManager.borderSubtle01Color),
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              // dense: true,
                              groupValue: widget.issueType,
                              title: CustomText(
                                property['name'].toString(),
                                type: FontStyle.Small,
                                textAlign: TextAlign.start,
                              ),
                              value: property['value'],
                              onChanged: (newValue) {
                                setState(() {
                                  widget.onchange(
                                      issueType:
                                          property['value'] as IssueType);
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: themeManager.primaryColour),
                          Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              height: 1,
                              width: double.infinity,
                              color: themeManager.borderDisabledColor),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            )),

        InkWell(
          onTap: () {
            widget.onchange(showEmptyGroups: !widget.showEmptyGroups);
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
                          color: widget.showEmptyGroups
                              ? greenHighLight
                              : themeManager.tertiaryBackgroundDefaultColor),
                      child: Align(
                        alignment: widget.showEmptyGroups
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
        ),
        Container(height: 15),
        DisplayPropertiesList(
          dProperties: widget.dProperties,
          layout: widget.layout,
          onchange: widget.onDPropertiesChange,
        )
      ],
    );
  }
}
