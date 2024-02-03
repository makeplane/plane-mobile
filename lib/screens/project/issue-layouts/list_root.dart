import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/core/components/issues/issue-card/issue_card_root.dart';
import 'package:plane/provider/issues/base-classes/base_issue_state.dart';
import 'package:plane/provider/issues/base-classes/base_issues_provider.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/utils/issues/issues_group_title_leading.dart';
import 'package:plane/widgets/custom_text.dart';

class ListLayoutRoot extends ConsumerStatefulWidget {
  const ListLayoutRoot(
      {required this.issuesProvider, required this.issuesState, super.key});
  final ABaseIssuesProvider issuesProvider;
  final ABaseIssuesState issuesState;
  @override
  ConsumerState<ListLayoutRoot> createState() => _ListLayoutRootState();
}

class _ListLayoutRootState extends ConsumerState<ListLayoutRoot> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final projectProvider = ref.watch(ProviderList.projectProvider);

    return Container(
      color: themeProvider.themeManager.secondaryBackgroundDefaultColor,
      margin: const EdgeInsets.only(top: 5),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          for (final group
              in widget.issuesState.currentLayoutIssues.keys.toList())
            widget.issuesState.currentLayoutIssues[group]!.isEmpty &&
                    !widget.issuesProvider.displayFilters.show_empty_groups
                ? Container()
                : SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // padding: const EdgeInsets.only(left: 15),
                          margin: const EdgeInsets.only(bottom: 10,left: 15),
                          child: Row(
                            children: [
                              getIssueGroupLeadingIcon(
                                  groupID: group,
                                  groupBY: widget.issuesProvider.group_by,
                                  ref: widget.issuesState.ref!),
                              Container(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                ),
                                child: CustomText(
                                  getIssuesGroupTitle(
                                      groupID: group,
                                      groupBY: widget.issuesProvider.group_by,
                                      ref: widget.issuesState.ref!),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  type: FontStyle.Large,
                                  color: themeProvider
                                      .themeManager.primaryTextColor,
                                  fontWeight: FontWeightt.Semibold,
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(
                                  left: 15,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: themeProvider.themeManager
                                        .tertiaryBackgroundDefaultColor),
                                height: 25,
                                width: 30,
                                child: CustomText(
                                  widget.issuesState.currentLayoutIssues[group]!
                                      .length
                                      .toString(),
                                  type: FontStyle.Small,
                                ),
                              ),
                              const Spacer(),
                              projectProvider.role == Role.admin ||
                                      projectProvider.role == Role.member
                                  ? IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.add,
                                        color: themeProvider
                                            .themeManager.tertiaryTextColor,
                                      ))
                                  : Container(
                                      height: 40,
                                    ),
                            ],
                          ),
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widget
                                .issuesState.currentLayoutIssues[group]!
                                .map((issue) => IssueCard(
                                    issue: issue,
                                    issuesProvider: widget.issuesProvider))
                                .toList()),
                        widget.issuesState.currentLayoutIssues[group]!.isEmpty
                            ? Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                width: MediaQuery.of(context).size.width,
                                color: themeProvider
                                    .themeManager.primaryBackgroundDefaultColor,
                                padding: const EdgeInsets.only(
                                    top: 15, bottom: 15, left: 15),
                                child: const CustomText(
                                  'No issues.',
                                  type: FontStyle.Small,
                                  maxLines: 10,
                                  textAlign: TextAlign.start,
                                ),
                              )
                            : Container(
                                margin: const EdgeInsets.only(bottom: 10),
                              )
                      ],
                    ),
                  )
        ]),
      ),
    );
  }
}
