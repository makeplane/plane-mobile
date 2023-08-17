// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/custom_toast.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_button.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import 'package:plane_startup/widgets/empty.dart';

class IssuesListSheet extends ConsumerStatefulWidget {
  // bool parent;
  final String issueId;
  final bool createIssue;
  // bool blocking;
  final IssueDetailCategory type;
  const IssuesListSheet(
      {
      // required this.parent,
      required this.issueId,
      required this.createIssue,
      required this.type,
      // required this.blocking,
      super.key});

  @override
  ConsumerState<IssuesListSheet> createState() => _IssuesListSheetState();
}

class _IssuesListSheetState extends ConsumerState<IssuesListSheet> {
  @override
  void initState() {
    super.initState();
    // ref.read(ProviderList.searchIssueProvider).setStateToLoading();
    ref.read(ProviderList.searchIssueProvider).getIssues(
          slug: ref
              .read(ProviderList.workspaceProvider)
              .selectedWorkspace!
              .workspaceSlug,
          projectId: widget.createIssue
              ? ref
                  .read(ProviderList.issuesProvider)
                  .createIssueProjectData['id']
              : ref.read(ProviderList.projectProvider).currentProject['id'],
          type: widget.type,
          // parent: widget.parent,
          issueId: widget.createIssue ? '' : widget.issueId,
        );
  }

  @override
  Widget build(BuildContext context) {
    var searchIssueProvider = ref.watch(ProviderList.searchIssueProvider);
    var searchIssueProviderRead = ref.read(ProviderList.searchIssueProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var issueProvider = ref.watch(ProviderList.issueProvider);
    var issuesProvider = ref.read(ProviderList.issuesProvider);
    var cyclesProvider = ref.read(ProviderList.cyclesProvider);
    var modulesProvider = ref.read(ProviderList.modulesProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: themeProvider.themeManager.secondaryBackgroundDefaultColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
      constraints: BoxConstraints(maxHeight: height * 0.7),
      child: searchIssueProvider.searchIssuesState == StateEnum.loading
          ? Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: LoadingIndicator(
                  indicatorType: Indicator.lineSpinFadeLoader,
                  colors: [themeProvider.themeManager.primaryTextColor],
                  strokeWidth: 1.0,
                  backgroundColor: Colors.transparent,
                ),
              ),
            )
          : searchIssueProvider.issues.isEmpty
              ? Column(
                  children: [
                    Row(
                      children: [
                        CustomText(
                          'Add new issues',
                          type: FontStyle.H4,
                          fontWeight: FontWeightt.Semibold,
                          color: themeProvider.themeManager.primaryTextColor,
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Icons.close,
                              color: themeProvider
                                  .themeManager.placeholderTextColor,
                            ))
                      ],
                    ),
                    const Spacer(),
                    EmptyPlaceholder.emptyIssues(
                      context,
                    ),
                    const Spacer(),
                  ],
                )
              : Column(
                  children: [
                    Row(
                      children: [
                        CustomText(
                          widget.type == IssueDetailCategory.parent
                              ? 'Add parent'
                              : 'Add sub issues',
                          type: FontStyle.H4,
                          fontWeight: FontWeightt.Semibold,
                          color: themeProvider.themeManager.primaryTextColor,
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Icons.close,
                              color: themeProvider
                                  .themeManager.placeholderTextColor,
                            ))
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      decoration: themeProvider.themeManager.textFieldDecoration
                          .copyWith(
                        prefixIcon: const Icon(
                          Icons.search,
                          color: greyColor,
                        ),
                      ),
                      onChanged: (value) => searchIssueProviderRead.getIssues(
                          slug: ref
                              .read(ProviderList.workspaceProvider)
                              .selectedWorkspace!
                              .workspaceSlug,
                          projectId: ref
                              .read(ProviderList.projectProvider)
                              .currentProject['id'],
                          input: value,
                          // parent: widget.parent,
                          type: widget.type,
                          issueId: widget.issueId),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: searchIssueProvider.issues.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                if (widget.type == IssueDetailCategory.parent) {
                                  if (widget.createIssue) {
                                    if (issuesProvider.createIssueParent ==
                                        searchIssueProvider.issues[index]
                                                ['project__identifier'] +
                                            '-' +
                                            searchIssueProvider.issues[index]
                                                    ['sequence_id']
                                                .toString()) {
                                      issuesProvider.createIssueParent = '';
                                      issuesProvider.createIssueParentId = '';
                                    } else {
                                      issuesProvider.createIssueParent =
                                          searchIssueProvider.issues[index]
                                                  ['project__identifier'] +
                                              '-' +
                                              searchIssueProvider.issues[index]
                                                      ['sequence_id']
                                                  .toString();
                                      issuesProvider.createIssueParentId =
                                          searchIssueProvider.issues[index]
                                              ['id'];
                                    }
                                    issuesProvider.setsState();
                                  } else {
                                    issueProvider.upDateIssue(
                                      slug: ref
                                          .read(ProviderList.workspaceProvider)
                                          .selectedWorkspace!
                                          .workspaceSlug,
                                      projID: ref
                                          .read(ProviderList.projectProvider)
                                          .currentProject['id'],
                                      issueID: widget.createIssue
                                          ? ''
                                          : widget.issueId,
                                      data: {
                                        "parent": searchIssueProvider
                                            .issues[index]['id']
                                      },
                                      refs: ref,
                                    );
                                  }
                                  Navigator.of(context).pop();
                                }
                                if (widget.type ==
                                    IssueDetailCategory.addModuleIssue) {
                                  if (modulesProvider.selectedIssues.contains(
                                      searchIssueProvider.issues[index]
                                          ['id'])) {
                                    modulesProvider.selectedIssues.remove(
                                        searchIssueProvider.issues[index]
                                            ['id']);
                                  } else {
                                    modulesProvider.selectedIssues.add(
                                        searchIssueProvider.issues[index]
                                            ['id']);
                                  }
                                  modulesProvider.setState();
                                }
                                if (widget.type ==
                                    IssueDetailCategory.addCycleIssue) {
                                  if (cyclesProvider.selectedIssues.contains(
                                      searchIssueProvider.issues[index]
                                          ['id'])) {
                                    cyclesProvider.selectedIssues.remove(
                                        searchIssueProvider.issues[index]
                                            ['id']);
                                  } else {
                                    cyclesProvider.selectedIssues.add(
                                        searchIssueProvider.issues[index]
                                            ['id']);
                                  }
                                  cyclesProvider.setState();
                                }
                                if (widget.type ==
                                    IssueDetailCategory.subIssue) {
                                  if (issuesProvider.subIssuesIds.contains(
                                      searchIssueProvider.issues[index]
                                          ['id'])) {
                                    issuesProvider.subIssuesIds.remove(
                                        searchIssueProvider.issues[index]
                                            ['id']);
                                  } else {
                                    issuesProvider.subIssuesIds.add(
                                        searchIssueProvider.issues[index]
                                            ['id']);
                                  }
                                  issuesProvider.setsState();
                                } else {
                                  if (widget.type ==
                                      IssueDetailCategory.blocking) {
                                    if (issuesProvider.blockingIssuesIds
                                        .contains(searchIssueProvider
                                            .issues[index]['id'])) {
                                      issuesProvider.blockingIssuesIds.remove(
                                          searchIssueProvider.issues[index]
                                              ['id']);
                                    } else {
                                      issuesProvider.blockingIssuesIds.add(
                                          searchIssueProvider.issues[index]
                                              ['id']);
                                    }
                                  } else {
                                    if (issuesProvider.blockedByIssuesIds
                                        .contains(searchIssueProvider
                                            .issues[index]['id'])) {
                                      issuesProvider.blockedByIssuesIds.remove(
                                          searchIssueProvider.issues[index]
                                              ['id']);
                                    } else {
                                      issuesProvider.blockedByIssuesIds.add(
                                          searchIssueProvider.issues[index]
                                              ['id']);
                                    }
                                  }
                                  issuesProvider.setsState();
                                }
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    widget.type != IssueDetailCategory.parent
                                        ? checkBoxWidget(widget.type, index)
                                        : Container(),
                                    widget.type != IssueDetailCategory.parent
                                        ? const SizedBox(
                                            width: 5,
                                          )
                                        : Container(),
                                    CustomText(
                                      searchIssueProvider.issues[index]
                                              ['project__identifier'] +
                                          '-' +
                                          searchIssueProvider.issues[index]
                                                  ['sequence_id']
                                              .toString() +
                                          ' ',
                                      type: FontStyle.Medium,
                                      fontWeight: FontWeightt.Regular,
                                      color: themeProvider
                                          .themeManager.primaryTextColor,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      width: width * 0.6,
                                      child: CustomText(
                                        searchIssueProvider.issues[index]
                                                ['name'] ??
                                            '',
                                        type: FontStyle.Medium,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeightt.Regular,
                                        color: themeProvider
                                            .themeManager.primaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                    widget.type != IssueDetailCategory.parent
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Button(
                              ontap: () async {
                                if (widget.type ==
                                        IssueDetailCategory.addModuleIssue &&
                                    modulesProvider.selectedIssues.isNotEmpty) {
                                  log('MODULE ISSUES SELECTED ${modulesProvider.selectedIssues}');
                                  await modulesProvider
                                      .createModuleIssues(
                                          slug: ref
                                              .watch(ProviderList
                                                  .workspaceProvider)
                                              .selectedWorkspace!
                                              .workspaceSlug,
                                          projID: ref
                                              .watch(
                                                  ProviderList.projectProvider)
                                              .currentProject['id'],
                                          issues:
                                              modulesProvider.selectedIssues)
                                      .then((_) {
                                    ref
                                        .watch(ProviderList.modulesProvider)
                                        .filterModuleIssues(
                                          slug: ref
                                              .watch(ProviderList
                                                  .workspaceProvider)
                                              .selectedWorkspace!
                                              .workspaceSlug,
                                          projectId: ref
                                              .watch(
                                                  ProviderList.projectProvider)
                                              .currentProject['id'],
                                        );
                                    issuesProvider.filterIssues(
                                        slug: ref
                                            .watch(
                                                ProviderList.workspaceProvider)
                                            .selectedWorkspace!
                                            .workspaceSlug,
                                        projID: ref
                                            .watch(ProviderList.projectProvider)
                                            .currentProject['id']);
                                    modulesProvider.setState();
                                  });
                                }
                                if (widget.type ==
                                        IssueDetailCategory.addCycleIssue &&
                                    cyclesProvider.selectedIssues.isNotEmpty) {
                                  log('CYCLE ISSUES SELECTED ');
                                  await cyclesProvider
                                      .createCycleIssues(
                                          slug: ref
                                              .watch(ProviderList
                                                  .workspaceProvider)
                                              .selectedWorkspace!
                                              .workspaceSlug,
                                          projId: ref
                                              .watch(
                                                  ProviderList.projectProvider)
                                              .currentProject['id'],
                                          issues: cyclesProvider.selectedIssues)
                                      .then((_) {
                                    ref
                                        .read(ProviderList.cyclesProvider)
                                        .filterCycleIssues(
                                          slug: ref
                                              .read(ProviderList
                                                  .workspaceProvider)
                                              .selectedWorkspace!
                                              .workspaceSlug,
                                          projectId: ref
                                              .read(
                                                  ProviderList.projectProvider)
                                              .currentProject['id'],
                                        );
                                    issuesProvider.filterIssues(
                                        slug: ref
                                            .read(
                                                ProviderList.workspaceProvider)
                                            .selectedWorkspace!
                                            .workspaceSlug,
                                        projID: ref
                                            .read(ProviderList.projectProvider)
                                            .currentProject['id']);
                                  });
                                }
                                if (widget.type ==
                                    IssueDetailCategory.subIssue) {
                                  log('SUB ISSUES SELECTED ');
                                  issueProvider.addSubIssue(
                                      slug: ref
                                          .watch(ProviderList.workspaceProvider)
                                          .selectedWorkspace!
                                          .workspaceSlug,
                                      projectId: ref
                                          .watch(ProviderList.projectProvider)
                                          .currentProject['id'],
                                      issueId: widget.issueId,
                                      data: {
                                        'sub_issue_ids':
                                            issuesProvider.subIssuesIds
                                      });
                                } else if (widget.type ==
                                        IssueDetailCategory.blocking ||
                                    widget.type ==
                                        IssueDetailCategory.blocked) {
                                  if ((widget.type ==
                                              IssueDetailCategory.blocking &&
                                          issuesProvider
                                              .blockingIssuesIds.isEmpty) ||
                                      (widget.type ==
                                              IssueDetailCategory.blocked &&
                                          issuesProvider
                                              .blockedByIssuesIds.isEmpty)) {
                                    CustomToast().showToast(context,
                                        'No issues selected', themeProvider,
                                        toastType: ToastType.warning);

                                    return;
                                  }
                                  log('BLOCKING ISSUES SELECTED ');
                                  issueProvider.upDateIssue(
                                    slug: ref
                                        .watch(ProviderList.workspaceProvider)
                                        .selectedWorkspace!
                                        .workspaceSlug,
                                    projID: ref
                                        .watch(ProviderList.projectProvider)
                                        .currentProject['id'],
                                    issueID: widget.createIssue
                                        ? ''
                                        : widget.issueId,
                                    data: widget.type ==
                                            IssueDetailCategory.blocking
                                        ? {
                                            "blockers_list":
                                                issuesProvider.blockingIssuesIds
                                          }
                                        : {
                                            "blocks_list": issuesProvider
                                                .blockedByIssuesIds
                                          },
                                    refs: ref,
                                  );
                                }
                                Navigator.of(context).pop();
                              },
                              text: 'Add issues',
                            ),
                          )
                        : Container()
                  ],
                ),
    );
  }

  Widget checkBoxWidget(IssueDetailCategory type, int index) {
    var issuesProvider = ref.watch(ProviderList.issuesProvider);
    var searchIssueProvider = ref.watch(ProviderList.searchIssueProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var modulesProvider = ref.watch(ProviderList.modulesProvider);
    var cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    if (type == IssueDetailCategory.blocking) {
      return issuesProvider.blockingIssuesIds
              .contains(searchIssueProvider.issues[index]['id'])
          ? const Icon(
              Icons.check_box,
              color: primaryColor,
            )
          : Icon(Icons.check_box_outline_blank,
              color: themeProvider.themeManager.placeholderTextColor);
    }
    if (type == IssueDetailCategory.addModuleIssue) {
      return modulesProvider.selectedIssues
              .contains(searchIssueProvider.issues[index]['id'])
          ? const Icon(
              Icons.check_box,
              color: primaryColor,
            )
          : Icon(Icons.check_box_outline_blank,
              color: themeProvider.themeManager.placeholderTextColor);
    }
    if (type == IssueDetailCategory.addCycleIssue) {
      return cyclesProvider.selectedIssues
              .contains(searchIssueProvider.issues[index]['id'])
          ? const Icon(
              Icons.check_box,
              color: primaryColor,
            )
          : Icon(Icons.check_box_outline_blank,
              color: themeProvider.themeManager.placeholderTextColor);
    }
    if (type == IssueDetailCategory.subIssue) {
      return issuesProvider.subIssuesIds
              .contains(searchIssueProvider.issues[index]['id'])
          ? const Icon(
              Icons.check_box,
              color: primaryColor,
            )
          : Icon(Icons.check_box_outline_blank,
              color: themeProvider.themeManager.placeholderTextColor);
    } else {
      return issuesProvider.blockedByIssuesIds
              .contains(searchIssueProvider.issues[index]['id'])
          ? const Icon(
              Icons.check_box,
              color: primaryColor,
            )
          : Icon(Icons.check_box_outline_blank,
              color: themeProvider.themeManager.placeholderTextColor);
    }
  }
}
