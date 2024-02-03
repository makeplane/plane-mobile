import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/models/project/issue/issue_model.dart';
import 'package:plane/provider/issues/base-classes/base_issue_state.dart';
import 'package:plane/provider/issues/base-classes/base_issues_provider.dart';
import 'package:plane/screens/project/issue-layouts/calender_view.dart';
import 'package:plane/screens/project/issue-layouts/kanban_root.dart';
import 'package:plane/screens/project/issue-layouts/list_root.dart';
import 'package:plane/screens/project/issue-layouts/spreadsheet_view.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/empty.dart';

class IssueLayoutHandler extends ConsumerStatefulWidget {
  const IssueLayoutHandler(
      {required this.issuesProvider,
      required this.issues,
      required this.issuesState,
      required this.issueLayout,
      super.key});
  final IssuesLayout issueLayout;
  final ABaseIssuesProvider issuesProvider;
  final ABaseIssuesState issuesState;
  final List<IssueModel> issues;
  @override
  ConsumerState<IssueLayoutHandler> createState() => _IssueLayoutState();
}

class _IssueLayoutState extends ConsumerState<IssueLayoutHandler> {
  @override
  Widget build(BuildContext context) {
    return widget.issuesState.rawIssues.isEmpty &&
            widget.issuesState.fetchIssuesState == StateEnum.success
        ? EmptyPlaceholder.emptyIssues(context, ref: ref)
        : widget.issueLayout == IssuesLayout.list
            ? ListLayoutRoot(
                issuesProvider: widget.issuesProvider,
                issuesState: widget.issuesState,
              )
            : widget.issueLayout == IssuesLayout.kanban
                ? KanbanLayoutRoot(
                    issuesProvider: widget.issuesProvider,
                    issuesState: widget.issuesState,
                  )
                : widget.issueLayout == IssuesLayout.calendar
                    ? CalendarView(
                        issues: widget.issues,
                        issuesProvider: widget.issuesProvider,
                        issuesState: widget.issuesState,
                      )
                    : SpreadSheetView(
                        issues: widget.issues,
                        issuesProvider: widget.issuesProvider,
                        issueCategory: IssueCategory.projectIssues,
                      );
  }
}
