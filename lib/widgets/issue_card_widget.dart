import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:plane/config/const.dart';
import 'package:plane/provider/projects_provider.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/utils/extensions/string_extensions.dart';

import 'package:plane/widgets/square_avatar_widget.dart';

import '../screens/MainScreens/Projects/ProjectDetail/IssuesTab/issue_detail.dart';
import 'custom_rich_text.dart';
import 'custom_text.dart';

class IssueCardWidget extends ConsumerStatefulWidget {
  const IssueCardWidget(
      {required this.cardIndex,
      required this.listIndex,
      required this.from,
      required this.issueCategory,
      this.isArchive = false,
      this.fromMyIssues = false,
      super.key});

  final int cardIndex;
  final int listIndex;
  final Enum issueCategory;
  final bool fromMyIssues;
  final bool isArchive;
  final PreviousScreen from;

  @override
  ConsumerState<IssueCardWidget> createState() => _IssueCardWidgetState();
}

class _IssueCardWidgetState extends ConsumerState<IssueCardWidget> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    dynamic provider;
    if (widget.issueCategory == IssueCategory.cycleIssues) {
      provider = ref.watch(ProviderList.cyclesProvider);
    } else if (widget.issueCategory == IssueCategory.myIssues) {
      provider = ref.watch(ProviderList.myIssuesProvider);
    } else if (widget.issueCategory == IssueCategory.moduleIssues) {
      provider = ref.watch(ProviderList.modulesProvider);
    } else {
      provider = ref.watch(ProviderList.issuesProvider);
    }

    return InkWell(
      onTap: () {
        if (widget.from == PreviousScreen.myIssues) {
          final projectProvider = ref.read(ProviderList.projectProvider);
          projectProvider.currentProject['name'] = provider
              .issuesResponse[widget.cardIndex]['project_detail']['name'];
          projectProvider.currentProject['id'] =
              provider.issuesResponse[widget.cardIndex]['project_detail']['id'];
        }
        Navigator.push(
            Const.globalKey.currentContext!,
            MaterialPageRoute(
                builder: (context) => IssueDetail(
                      isArchive: widget.isArchive,
                      from: widget.from,
                      projID: widget.issueCategory == IssueCategory.myIssues
                          ? provider.issuesResponse[widget.cardIndex]
                              ['project_detail']['id']
                          : null,
                      issueId: provider.issuesResponse[widget.cardIndex]['id'],
                      appBarTitle: provider.issuesResponse[widget.cardIndex]
                                  ['project_detail']['identifier'] !=
                              null
                          ? provider.issuesResponse[widget.cardIndex]
                                  ['project_detail']['identifier'] +
                              '-${provider.issuesResponse[widget.cardIndex]['sequence_id']}'
                          : '',
                    )));
      },
      child: Column(
        children: [
          Container(
            margin: (widget.issueCategory == IssueCategory.myIssues
                    ? ref
                            .watch(ProviderList.myIssuesProvider)
                            .issues
                            .projectView ==
                        IssueLayout.list
                    : ref
                            .watch(ProviderList.issuesProvider)
                            .issues
                            .projectView ==
                        IssueLayout.list)
                ? const EdgeInsets.only(bottom: 1)
                : const EdgeInsets.only(bottom: 15, right: 5, left: 5, top: 5),
            decoration: BoxDecoration(
              color: themeProvider.themeManager.primaryBackgroundDefaultColor,
              boxShadow: (widget.issueCategory == IssueCategory.myIssues
                      ? ref
                              .watch(ProviderList.myIssuesProvider)
                              .issues
                              .projectView ==
                          IssueLayout.kanban
                      : ref
                              .watch(ProviderList.issuesProvider)
                              .issues
                              .projectView ==
                          IssueLayout.kanban)
                  ? [
                      BoxShadow(
                        blurRadius: 2,
                        color: themeProvider.themeManager.borderSubtle01Color,
                        spreadRadius: 0,
                      )
                    ]
                  : null,
            ),
            child: Container(
                width: widget.issueCategory == IssueCategory.cycleIssues &&
                        ref
                                .watch(ProviderList.issuesProvider)
                                .issues
                                .projectView ==
                            IssueLayout.list
                    ? width
                    : widget.issueCategory == IssueCategory.moduleIssues
                        ? width
                        : widget.issueCategory == IssueCategory.cycleIssues
                            ? width
                            : widget.issueCategory == IssueCategory.myIssues
                                ? ref
                                    .watch(ProviderList.myIssuesProvider)
                                    .issues
                                    .issues[widget.listIndex]
                                    .width
                                : ref
                                    .watch(ProviderList.issuesProvider)
                                    .issues
                                    .issues[0]
                                    .width,
                padding: const EdgeInsets.only(
                  left: 15.0,
                  right: 10,
                ),
                child: (widget.issueCategory == IssueCategory.myIssues
                        ? ref
                                .watch(ProviderList.myIssuesProvider)
                                .issues
                                .projectView ==
                            IssueLayout.list
                        : ref
                                .watch(ProviderList.issuesProvider)
                                .issues
                                .projectView ==
                            IssueLayout.list)
                    ? listCard()
                    : kanbanCard()),
          ),
          (widget.issueCategory == IssueCategory.myIssues
                  ? ref
                          .watch(ProviderList.myIssuesProvider)
                          .issues
                          .projectView ==
                      IssueLayout.list
                  : ref.watch(ProviderList.issuesProvider).issues.projectView ==
                      IssueLayout.list)
              ? Divider(
                  height: 1,
                  thickness: 1,
                  color: themeProvider.themeManager.borderSubtle01Color,
                )
              : Container(),
        ],
      ),
    );
  }

  Widget kanbanCard() {
    final themeProvider = ref.read(ProviderList.themeProvider);
    dynamic provider;
    final projectProvider = ref.watch(ProviderList.projectProvider);

    if (widget.issueCategory == IssueCategory.cycleIssues) {
      provider = ref.watch(ProviderList.cyclesProvider);
    } else if (widget.issueCategory == IssueCategory.moduleIssues) {
      provider = ref.watch(ProviderList.modulesProvider);
    } else if (widget.issueCategory == IssueCategory.myIssues) {
      provider = ref.watch(ProviderList.myIssuesProvider);
    } else {
      provider = ref.watch(ProviderList.issuesProvider);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        provider.issues.displayProperties.id
            ? Container(
                margin: const EdgeInsets.only(top: 15),
                child: CustomRichText(
                  type: FontStyle.Small,
                  color: themeProvider.themeManager.placeholderTextColor,
                  widgets: [
                    TextSpan(
                        text: projectProvider.currentProject['identifier']),
                    TextSpan(
                        text:
                            '-${provider.issuesResponse[widget.cardIndex]['sequence_id']}'),
                  ],
                ),
              )
            : Container(),
        const SizedBox(
          height: 10,
        ),
        CustomText(
          provider.issuesResponse[widget.cardIndex]['name'],
          type: FontStyle.Medium,
          fontWeight: FontWeightt.Medium,
          maxLines: 2,
          textAlign: TextAlign.start,
        ),
        !provider.isTagsEnabled()
            ? const SizedBox(
                height: 10,
                width: 0,
              )
            : Container(
                width: 300,
                height: 55,
                padding: const EdgeInsets.only(bottom: 15, top: 10),
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    provider.issues.displayProperties.priority
                        ? Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: provider.issuesResponse[widget.cardIndex]
                                            ['priority'] ==
                                        'urgent'
                                    ? Colors.red
                                    : null,
                                border: Border.all(
                                    color: themeProvider
                                        .themeManager.borderSubtle01Color),
                                borderRadius: BorderRadius.circular(5)),
                            margin: const EdgeInsets.only(right: 5),
                            height: 30,
                            width: 30,
                            child: provider.issuesResponse[widget.cardIndex]['priority'] == null ||
                                    provider.issuesResponse[widget.cardIndex]
                                            ['priority'] ==
                                        'none'
                                ? Icon(
                                    Icons.do_disturb_alt_outlined,
                                    size: 18,
                                    color: themeProvider
                                        .themeManager.tertiaryTextColor,
                                  )
                                : provider.issuesResponse[widget.cardIndex]
                                            ['priority'] ==
                                        'urgent'
                                    ? const Icon(
                                        Icons.error_outline_rounded,
                                        color: Colors.white,
                                        size: 18,
                                      )
                                    : provider.issuesResponse[widget.cardIndex]
                                                ['priority'] ==
                                            'high'
                                        ? const Icon(
                                            Icons.signal_cellular_alt,
                                            color:
                                                Color.fromRGBO(249, 115, 23, 1),
                                            size: 18,
                                          )
                                        : provider.issuesResponse[widget.cardIndex]['priority'] == 'medium'
                                            ? const Icon(
                                                Icons.signal_cellular_alt_2_bar,
                                                color: Color.fromRGBO(
                                                    234, 179, 9, 1),
                                                size: 18,
                                              )
                                            : const Icon(
                                                Icons.signal_cellular_alt_1_bar,
                                                color: Color.fromRGBO(
                                                    34, 197, 94, 1),
                                                size: 18,
                                              ))
                        : const SizedBox(
                            width: 0,
                          ),
                    provider.issues.displayProperties.assignee == true
                        ? (provider.issuesResponse[widget.cardIndex]
                                        ['assignee_details'] !=
                                    null &&
                                provider
                                    .issuesResponse[widget.cardIndex]
                                        ['assignee_details']
                                    .isNotEmpty)
                            ? Container(
                                margin: const EdgeInsets.only(right: 5),
                                child: SquareAvatarWidget(
                                  details:
                                      provider.issuesResponse[widget.cardIndex]
                                          ['assignee_details'],
                                ),
                              )
                            : Container(
                                height: 30,
                                margin: const EdgeInsets.only(right: 5),
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: themeProvider
                                          .themeManager.borderSubtle01Color,
                                    ),
                                    borderRadius: BorderRadius.circular(4)),
                                child: Icon(
                                  Icons.groups_2_outlined,
                                  size: 18,
                                  color: themeProvider
                                      .themeManager.tertiaryTextColor,
                                ),
                              )
                        : Container(
                            width: 0,
                          ),
                    (provider.issues.displayProperties.label == true &&
                            provider
                                .issuesResponse[widget.cardIndex]['label_ids']
                                .isNotEmpty)
                        ? provider.issuesResponse[widget.cardIndex]['label_ids']
                                    .length ==
                                1
                            ? Container(
                                width: 80,
                                margin: const EdgeInsets.only(right: 5),
                                padding: const EdgeInsets.only(
                                  left: 8,
                                  right: 8,
                                ),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: themeProvider
                                          .themeManager.borderSubtle01Color,
                                    ),
                                    borderRadius: BorderRadius.circular(4)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 5,
                                      backgroundColor: getLabelDetail(
                                              provider.issuesResponse[
                                                      widget.cardIndex]
                                                  ['label_ids'][0])['color']
                                          .toString()
                                          .toColor(),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    CustomText(
                                      '${provider.issuesResponse[widget.cardIndex]['label_ids'].length} Labels',
                                      type: FontStyle.XSmall,
                                      height: 1,
                                      color: themeProvider
                                          .themeManager.tertiaryTextColor,
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                margin: const EdgeInsets.only(right: 5),
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  scrollDirection: Axis.horizontal,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: provider
                                      .issuesResponse[widget.cardIndex]
                                          ['label_ids']
                                      .length,
                                  itemBuilder: (context, idx) {
                                    return Container(
                                      height: 30,
                                      padding: const EdgeInsets.only(
                                        left: 8,
                                        right: 8,
                                      ),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: themeProvider.themeManager
                                                  .borderSubtle01Color),
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: 5,
                                            backgroundColor: getLabelDetail(
                                                    provider.issuesResponse[
                                                                widget
                                                                    .cardIndex]
                                                            ['label_details']
                                                        [idx])['color']
                                                .toString()
                                                .toColor(),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            constraints: const BoxConstraints(
                                                maxWidth: 120),
                                            child: CustomText(
                                              getLabelDetail(
                                                  provider.issuesResponse[
                                                              widget.cardIndex]
                                                          ['label_details']
                                                      [idx])['name'],
                                              type: FontStyle.XSmall,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              height: 1,
                                              color: themeProvider.themeManager
                                                  .tertiaryTextColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                        : Container(),
                    provider.issues.displayProperties.dueDate == true
                        ? Container(
                            height: 30,
                            margin: const EdgeInsets.only(right: 5),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: themeProvider
                                      .themeManager.borderSubtle01Color,
                                ),
                                borderRadius: BorderRadius.circular(4)),
                            child: CustomText(
                              provider.issuesResponse[widget.cardIndex]
                                          ['start_date'] !=
                                      null
                                  ?
                                  //convert yyyy-mm-dd to Aug 12, 2021
                                  DateFormat('MMM dd, yyyy').format(
                                      DateTime.parse(provider
                                              .issuesResponse[widget.cardIndex]
                                          ['start_date']))
                                  : 'Start date',
                              type: FontStyle.XSmall,
                              height: 1,
                              color:
                                  themeProvider.themeManager.tertiaryTextColor,
                            ),
                          )
                        : Container(),
                    provider.issues.displayProperties.dueDate == true
                        ? Container(
                            margin: const EdgeInsets.only(right: 5),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: themeProvider
                                        .themeManager.borderSubtle01Color),
                                borderRadius: BorderRadius.circular(4)),
                            child: CustomText(
                              provider.issuesResponse[widget.cardIndex]
                                          ['target_date'] !=
                                      null
                                  ?
                                  //convert yyyy-mm-dd to Aug 12, 2021
                                  DateFormat('MMM dd, yyyy').format(
                                      DateTime.parse(provider
                                              .issuesResponse[widget.cardIndex]
                                          ['target_date']))
                                  : 'Due date',
                              type: FontStyle.XSmall,
                              height: 1,
                              color:
                                  themeProvider.themeManager.tertiaryTextColor,
                            ),
                          )
                        : Container(),
                    provider.issues.displayProperties.subIsseCount == true
                        ? Container(
                            margin: const EdgeInsets.only(right: 5),
                            height: 30,
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: themeProvider
                                      .themeManager.borderSubtle01Color,
                                ),
                                borderRadius: BorderRadius.circular(4)),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                SvgPicture.asset(
                                    'assets/svg_images/issues_icon.svg',
                                    width: 16,
                                    height: 16,
                                    colorFilter: ColorFilter.mode(
                                        themeProvider
                                            .themeManager.tertiaryTextColor,
                                        BlendMode.srcIn)),
                                const SizedBox(
                                  width: 5,
                                ),
                                CustomText(
                                  provider.issuesResponse[widget.cardIndex]
                                                  ['sub_issues_count'] !=
                                              '' &&
                                          provider.issuesResponse[
                                                      widget.cardIndex]
                                                  ['sub_issues_count'] !=
                                              null
                                      ? provider
                                          .issuesResponse[widget.cardIndex]
                                              ['sub_issues_count']
                                          .toString()
                                      : '0',
                                  type: FontStyle.XSmall,
                                  height: 1,
                                  color: themeProvider
                                      .themeManager.tertiaryTextColor,
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    provider.issues.displayProperties.linkCount == true
                        ? Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(right: 5),
                            height: 30,
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: themeProvider
                                        .themeManager.borderSubtle01Color),
                                borderRadius: BorderRadius.circular(4)),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Transform.rotate(
                                  angle: 33.6,
                                  child: Icon(
                                    Icons.link,
                                    size: 18,
                                    color: themeProvider
                                        .themeManager.tertiaryTextColor,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                CustomText(
                                  provider.issuesResponse[widget.cardIndex]
                                                  ['link_count'] !=
                                              '' &&
                                          provider.issuesResponse[widget
                                                  .cardIndex]['link_count'] !=
                                              null
                                      ? provider
                                          .issuesResponse[widget.cardIndex]
                                              ['link_count']
                                          .toString()
                                      : '0',
                                  type: FontStyle.XSmall,
                                  height: 1,
                                  color: themeProvider
                                      .themeManager.tertiaryTextColor,
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    provider.issues.displayProperties.attachmentCount == true
                        ? Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(right: 5),
                            height: 30,
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: themeProvider
                                      .themeManager.borderSubtle01Color,
                                ),
                                borderRadius: BorderRadius.circular(4)),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Icon(
                                  Icons.attach_file,
                                  size: 18,
                                  color: themeProvider
                                      .themeManager.tertiaryTextColor,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                CustomText(
                                  provider.issuesResponse[widget.cardIndex]
                                                  ['attachment_count'] !=
                                              '' &&
                                          provider.issuesResponse[
                                                      widget.cardIndex]
                                                  ['attachment_count'] !=
                                              null
                                      ? provider
                                          .issuesResponse[widget.cardIndex]
                                              ['attachment_count']
                                          .toString()
                                      : '0',
                                  type: FontStyle.XSmall,
                                  height: 1,
                                  color: themeProvider
                                      .themeManager.tertiaryTextColor,
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    (provider.issues.displayProperties.estimate == true &&
                            projectProvider.currentProject['estimate'] != null)
                        ? Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(right: 5),
                            height: 30,
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: themeProvider
                                      .themeManager.borderSubtle01Color,
                                ),
                                borderRadius: BorderRadius.circular(4)),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Icon(
                                  Icons.change_history,
                                  size: 18,
                                  color: themeProvider
                                      .themeManager.tertiaryTextColor,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                CustomText(
                                  provider.issuesResponse[widget.cardIndex]
                                                  ['estimate_point'] !=
                                              '' &&
                                          provider.issuesResponse[
                                                      widget.cardIndex]
                                                  ['estimate_point'] !=
                                              null
                                      ? ref
                                          .read(ProviderList.estimatesProvider)
                                          .estimates
                                          .firstWhere((element) {
                                          return element['id'] ==
                                              projectProvider
                                                  .currentProject['estimate'];
                                        })['points'].firstWhere((element) {
                                          return element['key'] ==
                                              provider.issuesResponse[widget
                                                  .cardIndex]['estimate_point'];
                                        })['value']
                                      : 'Estimate',
                                  type: FontStyle.XSmall,
                                  height: 1,
                                  color: themeProvider
                                      .themeManager.tertiaryTextColor,
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
      ],
    );
  }

  Widget listCard() {
    final themeProvider = ref.read(ProviderList.themeProvider);
    dynamic provider;
    if (widget.issueCategory == IssueCategory.cycleIssues) {
      provider = ref.watch(ProviderList.cyclesProvider);
    } else if (widget.issueCategory == IssueCategory.moduleIssues) {
      provider = ref.watch(ProviderList.modulesProvider);
    } else if (widget.issueCategory == IssueCategory.myIssues) {
      provider = ref.watch(ProviderList.myIssuesProvider);
    } else {
      provider = ref.watch(ProviderList.issuesProvider);
    }
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: [
          provider.issues.displayProperties.priority
              ? Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: provider.issuesResponse[widget.cardIndex]
                                  ['priority'] ==
                              'urgent'
                          ? Colors.red
                          : null,
                      border: Border.all(
                          color:
                              themeProvider.themeManager.borderSubtle01Color),
                      borderRadius: BorderRadius.circular(5)),
                  margin: const EdgeInsets.only(right: 15),
                  height: 30,
                  width: 30,
                  child: provider.issuesResponse[widget.cardIndex]['priority'] ==
                              null ||
                          provider.issuesResponse[widget.cardIndex]['priority'] ==
                              'none'
                      ? Icon(
                          Icons.do_disturb_alt_outlined,
                          size: 18,
                          color: themeProvider.themeManager.tertiaryTextColor,
                        )
                      : provider.issuesResponse[widget.cardIndex]['priority'] ==
                              'urgent'
                          ? const Icon(
                              Icons.error_outline_rounded,
                              color: Colors.white,
                              size: 18,
                            )
                          : provider.issuesResponse[widget.cardIndex]['priority'] ==
                                  'high'
                              ? const Icon(
                                  Icons.signal_cellular_alt,
                                  color: Color.fromRGBO(249, 115, 23, 1),
                                  size: 18,
                                )
                              : provider.issuesResponse[widget.cardIndex]
                                          ['priority'] ==
                                      'medium'
                                  ? const Icon(
                                      Icons.signal_cellular_alt_2_bar,
                                      color: Color.fromRGBO(234, 179, 9, 1),
                                      size: 18,
                                    )
                                  : const Icon(
                                      Icons.signal_cellular_alt_1_bar,
                                      color: Color.fromRGBO(34, 197, 94, 1),
                                      size: 18,
                                    ))
              : const SizedBox(),
          provider.issues.displayProperties.id
              ? SizedBox(
                  width:
                      70, // So that id will take a fixed space and the starting position of issue title will be same
                  child: CustomRichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      type: FontStyle.Small,
                      color: themeProvider.themeManager.placeholderTextColor,
                      widgets: [
                        TextSpan(
                            text: provider.issuesResponse[widget.cardIndex]
                                ['project_detail']['identifier'],
                            style: TextStyle(
                              color: themeProvider
                                  .themeManager.placeholderTextColor,
                            )),
                        TextSpan(
                            text:
                                '-${provider.issuesResponse[widget.cardIndex]['sequence_id']}',
                            style: TextStyle(
                              color: themeProvider
                                  .themeManager.placeholderTextColor,
                            )),
                      ]))
              : Container(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: CustomText(
                provider.issuesResponse[widget.cardIndex]['name']
                    .toString()
                    .trim(),
                type: FontStyle.Small,
                maxLines: 1,
                textAlign: TextAlign.start,
              ),
            ),
          ),
          provider.issues.displayProperties.assignee == true
              ? provider.issuesResponse[widget.cardIndex]['assignee_details'] !=
                          null &&
                      provider
                          .issuesResponse[widget.cardIndex]['assignee_details']
                          .isNotEmpty
                  ? SizedBox(
                      height: 30,
                      child: Container(
                        alignment: Alignment.center,
                        height: 30,
                        child: SquareAvatarWidget(
                          details: provider.issuesResponse[widget.cardIndex]
                              ['assignee_details'],
                        ),
                      ),
                    )
                  : Container(
                      height: 30,
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: themeProvider
                                  .themeManager.borderSubtle01Color),
                          borderRadius: BorderRadius.circular(5)),
                      child: Icon(
                        Icons.groups_2_outlined,
                        size: 18,
                        color: themeProvider.themeManager.tertiaryTextColor,
                      ),
                    )
              : const SizedBox(
                  height: 0,
                  width: 0,
                ),
        ],
      ),
    );
  }

  Map getLabelDetail(String issueId) {
    final issuesProvider = ref.watch(ProviderList.issuesProvider);
    Map? issueDetail;
    for (final label in issuesProvider.labels) {
      if (issueId == label['id']) {
        log(issueId);
      }
    }
    return issueDetail!;
  }
}
