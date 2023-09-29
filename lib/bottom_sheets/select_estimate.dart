import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/widgets/custom_text.dart';

class SelectEstimate extends ConsumerStatefulWidget {
  const SelectEstimate({this.issueId, required this.createIssue, super.key});
  final bool createIssue;
  final String? issueId;

  @override
  ConsumerState<SelectEstimate> createState() => _SelectEstimateState();
}

class _SelectEstimateState extends ConsumerState<SelectEstimate> {
  int selectedEstimate = -1;
  String? issueDetailSelectedPriorityItem;

  @override
  void initState() {
    super.initState();
    final issuesProvider = ref.read(ProviderList.issuesProvider);
    final estimatesProvider = ref.read(ProviderList.estimatesProvider);
    final projectProvider = ref.read(ProviderList.projectProvider);
    if (widget.createIssue) {
      selectedEstimate = estimatesProvider.estimates.firstWhere((element) {
        return element['id'] ==
            projectProvider.projects.firstWhere((element) =>
                element['id'] ==
                issuesProvider.createIssueProjectData['id'])['estimate'];
      })['points'].indexWhere((element) {
        return element['key'] ==
            issuesProvider.createIssuedata['estimate_point'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final issueProvider = ref.watch(ProviderList.issueProvider);
    final issuesProvider = ref.watch(ProviderList.issuesProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final estimatesProvider = ref.watch(ProviderList.estimatesProvider);
    final projectProvider = ref.watch(ProviderList.projectProvider);
    return WillPopScope(
      onWillPop: () async {
        final prov = ref.read(ProviderList.issuesProvider);
        if (widget.createIssue) {
          if (selectedEstimate == -1) {
            prov.createIssuedata['estimate_point'] = null;
          } else {
            prov.createIssuedata['estimate_point'] =
                estimatesProvider.estimates.firstWhere((element) {
              return element['id'] ==
                  projectProvider.projects.firstWhere((element) =>
                      element['id'] ==
                      issuesProvider.createIssueProjectData['id'])['estimate'];
            })['points'][selectedEstimate]['key'];
          }
        }
        log(prov.createIssuedata.toString());
        prov.setsState();
        return true;
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: themeProvider.themeManager.secondaryBackgroundDefaultColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        width: double.infinity,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Wrap(
                children: [
                  Container(
                    height: 40,
                  ),
                  InkWell(
                    onTap: () {
                      if (widget.createIssue) {
                        setState(() {
                          selectedEstimate = -1;
                        });
                      } else {
                        setState(() {
                          issueDetailSelectedPriorityItem = 'No Estimate';
                        });
                        issueProvider.upDateIssue(
                            slug: ref
                                .read(ProviderList.workspaceProvider)
                                .selectedWorkspace
                                .workspaceSlug,
                            refs: ref,
                            projID: ref
                                .read(ProviderList.projectProvider)
                                .currentProject['id'],
                            issueID: widget.issueId!,
                            data: {
                              "estimate_point": null,
                            }).then((value) {
                          ref
                              .read(ProviderList.issueProvider)
                              .getIssueDetails(
                                  slug: ref
                                      .read(ProviderList.workspaceProvider)
                                      .selectedWorkspace
                                      .workspaceSlug,
                                  projID: ref
                                      .read(ProviderList.projectProvider)
                                      .currentProject['id'],
                                  issueID: widget.issueId!)
                              .then(
                                (value) => ref
                                    .read(ProviderList.issueProvider)
                                    .getIssueActivity(
                                      slug: ref
                                          .read(ProviderList.workspaceProvider)
                                          .selectedWorkspace
                                          .workspaceSlug,
                                      projID: ref
                                          .read(ProviderList.projectProvider)
                                          .currentProject['id'],
                                      issueID: widget.issueId!,
                                    ),
                              );
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
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  //   color: const Color.fromRGBO(55, 65, 81, 1),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.change_history,
                                  color: themeProvider
                                      .themeManager.placeholderTextColor,
                                ),
                              ),
                              Container(
                                width: 10,
                              ),
                              CustomText(
                                'No Estimate',
                                type: FontStyle.Medium,
                                fontWeight: FontWeightt.Regular,
                                color:
                                    themeProvider.themeManager.primaryTextColor,
                              ),
                              const Spacer(),
                              if ((widget.createIssue &&
                                      selectedEstimate == -1) ||
                                  (!widget.createIssue &&
                                      issueProvider
                                              .issueDetails['estimate_point'] ==
                                          null))
                                const Icon(
                                  Icons.check,
                                  color: greenHighLight,
                                ),
                              if (!widget.createIssue &&
                                  issueProvider.updateIssueState ==
                                      StateEnum.loading &&
                                  issueProvider
                                          .issueDetails['estimate_point'] !=
                                      null &&
                                  issueDetailSelectedPriorityItem ==
                                      'No Estimate')
                                const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: greyColor,
                                  ),
                                ),
                              const SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                              height: 1,
                              width: width,
                              color: themeProvider
                                  .themeManager.placeholderTextColor),
                        ],
                      ),
                    ),
                  ),
                  ListView.builder(
                      itemCount: 6,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            if (widget.createIssue) {
                              setState(() {
                                selectedEstimate = index;
                              });
                            } else {
                              setState(() {
                                issueDetailSelectedPriorityItem =
                                    estimatesProvider.estimates
                                        .firstWhere((element) {
                                  return element['id'] ==
                                      projectProvider
                                          .currentProject['estimate'];
                                })['points'][index]['key'].toString();
                              });
                              issueProvider.upDateIssue(
                                  slug: ref
                                      .read(ProviderList.workspaceProvider)
                                      .selectedWorkspace
                                      .workspaceSlug,
                                  refs: ref,
                                  projID: ref
                                      .read(ProviderList.projectProvider)
                                      .currentProject['id'],
                                  issueID: widget.issueId!,
                                  data: {
                                    "estimate_point": estimatesProvider
                                        .estimates
                                        .firstWhere((element) {
                                      return element['id'] ==
                                          projectProvider
                                              .currentProject['estimate'];
                                    })['points'][index]['key'],
                                  }).then((value) {
                                ref
                                    .read(ProviderList.issueProvider)
                                    .getIssueDetails(
                                        slug: ref
                                            .read(
                                                ProviderList.workspaceProvider)
                                            .selectedWorkspace
                                            .workspaceSlug,
                                        projID: ref
                                            .read(ProviderList.projectProvider)
                                            .currentProject['id'],
                                        issueID: widget.issueId!)
                                    .then(
                                      (value) => ref
                                          .read(ProviderList.issueProvider)
                                          .getIssueActivity(
                                            slug: ref
                                                .read(ProviderList
                                                    .workspaceProvider)
                                                .selectedWorkspace
                                                .workspaceSlug,
                                            projID: ref
                                                .read(ProviderList
                                                    .projectProvider)
                                                .currentProject['id'],
                                            issueID: widget.issueId!,
                                          ),
                                    );
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
                                    Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        //   color: const Color.fromRGBO(55, 65, 81, 1),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      alignment: Alignment.center,
                                      child: Icon(Icons.change_history,
                                          color: themeProvider.themeManager
                                              .placeholderTextColor),
                                    ),
                                    Container(
                                      width: 10,
                                    ),
                                    CustomText(
                                      widget.createIssue
                                          ? estimatesProvider.estimates
                                              .firstWhere((element) {
                                              return element['id'] ==
                                                  projectProvider.projects
                                                      .firstWhere((element) =>
                                                          element['id'] ==
                                                          issuesProvider
                                                                  .createIssueProjectData[
                                                              'id'])['estimate'];
                                            })['points'][index]
                                                  ['value'].toString()
                                          : estimatesProvider.estimates
                                              .firstWhere((element) =>
                                                  element['id'] ==
                                                  ref
                                                          .read(ProviderList
                                                              .projectProvider)
                                                          .currentProject[
                                                      'estimate'])['points']
                                                  [index]['value']
                                              .toString(),
                                      type: FontStyle.Medium,
                                      fontWeight: FontWeightt.Regular,
                                      color: themeProvider
                                          .themeManager.primaryTextColor,
                                    ),
                                    const Spacer(),
                                    widget.createIssue
                                        ? createIssueSelectedPriority(index)
                                        : issueDetailSelectedPriority(index),
                                    const SizedBox(
                                      width: 10,
                                    )
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Container(
                                    height: 1,
                                    width: width,
                                    color: themeProvider
                                        .themeManager.placeholderTextColor),
                              ],
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
            Container(
              height: 50,
              color: themeProvider.themeManager.secondaryBackgroundDefaultColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    'Select Estimate',
                    type: FontStyle.H4,
                    fontWeight: FontWeightt.Semibold,
                  ),
                  IconButton(
                      onPressed: () {
                        final prov = ref.read(ProviderList.issuesProvider);
                        if (widget.createIssue) {
                          if (selectedEstimate == -1) {
                            prov.createIssuedata['estimate_point'] = null;
                          } else {
                            prov.createIssuedata['estimate_point'] =
                                estimatesProvider.estimates
                                    .firstWhere((element) {
                              return element['id'] ==
                                  projectProvider.projects.firstWhere(
                                      (element) =>
                                          element['id'] ==
                                          issuesProvider.createIssueProjectData[
                                              'id'])['estimate'];
                            })['points'][selectedEstimate]['key'];
                          }
                        }
                        log(prov.createIssuedata.toString());
                        prov.setsState();
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close,
                          color:
                              themeProvider.themeManager.placeholderTextColor))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createIssueSelectedPriority(int idx) {
    final estimatesProvider = ref.watch(ProviderList.estimatesProvider);
    final projectProvider = ref.watch(ProviderList.projectProvider);
    final issuesProvider = ref.watch(ProviderList.issuesProvider);
    if (selectedEstimate == -1) return const SizedBox();
    return estimatesProvider.estimates.firstWhere((element) {
              return element['id'] ==
                  projectProvider.projects.firstWhere((element) =>
                      element['id'] ==
                      issuesProvider.createIssueProjectData['id'])['estimate'];
            })['points'][idx]['key'] ==
            estimatesProvider.estimates.firstWhere((element) {
              return element['id'] ==
                  projectProvider.projects.firstWhere((element) =>
                      element['id'] ==
                      issuesProvider.createIssueProjectData['id'])['estimate'];
            })['points'][selectedEstimate]['key']
        ? const Icon(
            Icons.done,
            color: Color.fromRGBO(8, 171, 34, 1),
          )
        : const SizedBox();
  }

  Widget issueDetailSelectedPriority(int idx) {
    final issueProvider = ref.watch(ProviderList.issueProvider);
    final estimatesProvider = ref.watch(ProviderList.estimatesProvider);
    final projectProvider = ref.watch(ProviderList.projectProvider);
    // log(issueProvider.issueDetails['estimate_point'].toString());
    return issueProvider.issueDetails['estimate_point'] ==
            estimatesProvider.estimates.firstWhere((element) {
              return element['id'] ==
                  projectProvider.currentProject['estimate'];
            })['points'][idx]['key']
        ? const Icon(
            Icons.done,
            color: Color.fromRGBO(8, 171, 34, 1),
          )
        : issueProvider.updateIssueState == StateEnum.loading &&
                issueDetailSelectedPriorityItem ==
                    estimatesProvider.estimates.firstWhere((element) {
                      return element['id'] ==
                          projectProvider.currentProject['estimate'];
                    })['points'][idx]['key'].toString()
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: greyColor,
                ),
              )
            : const SizedBox();
  }
}
