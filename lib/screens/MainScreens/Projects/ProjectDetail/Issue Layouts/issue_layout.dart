import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/Issue%20Layouts/Kanban%20Layout/kanban_root.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/Issue%20Layouts/List%20Layout/list_root.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/calender_view.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/spreadsheet_view.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/empty.dart';

class IssueLayoutHandler extends ConsumerStatefulWidget {
  const IssueLayoutHandler(
      {required this.issueLayout, required this.isView, super.key});
  final IssueLayout issueLayout;
  final bool isView;
  @override
  ConsumerState<IssueLayoutHandler> createState() => _IssueLayoutState();
}

class _IssueLayoutState extends ConsumerState<IssueLayoutHandler> {
  @override
  Widget build(BuildContext context) {
    final issueProvider = ref.watch(ProviderList.issuesProvider);

    return issueProvider.groupByResponse.isEmpty &&
            issueProvider.issueState == StateEnum.success
        ? EmptyPlaceholder.emptyIssues(context, ref: ref)
        : widget.issueLayout == IssueLayout.list
            ? const ListLayoutRoot()
            : widget.issueLayout == IssueLayout.kanban
                ? KanbanLayoutRoot(
                    isViews: widget.isView,
                  )
                : widget.issueLayout == IssueLayout.calendar
                    ? const CalendarView()
                    : const SpreadSheetView(
                        issueCategory: IssueCategory.issues,
                      );
  }
}
