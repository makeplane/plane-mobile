import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/core/icons/priority_icon.dart';
import 'package:plane/models/project/issue/issue_model.dart';
import 'package:plane/provider/issues/base-classes/base_issues_provider.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_rich_text.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/square_avatar_widget.dart';

class IssueListCard extends ConsumerStatefulWidget {
  const IssueListCard(
      {required this.issue, required this.issuesProvider, super.key});
  final ABaseIssuesProvider issuesProvider;
  final IssueModel issue;
  @override
  ConsumerState<IssueListCard> createState() => _IssueListCardState();
}

class _IssueListCardState extends ConsumerState<IssueListCard> {
  @override
  Widget build(BuildContext context) {
    final themeManager = ref.read(ProviderList.themeProvider).themeManager;
    final appliedDisplayProperties = widget.issuesProvider.displayProperties;
    final projectProvider = ref.read(ProviderList.projectProvider);
    return Container(
      color: themeManager.primaryBackgroundDefaultColor,
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          appliedDisplayProperties.priority
              ? Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color:
                          widget.issue.priority == 'urgent' ? Colors.red : null,
                      border:
                          Border.all(color: themeManager.borderSubtle01Color),
                      borderRadius: BorderRadius.circular(5)),
                  margin: const EdgeInsets.only(right: 15),
                  height: 30,
                  width: 30,
                  child: priorityIcon(widget.issue.priority))
              : const SizedBox(),
          appliedDisplayProperties.key
              ? SizedBox(
                  width:
                      70, // So that id will take a fixed space and the starting position of issue title will be same
                  child: CustomRichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      type: FontStyle.Small,
                      color: themeManager.placeholderTextColor,
                      widgets: [
                        TextSpan(
                            text: projectProvider.currentProject['identifier'],
                            style: TextStyle(
                              color: themeManager.placeholderTextColor,
                            )),
                        TextSpan(
                            text: '-${widget.issue.sequence_id}',
                            style: TextStyle(
                              color: themeManager.placeholderTextColor,
                            )),
                      ]))
              : Container(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: CustomText(
                widget.issue.name.trim(),
                type: FontStyle.Small,
                maxLines: 1,
                textAlign: TextAlign.start,
              ),
            ),
          ),
          appliedDisplayProperties.assignee
              ? widget.issue.assignee_ids.isNotEmpty
                  ? SizedBox(
                      height: 30,
                      child: Container(
                        alignment: Alignment.center,
                        height: 30,
                        child: SquareAvatarWidget(
                          member_ids: widget.issue.assignee_ids,
                        ),
                      ),
                    )
                  : Container(
                      height: 30,
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: themeManager.borderSubtle01Color),
                          borderRadius: BorderRadius.circular(5)),
                      child: Icon(
                        Icons.groups_2_outlined,
                        size: 18,
                        color: themeManager.tertiaryTextColor,
                      ),
                    )
              : const SizedBox(),
        ],
      ),
    );
  }
}
