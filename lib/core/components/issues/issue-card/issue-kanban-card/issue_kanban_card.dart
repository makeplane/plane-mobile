import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/core/components/issues/issue-card/issue-kanban-card/kanban_card_dproperties.dart';
import 'package:plane/models/project/issue/issue_model.dart';
import 'package:plane/provider/issues/base-classes/base_issues_provider.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_rich_text.dart';
import 'package:plane/widgets/custom_text.dart';

class IssueKanbanCard extends ConsumerStatefulWidget {
  const IssueKanbanCard(
      {required this.issue, required this.issuesProvider, super.key});
  final ABaseIssuesProvider issuesProvider;
  final IssueModel issue;

  @override
  ConsumerState<IssueKanbanCard> createState() => _IssueKanbanCardState();
}

class _IssueKanbanCardState extends ConsumerState<IssueKanbanCard> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.read(ProviderList.themeProvider);
    final appliedDProperties = widget.issuesProvider.displayProperties;
    final projectProvider = ref.read(ProviderList.projectProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal:10),
      margin: const EdgeInsets.only(bottom: 15, right: 5, left: 5, top: 5),
      decoration: BoxDecoration(
          color: themeProvider.themeManager.primaryBackgroundDefaultColor,
        boxShadow: [
        BoxShadow(
          blurRadius: 2,
          color: themeProvider.themeManager.borderSubtle01Color,
          spreadRadius: 0,
        )
      ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          appliedDProperties.key
              ? Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: CustomRichText(
                    type: FontStyle.Small,
                    color: themeProvider.themeManager.placeholderTextColor,
                    widgets: [
                      TextSpan(
                          text: projectProvider.currentProject['identifier']),
                      TextSpan(text: '-${widget.issue.sequence_id}'),
                    ],
                  ),
                )
              : Container(),
          const SizedBox(
            height: 10,
          ),
          CustomText(
            widget.issue.name,
            type: FontStyle.Medium,
            fontWeight: FontWeightt.Medium,
            maxLines: 2,
            textAlign: TextAlign.start,
          ),
          !widget.issuesProvider.isDisplayPropertiesEnabled
              ? const SizedBox(
                  height: 10,
                  width: 0,
                )
              : KanbanCardDProperties(
                  appliedDProperties: appliedDProperties,
                  issue: widget.issue,
                )
        ],
      ),
    );
  }
}
