import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plane_startup/config/const.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/IssuesTab/issue_detail_screen.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/enums.dart';

import 'package:plane_startup/widgets/square_avatar_widget.dart';

import 'custom_rich_text.dart';
import 'custom_text.dart';

class IssueCardWidget extends ConsumerStatefulWidget {
  final int cardIndex;
  final int listIndex;
  final Enum issueCategory;
  const IssueCardWidget(
      {required this.cardIndex,
      required this.listIndex,
      required this.issueCategory,
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
      child: Container(
        margin: ref.watch(ProviderList.issuesProvider).issues.projectView ==
                ProjectView.list
            ? const EdgeInsets.only(bottom: 1)
            : const EdgeInsets.only(bottom: 15, right: 5, left: 5, top: 5),
        decoration: BoxDecoration(
          color: themeProvider.isDarkThemeEnabled
              ? darkBackgroundColor
              : lightBackgroundColor,
          border: Border(
              bottom: BorderSide(
                  color: themeProvider.isDarkThemeEnabled
                      ? darkThemeBorder
                      : strokeColor,
                  width: 1)),
          boxShadow:
              ref.watch(ProviderList.issuesProvider).issues.projectView ==
                      ProjectView.kanban
                  ? [
                      BoxShadow(
                        blurRadius: 3.0,
                        color: themeProvider.isDarkThemeEnabled
                            ? Colors.grey.shade700
                            : Colors.grey.shade300,
                        spreadRadius: 1,
                      )
                    ]
                  : null,
          // borderRadius:
          //     ref.watch(ProviderList.issuesProvider).issues.projectView ==
          //             ProjectView.list
          //         ? null
          //         : BorderRadius.circular(6),
        ),
        child: Container(
            width: widget.issueCategory == IssueCategory.cycleIssues &&
                    ref.watch(ProviderList.issuesProvider).issues.projectView ==
                        ProjectView.list
                ? width
                : widget.issueCategory == IssueCategory.moduleIssues
                    ? width
                    : widget.issueCategory == IssueCategory.cycleIssues
                        ? width
                        : ref
                            .watch(ProviderList.issuesProvider)
                            .issues
                            .issues[widget.listIndex]
                            .width,
            padding: const EdgeInsets.only(
              left: 15.0,
              right: 10,
              // top: provider.isTagsEnabled() ? 0 : 0,
              // bottom: provider.isTagsEnabled() ? 0 : 0
            ),
            child: ref.watch(ProviderList.issuesProvider).issues.projectView ==
                    ProjectView.list
                ? listCard()
                : kanbanCard()),
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
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
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
          type: FontStyle.Small,
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
                padding: const EdgeInsets.only(bottom: 15, top: 10),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 10,
                  children: [
                    provider.issues.displayProperties.priority
                        ? Container(
                            // alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: themeProvider.isDarkThemeEnabled
                                        ? darkThemeBorder
                                        : lightGreeyColor)),
                            // margin: const EdgeInsets.only(right: 5),
                            height: 30,
                            width: 30,
                            child: provider.issuesResponse[widget.cardIndex]
                                        ['priority'] ==
                                    null
                                ? const Icon(
                                    Icons.do_disturb_alt_outlined,
                                    size: 18,
                                    color: greyColor,
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
                            ? SquareAvatarWidget(
                                details:
                                    provider.issuesResponse[widget.cardIndex]
                                        ['assignee_details'],
                              )
                            : Container(
                                height: 30,
                                margin: const EdgeInsets.only(right: 5),
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: themeProvider.isDarkThemeEnabled
                                            ? darkThemeBorder
                                            : lightGreeyColor),
                                    borderRadius: BorderRadius.circular(5)),
                                child: const Icon(
                                  Icons.groups_2_outlined,
                                  size: 18,
                                  color: greyColor,
                                ),
                              )
                        : Container(),
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
                                    // color: Colors.grey,
                                    width: 85,
                                    padding: const EdgeInsets.only(
                                      left: 8,
                                      right: 8,
                                    ),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                                themeProvider.isDarkThemeEnabled
                                                    ? darkThemeBorder
                                                    : lightGreeyColor),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 5,
                                          backgroundColor: Color(int.parse(
                                              provider
                                                  .issuesResponse[widget
                                                          .cardIndex]
                                                      ['label_details'][0]
                                                      ['color']
                                                  .replaceAll('#', '0xFF'))),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        CustomText(
                                          '${provider.issuesResponse[widget.cardIndex]['label_details'].length} Labels',
                                          fontSize: 13,
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
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
                                        height: 20,
                                        padding: const EdgeInsets.only(
                                          left: 8,
                                          right: 8,
                                        ),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: themeProvider
                                                        .isDarkThemeEnabled
                                                    ? darkThemeBorder
                                                    : lightGreeyColor),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              radius: 5,
                                              backgroundColor: Color(int.parse(
                                                  provider.issuesResponse[
                                                          widget.cardIndex]
                                                          ['label_details'][idx]
                                                          ['color']
                                                      .replaceAll(
                                                          '#', '0xFF'))),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            CustomText(
                                              provider.issuesResponse[
                                                          widget.cardIndex]
                                                      ['label_details'][idx]
                                                  ['name'],
                                              fontSize: 13,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                          )
                        : (provider.issues.displayProperties.label == true &&
                                provider
                                    .issuesResponse[widget.cardIndex]
                                        ['label_details']
                                    .isEmpty)
                            ? Container(
                                height: 20,
                                padding: const EdgeInsets.only(
                                  left: 8,
                                  right: 8,
                                ),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: themeProvider.isDarkThemeEnabled
                                            ? darkThemeBorder
                                            : lightGreeyColor),
                                    borderRadius: BorderRadius.circular(5)),
                                child: const CustomText(
                                  'No Label',
                                  fontSize: 13,
                                ),
                              )
                            : Container(),
                    provider.issues.displayProperties.dueDate == true
                        ? Container(
                            height: 30,
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 5, bottom: 5),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: themeProvider.isDarkThemeEnabled
                                        ? darkThemeBorder
                                        : lightGreeyColor),
                                borderRadius: BorderRadius.circular(5)),
                            child: CustomText(
                              provider.issuesResponse[widget.cardIndex]
                                      ['start_date'] ??
                                  'Due date',
                              type: FontStyle.XSmall,
                              color:
                                  themeProvider.themeManager.secondaryTextColor,
                            ),
                          )
                        : Container(),
                    provider.issues.displayProperties.subIsseCount == true
                        ? Container(
                            height: 30,
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 5, bottom: 5),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: themeProvider.isDarkThemeEnabled
                                        ? darkThemeBorder
                                        : lightGreeyColor),
                                borderRadius: BorderRadius.circular(5)),
                            child: Wrap(
                              children: [
                                // SvgPicture.asset(
                                //   'assets/svg_images/sub_issue.svg',
                                //   height: 15,
                                //   width: 15,
                                //   color: themeProvider.isDarkThemeEnabled
                                //       ? lightBackgroundColor
                                //       : darkBackgroundColor,
                                // ),
                                SvgPicture.asset(
                                    'assets/svg_images/issues_icon.svg',
                                    width: 15,
                                    height: 15,
                                    colorFilter: const ColorFilter.mode(
                                        greyColor, BlendMode.srcIn)),
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
                                  fontSize: 13,
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    provider.issues.displayProperties.linkCount == true
                        ? Container(
                            height: 30,
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 5, bottom: 5),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: themeProvider.isDarkThemeEnabled
                                        ? darkThemeBorder
                                        : lightGreeyColor),
                                borderRadius: BorderRadius.circular(5)),
                            child: Wrap(
                              children: [
                                // SvgPicture.asset(
                                //   'assets/svg_images/sub_issue.svg',
                                //   height: 15,
                                //   width: 15,
                                //   color: themeProvider.isDarkThemeEnabled
                                //       ? lightBackgroundColor
                                //       : darkBackgroundColor,
                                // ),
                                Transform.rotate(
                                  angle: 33.6,
                                  child: const Icon(
                                    Icons.link,
                                    size: 18,
                                    color: greyColor,
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
                                  fontSize: 13,
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    provider.issues.displayProperties.attachmentCount == true
                        ? Container(
                            height: 30,
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 5, bottom: 5),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: themeProvider.isDarkThemeEnabled
                                        ? darkThemeBorder
                                        : lightGreeyColor),
                                borderRadius: BorderRadius.circular(5)),
                            child: Wrap(
                              children: [
                                // SvgPicture.asset(
                                //   'assets/svg_images/sub_issue.svg',
                                //   height: 15,
                                //   width: 15,
                                //   color: themeProvider.isDarkThemeEnabled
                                //       ? lightBackgroundColor
                                //       : darkBackgroundColor,
                                // ),
                                const Icon(
                                  Icons.attach_file,
                                  size: 18,
                                  color: greyColor,
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
                                  fontSize: 13,
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
                                left: 8, right: 8, top: 5, bottom: 5),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: themeProvider.isDarkThemeEnabled
                                        ? darkThemeBorder
                                        : lightGreeyColor),
                                borderRadius: BorderRadius.circular(5)),
                            child: Wrap(
                              children: [
                                // SvgPicture.asset(
                                //   'assets/svg_images/sub_issue.svg',
                                //   height: 15,
                                //   width: 15,
                                //   color: themeProvider.isDarkThemeEnabled
                                //       ? lightBackgroundColor
                                //       : darkBackgroundColor,
                                // ),
                                const Icon(
                                  Icons.change_history,
                                  size: 16,
                                  color: greyColor,
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
                          color: themeProvider.isDarkThemeEnabled
                              ? darkThemeBorder
                              : strokeColor),
                      borderRadius: BorderRadius.circular(5)),
                  margin: const EdgeInsets.only(right: 15),
                  height: 30,
                  width: 30,
                  child: provider.issuesResponse[widget.cardIndex]
                              ['priority'] ==
                          null
                      ? const Icon(
                          Icons.do_disturb_alt_outlined,
                          size: 18,
                          color: greyColor,
                        )
                      : provider.issuesResponse[widget.cardIndex]['priority'] ==
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
                      fontSize: 14,
                      color: themeProvider.isDarkThemeEnabled
                          ? Colors.grey.shade400
                          : darkBackgroundColor,
                      fontWeight: FontWeight.w500,
                      widgets: [
                        TextSpan(
                            text: provider.issuesResponse[widget.cardIndex]
                                ['project_detail']['identifier'],
                            style: TextStyle(
                              color: themeProvider.isDarkThemeEnabled
                                  ? darkSecondaryTextColor
                                  : lightSecondaryTextColor,
                            )),
                        TextSpan(
                            text:
                                '-${provider.issuesResponse[widget.cardIndex]['sequence_id']}',
                            style: TextStyle(
                              color: themeProvider.isDarkThemeEnabled
                                  ? darkSecondaryTextColor
                                  : lightSecondaryTextColor,
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
                provider.issuesResponse[widget.cardIndex]['name'],
                type: FontStyle.Small,
                fontWeight: FontWeightt.Medium,
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
                              color: themeProvider.isDarkThemeEnabled
                                  ? darkThemeBorder
                                  : lightGreeyColor),
                          borderRadius: BorderRadius.circular(5)),
                      child: const Icon(
                        Icons.groups_2_outlined,
                        size: 18,
                        color: greyColor,
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
