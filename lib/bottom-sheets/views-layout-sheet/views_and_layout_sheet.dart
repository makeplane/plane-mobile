import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/bottom-sheets/views-layout-sheet/widgets/display_tab.dart';
import 'package:plane/bottom-sheets/views-layout-sheet/widgets/layout_tab.dart';
import 'package:plane/models/project/issue-filter-properties-and-view/issue_filter_and_properties.dart';
import 'package:plane/models/project/layout-properties/layout_properties.model.dart';
import 'package:plane/provider/issues/base-classes/base_issues_provider.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/utils/issues/issues_converter.helper.dart';
import 'package:plane/widgets/custom_button.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/widgets/custom_text.dart';

class ViewsAndLayoutSheet extends ConsumerStatefulWidget {
  const ViewsAndLayoutSheet(
      {required this.issuesProvider, required this.issueCategory, super.key});
  final ABaseIssuesProvider issuesProvider;
  final IssuesCategory issueCategory;
  @override
  ConsumerState<ViewsAndLayoutSheet> createState() =>
      _ViewsAndLayoutSheetState();
}

class _ViewsAndLayoutSheetState extends ConsumerState<ViewsAndLayoutSheet> {
  late GroupBY groupBy;
  late OrderBY orderBy;
  late IssueType issueType;
  late bool showEmptyGroups;
  late DisplayPropertiesModel dProperties;
  late IssuesLayout layout;
  int selectedTab = 0;
  ScrollController scrollController = ScrollController();
  PageController pageController = PageController();

  void onDisplayFilterChange(
      {GroupBY? groupBy,
      OrderBY? orderBy,
      IssueType? issueType,
      bool? showEmptyGroups}) {}

  void applyChanges(BuildContext context) {
    LayoutPropertiesModel layoutProperties =
        widget.issuesProvider.state.layoutProperties;
    layoutProperties = layoutProperties.copyWith(
        display_properties: dProperties,
        display_filters: layoutProperties.display_filters.copyWith(
          show_empty_groups: showEmptyGroups,
          group_by: IssuesConverter.fromGroupbyToString(groupBy),
          order_by: IssuesConverter.fromOrderbyToString(orderBy),
          type: IssuesConverter.fromIssueTypetoString(issueType),
        ));
    widget.issuesProvider.updateLayoutProperties(layoutProperties);
    Navigator.of(context).pop();
  }

  void onDisplayPropertiesChange(DisplayPropertiesModel dProperties) {
    setState(() {
      this.dProperties = dProperties;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ProviderList.myIssuesProvider).changeTabIndex(index: 0);
    });
    groupBy = widget.issuesProvider.group_by;
    orderBy = widget.issuesProvider.order_by;
    issueType = IssuesConverter.fromStringToIssueType(
        widget.issuesProvider.displayFilters.type);
    showEmptyGroups = widget.issuesProvider.displayFilters.show_empty_groups;
    dProperties =
        widget.issuesProvider.state.layoutProperties.display_properties;
    layout = widget.issuesProvider.layout;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ref.watch(ProviderList.themeProvider).themeManager;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Column(
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
                    color: themeManager.placeholderTextColor,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),

          /// Layout and Display tabs
          Container(
            //bottom border
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: themeManager.borderSubtle01Color,
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
                                ? themeManager.primaryColour
                                : themeManager.placeholderTextColor,
                            type: FontStyle.H5,
                            fontWeight: FontWeightt.Medium,
                          ),
                        ),
                        Container(
                          height: 2,
                          color: selectedTab == 0
                              ? themeManager.primaryColour
                              : themeManager.borderSubtle01Color,
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
                                ? themeManager.primaryColour
                                : lightGreyTextColor,
                            type: FontStyle.H5,
                            fontWeight: FontWeightt.Medium,
                          ),
                        ),
                        Container(
                          height: 2,
                          color: selectedTab == 1
                              ? themeManager.primaryColour
                              : themeManager.borderSubtle01Color,
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
                  LayoutTab(
                      issuesProvider: widget.issuesProvider,
                      issueCategory: widget.issueCategory),
                  DisplayTab(
                    dProperties: dProperties,
                    onDPropertiesChange: onDisplayPropertiesChange,
                    groupBy: groupBy,
                    orderBy: orderBy,
                    issueType: issueType,
                    layout: layout,
                    showEmptyGroups: showEmptyGroups,
                    issuesCategory: widget.issueCategory,
                    onchange: onDisplayFilterChange,
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            child: Button(
              text: 'Apply',
              ontap: () => applyChanges(context),
              textColor: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
