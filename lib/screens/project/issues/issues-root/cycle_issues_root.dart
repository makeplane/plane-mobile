import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/project/issue-layouts/issue_layout_handler.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/loading_widget.dart';

class CycleIssuesRoot extends ConsumerStatefulWidget {
  const CycleIssuesRoot({super.key});

  @override
  ConsumerState<CycleIssuesRoot> createState() => _CycleIssuesRootState();
}

class _CycleIssuesRootState extends ConsumerState<CycleIssuesRoot> {
  @override
  Widget build(BuildContext context) {
    final cycleIssuesState = ref.watch(ProviderList.cycleIssuesProvider);
    final cycleIssueProvider =
        ref.watch(ProviderList.cycleIssuesProvider.notifier);

    return LoadingWidget(
        loading: cycleIssuesState.fetchIssuesState == DataState.loading,
        widgetClass: IssueLayoutHandler(
          issueLayout: cycleIssueProvider.layout,
          issuesProvider: cycleIssueProvider,
          issuesState: cycleIssuesState,
          issues: cycleIssuesState.rawIssues.values.toList(),
        ));
  }
}
