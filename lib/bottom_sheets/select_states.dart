import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane_startup/screens/create_state.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_text.dart';

class SelectStates extends ConsumerStatefulWidget {
  final bool createIssue;
  final String? issueId;

  const SelectStates({required this.createIssue, this.issueId, super.key});

  @override
  ConsumerState<SelectStates> createState() => _SelectStatesState();
}

class _SelectStatesState extends ConsumerState<SelectStates> {
  var selectedState = '';
  @override
  void initState() {
    var prov = ref.read(ProviderList.issuesProvider);
    if (prov.states.isEmpty) {
      prov.getStates(
          slug: ref
              .read(ProviderList.workspaceProvider)
              .selectedWorkspace!
              .workspaceSlug,
          projID: ref.read(ProviderList.projectProvider).currentProject['id']);
    }

    // selectedState = widget.createIssue
    //     ? prov.createIssuedata['state'] != null
    //         ? prov.createIssuedata['state']['id']
    //         : ''
    //     : prov.states['state'] != null
    //         ? prov.states['state']['id']
    //         : '';
    // log(prov.createIssuedata['state'].toString());
    selectedState = prov.createIssuedata['state'] ?? prov.states.keys.first;
    super.initState();
  }

  String issueDetailSelectedState = '';
  @override
  Widget build(BuildContext context) {
    var issuesProvider = ref.watch(ProviderList.issuesProvider);
    var issueProvider = ref.watch(ProviderList.issueProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return WillPopScope(
      onWillPop: () async {
        var prov = ref.read(ProviderList.issuesProvider);
        //   if (selectedState.isNotEmpty) {
        prov.createIssuedata['state'] = selectedState;

        prov.setsState();
        log(prov.states.toString());
        //  }
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
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(
                        'Select State',
                        type: FontStyle.H6,
                        fontWeight: FontWeightt.Semibold,
                      ),
                      IconButton(
                          onPressed: () {
                            var prov = ref.read(ProviderList.issuesProvider);
                            //   if (selectedState.isNotEmpty) {
                            prov.createIssuedata['state'] = selectedState;
                            // print('state');
                            // print(prov.createIssuedata['state'].toString());

                            prov.setsState();
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close,
                            color: themeProvider.isDarkThemeEnabled
                                ? darkSecondaryTextColor
                                : lightSecondaryTextColor,
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  for (int j = 0; j < issuesProvider.stateOrdering.length; j++)
                    for (int i = 0; i < issuesProvider.states.length; i++)
                      issuesProvider.states.keys.elementAt(i) ==
                              issuesProvider.stateOrdering[j]
                          ? InkWell(
                              onTap: () async {
                                if (widget.createIssue) {
                                  setState(() {
                                    log(issuesProvider.states[issuesProvider
                                            .states.keys
                                            .elementAt(i)]
                                        .toString());
                                    selectedState = issuesProvider.states[
                                        issuesProvider.states.keys
                                            .elementAt(i)]['id'];
                                    issuesProvider.createIssuedata['state'] =
                                        selectedState;

                                    issuesProvider.setsState();
                                  });
                                  issuesProvider.setsState();
                                } else {
                                  setState(() {
                                    issueDetailSelectedState =
                                        issuesProvider.states[issuesProvider
                                            .states.keys
                                            .elementAt(i)]['name'];
                                  });
                                  await issueProvider.upDateIssue(
                                      slug: ref
                                          .read(ProviderList.workspaceProvider)
                                          .selectedWorkspace!
                                          .workspaceSlug,
                                      projID: ref
                                          .read(ProviderList.projectProvider)
                                          .currentProject['id'],
                                      issueID: widget.issueId!,
                                      refs: ref,
                                      data: {
                                        'state':
                                            '${issuesProvider.states[issuesProvider.states.keys.elementAt(i)]['id']}'
                                      });
                                  await issuesProvider.filterIssues(
                                    slug: ref
                                        .read(ProviderList.workspaceProvider)
                                        .selectedWorkspace!
                                        .workspaceSlug,
                                    projID: ref
                                        .read(ProviderList.projectProvider)
                                        .currentProject['id'],
                                  );
                                }
                                // ignore: use_build_context_synchronously
                                Navigator.of(context).pop();
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
                                            height: 25,
                                            width: 25,
                                            // decoration: BoxDecoration(
                                            //   color: Colors.grey,
                                            //   borderRadius: BorderRadius.circular(5),
                                            // ),
                                            child: issuesProvider.stateIcons[
                                                issuesProvider.states.keys
                                                    .elementAt(i)]),
                                        Container(
                                          width: 10,
                                        ),
                                        CustomText(
                                          issuesProvider.states[issuesProvider
                                              .states.keys
                                              .elementAt(i)]["name"],
                                          type: FontStyle.Small,
                                        ),
                                        const Spacer(),
                                        widget.createIssue
                                            ? createIssueStateSelectionWidget(i)
                                            : issueDetailStateSelectionWidget(
                                                i),
                                        const SizedBox(
                                          width: 10,
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Container(
                                      width: width,
                                      height: 1,
                                      color: strokeColor,
                                    )
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                  widget.createIssue
                      ? GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const CreateState()));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 5, top: 15),
                            child: Row(
                              children: [
                                const SizedBox(
                                    height: 25,
                                    width: 25,
                                    // decoration: BoxDecoration(
                                    //   color: Colors.grey,
                                    //   borderRadius: BorderRadius.circular(5),
                                    // ),
                                    child: Icon(Icons.add)),
                                Container(
                                  width: 10,
                                ),
                                const CustomText(
                                  'Create New State',
                                  type: FontStyle.Small,
                                )
                              ],
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
              issuesProvider.statesState == StateEnum.loading
                  ? Container(
                      alignment: Alignment.center,
                      color: Colors.white.withOpacity(0.7),
                      // height: 25,
                      // width: 25,
                      child: const Wrap(
                        children: [
                          SizedBox(
                            height: 25,
                            width: 25,
                            child: LoadingIndicator(
                              indicatorType: Indicator.lineSpinFadeLoader,
                              colors: [Colors.black],
                              strokeWidth: 1.0,
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget createIssueStateSelectionWidget(int i) {
    var issuesProvider = ref.watch(ProviderList.issuesProvider);
    return selectedState ==
            issuesProvider.states[issuesProvider.states.keys.elementAt(i)]['id']
        ? const Icon(
            Icons.done,
            color: Color.fromRGBO(8, 171, 34, 1),
          )
        : const SizedBox();
  }

  Widget issueDetailStateSelectionWidget(int i) {
    var issueProvider = ref.watch(ProviderList.issueProvider);
    var issuesProvider = ref.watch(ProviderList.issuesProvider);
    return issueProvider.issueDetails['state_detail']['id'] ==
            issuesProvider.states[issuesProvider.states.keys.elementAt(i)]['id']
        ? const Icon(
            Icons.done,
            color: Color.fromRGBO(8, 171, 34, 1),
          )
        : issueProvider.updateIssueState == StateEnum.loading &&
                issueDetailSelectedState ==
                    issuesProvider
                        .states[issuesProvider.states.keys.elementAt(i)]['name']
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
