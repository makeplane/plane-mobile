import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/config/const.dart';
import 'package:plane/core/components/issues/issue-card/issue-kanban-card/issue_kanban_card.dart';
import 'package:plane/core/components/issues/issue-card/issue_list_card.dart';
import 'package:plane/models/project/issue/issue_model.dart';
import 'package:plane/provider/issues/base-classes/base_issues_provider.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/project/issues/issue_detail.dart';
import 'package:plane/utils/enums.dart';

class IssueCard extends ConsumerStatefulWidget {
  const IssueCard(
      {required this.issue, required this.issuesProvider, super.key});

  final ABaseIssuesProvider issuesProvider;
  final IssueModel issue;
  @override
  ConsumerState<IssueCard> createState() => _IssueCardWidgetState();
}

class _IssueCardWidgetState extends ConsumerState<IssueCard> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.read(ProviderList.themeProvider);
    return InkWell(
      onTap: () {
        Navigator.push(Const.globalKey.currentContext!,
            MaterialPageRoute(builder: (context) => const IssueDetail()));
      },
      child: Column(
        children: [
          Container(
              child: widget.issuesProvider.layout == IssuesLayout.list
                  ? IssueListCard(
                      issue: widget.issue,
                      issuesProvider: widget.issuesProvider,
                    )
                  : IssueKanbanCard(
                      issue: widget.issue,
                      issuesProvider: widget.issuesProvider,
                    )),
          widget.issuesProvider.layout == IssuesLayout.list
              ? Divider(
                  height: 1,
                  thickness: 1,
                  color: themeProvider.themeManager.borderSubtle01Color,
                )
              : Container(),
        ],
      ),
    );
  }
}
