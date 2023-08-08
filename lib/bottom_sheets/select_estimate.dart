import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/widgets/custom_text.dart';

class SelectEstimate extends ConsumerStatefulWidget {
  final bool createIssue;
  final String? issueId;

  const SelectEstimate({this.issueId, required this.createIssue, super.key});

  @override
  ConsumerState<SelectEstimate> createState() => _SelectEstimateState();
}

class _SelectEstimateState extends ConsumerState<SelectEstimate> {
  int selectedEstimate = -1;
  String? issueDetailSelectedPriorityItem;

  @override
  void initState() {
    super.initState();
    var issuesProvider = ref.read(ProviderList.issuesProvider);
    var estimatesProvider = ref.read(ProviderList.estimatesProvider);
    var projectProvider = ref.read(ProviderList.projectProvider);
    if (widget.createIssue) {
      selectedEstimate = estimatesProvider.estimates.firstWhere((element) {
        return element['id'] == projectProvider.currentProject['estimate'];
      })['points'].indexWhere((element) {
        return element['key'] ==
            issuesProvider.createIssuedata['estimate_point'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var issueProvider = ref.watch(ProviderList.issueProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var estimatesProvider = ref.watch(ProviderList.estimatesProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    return WillPopScope(
      onWillPop: () async {
        var prov = ref.read(ProviderList.issuesProvider);
        if (widget.createIssue) {
          if (selectedEstimate == -1) {
            prov.createIssuedata['estimate_point'] = null;
          } else {
            prov.createIssuedata['estimate_point'] =
                estimatesProvider.estimates.firstWhere((element) {
              return element['id'] ==
                  projectProvider.currentProject['estimate'];
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
          color: themeProvider.isDarkThemeEnabled
              ? darkBackgroundColor
              : lightBackgroundColor,
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
                                .selectedWorkspace!
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
                                      .selectedWorkspace!
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
                                          .selectedWorkspace!
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
                                  color: themeProvider.isDarkThemeEnabled
                                      ? darkPrimaryTextColor
                                      : lightPrimaryTextColor,
                                ),
                              ),
                              Container(
                                width: 10,
                              ),
                              const CustomText(
                                'No Estimate',
                                type: FontStyle.Small,
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
                            color: strokeColor,
                          ),
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
                                      .selectedWorkspace!
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
                                            .selectedWorkspace!
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
                                                .selectedWorkspace!
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
                                      child: Icon(
                                        Icons.change_history,
                                        color: themeProvider.isDarkThemeEnabled
                                            ? darkPrimaryTextColor
                                            : lightPrimaryTextColor,
                                      ),
                                    ),
                                    Container(
                                      width: 10,
                                    ),
                                    CustomText(
                                      estimatesProvider.estimates
                                          .firstWhere((element) =>
                                              element['id'] ==
                                              ref
                                                  .read(ProviderList
                                                      .projectProvider)
                                                  .currentProject['estimate'])[
                                              'points'][index]['value']
                                          .toString(),
                                      type: FontStyle.Small,
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
                                  color: strokeColor,
                                ),
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
              color: themeProvider.isDarkThemeEnabled
                  ? darkBackgroundColor
                  : lightBackgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    'Select Estimate',
                    type: FontStyle.H6,
                    fontWeight: FontWeightt.Semibold,
                  ),
                  IconButton(
                      onPressed: () {
                        var prov = ref.read(ProviderList.issuesProvider);
                        if (widget.createIssue) {
                          if (selectedEstimate == -1) {
                            prov.createIssuedata['estimate_point'] = null;
                          } else {
                            prov.createIssuedata['estimate_point'] =
                                estimatesProvider.estimates
                                    .firstWhere((element) {
                              return element['id'] ==
                                  projectProvider.currentProject['estimate'];
                            })['points'][selectedEstimate]['key'];
                          }
                        }

                        prov.setsState();
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: themeProvider.isDarkThemeEnabled
                            ? darkPrimaryTextColor
                            : lightPrimaryTextColor,
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createIssueSelectedPriority(int idx) {
    var estimatesProvider = ref.watch(ProviderList.estimatesProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    if (selectedEstimate == -1) return const SizedBox();
    return estimatesProvider.estimates.firstWhere((element) {
              return element['id'] ==
                  projectProvider.currentProject['estimate'];
            })['points'][idx]['key'] ==
            estimatesProvider.estimates.firstWhere((element) {
              return element['id'] ==
                  projectProvider.currentProject['estimate'];
            })['points'][selectedEstimate]['key']
        ? const Icon(
            Icons.done,
            color: Color.fromRGBO(8, 171, 34, 1),
          )
        : const SizedBox();
  }

  Widget issueDetailSelectedPriority(int idx) {
    var issueProvider = ref.watch(ProviderList.issueProvider);
    var estimatesProvider = ref.watch(ProviderList.estimatesProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
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
