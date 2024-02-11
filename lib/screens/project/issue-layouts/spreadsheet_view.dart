import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plane/core/icons/state_group_icon.dart';
import 'package:plane/models/project/issue/issue_model.dart';
import 'package:plane/provider/issues/base-classes/base_issues_provider.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/project/issues/issue_detail.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/core/extensions/string_extensions.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/square_avatar_widget.dart';

class SpreadSheetView extends ConsumerStatefulWidget {
  const SpreadSheetView(
      {required this.issues,
      required this.issueCategory,
      required this.issuesProvider,
      super.key});
  final IssuesCategory issueCategory;
  final ABaseIssuesProvider issuesProvider;
  final List<IssueModel> issues;

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

    final statesNotifier = ref.watch(ProviderList.statesProvider.notifier);
    final labelsNotifier = ref.watch(ProviderList.labelProvider.notifier);
    final projectProvider = ref.watch(ProviderList.projectProvider);

    widget.issuesProvider.displayProperties.state ? width += 201 : width += 0;

    //for assignee
    widget.issuesProvider.displayProperties.assignee
        ? width += 151
        : width += 0;

    //for label
    widget.issuesProvider.displayProperties.labels ? width += 151 : width += 0;

    //for start date
    widget.issuesProvider.displayProperties.start_date
        ? width += 151
        : width += 0;

    //for due date
    widget.issuesProvider.displayProperties.due_date
        ? width += 151
        : width += 0;

    //for estimate
    projectProvider.currentProject['estimate'] != null
        ? widget.issuesProvider.displayProperties.estimate
            ? width += 151
            : width += 0
        : width += 0;

    //for updated on
    widget.issuesProvider.displayProperties.updated_on
        ? width += 151
        : width += 0;

    //for created on
    widget.issuesProvider.displayProperties.created_on
        ? width += 151
        : width += 0;

    Widget priorityWidget(String? priority) {
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
              child: priority == null
                  ? Icon(
                      Icons.do_disturb_alt_outlined,
                      size: 18,
                      color: themeProvider.themeManager.tertiaryTextColor,
                    )
                  : priority == 'high'
                      ? const Icon(
                          Icons.signal_cellular_alt,
                          color: Colors.orange,
                          size: 18,
                        )
                      : priority == 'medium'
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

    Widget titleWidget(IssueModel issue) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const IssueDetail(),
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
                    widget.issuesProvider.displayProperties.priority
                        ? priorityWidget(issue.priority)
                        : const SizedBox(),
                    widget.issuesProvider.displayProperties.priority
                        ? const SizedBox(width: 10)
                        : const SizedBox(),
                    SizedBox(
                      width: 320,
                      child: CustomText(
                        issue.name,
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
                StateGroupIcon(statesNotifier
                    .getStateById(widget.issues[index].state_id)
                    ?.group),
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
              child: widget.issues[index].assignee_ids.isNotEmpty
                  ? Container(
                      alignment: Alignment.centerLeft,
                      height: 30,
                      child: SquareAvatarWidget(
                        member_ids: widget.issues[index].assignee_ids,
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
            child: widget.issuesProvider.displayProperties.labels == true &&
                    widget.issues[index].label_ids.isNotEmpty
                ? SizedBox(
                    height: 30,
                    child: widget.issues[index].label_ids.length > 1
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
                                  backgroundColor: labelsNotifier
                                      .getLabelById(
                                          widget.issues[index].label_ids[0])
                                      ?.color
                                      .toColor(),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                CustomText(
                                  '${widget.issues[index].label_ids.length} Labels',
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
                            itemCount: widget.issues[index].label_ids.length,
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
                                        backgroundColor: labelsNotifier
                                            .getLabelById(widget
                                                .issues[index].label_ids[idx])
                                            ?.color
                                            .toColor()),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    CustomText(
                                      labelsNotifier
                                              .getLabelById(widget
                                                  .issues[index].label_ids[idx])
                                              ?.name ??
                                          '',
                                      type: FontStyle.Small,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  )
                : (widget.issuesProvider.displayProperties.labels == true &&
                        widget.issues[index].label_ids.isEmpty)
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
            child: Center(
              child: CustomText(
                widget.issues[index].target_date != null
                    ? DateFormat('dd MMM yyyy').format(
                        DateTime.parse(
                          widget.issues[index].target_date!,
                        ),
                      )
                    : 'No Due Date',
                type: FontStyle.Small,
              ),
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
            child: Center(
              child: CustomText(
                widget.issues[index].start_date != null
                    ? DateFormat('dd MMM yyyy').format(
                        DateTime.parse(
                          widget.issues[index].start_date!,
                        ),
                      )
                    : 'No Start Date',
                type: FontStyle.Small,
              ),
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
                  widget.issues[index].estimate_point != '' &&
                          widget.issues[index].estimate_point != null
                      ? ref
                          .read(ProviderList.estimatesProvider)
                          .estimates
                          .firstWhere((element) {
                          return element['id'] ==
                              ref
                                  .watch(ProviderList.projectProvider)
                                  .currentProject['estimate'];
                        })['points'].firstWhere((element) {
                          return element['key'] ==
                              widget.issues[index].estimate_point;
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
            child: Center(
              child: CustomText(
                DateFormat('dd MMM yyyy').format(
                  DateTime.parse(
                    widget.issues[index].created_at,
                  ),
                ),
                type: FontStyle.Small,
              ),
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
            child: Center(
              child: CustomText(
                //date month year
                DateFormat('dd MMM yyyy').format(
                  DateTime.parse(
                    widget.issues[index].created_at,
                  ),
                ),
                type: FontStyle.Small,
              ),
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
                itemCount: widget.issues.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  String stateName = statesNotifier
                          .getStateById(widget.issues[index].state_id)
                          ?.name ??
                      '';
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

                        titleWidget(widget.issues[index]),

                        widget.issuesProvider.displayProperties.state
                            ? stateWidget(index, stateName)
                            : Container(),

                        //for assignees
                        widget.issuesProvider.displayProperties.assignee
                            ? assigneesWidget(index)
                            : Container(),

                        //for labels
                        widget.issuesProvider.displayProperties.labels
                            ? labelsWidget(index)
                            : Container(),

                        //for start date
                        widget.issuesProvider.displayProperties.start_date
                            ? startDateWidget(index)
                            : Container(),

                        //for due date
                        widget.issuesProvider.displayProperties.due_date
                            ? dueDateWidget(index)
                            : Container(),

                        //for estimate
                        projectProvider.currentProject['estimate'] == null
                            ? Container()
                            : widget.issuesProvider.displayProperties.estimate
                                ? estimatesWidget(index)
                                : Container(),

                        //for updated on
                        widget.issuesProvider.displayProperties.updated_on
                            ? updatedOnWidget(index)
                            : Container(),

                        //for created on
                        widget.issuesProvider.displayProperties.created_on
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
              widget.issuesProvider.displayProperties.state
                  ? headingText('State', 201)
                  : Container(),

              widget.issuesProvider.displayProperties.assignee
                  ? headingText('Assignees', 151)
                  : Container(),

              //for labels
              widget.issuesProvider.displayProperties.labels
                  ? headingText('Labels', 151)
                  : Container(),

              //for start date
              widget.issuesProvider.displayProperties.start_date
                  ? headingText('Start Date', 151)
                  : Container(),

              //for due date
              widget.issuesProvider.displayProperties.due_date
                  ? headingText('Due Date', 151)
                  : Container(),

              //for estimate
              ref
                          .watch(ProviderList.projectProvider)
                          .currentProject['estimate'] ==
                      null
                  ? Container()
                  : widget.issuesProvider.displayProperties.estimate
                      ? headingText('Estimate', 151)
                      : Container(),

              //for updated on
              widget.issuesProvider.displayProperties.updated_on
                  ? headingText('Updated On', 151)
                  : Container(),

              //for created on
              widget.issuesProvider.displayProperties.created_on
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
              itemCount: widget.issues.length,
              // shrinkWrap: true,
              itemBuilder: (context, index) {
                final issue = widget.issues[index];
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
                        '${projectProvider.currentProject['identifier']} - ${issue.sequence_id}',
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
