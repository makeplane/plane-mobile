// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/bottom-sheets/filters/filter_sheet.dart';
import 'package:plane/bottom-sheets/views-layout-sheet/display_sheet.dart';
import 'package:plane/bottom-sheets/views-layout-sheet/widgets/layout_tab.dart';
import 'package:plane/models/project/issue-filter-properties-and-view/issue_filter_and_properties.dart';
import 'package:plane/provider/issues/base-classes/base_issues_provider.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/bottom_sheet.helper.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';

class _Tab {
  IconData leading;
  String title;
  VoidCallback onTap;

  _Tab({required this.leading, required this.title, required this.onTap});
}

class IssuesLayoutBottomActions extends ConsumerStatefulWidget {
  const IssuesLayoutBottomActions(
      {required this.issuesProvider, required this.selectedTab, super.key});
  final int selectedTab;
  final ABaseIssuesProvider issuesProvider;
  @override
  ConsumerState<IssuesLayoutBottomActions> createState() =>
      _IssuesLayoutBottomActionsState();
}

class _IssuesLayoutBottomActionsState
    extends ConsumerState<IssuesLayoutBottomActions> {
  List<_Tab> TABS = [];

  void onIssueTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Container(),
      ),
    );
  }

  void onLayoutTap() {
    BottomSheetHelper.showBottomSheet(
      context,
      LayoutTab(
        issuesProvider: widget.issuesProvider,
        issueCategory: IssuesCategory.PROJECT,
      ),
    );
  }

  void onDisplayTap() {
    BottomSheetHelper.showBottomSheet(
      context,
      DisplayFilterSheet(
        issuesProvider: widget.issuesProvider,
      ),
    );
  }

  void onFilterTap() {
    BottomSheetHelper.showBottomSheet(
        context,
        SelectFilterSheet(
          appliedFilter: widget.issuesProvider.appliedFilters,
          applyFilter: (filters) => {
            widget.issuesProvider.updateLayoutProperties(widget
                .issuesProvider.state.layoutProperties
                .copyWith(filters: filters))
          },
          clearAllFilter: () => {
            widget.issuesProvider.updateLayoutProperties(widget
                .issuesProvider.state.layoutProperties
                .copyWith(filters: const FiltersModel()))
          },
          labels: ref
              .read(ProviderList.labelProvider)
              .projectLabels
              .values
              .toList(),
          states: ref
              .read(ProviderList.statesProvider)
              .projectStates
              .values
              .toList(),
        ));
  }

  @override
  void initState() {
    TABS = [
      _Tab(leading: Icons.add, title: 'Issue', onTap: onIssueTap),
      _Tab(leading: Icons.list_outlined, title: 'Layout', onTap: onLayoutTap),
      _Tab(
          leading: Icons.wysiwyg_outlined, title: 'Display', onTap: onDisplayTap),
      _Tab(
          leading: Icons.filter_list_outlined,
          title: 'Filters',
          onTap: onFilterTap),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ref.watch(ProviderList.themeProvider).themeManager;
    final projectProvider = ref.watch(ProviderList.projectProvider);
    return Row(children: [
      Container(
          decoration: BoxDecoration(
            color: themeManager.primaryBackgroundDefaultColor,
            boxShadow: themeManager.shadowBottomControlButtons,
          ),
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: TABS
                .map((tab) =>
                    // SHow issue tab, if user is admin or member.
                    (tab.title == 'Issue' &&
                                (projectProvider.role != Role.admin &&
                                    projectProvider.role != Role.member)) ||
                            // Hide display tab for calendar layout.
                            (tab.title == 'Display' &&
                                widget.issuesProvider.displayFilters.layout ==
                                    'calendar')
                        ? Container()
                        : Expanded(
                            child: InkWell(
                              onTap: tab.onTap,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        right: BorderSide(
                                            width: 0.5,
                                            color: themeManager
                                                .borderSubtle01Color))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      tab.leading,
                                      color: themeManager.primaryTextColor,
                                      size: 18,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    CustomText(
                                      tab.title,
                                      height: 1,
                                      type: FontStyle.Medium,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ))
                .toList(),
          ))
    ]);
  }
}
