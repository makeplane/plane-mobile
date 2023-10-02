import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/utils/extensions/string_extensions.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/square_avatar_widget.dart';

import 'IssuesTab/issue_detail.dart';

class SpreadSheetView extends ConsumerStatefulWidget {
  const SpreadSheetView({super.key, required this.issueCategory});
  final IssueCategory issueCategory;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SpreadSheetViewState();
}

class _SpreadSheetViewState extends ConsumerState<SpreadSheetView> {
  ScrollController scrollController1 = ScrollController();
  ScrollController scrollController2 = ScrollController();
  ScrollController scrollController3 = ScrollController();
  ScrollController scrollController4 = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController1.addListener(() {
      scrollController2.jumpTo(scrollController1.offset);
    });

    scrollController3.addListener(() {
      scrollController4.jumpTo(scrollController3.offset);
    });
    log(ref.read(ProviderList.issuesProvider).issuesList.toString());
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    double width = 481;
    Widget headingText(String text, double width) {
      return Container(
        // margin: const EdgeInsets.symmetric(horizontal: 10),
        // right border
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: themeProvider.themeManager.secondaryBackgroundDefaultColor,
          border: Border(
            right: BorderSide(
              color: themeProvider.themeManager.borderSubtle01Color,
              width: 1,
            ),
          ),
        ),
        width: width,
        child: Center(
          child: CustomText(
            text,
            type: FontStyle.Small,
            color: themeProvider.themeManager.tertiaryTextColor,
            fontWeight: FontWeightt.Medium,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      );
    }

    final issuesProvider = ref.watch(ProviderList.issuesProvider);
    final cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    final modulesProvider = ref.watch(ProviderList.modulesProvider);

    widget.issueCategory == IssueCategory.issues
        ? issuesProvider.issues.displayProperties.state
            ? width += 201
            : width += 0
        : widget.issueCategory == IssueCategory.cycleIssues
            ? cyclesProvider.issueProperty['properties']['state']
                ? width += 201
                : width += 0
            : modulesProvider.issueProperty['properties']['state']
                ? width += 201
                : width += 0;

    //for assignee
    widget.issueCategory == IssueCategory.issues
        ? issuesProvider.issues.displayProperties.assignee
            ? width += 151
            : width += 0
        : widget.issueCategory == IssueCategory.cycleIssues
            ? cyclesProvider.issueProperty['properties']['assignee']
                ? width += 151
                : width += 0
            : modulesProvider.issueProperty['properties']['assignee']
                ? width += 151
                : width += 0;

    //for label
    widget.issueCategory == IssueCategory.issues
        ? issuesProvider.issues.displayProperties.label
            ? width += 151
            : width += 0
        : widget.issueCategory == IssueCategory.cycleIssues
            ? cyclesProvider.issueProperty['properties']['labels']
                ? width += 151
                : width += 0
            : modulesProvider.issueProperty['properties']['labels']
                ? width += 151
                : width += 0;

    //for start date
    widget.issueCategory == IssueCategory.issues
        ? issuesProvider.issues.displayProperties.startDate
            ? width += 151
            : width += 0
        : widget.issueCategory == IssueCategory.cycleIssues
            ? cyclesProvider.issueProperty['properties']['start_date']
                ? width += 151
                : width += 0
            : modulesProvider.issueProperty['properties']['start_date']
                ? width += 151
                : width += 0;

    //for due date
    widget.issueCategory == IssueCategory.issues
        ? issuesProvider.issues.displayProperties.dueDate
            ? width += 151
            : width += 0
        : widget.issueCategory == IssueCategory.cycleIssues
            ? cyclesProvider.issueProperty['properties']['due_date']
                ? width += 151
                : width += 0
            : modulesProvider.issueProperty['properties']['due_date']
                ? width += 151
                : width += 0;

    //for estimate
    widget.issueCategory == IssueCategory.issues
        ? issuesProvider.issues.displayProperties.estimate
            ? width += 151
            : width += 0
        : widget.issueCategory == IssueCategory.cycleIssues
            ? cyclesProvider.issueProperty['properties']['estimate']
                ? width += 151
                : width += 0
            : modulesProvider.issueProperty['properties']['estimate']
                ? width += 151
                : width += 0;

    //for updated on
    widget.issueCategory == IssueCategory.issues
        ? issuesProvider.issues.displayProperties.updatedOn
            ? width += 151
            : width += 0
        : widget.issueCategory == IssueCategory.cycleIssues
            ? cyclesProvider.issueProperty['properties']['updated_on']
                ? width += 151
                : width += 0
            : modulesProvider.issueProperty['properties']['updated_on']
                ? width += 151
                : width += 0;

    //for created on
    widget.issueCategory == IssueCategory.issues
        ? issuesProvider.issues.displayProperties.createdOn
            ? width += 151
            : width += 0
        : widget.issueCategory == IssueCategory.cycleIssues
            ? cyclesProvider.issueProperty['properties']['created_on']
                ? width += 151
                : width += 0
            : modulesProvider.issueProperty['properties']['created_on']
                ? width += 151
                : width += 0;

    Widget priorityWidget(int index) {
      return Row(
        children: [
          Container(
              // alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color: themeProvider.themeManager.borderSubtle01Color)),
              // margin: const EdgeInsets.only(right: 5),
              height: 30,
              width: 30,
              child: issuesProvider.issuesList[index]['priority'] == null
                  ? Icon(
                      Icons.do_disturb_alt_outlined,
                      size: 18,
                      color: themeProvider.themeManager.tertiaryTextColor,
                    )
                  : issuesProvider.issuesList[index]['priority'] == 'high'
                      ? const Icon(
                          Icons.signal_cellular_alt,
                          color: Colors.orange,
                          size: 18,
                        )
                      : issuesProvider.issuesList[index]['priority'] == 'medium'
                          ? const Icon(
                              Icons.signal_cellular_alt_2_bar,
                              color: Colors.orange,
                              size: 18,
                            )
                          : const Icon(
                              Icons.signal_cellular_alt_1_bar,
                              color: Colors.orange,
                              size: 18,
                            )),
        ],
      );
    }

    Widget titleWidget(int index) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => IssueDetail(
                ref: ref.read(ProviderList.workspaceProvider).ref!,
                from: PreviousScreen.projectDetail,
                issueId: issuesProvider.issuesList[index]['id'],
                appBarTitle:
                    '${issuesProvider.issuesList[index]['project_detail']['identifier']} - ${issuesProvider.issuesList[index]['sequence_id']}',
              ),
            ),
          );
        },
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: 400,
              //bottom border
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: themeProvider.themeManager.borderSubtle01Color,
                    width: 1,
                  ),
                ),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    widget.issueCategory == IssueCategory.issues
                        ? issuesProvider.issues.displayProperties.priority
                            ? priorityWidget(index)
                            : const SizedBox()
                        : widget.issueCategory == IssueCategory.cycleIssues
                            ? cyclesProvider.issueProperty['properties']
                                    ['priority']
                                ? priorityWidget(index)
                                : const SizedBox()
                            : modulesProvider.issueProperty['properties']
                                    ['priority']
                                ? priorityWidget(index)
                                : const SizedBox(),
                    widget.issueCategory == IssueCategory.issues
                        ? issuesProvider.issues.displayProperties.priority
                            ? const SizedBox(width: 10)
                            : const SizedBox()
                        : widget.issueCategory == IssueCategory.cycleIssues
                            ? cyclesProvider.issueProperty['properties']
                                    ['priority']
                                ? const SizedBox(width: 10)
                                : const SizedBox()
                            : modulesProvider.issueProperty['properties']
                                    ['priority']
                                ? const SizedBox(width: 10)
                                : const SizedBox(),
                    SizedBox(
                      width: 320,
                      child: CustomText(
                        issuesProvider.issuesList[index]['name'],
                        type: FontStyle.Small,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              // margin: const EdgeInsets.symmetric(horizontal: 10),
              width: 1,
              color: themeProvider.themeManager.borderSubtle01Color,
            ),
          ],
        ),
      );
    }

    Widget stateWidget(int index, String stateName) {
      return Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: themeProvider.themeManager.borderSubtle01Color,
                  width: 1,
                ),
              ),
            ),
            width: 200,
            child: Row(
              children: [
                issuesProvider
                    .stateIcons[issuesProvider.issuesList[index]['state']],
                const SizedBox(
                  width: 5,
                ),
                SizedBox(
                  // width: 50,
                  child: CustomText(
                    stateName,
                    type: FontStyle.Small,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          Container(
            // margin: const EdgeInsets.symmetric(horizontal: 10),
            width: 1,
            color: themeProvider.themeManager.borderSubtle01Color,
          )
        ],
      );
    }

    Widget assigneesWidget(int index) {
      return Row(
        children: [
          Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: themeProvider.themeManager.borderSubtle01Color,
                    width: 1,
                  ),
                ),
              ),
              width: 150,
              child: (issuesProvider.issuesList[index]['assignee_details'] !=
                          null &&
                      issuesProvider
                          .issuesList[index]['assignee_details'].isNotEmpty)
                  ? Container(
                      alignment: Alignment.centerLeft,
                      height: 30,
                      child: SquareAvatarWidget(
                        details: issuesProvider.issuesList[index]
                            ['assignee_details'],
                      ),
                    )
                  : Container(
                      height: 30,
                      margin: const EdgeInsets.only(right: 5),
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                themeProvider.themeManager.borderSubtle01Color,
                          ),
                          borderRadius: BorderRadius.circular(5)),
                      child: Icon(
                        Icons.groups_2_outlined,
                        size: 18,
                        color: themeProvider.themeManager.tertiaryTextColor,
                      ),
                    )),
          Container(
            // margin: const EdgeInsets.symmetric(horizontal: 10),
            width: 1,
            color: themeProvider.themeManager.borderSubtle01Color,
          )
        ],
      );
    }

    Widget labelsWidget(int index) {
      return Row(
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: themeProvider.themeManager.borderSubtle01Color,
                  width: 1,
                ),
              ),
            ),
            width: 150,
            height: 60,
            child: (issuesProvider.issues.displayProperties.label == true &&
                    issuesProvider.issuesList[index]['label_details'] != null &&
                    issuesProvider
                        .issuesList[index]['label_details'].isNotEmpty)
                ? SizedBox(
                    height: 30,
                    child: issuesProvider
                                .issuesList[index]['label_details'].length >
                            1
                        ? Container(
                            height: 30,
                            // color: Colors.grey,
                            width: 90,
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: themeProvider
                                        .themeManager.borderSubtle01Color),
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 5,
                                  backgroundColor: Color(int.parse(
                                      issuesProvider.issuesList[index]
                                              ['label_details'][0]['color']
                                          .replaceAll('#', '0xFF'))),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                CustomText(
                                  '${issuesProvider.issuesList[index]['label_details'].length} Labels',
                                  type: FontStyle.Small,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: issuesProvider
                                .issuesList[index]['label_details'].length,
                            itemBuilder: (context, idx) {
                              return Container(
                                height: 20,
                                padding: const EdgeInsets.only(
                                  left: 8,
                                  right: 8,
                                ),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: themeProvider
                                            .themeManager.borderSubtle01Color),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                        radius: 5,
                                        backgroundColor: issuesProvider
                                            .issuesList[index]['label_details']
                                                [idx]['color']
                                            .toString()
                                            .toColor()),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    CustomText(
                                      issuesProvider.issuesList[index]
                                          ['label_details'][idx]['name'],
                                      type: FontStyle.Small,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  )
                : (issuesProvider.issues.displayProperties.label == true &&
                        issuesProvider
                            .issuesList[index]['label_details'].isEmpty)
                    ? Container(
                        alignment: Alignment.center,
                        height: 30,
                        padding:
                            const EdgeInsets.only(left: 8, right: 8, bottom: 2),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: themeProvider
                                    .themeManager.borderSubtle01Color),
                            borderRadius: BorderRadius.circular(5)),
                        child: const CustomText(
                          'No Label',
                          type: FontStyle.XSmall,
                        ),
                      )
                    : Container(),
          ),
          Container(
            // margin: const EdgeInsets.symmetric(horizontal: 10),
            width: 1,
            color: themeProvider.themeManager.borderSubtle01Color,
          )
        ],
      );
    }

    Widget dueDateWidget(int index) {
      return Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: themeProvider.themeManager.borderSubtle01Color,
                  width: 1,
                ),
              ),
            ),
            width: 150,
            child: CustomText(
              issuesProvider.issuesList[index]['target_date'] != null
                  ? DateFormat('dd MMM yyyy').format(
                      DateTime.parse(
                        issuesProvider.issuesList[index]['target_date'],
                      ),
                    )
                  : 'No Due Date',
              type: FontStyle.Small,
            ),
          ),
          Container(
            // margin: const EdgeInsets.symmetric(horizontal: 10),
            width: 1,
            color: themeProvider.themeManager.borderSubtle01Color,
          )
        ],
      );
    }

    Widget startDateWidget(int index) {
      return Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: themeProvider.themeManager.borderSubtle01Color,
                  width: 1,
                ),
              ),
            ),
            width: 150,
            child: CustomText(
              issuesProvider.issuesList[index]['start_date'] != null
                  ? DateFormat('dd MMM yyyy').format(
                      DateTime.parse(
                        issuesProvider.issuesList[index]['start_date'],
                      ),
                    )
                  : 'No Start Date',
              type: FontStyle.Small,
            ),
          ),
          Container(
            // margin: const EdgeInsets.symmetric(horizontal: 10),
            width: 1,
            color: themeProvider.themeManager.borderSubtle01Color,
          )
        ],
      );
    }

    Widget estimatesWidget(int index) {
      return Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: themeProvider.themeManager.borderSubtle01Color,
                  width: 1,
                ),
              ),
            ),
            width: 150,
            child: Wrap(
              children: [
                Icon(
                  Icons.change_history,
                  size: 16,
                  color: themeProvider.themeManager.tertiaryTextColor,
                ),
                const SizedBox(
                  width: 5,
                ),
                CustomText(
                  issuesProvider.issuesList[index]['estimate_point'] != '' &&
                          issuesProvider.issuesList[index]['estimate_point'] !=
                              null
                      ? ref
                          .read(ProviderList.estimatesProvider)
                          .estimates
                          .firstWhere((element) {
                          return element['id'] ==
                              ref
                                  .read(ProviderList.projectProvider)
                                  .currentProject['estimate'];
                        })['points'].firstWhere((element) {
                          return element['key'] ==
                              issuesProvider.issuesList[index]
                                  ['estimate_point'];
                        })['value']
                      : 'Estimate',
                  type: FontStyle.Small,
                ),
              ],
            ),
          ),
          Container(
            // margin: const EdgeInsets.symmetric(horizontal: 10),
            width: 1,
            color: themeProvider.themeManager.borderSubtle01Color,
          )
        ],
      );
    }

    Widget updatedOnWidget(int index) {
      return Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: themeProvider.themeManager.borderSubtle01Color,
                  width: 1,
                ),
              ),
            ),
            width: 150,
            child: CustomText(
              DateFormat('dd MMM yyyy').format(
                DateTime.parse(
                  issuesProvider.issuesList[index]['created_at'],
                ),
              ),
              type: FontStyle.Small,
            ),
          ),
          Container(
            // margin: const EdgeInsets.symmetric(horizontal: 10),
            width: 1,
            color: themeProvider.themeManager.borderSubtle01Color,
          )
        ],
      );
    }

    Widget createdOnWidget(int index) {
      return Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: themeProvider.themeManager.borderSubtle01Color,
                  width: 1,
                ),
              ),
            ),
            width: 150,
            child: CustomText(
              //date month year
              DateFormat('dd MMM yyyy').format(
                DateTime.parse(
                  issuesProvider.issuesList[index]['created_at'],
                ),
              ),
              type: FontStyle.Small,
            ),
          ),
          Container(
            // margin: const EdgeInsets.symmetric(horizontal: 10),
            width: 1,
            color: themeProvider.themeManager.borderSubtle01Color,
          )
        ],
      );
    }

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 50),
          child: SingleChildScrollView(
            controller: scrollController1,
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              // height: 450,
              width: width,
              child: ListView.builder(
                controller: scrollController3,
                // primary: false,
                itemCount: issuesProvider.issuesList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  String stateName = '';
                  for (final keys in issuesProvider.statesData.keys) {
                    for (final state in issuesProvider.statesData[keys]) {
                      if (state['id'] ==
                          issuesProvider.issuesList[index]['state']) {
                        stateName = state['name'];
                        break;
                      }
                    }
                  }
                  return SizedBox(
                    height: 60,
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      primary: false,
                      children: [
                        Container(
                          width: 100,
                        ),

                        titleWidget(index),

                        widget.issueCategory == IssueCategory.issues
                            ? issuesProvider.issues.displayProperties.state
                                ? stateWidget(index, stateName)
                                : Container()
                            : widget.issueCategory == IssueCategory.cycleIssues
                                ? cyclesProvider.issueProperty['properties']
                                        ['state']
                                    ? stateWidget(index, stateName)
                                    : Container()
                                : modulesProvider.issueProperty['properties']
                                        ['state']
                                    ? stateWidget(index, stateName)
                                    : Container(),

                        //for assignees
                        widget.issueCategory == IssueCategory.issues
                            ? issuesProvider.issues.displayProperties.assignee
                                ? assigneesWidget(index)
                                : Container()
                            : widget.issueCategory == IssueCategory.cycleIssues
                                ? cyclesProvider.issueProperty['properties']
                                        ['assignee']
                                    ? assigneesWidget(index)
                                    : Container()
                                : modulesProvider.issueProperty['properties']
                                        ['assignee']
                                    ? assigneesWidget(index)
                                    : Container(),

                        //for labels
                        widget.issueCategory == IssueCategory.issues
                            ? issuesProvider.issues.displayProperties.label
                                ? labelsWidget(index)
                                : Container()
                            : widget.issueCategory == IssueCategory.cycleIssues
                                ? cyclesProvider.issueProperty['properties']
                                        ['labels']
                                    ? labelsWidget(index)
                                    : Container()
                                : modulesProvider.issueProperty['properties']
                                        ['labels']
                                    ? labelsWidget(index)
                                    : Container(),

                        //for start date
                        widget.issueCategory == IssueCategory.issues
                            ? issuesProvider.issues.displayProperties.startDate
                                ? startDateWidget(index)
                                : Container()
                            : widget.issueCategory == IssueCategory.cycleIssues
                                ? cyclesProvider.issueProperty['properties']
                                        ['start_date']
                                    ? startDateWidget(index)
                                    : Container()
                                : modulesProvider.issueProperty['properties']
                                        ['start_date']
                                    ? startDateWidget(index)
                                    : Container(),

                        //for due date
                        widget.issueCategory == IssueCategory.issues
                            ? issuesProvider.issues.displayProperties.dueDate
                                ? dueDateWidget(index)
                                : Container()
                            : widget.issueCategory == IssueCategory.cycleIssues
                                ? cyclesProvider.issueProperty['properties']
                                        ['due_date']
                                    ? dueDateWidget(index)
                                    : Container()
                                : modulesProvider.issueProperty['properties']
                                        ['due_date']
                                    ? dueDateWidget(index)
                                    : Container(),

                        //for estimate
                        ref
                                    .read(ProviderList.projectProvider)
                                    .currentProject['estimate'] ==
                                null
                            ? Container()
                            : widget.issueCategory == IssueCategory.issues
                                ? issuesProvider
                                        .issues.displayProperties.estimate
                                    ? estimatesWidget(index)
                                    : Container()
                                : widget.issueCategory ==
                                        IssueCategory.cycleIssues
                                    ? cyclesProvider.issueProperty['properties']
                                            ['estimate']
                                        ? estimatesWidget(index)
                                        : Container()
                                    : modulesProvider
                                                .issueProperty['properties']
                                            ['estimate']
                                        ? estimatesWidget(index)
                                        : Container(),

                        //for updated on
                        widget.issueCategory == IssueCategory.issues
                            ? issuesProvider.issues.displayProperties.updatedOn
                                ? updatedOnWidget(index)
                                : Container()
                            : widget.issueCategory == IssueCategory.cycleIssues
                                ? cyclesProvider.issueProperty['properties']
                                        ['updated_on']
                                    ? updatedOnWidget(index)
                                    : Container()
                                : modulesProvider.issueProperty['properties']
                                        ['updated_on']
                                    ? updatedOnWidget(index)
                                    : Container(),

                        //for created on
                        widget.issueCategory == IssueCategory.issues
                            ? issuesProvider.issues.displayProperties.createdOn
                                ? createdOnWidget(index)
                                : Container()
                            : widget.issueCategory == IssueCategory.cycleIssues
                                ? cyclesProvider.issueProperty['properties']
                                        ['created_on']
                                    ? createdOnWidget(index)
                                    : Container()
                                : modulesProvider.issueProperty['properties']
                                        ['created_on']
                                    ? createdOnWidget(index)
                                    : Container(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        Container(
          height: 50,

          //bottom border
          decoration: BoxDecoration(
            color: themeProvider.themeManager.borderSubtle01Color,
            border: Border(
              bottom: BorderSide(
                color: themeProvider.themeManager.borderSubtle01Color,
                width: 1,
              ),
            ),
          ),
          child: ListView(
            controller: scrollController2,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: [
              headingText('Key', 100),
              headingText('Title', 401),
              widget.issueCategory == IssueCategory.issues
                  ? issuesProvider.issues.displayProperties.state
                      ? headingText('State', 201)
                      : Container()
                  : widget.issueCategory == IssueCategory.cycleIssues
                      ? cyclesProvider.issueProperty['properties']['state']
                          ? headingText('State', 201)
                          : Container()
                      : modulesProvider.issueProperty['properties']['state']
                          ? headingText('State', 201)
                          : Container(),

              widget.issueCategory == IssueCategory.issues
                  ? issuesProvider.issues.displayProperties.assignee
                      ? headingText('Assignees', 151)
                      : Container()
                  : widget.issueCategory == IssueCategory.cycleIssues
                      ? cyclesProvider.issueProperty['properties']['assignee']
                          ? headingText('Assignees', 151)
                          : Container()
                      : modulesProvider.issueProperty['properties']['assignee']
                          ? headingText('Assignees', 151)
                          : Container(),

              //for labels
              widget.issueCategory == IssueCategory.issues
                  ? issuesProvider.issues.displayProperties.label
                      ? headingText('Labels', 151)
                      : Container()
                  : widget.issueCategory == IssueCategory.cycleIssues
                      ? cyclesProvider.issueProperty['properties']['labels']
                          ? headingText('Labels', 151)
                          : Container()
                      : modulesProvider.issueProperty['properties']['labels']
                          ? headingText('Labels', 151)
                          : Container(),

              //for start date
              widget.issueCategory == IssueCategory.issues
                  ? issuesProvider.issues.displayProperties.startDate
                      ? headingText('Start Date', 151)
                      : Container()
                  : widget.issueCategory == IssueCategory.cycleIssues
                      ? cyclesProvider.issueProperty['properties']['start_date']
                          ? headingText('Start Date', 151)
                          : Container()
                      : modulesProvider.issueProperty['properties']
                              ['start_date']
                          ? headingText('Start Date', 151)
                          : Container(),

              //for due date
              widget.issueCategory == IssueCategory.issues
                  ? issuesProvider.issues.displayProperties.dueDate
                      ? headingText('Due Date', 151)
                      : Container()
                  : widget.issueCategory == IssueCategory.cycleIssues
                      ? cyclesProvider.issueProperty['properties']['due_date']
                          ? headingText('Due Date', 151)
                          : Container()
                      : modulesProvider.issueProperty['properties']['due_date']
                          ? headingText('Due Date', 151)
                          : Container(),

              //for estimate
              ref
                          .read(ProviderList.projectProvider)
                          .currentProject['estimate'] ==
                      null
                  ? Container()
                  : widget.issueCategory == IssueCategory.issues
                      ? issuesProvider.issues.displayProperties.estimate
                          ? headingText('Estimate', 151)
                          : Container()
                      : widget.issueCategory == IssueCategory.cycleIssues
                          ? cyclesProvider.issueProperty['properties']
                                  ['estimate']
                              ? headingText('Estimate', 151)
                              : Container()
                          : modulesProvider.issueProperty['properties']
                                  ['estimate']
                              ? headingText('Estimate', 151)
                              : Container(),

              //for updated on
              widget.issueCategory == IssueCategory.issues
                  ? issuesProvider.issues.displayProperties.updatedOn
                      ? headingText('Updated On', 151)
                      : Container()
                  : widget.issueCategory == IssueCategory.cycleIssues
                      ? cyclesProvider.issueProperty['properties']['updated_on']
                          ? headingText('Updated On', 151)
                          : Container()
                      : modulesProvider.issueProperty['properties']
                              ['updated_on']
                          ? headingText('Updated On', 151)
                          : Container(),

              //for created on
              widget.issueCategory == IssueCategory.issues
                  ? issuesProvider.issues.displayProperties.createdOn
                      ? headingText('Created On', 151)
                      : Container()
                  : widget.issueCategory == IssueCategory.cycleIssues
                      ? cyclesProvider.issueProperty['properties']['created_on']
                          ? headingText('Created On', 151)
                          : Container()
                      : modulesProvider.issueProperty['properties']
                              ['created_on']
                          ? headingText('Created On', 151)
                          : Container(),
            ],
          ),
        ),
        Container(
          // height: 450,
          margin: const EdgeInsets.only(top: 50),
          width: 100,
          child: ListView.builder(
              // controller: scrollController4,
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              controller: scrollController4,
              itemCount: issuesProvider.issuesList.length,
              // shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  height: 60,
                  //right border
                  decoration: BoxDecoration(
                    color: themeProvider
                        .themeManager.secondaryBackgroundDefaultColor,
                    border: Border(
                      right: BorderSide(
                        color: themeProvider.themeManager.borderSubtle01Color,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: 100,
                    //bottom border
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: themeProvider.themeManager.borderSubtle01Color,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Center(
                      child: CustomText(
                        '${issuesProvider.issuesList[index]['project_detail']['identifier']} - ${issuesProvider.issuesList[index]['sequence_id']}',
                        type: FontStyle.Small,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                );
              }),
        ),
        Container(
          height: 50,
          // padding: const EdgeInsets.symmetric(vertical: 10),
          //right border
          decoration: BoxDecoration(
            color: themeProvider.themeManager.secondaryBackgroundDefaultColor,
            border: Border(
              right: BorderSide(
                color: themeProvider.themeManager.borderSubtle01Color,
                width: 1,
              ),
              bottom: BorderSide(
                color: themeProvider.themeManager.borderSubtle01Color,
                width: 1,
              ),
            ),
          ),
          child: Container(
            color: themeProvider.themeManager.secondaryBackgroundDefaultColor,
            // height: 50,
            width: 99,
            child: Center(
              child: CustomText(
                'Key',
                type: FontStyle.Small,
                fontWeight: FontWeightt.Medium,
                color: themeProvider.themeManager.tertiaryTextColor,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
