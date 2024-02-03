import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/project/issue-layouts/issue_layout_handler.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/loading_widget.dart';

class ModuleIssuesRoot extends ConsumerStatefulWidget {
  const ModuleIssuesRoot({super.key});

  @override
  ConsumerState<ModuleIssuesRoot> createState() => _ModuleIssuesRootState();
}

class _ModuleIssuesRootState extends ConsumerState<ModuleIssuesRoot> {
  @override
  Widget build(BuildContext context) {
    final projectIssuesState = ref.watch(ProviderList.projectIssuesProvider);
    final issueProvider =
        ref.watch(ProviderList.projectIssuesProvider.notifier);
    final issuesLayout =
        ref.read(ProviderList.projectIssuesProvider.notifier).issuesLayout;

    return LoadingWidget(
        loading: projectIssuesState.fetchIssuesState == StateEnum.loading,
        widgetClass: IssueLayoutHandler(
          issueLayout: issuesLayout,
          issuesProvider: issueProvider,
          issuesState: projectIssuesState,
          issues: projectIssuesState.rawIssues.values.toList(),
        ));
  }
}
