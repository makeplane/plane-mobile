import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/member_logo_widget.dart';

import '../widgets/custom_button.dart';

class SelectProjectMembers extends ConsumerStatefulWidget {
  const SelectProjectMembers(
      {this.issueId, required this.createIssue, super.key});
  final bool createIssue;
  final String? issueId;

  @override
  ConsumerState<SelectProjectMembers> createState() =>
      _SelectProjectMembersState();
}

class _SelectProjectMembersState extends ConsumerState<SelectProjectMembers> {
  Map selectedMembers = {};
  List<String> issueDetailSelectedMembers = [];

  @override
  void initState() {
    if (ref.read(ProviderList.issuesProvider).members.isEmpty ||
        widget.createIssue) {
      ref.read(ProviderList.issuesProvider).getProjectMembers(
          slug: ref
              .read(ProviderList.workspaceProvider)
              .selectedWorkspace
              .workspaceSlug,
          projID: widget.createIssue
              ? ref
                  .read(ProviderList.issuesProvider)
                  .createIssueProjectData['id']
              : ref.read(ProviderList.projectProvider).currentProject['id']);
    }
    selectedMembers =
        ref.read(ProviderList.issuesProvider).createIssuedata['members'] ?? {};
    if (!widget.createIssue) getIssueMembers();
    super.initState();
  }

  void getIssueMembers() {
    final issueProvider = ref.read(ProviderList.issueProvider);
    for (int i = 0;
        i < issueProvider.issueDetails['assignee_details'].length;
        i++) {
      issueDetailSelectedMembers
          .add(issueProvider.issueDetails['assignee_details'][i]['id']);
    }
  }

  @override
  Widget build(BuildContext context) {
    final issuesProvider = ref.watch(ProviderList.issuesProvider);
    final issueProvider = ref.watch(ProviderList.issueProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    return WillPopScope(
      onWillPop: () async {
        issuesProvider.createIssuedata['members'] =
            selectedMembers.isEmpty ? null : selectedMembers;
        issuesProvider.setsState();
        return true;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: themeProvider.themeManager.primaryBackgroundDefaultColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText(
                  'Select Members',
                  type: FontStyle.H4,
                  fontWeight: FontWeightt.Semibold,
                ),
                IconButton(
                    onPressed: () {
                      issuesProvider.createIssuedata['members'] =
                          selectedMembers.isEmpty ? null : selectedMembers;
                      issuesProvider.setsState();
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.close,
                        color: themeProvider.themeManager.placeholderTextColor))
              ],
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: ListView(
                      children: [
                        ListView.builder(
                            itemCount: issuesProvider.members.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  if (widget.createIssue) {
                                    setState(() {
                                      if (selectedMembers[
                                              issuesProvider.members[index]
                                                  ['member']['id']] ==
                                          null) {
                                        selectedMembers[issuesProvider
                                            .members[index]['member']['id']] = {
                                          "avatar":
                                              issuesProvider.members[index]
                                                  ['member']['avatar'],
                                          "display_name":
                                              issuesProvider.members[index]
                                                  ['member']['display_name'],
                                          "id": issuesProvider.members[index]
                                              ['member']['id']
                                        };
                                      } else {
                                        selectedMembers.remove(issuesProvider
                                            .members[index]['member']['id']);
                                      }
                                    });
                                  } else {
                                    setState(() {
                                      if (issueDetailSelectedMembers.contains(
                                          issuesProvider.members[index]
                                              ['member']['id'])) {
                                        issueDetailSelectedMembers.remove(
                                            issuesProvider.members[index]
                                                ['member']['id']);
                                      } else {
                                        issueDetailSelectedMembers.add(
                                            issuesProvider.members[index]
                                                ['member']['id']);
                                      }
                                    });
                                  }
                                },
                                child: Container(
                                  //height: 40,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),

                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: MemberLogoWidget(
                                              padding: EdgeInsets.zero,
                                              imageUrl:
                                                  issuesProvider.members[index]
                                                      ['member']['avatar'],
                                              colorForErrorWidget:
                                                  const Color.fromRGBO(
                                                      55, 65, 81, 1),
                                              memberNameFirstLetterForErrorWidget:
                                                  issuesProvider.members[index]
                                                          ['member']
                                                          ['display_name'][0]
                                                      .toString()
                                                      .toUpperCase(),
                                            ),
                                          ),
                                          Container(
                                            width: 10,
                                          ),
                                          SizedBox(
                                            width: width * 0.7,
                                            child: CustomText(
                                              issuesProvider.members[index]
                                                  ['member']['display_name'],
                                              type: FontStyle.Medium,
                                              fontWeight: FontWeightt.Regular,
                                              color: themeProvider.themeManager
                                                  .primaryTextColor,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const Spacer(),
                                          widget.createIssue
                                              ? createIsseuSelectedMembersWidget(
                                                  index)
                                              : issueDetailSelectedMembersWidget(
                                                  index),
                                          const SizedBox(
                                            width: 10,
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Container(
                                          width: width,
                                          height: 1,
                                          color: themeProvider.themeManager
                                              .borderDisabledColor),
                                    ],
                                  ),
                                ),
                              );
                            }),
                        Container(height: 30),
                      ],
                    ),
                  ),
                  issuesProvider.membersState == StateEnum.loading
                      ? Container(
                          alignment: Alignment.center,
                          color: themeProvider
                              .themeManager.primaryBackgroundDefaultColor,
                          child: Wrap(
                            children: [
                              SizedBox(
                                height: 25,
                                width: 25,
                                child: LoadingIndicator(
                                  indicatorType: Indicator.lineSpinFadeLoader,
                                  colors: [
                                    themeProvider.themeManager.primaryTextColor
                                  ],
                                  strokeWidth: 1.0,
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      height: 50,
                      child: Button(
                        text: 'Select',
                        ontap: () {
                          if (!widget.createIssue) {
                            issueProvider.upDateIssue(
                                slug: ref
                                    .read(ProviderList.workspaceProvider)
                                    .selectedWorkspace
                                    .workspaceSlug,
                                projID: ref
                                    .read(ProviderList.projectProvider)
                                    .currentProject['id'],
                                issueID: widget.issueId!,
                                refs: ref,
                                data: {
                                  "assignees_list": issueDetailSelectedMembers
                                });
                            Navigator.of(context).pop();
                          } else {
                            issuesProvider.createIssuedata['members'] =
                                selectedMembers.isEmpty
                                    ? null
                                    : selectedMembers;
                            issuesProvider.setsState();
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createIsseuSelectedMembersWidget(int idx) {
    final issuesProvider = ref.watch(ProviderList.issuesProvider);
    return selectedMembers[issuesProvider.members[idx]['member']['id']] != null
        ? const Icon(
            Icons.done,
            color: Color.fromRGBO(8, 171, 34, 1),
          )
        : const SizedBox();
  }

  Widget issueDetailSelectedMembersWidget(int idx) {
    final issuesProvider = ref.read(ProviderList.issuesProvider);
    return issueDetailSelectedMembers
            .contains(issuesProvider.members[idx]['member']['id'])
        ? const Icon(
            Icons.done,
            color: Color.fromRGBO(8, 171, 34, 1),
          )
        : const SizedBox();
  }
}
