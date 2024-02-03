import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/models/project/layout-properties/layout_properties.model.dart';
import 'package:plane/provider/issues/base-classes/base_issues_provider.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/issues/issues_converter.helper.dart';
import 'package:plane/widgets/custom_text.dart';

class LayoutTab extends ConsumerStatefulWidget {
  const LayoutTab(
      {required this.issuesProvider, super.key, required this.issueCategory});
  final Enum issueCategory;
  final ABaseIssuesProvider issuesProvider;

  @override
  ConsumerState<LayoutTab> createState() => _LayoutTabState();
}

class _LayoutTabState extends ConsumerState<LayoutTab> {
  late IssuesLayout selectLayout;
  List layoutList = [
    {'title': 'Kanban', 'key': IssuesLayout.kanban},
    {'title': 'List', 'key': IssuesLayout.list},
    {'title': 'Calendar', 'key': IssuesLayout.calendar},
    {'title': 'Spreadsheet', 'key': IssuesLayout.spreadsheet},
  ];

  @override
  void initState() {
    super.initState();
    selectLayout = widget.issuesProvider.layout;
  }

  void onLayoutChange(IssuesLayout layout) {
    setState(() {
      selectLayout = layout;
    });
    LayoutPropertiesModel layoutProperties =
        widget.issuesProvider.state.layoutProperties;
    layoutProperties = layoutProperties.copyWith(
            display_filters: layoutProperties.display_filters
                .copyWith(
                    layout: IssuesConverter.fromIssuesLayoutToString(layout)));
    widget.issuesProvider.updateLayoutProperties(layoutProperties);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 23, left: 23, right: 23),
      child: Wrap(
        children: [
          Column(
            children: [
              Row(
                children: [
                  const CustomText(
                    'Layout',
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
              Container(
                height: 10,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: layoutList.length,
                  itemBuilder: (ctx, index) {
                    if (widget.issueCategory == IssueCategory.myIssues &&
                        index > 1) return Container();
                    return Column(
                      children: [
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: InkWell(
                            onTap: () {
                              onLayoutChange(
                                  layoutList[index]['key'] as IssuesLayout);
                              return;
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
                                    fillColor:
                                        selectLayout == layoutList[index]['key']
                                            ? null
                                            : MaterialStateProperty.all<Color>(
                                                themeProvider.themeManager
                                                    .borderSubtle01Color),
                                    groupValue: selectLayout,
                                    activeColor: themeProvider
                                        .themeManager.primaryColour,
                                    value: layoutList[index]['key'],
                                    onChanged: (val) {
                                      onLayoutChange(layoutList[index]['key']
                                          as IssuesLayout);
                                    }),
                                const SizedBox(width: 10),
                                CustomText(
                                  layoutList[index]['title'],
                                  type: FontStyle.H6,
                                  //color: themeProvider.themeManager.tertiaryTextColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 1,
                          width: double.infinity,
                          child: Container(
                              color: themeProvider
                                  .themeManager.borderDisabledColor),
                        ),
                      ],
                    );
                  }),
              SizedBox(height: bottomSheetConstBottomPadding),
            ],
          ),
          //long blue button to apply filter
          // Container(
          //   margin: const EdgeInsets.only(bottom: 18, top: 20),
          //   child: Button(
          //     text: 'Apply Filter',
          //     ontap: () {
          //       if (widget.issueCategory == IssueCategory.myIssues) {
          //         if (selected == 0) {
          //           myIssuesProv.issues.projectView = IssueLayout.kanban;
          //         } else if (selected == 1) {
          //           myIssuesProv.issues.projectView = IssueLayout.list;
          //         }
          //         myIssuesProv.setState();
          //         myIssuesProv.updateMyIssueView();
          //       } else {
          //         if (selected == 0) {
          //           prov.issues.projectView = IssueLayout.kanban;
          //           prov.tempProjectView = IssueLayout.kanban;
          //         } else if (selected == 1) {
          //           prov.issues.projectView = IssueLayout.list;
          //           prov.tempProjectView = IssueLayout.list;
          //         } else if (selected == 2) {
          //           prov.issues.projectView = IssueLayout.calendar;
          //           prov.tempProjectView = IssueLayout.calendar;
          //         } else if (selected == 3) {
          //           prov.issues.projectView = IssueLayout.spreadsheet;
          //           prov.tempProjectView = IssueLayout.spreadsheet;
          //         }
          //         prov.setsState();
          //         if (widget.issueCategory == IssueCategory.issues) {
          //           prov.updateProjectView();
          //         }
          //       }

          //       Navigator.pop(context);
          //     },
          //     textColor: Colors.white,
          //   ),
          // ),
        ],
      ),
    );
  }
}
