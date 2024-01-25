import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/project/issue-layouts/issue_layout.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/loading_widget.dart';

class IssuesTab extends ConsumerStatefulWidget {
  const IssuesTab({super.key});

  @override
  ConsumerState<IssuesTab> createState() => _IssuesTabState();
}

class _IssuesTabState extends ConsumerState<IssuesTab> {
  @override
  Widget build(BuildContext context) {
    final issueProvider = ref.watch(ProviderList.issuesProvider);
    final statesProvider = ref.watch(ProviderList.statesProvider);
    return LoadingWidget(
        loading: issueProvider.issuePropertyState == StateEnum.loading ||
            issueProvider.issueState == StateEnum.loading ||
            statesProvider.statesState == StateEnum.loading ||
            issueProvider.projectViewState == StateEnum.loading ||
            issueProvider.orderByState == StateEnum.loading,
        widgetClass: IssueLayoutHandler(
          issueLayout: issueProvider.issues.projectView,
          isView: false,
        ));
  }
}
