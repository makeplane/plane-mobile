import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/MainScreens/Profile/member_profile.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/IssuesTab/issue_detail_screen.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_app_bar.dart';
import 'package:plane/widgets/custom_rich_text.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/error_state.dart';
import 'package:plane/widgets/loading_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class Activity extends ConsumerStatefulWidget {
  const Activity({super.key});

  @override
  ConsumerState<Activity> createState() => _ActivityState();
}

class _ActivityState extends ConsumerState<Activity> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.watch(ProviderList.activityProvider).getAcivity(
            slug: ref
                .read(ProviderList.workspaceProvider)
                .selectedWorkspace!
                .workspaceSlug,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    var activityProvider = ref.watch(ProviderList.activityProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Scaffold(
      // backgroundColor: themeProvider.isDarkThemeEnabled
      //     ? darkSecondaryBackgroundColor
      //     : lightSecondaryBackgroundColor,

      appBar: CustomAppBar(
          onPressed: () {
            Navigator.pop(context);
          },
          text: "Activity"),

      body: LoadingWidget(
          loading: activityProvider.getActivityState == StateEnum.loading,
          widgetClass: activityProvider.getActivityState == StateEnum.success
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: activityProvider.data.isEmpty
                              ? const Center(
                                  child: CustomText('No Activity'),
                                )
                              : ListView.builder(
                                  primary: false,
                                  shrinkWrap: true,
                                  itemCount: activityProvider.data.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        log('TApped');
                                        if (activityProvider.data[index]
                                                ["comment"]
                                            .toString()
                                            .contains("created the issue")) {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (_) => IssueDetail(
                                                        fromMyIssues: true,
                                                        projID: activityProvider
                                                                .data[index]
                                                            ["project"],
                                                        workspaceSlug: ref
                                                            .read(ProviderList
                                                                .workspaceProvider)
                                                            .workspaces
                                                            .firstWhere((element) =>
                                                                element['id'] ==
                                                                activityProvider
                                                                            .data[
                                                                        index][
                                                                    "workspace"])["slug"],
                                                        appBarTitle: '',
                                                        issueId:
                                                            activityProvider
                                                                    .data[index]
                                                                ["issue"],
                                                      )));
                                        } else if (activityProvider.data[index]
                                                ["comment"]
                                            .toString()
                                            .contains("created a link")) {
                                          if (!await launchUrl(Uri.parse(
                                              activityProvider.data[index]
                                                      ["new_value"]
                                                  .toString()))) {
                                            // ignore: use_build_context_synchronously
                                            CustomToast.showToast(context,
                                                message: 'Failed to launch',
                                                toastType: ToastType.failure);
                                          }
                                        }
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 15, top: 15),
                                            child:
                                                activityProvider.data[index]
                                                                ['comment'] !=
                                                            null &&
                                                        activityProvider
                                                                    .data[index]
                                                                ['field'] ==
                                                            null
                                                    ? SizedBox(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            CircleAvatar(
                                                              backgroundColor:
                                                                  themeProvider
                                                                      .themeManager
                                                                      .borderSubtle01Color,
                                                              radius: 16,
                                                              child:
                                                                  CircleAvatar(
                                                                backgroundColor:
                                                                    themeProvider
                                                                        .themeManager
                                                                        .tertiaryBackgroundDefaultColor,
                                                                radius: 15,
                                                                child: Center(
                                                                  child:
                                                                      CustomText(
                                                                    activityProvider
                                                                        .data[
                                                                            index]
                                                                            [
                                                                            'actor_detail']
                                                                            [
                                                                            'first_name']
                                                                            [0]
                                                                        .toString()
                                                                        .toUpperCase(),
                                                                    // color: Colors.black,
                                                                    type: FontStyle
                                                                        .Medium,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            SizedBox(
                                                              width: MediaQuery
                                                                          .sizeOf(
                                                                              context)
                                                                      .width -
                                                                  80,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  GestureDetector(
                                                                    child: Wrap(
                                                                      children: [
                                                                        // CustomText(
                                                                        //   "${activityProvider.data[index]['actor_detail']['display_name']} ${activityProvider.data[index]['comment']}",
                                                                        //   fontSize:
                                                                        //       14,
                                                                        //   type: FontStyle
                                                                        //       .Medium,
                                                                        //   textAlign:
                                                                        //       TextAlign.left,
                                                                        //   maxLines:
                                                                        //       4,
                                                                        //   color: themeProvider
                                                                        //       .themeManager
                                                                        //       .primaryTextColor,
                                                                        // ),

                                                                        CustomRichText(
                                                                          type:
                                                                              FontStyle.Small,
                                                                          widgets: [
                                                                            TextSpan(
                                                                              text: '${activityProvider.data[index]['actor_detail']['display_name']} ',
                                                                              recognizer: TapGestureRecognizer()
                                                                                ..onTap = () {
                                                                                  Navigator.of(context).push(MaterialPageRoute(
                                                                                      builder: (_) => MemberProfile(
                                                                                            userID: activityProvider.data[index]["actor_detail"]["id"],
                                                                                          )));
                                                                                },
                                                                              style: TextStyle(
                                                                                color: themeProvider.themeManager.primaryTextColor,
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                            TextSpan(
                                                                              text: '${activityProvider.data[index]['comment']}',
                                                                              style: TextStyle(
                                                                                color: themeProvider.themeManager.primaryTextColor,
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w400,
                                                                              ),
                                                                            ),
                                                                            TextSpan(
                                                                              recognizer: TapGestureRecognizer()
                                                                                ..onTap = () {
                                                                                  Navigator.of(context).push(MaterialPageRoute(
                                                                                      builder: (_) => IssueDetail(
                                                                                            fromMyIssues: true,
                                                                                            projID: activityProvider.data[index]["project"],
                                                                                            workspaceSlug: ref.read(ProviderList.workspaceProvider).workspaces.firstWhere((element) => element['id'] == activityProvider.data[index]["workspace"])["slug"],
                                                                                            appBarTitle: '',
                                                                                            issueId: activityProvider.data[index]["issue"],
                                                                                          )));
                                                                                },
                                                                              text: activityProvider.data[index]['issue_detail'] != null ? ' ${activityProvider.data[index]['project_detail']['identifier']} - ${activityProvider.data[index]['issue_detail']['sequence_id']}' : '',
                                                                              style: TextStyle(
                                                                                color: themeProvider.themeManager.primaryTextColor,
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        // const SizedBox(
                                                                        //   width:
                                                                        //       5,
                                                                        // ),
                                                                        // activityProvider.data[index]["comment"].toString().contains("created the issue") ||
                                                                        //         activityProvider.data[index]["comment"].toString().contains("created a link")
                                                                        //     ? SvgPicture.asset(
                                                                        //         "assets/svg_images/redirect.svg",
                                                                        //         height: 15,
                                                                        //         width: 15,
                                                                        //         // ignore: deprecated_member_use
                                                                        //         color: themeProvider.themeManager.primaryTextColor,
                                                                        //       )
                                                                        //     : Container()
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          6),
                                                                  CustomText(
                                                                    checkTimeDifferenc(
                                                                        activityProvider.data[index]
                                                                            [
                                                                            'created_at']),
                                                                    color: themeProvider
                                                                        .themeManager
                                                                        .primaryTextColor,
                                                                    type: FontStyle
                                                                        .Small,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    maxLines: 4,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          CircleAvatar(
                                                            backgroundColor:
                                                                themeProvider
                                                                    .themeManager
                                                                    .borderSubtle01Color,
                                                            radius: 16,
                                                            child: CircleAvatar(
                                                              backgroundColor:
                                                                  themeProvider
                                                                      .themeManager
                                                                      .tertiaryBackgroundDefaultColor,
                                                              radius: 15,
                                                              child: Center(
                                                                  child: activityProvider.data[index]
                                                                              [
                                                                              'field'] ==
                                                                          'state'
                                                                      ? Icon(
                                                                          Icons
                                                                              .grid_view_outlined,
                                                                          size:
                                                                              15,
                                                                          color: themeProvider
                                                                              .themeManager
                                                                              .primaryTextColor,
                                                                        )
                                                                      : activityProvider.data[index]['field'] ==
                                                                              'priority'
                                                                          ? SvgPicture
                                                                              .asset(
                                                                              'assets/svg_images/priority.svg',
                                                                              height: 15,
                                                                              width: 15,
                                                                              colorFilter: ColorFilter.mode(themeProvider.themeManager.primaryTextColor, BlendMode.srcIn),
                                                                            )
                                                                          : activityProvider.data[index]['field'] == 'assignees' || activityProvider.data[index]['field'] == 'assignee'
                                                                              ? Icon(
                                                                                  Icons.people_outline,
                                                                                  size: 18,
                                                                                  color: themeProvider.themeManager.primaryTextColor,
                                                                                )
                                                                              : activityProvider.data[index]['field'] == 'labels'
                                                                                  ? Icon(
                                                                                      Icons.local_offer_outlined,
                                                                                      size: 15,
                                                                                      color: themeProvider.themeManager.primaryTextColor,
                                                                                    )
                                                                                  : activityProvider.data[index]['field'] == 'blocks'
                                                                                      ? SvgPicture.asset(
                                                                                          'assets/svg_images/blocked_icon.svg',
                                                                                          height: 15,
                                                                                          width: 15,
                                                                                          colorFilter: ColorFilter.mode(themeProvider.themeManager.primaryTextColor, BlendMode.srcIn),
                                                                                        )
                                                                                      : activityProvider.data[index]['field'] == 'blocking'
                                                                                          ? SvgPicture.asset(
                                                                                              'assets/svg_images/blocking_icon.svg',
                                                                                              height: 15,
                                                                                              width: 15,
                                                                                              colorFilter: ColorFilter.mode(themeProvider.themeManager.primaryTextColor, BlendMode.srcIn),
                                                                                            )
                                                                                          : activityProvider.data[index]['field'] == 'description'
                                                                                              ? Icon(
                                                                                                  Icons.comment_outlined,
                                                                                                  color: themeProvider.themeManager.primaryTextColor,
                                                                                                  size: 15,
                                                                                                )
                                                                                              : activityProvider.data[index]['field'] == 'link'
                                                                                                  ? SvgPicture.asset('assets/svg_images/link.svg', height: 15, width: 15, colorFilter: ColorFilter.mode(themeProvider.themeManager.primaryTextColor, BlendMode.srcIn))
                                                                                                  : activityProvider.data[index]['field'] == 'modules'
                                                                                                      ? SvgPicture.asset('assets/svg_images/module.svg', height: 18, width: 18, colorFilter: ColorFilter.mode(themeProvider.themeManager.primaryTextColor, BlendMode.srcIn))
                                                                                                      : activityProvider.data[index]['field'] == 'cycles'
                                                                                                          ? SvgPicture.asset('assets/svg_images/cycles_icon.svg', height: 22, width: 22, colorFilter: ColorFilter.mode(themeProvider.themeManager.primaryTextColor, BlendMode.srcIn))
                                                                                                          : activityProvider.data[index]['field'] == 'attachment'
                                                                                                              ? SvgPicture.asset('assets/svg_images/attachment.svg', height: 20, width: 20, colorFilter: ColorFilter.mode(themeProvider.themeManager.primaryTextColor, BlendMode.srcIn))
                                                                                                              : activityProvider.data[index]['field'] == 'parent'
                                                                                                                  ? Icon(
                                                                                                                      Icons.person_outline,
                                                                                                                      size: 16,
                                                                                                                      color: themeProvider.themeManager.primaryTextColor,
                                                                                                                    )
                                                                                                                  : SvgPicture.asset('assets/svg_images/calendar_icon.svg', height: 15, width: 15, colorFilter: ColorFilter.mode(themeProvider.themeManager.primaryTextColor, BlendMode.srcIn))),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          SizedBox(
                                                            width: MediaQuery
                                                                        .sizeOf(
                                                                            context)
                                                                    .width -
                                                                80,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                GestureDetector(
                                                                  child: Wrap(
                                                                    children: [
                                                                      // CustomText(
                                                                      //   '${activityFormat(activityProvider.data[index])} ',
                                                                      //   fontSize:
                                                                      //       14,
                                                                      //   type: FontStyle
                                                                      //       .Medium,
                                                                      //   textAlign:
                                                                      //       TextAlign
                                                                      //           .left,
                                                                      //   maxLines:
                                                                      //       4,
                                                                      //   color: themeProvider
                                                                      //       .themeManager
                                                                      //       .primaryTextColor,
                                                                      // ),
                                                                      CustomRichText(
                                                                        type: FontStyle
                                                                            .Small,
                                                                        widgets: [
                                                                          TextSpan(
                                                                            text:
                                                                                '${activityProvider.data[index]['actor_detail']['display_name']} ',
                                                                            recognizer: TapGestureRecognizer()
                                                                              ..onTap = () {
                                                                                Navigator.of(context).push(MaterialPageRoute(
                                                                                    builder: (_) => MemberProfile(
                                                                                          userID: activityProvider.data[index]["actor_detail"]["id"],
                                                                                        )));
                                                                              },
                                                                            style:
                                                                                TextStyle(
                                                                              color: themeProvider.themeManager.primaryTextColor,
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                          TextSpan(
                                                                            text:
                                                                                '${activityFormat(activityProvider.data[index])} ',
                                                                            style:
                                                                                TextStyle(
                                                                              color: themeProvider.themeManager.primaryTextColor,
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                          TextSpan(
                                                                            recognizer: TapGestureRecognizer()
                                                                              ..onTap = () {
                                                                                Navigator.of(context).push(MaterialPageRoute(
                                                                                    builder: (_) => IssueDetail(
                                                                                          fromMyIssues: true,
                                                                                          projID: activityProvider.data[index]["project"],
                                                                                          workspaceSlug: ref.read(ProviderList.workspaceProvider).workspaces.firstWhere((element) => element['id'] == activityProvider.data[index]["workspace"])["slug"],
                                                                                          appBarTitle: '',
                                                                                          issueId: activityProvider.data[index]["issue"],
                                                                                        )));
                                                                              },
                                                                            text: activityProvider.data[index]['issue_detail'] != null
                                                                                ? '${activityProvider.data[index]['project_detail']['identifier']} - ${activityProvider.data[index]['issue_detail']['sequence_id']}'
                                                                                : '',
                                                                            style:
                                                                                TextStyle(
                                                                              color: themeProvider.themeManager.primaryTextColor,
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      activityProvider.data[index]["comment"].toString().contains("created the issue") ||
                                                                              activityProvider.data[index]["comment"].toString().contains(
                                                                                  "created a link")
                                                                          ? SvgPicture.asset(
                                                                              "assets/svg_images/redirect.svg",
                                                                              height: 15,
                                                                              width: 15,
                                                                              colorFilter: ColorFilter.mode(themeProvider.themeManager.primaryTextColor, BlendMode.srcIn))
                                                                          : Container()
                                                                    ],
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    height: 6),
                                                                CustomText(
                                                                  ' ${checkTimeDifferenc(activityProvider.data[index]['created_at'])}',
                                                                  color: themeProvider
                                                                      .themeManager
                                                                      .primaryTextColor,
                                                                  type: FontStyle
                                                                      .Small,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  maxLines: 4,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                          ),
                                          Container(
                                              height: 1,
                                              width: width,
                                              color: themeProvider.themeManager
                                                  .borderDisabledColor)
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                )
              : errorState(
                  context: context,
                  ontap: () {
                    ref.watch(ProviderList.activityProvider).getAcivity(
                          slug: ref
                              .read(ProviderList.workspaceProvider)
                              .selectedWorkspace!
                              .workspaceSlug,
                        );
                  },
                )),
    );
  }

  String checkTimeDifferenc(String dateTime) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(DateTime.parse(dateTime));
    String? format;

    if (difference.inDays > 0) {
      format = '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      format = '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      format = '${difference.inMinutes} minutes ago';
    } else {
      format = '${difference.inSeconds} seconds ago';
    }

    return format;
  }

  String activityFormat(Map activity) {
    String formattedActivity = '';
    if (activity['actor_detail']['first_name'] != null &&
        activity['actor_detail']['last_name'] != null) {
      if (activity['field'] == 'description') {
        formattedActivity = activity['actor_detail']['display_name'] +
            ' updated the description to ';
      } else {
        formattedActivity = "${activity['comment']} ";
      }
      if (activity['issue_detail'] != null) {
        formattedActivity += "to ";
      }
      return formattedActivity;
    } else {
      return activity['actor_detail']['email'];
    }
  }
}
