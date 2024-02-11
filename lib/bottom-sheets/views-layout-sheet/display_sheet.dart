import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/models/project/issue-filter-properties-and-view/issue_filter_and_properties.dart';
import 'package:plane/models/project/layout-properties/layout_properties.model.dart';
import 'package:plane/provider/issues/base-classes/base_issues_provider.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/utils/issues/issues_converter.helper.dart';
import 'package:plane/widgets/custom_button.dart';
import 'package:plane/widgets/custom_text.dart';
import 'widgets/display_tab.dart';

class DisplayFilterSheet extends ConsumerStatefulWidget {
  const DisplayFilterSheet({required this.issuesProvider, super.key});
  final ABaseIssuesProvider issuesProvider;

  @override
  ConsumerState<DisplayFilterSheet> createState() => _DisplayFilterSheetState();
}

class _DisplayFilterSheetState extends ConsumerState<DisplayFilterSheet> {
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
      bool? showEmptyGroups}) {
    setState(() {
      this.groupBy = groupBy ?? this.groupBy;
      this.orderBy = orderBy ?? this.orderBy;
      this.issueType = issueType ?? this.issueType;
      this.showEmptyGroups = showEmptyGroups ?? this.showEmptyGroups;
    });
  }

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
    groupBy = widget.issuesProvider.group_by;
    orderBy = widget.issuesProvider.order_by;
    issueType = IssuesConverter.fromStringToIssueType(
        widget.issuesProvider.displayFilters.type);
    showEmptyGroups = widget.issuesProvider.displayFilters.show_empty_groups;
    dProperties = widget.issuesProvider.displayProperties;
    layout = widget.issuesProvider.layout;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ref.watch(ProviderList.themeProvider).themeManager;
    return Container(
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Wrap(
          children: [
            Container(
                color: themeManager.primaryBackgroundDefaultColor,
                height: 50,
                child: Row(children: [
                  const CustomText(
                    'Display',
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
                      color: themeManager.placeholderTextColor,
                    ),
                  ),
                ])),
            DisplayTab(
              dProperties: dProperties,
              onDPropertiesChange: onDisplayPropertiesChange,
              groupBy: groupBy,
              orderBy: orderBy,
              issueType: issueType,
              layout: layout,
              showEmptyGroups: showEmptyGroups,
              issuesCategory: widget.issuesProvider.category,
              onchange: onDisplayFilterChange,
            ),
            Button(text: 'Apply Changes', ontap: () => applyChanges(context)),
          ],
        ),
      ),
    );
  }
}
