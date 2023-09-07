import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:plane_startup/config/const.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/IssuesTab/issue_detail_screen.dart';
import 'package:plane_startup/utils/color_manager.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/enums.dart';

import 'package:plane_startup/widgets/square_avatar_widget.dart';

import 'custom_rich_text.dart';
import 'custom_text.dart';

class IssueCardWidget extends ConsumerStatefulWidget {
  final int cardIndex;
  final int listIndex;
  final Enum issueCategory;
  final bool fromMyIssues;

  const IssueCardWidget(
      {required this.cardIndex,
      required this.listIndex,
      required this.issueCategory,
      this.fromMyIssues = false,
      super.key});

  @override
  ConsumerState<IssueCardWidget> createState() => _IssueCardWidgetState();
}

class _IssueCardWidgetState extends ConsumerState<IssueCardWidget> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
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

    // log('issue category ${provider.issuesResponse}');
    return InkWell(
      onTap: () {
        Navigator.push(
            Const.globalKey.currentContext!,
            MaterialPageRoute(
                builder: (context) => IssueDetail(
                      fromMyIssues: widget.fromMyIssues,
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
                        ProjectView.list
                    : ref
                            .watch(ProviderList.issuesProvider)
                            .issues
                            .projectView ==
                        ProjectView.list)
                ? const EdgeInsets.only(bottom: 1)
                : const EdgeInsets.only(bottom: 15, right: 5, left: 5, top: 5),
            decoration: BoxDecoration(
              color: themeProvider.themeManager.primaryBackgroundDefaultColor,
              // border: Border(
              //     bottom: BorderSide(
              //         color: themeProvider.themeManager.borderDisabledColor,
              //         width: 1)),
              boxShadow: (widget.issueCategory == IssueCategory.myIssues
                      ? ref
                              .watch(ProviderList.myIssuesProvider)
                              .issues
                              .projectView ==
                          ProjectView.kanban
                      : ref
                              .watch(ProviderList.issuesProvider)
                              .issues
                              .projectView ==
                          ProjectView.kanban)
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
                            ProjectView.list
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
                  // top: provider.isTagsEnabled() ? 0 : 0,
                  // bottom: provider.isTagsEnabled() ? 0 : 0
                ),
                child: (widget.issueCategory == IssueCategory.myIssues
                        ? ref
                                .watch(ProviderList.myIssuesProvider)
                                .issues
                                .projectView ==
                            ProjectView.list
                        : ref
                                .watch(ProviderList.issuesProvider)
                                .issues
                                .projectView ==
                            ProjectView.list)
                    ? listCard()
                    : kanbanCard()),
          ),
          (widget.issueCategory == IssueCategory.myIssues
                  ? ref
                          .watch(ProviderList.myIssuesProvider)
                          .issues
                          .projectView ==
                      ProjectView.list
                  : ref.watch(ProviderList.issuesProvider).issues.projectView ==
                      ProjectView.list)
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
    var themeProvider = ref.read(ProviderList.themeProvider);
    // IssuesProvider provider = widget.cycleIssues ? ref.watch(ProviderList.cyclesProvider) : ref.watch(ProviderList.issuesProvider);
    dynamic provider;
    var projectProvider = ref.watch(ProviderList.projectProvider);

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
                    //ype: RichFontStyle.Small,
                    type: FontStyle.Small,
                    color: themeProvider.themeManager.placeholderTextColor,
                    widgets: [
                      TextSpan(
                          text: provider.issuesResponse[widget.cardIndex]
                              ['project_detail']['identifier']),
                      TextSpan(
                          text:
                              '-${provider.issuesResponse[widget.cardIndex]['sequence_id']}'),
                    ]))
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
                  // runSpacing: 10,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    provider.issues.displayProperties.priority
                        ? Container(
                            // alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: themeProvider
                                      .themeManager.borderSubtle01Color,
                                )),
                            margin: const EdgeInsets.only(right: 5),
                            height: 30,
                            width: 30,
                            child: provider.issuesResponse[widget.cardIndex]
                                        ['priority'] ==
                                    null
                                ? Icon(
                                    Icons.do_disturb_alt_outlined,
                                    size: 18,
                                    color: themeProvider
                                        .themeManager.tertiaryTextColor,
                                  )
                                : provider.issuesResponse[widget.cardIndex]
                                            ['priority'] ==
                                        'high'
                                    ? const Icon(
                                        Icons.signal_cellular_alt,
                                        color: Colors.orange,
                                        size: 18,
                                      )
                                    : provider.issuesResponse[widget.cardIndex]
                                                ['priority'] ==
                                            'medium'
                                        ? const Icon(
                                            Icons.signal_cellular_alt_2_bar,
                                            color: Colors.orange,
                                            size: 18,
                                          )
                                        : const Icon(
                                            Icons.signal_cellular_alt_1_bar,
                                            color: Colors.orange,
                                            size: 18,
                                          ))
                        : const SizedBox(
                            width: 0,
                          ),

                    // -------------- STATE UI WIDGET ------------- //

                    // provider.issues.displayProperties.state
                    //     ? Container(
                    //         height: 30,
                    //         margin: const EdgeInsets.only(
                    //           right: 5,
                    //         ),
                    //         padding: const EdgeInsets.only(
                    //             left: 8, right: 8, top: 5, bottom: 5),
                    //         decoration: BoxDecoration(
                    //             border: Border.all(
                    //                 color: themeProvider.isDarkThemeEnabled
                    //                     ? darkThemeBorder
                    //                     : lightGreeyColor),
                    //             borderRadius: BorderRadius.circular(5)),
                    //         child: Wrap(
                    //           children: [
                    //             SizedBox(
                    //               height: 20,
                    //               width: 20,
                    //               child: ref
                    //                   .watch(ProviderList.issuesProvider)
                    //                   .stateIcons[provider
                    //                       .issuesResponse[widget.cardIndex]
                    //                   ['state_detail']['id']],
                    //             ),
                    //             const SizedBox(
                    //               width: 5,
                    //             ),
                    //             Padding(
                    //               padding: const EdgeInsets.only(top: 2),
                    //               child: CustomText(
                    //                 provider
                    //                         .issuesResponse[widget.cardIndex]
                    //                     ['state_detail']['name'],
                    //                 type: FontStyle.Medium,
                    //                 fontSize: 13,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       )
                    //     : Container(),

                    // -------------------------------------------- //

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
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, top: 5, bottom: 5),
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
                            provider.issuesResponse[widget.cardIndex]
                                    ['label_details'] !=
                                null &&
                            provider
                                .issuesResponse[widget.cardIndex]
                                    ['label_details']
                                .isNotEmpty)
                        ? SizedBox(
                            height: 30,
                            child: provider
                                        .issuesResponse[widget.cardIndex]
                                            ['label_details']
                                        .length >
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 5,
                                          backgroundColor: ColorManager
                                              .getColorFromHexaDecimal(
                                                  provider.issuesResponse[
                                                              widget.cardIndex]
                                                          ['label_details'][0]
                                                      ['color']),
                                          // Color(int.parse(
                                          //     provider
                                          //         .issuesResponse[widget
                                          //                 .cardIndex]
                                          //             ['label_details'][0]
                                          //             ['color']
                                          //         .replaceAll('#', '0xFF'))),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 2),
                                          child: CustomText(
                                            '${provider.issuesResponse[widget.cardIndex]['label_details'].length} Labels',
                                            type: FontStyle.XSmall,
                                            color: themeProvider
                                                .themeManager.tertiaryTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    margin: const EdgeInsets.only(right: 5),
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.horizontal,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: provider
                                          .issuesResponse[widget.cardIndex]
                                              ['label_details']
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
                                                  color: themeProvider
                                                      .themeManager
                                                      .borderSubtle01Color),
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 5,
                                                backgroundColor: Color(
                                                    int.parse(provider
                                                        .issuesResponse[
                                                            widget.cardIndex]
                                                            ['label_details']
                                                            [idx]['color']
                                                        .replaceAll(
                                                            '#', '0xFF'))),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 2),
                                                child: CustomText(
                                                  provider.issuesResponse[
                                                              widget.cardIndex]
                                                          ['label_details'][idx]
                                                      ['name'],
                                                  type: FontStyle.XSmall,
                                                  color: themeProvider
                                                      .themeManager
                                                      .tertiaryTextColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                          )
                        : (provider.issues.displayProperties.label == true &&
                                provider
                                    .issuesResponse[widget.cardIndex]
                                        ['label_details']
                                    .isEmpty)
                            ? Container(
                                height: 30,
                                margin: const EdgeInsets.only(right: 5),
                                padding: const EdgeInsets.only(
                                  left: 8,
                                  top: 2,
                                  bottom: 5,
                                  right: 8,
                                ),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: themeProvider
                                            .themeManager.borderSubtle01Color),
                                    borderRadius: BorderRadius.circular(4)),
                                child: CustomText(
                                  'No Label',
                                  type: FontStyle.XSmall,
                                  color: themeProvider
                                      .themeManager.tertiaryTextColor,
                                ),
                              )
                            : Container(
                                width: 0,
                              ),
                    provider.issues.displayProperties.dueDate == true
                        ? Container(
                            height: 30,
                            margin: const EdgeInsets.only(right: 5),
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 2, bottom: 5),
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
                              color:
                                  themeProvider.themeManager.tertiaryTextColor,
                            ),
                          )
                        : Container(),
                    provider.issues.displayProperties.dueDate == true
                        ? Container(
                            height: 30,
                            margin: const EdgeInsets.only(right: 5),
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 2, bottom: 5),
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
                                left: 8, right: 8, top: 0, bottom: 5),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: themeProvider
                                      .themeManager.borderSubtle01Color,
                                ),
                                borderRadius: BorderRadius.circular(4)),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: SvgPicture.asset(
                                      'assets/svg_images/issues_icon.svg',
                                      width: 16,
                                      height: 16,
                                      colorFilter: ColorFilter.mode(
                                          themeProvider
                                              .themeManager.tertiaryTextColor,
                                          BlendMode.srcIn)),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: CustomText(
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
                                    color: themeProvider
                                        .themeManager.tertiaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    provider.issues.displayProperties.linkCount == true
                        ? Container(
                            margin: const EdgeInsets.only(right: 5),
                            height: 30,
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 0, bottom: 5),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: themeProvider
                                        .themeManager.borderSubtle01Color),
                                borderRadius: BorderRadius.circular(4)),
                            child: Wrap(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Transform.rotate(
                                    angle: 33.6,
                                    child: Icon(
                                      Icons.link,
                                      size: 18,
                                      color: themeProvider
                                          .themeManager.tertiaryTextColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: CustomText(
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
                                    color: themeProvider
                                        .themeManager.tertiaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    provider.issues.displayProperties.attachmentCount == true
                        ? Container(
                            margin: const EdgeInsets.only(right: 5),
                            height: 30,
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, bottom: 5),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: themeProvider
                                      .themeManager.borderSubtle01Color,
                                ),
                                borderRadius: BorderRadius.circular(4)),
                            child: Wrap(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Icon(
                                    Icons.attach_file,
                                    size: 18,
                                    color: themeProvider
                                        .themeManager.tertiaryTextColor,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: CustomText(
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
                                    color: themeProvider
                                        .themeManager.tertiaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    (provider.issues.displayProperties.estimate == true &&
                            projectProvider.currentProject['estimate'] != null)
                        ? Container(
                            height: 30,
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, bottom: 5),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: themeProvider
                                      .themeManager.borderSubtle01Color,
                                ),
                                borderRadius: BorderRadius.circular(4)),
                            child: Wrap(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Icon(
                                    Icons.change_history,
                                    size: 18,
                                    color: themeProvider
                                        .themeManager.tertiaryTextColor,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: CustomText(
                                    provider.issuesResponse[widget.cardIndex]
                                                    ['estimate_point'] !=
                                                '' &&
                                            provider.issuesResponse[
                                                        widget.cardIndex]
                                                    ['estimate_point'] !=
                                                null
                                        ? ref
                                            .read(
                                                ProviderList.estimatesProvider)
                                            .estimates
                                            .firstWhere((element) {
                                            return element['id'] ==
                                                projectProvider
                                                    .currentProject['estimate'];
                                          })['points'].firstWhere((element) {
                                            return element['key'] ==
                                                provider.issuesResponse[
                                                        widget.cardIndex]
                                                    ['estimate_point'];
                                          })['value']
                                        : 'Estimate',
                                    type: FontStyle.XSmall,
                                    color: themeProvider
                                        .themeManager.tertiaryTextColor,
                                  ),
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
    var themeProvider = ref.read(ProviderList.themeProvider);
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
      // color: Colors.amber,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: [
          provider.issues.displayProperties.priority
              ? Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color:
                              themeProvider.themeManager.borderSubtle01Color),
                      borderRadius: BorderRadius.circular(5)),
                  margin: const EdgeInsets.only(right: 15),
                  height: 30,
                  width: 30,
                  child: provider.issuesResponse[widget.cardIndex]
                              ['priority'] ==
                          null
                      ? Icon(
                          Icons.do_disturb_alt_outlined,
                          size: 18,
                          color: themeProvider.themeManager.tertiaryTextColor,
                        )
                      : provider.issuesResponse[widget.cardIndex]['priority'] ==
                              'urgent'
                          ? const Icon(
                              Icons.error_outline_rounded,
                              color: Colors.orange,
                              size: 18,
                            )
                          : provider.issuesResponse[widget.cardIndex]
                                      ['priority'] ==
                                  'high'
                              ? const Icon(
                                  Icons.signal_cellular_alt,
                                  color: Colors.orange,
                                  size: 18,
                                )
                              : provider.issuesResponse[widget.cardIndex]
                                          ['priority'] ==
                                      'medium'
                                  ? const Icon(
                                      Icons.signal_cellular_alt_2_bar,
                                      color: Colors.orange,
                                      size: 18,
                                    )
                                  : const Icon(
                                      Icons.signal_cellular_alt_1_bar,
                                      color: Colors.orange,
                                      size: 18,
                                    ))
              : const SizedBox(),
          provider.issues.displayProperties.id
              ? Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: CustomRichText(
                      //ype: RichFontStyle.Small,
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
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              //color: Colors.amber,

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
          // const Spacer(),
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
}
