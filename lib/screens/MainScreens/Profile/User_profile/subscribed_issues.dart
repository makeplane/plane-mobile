import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/IssuesTab/issue_detail.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_rich_text.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/square_avatar_widget.dart';

class SubscribesIssuesPage extends ConsumerStatefulWidget {
  const SubscribesIssuesPage({super.key});

  @override
  ConsumerState<SubscribesIssuesPage> createState() =>
      _SubscribesIssuesPageState();
}

class _SubscribesIssuesPageState extends ConsumerState<SubscribesIssuesPage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final userProfileProvider = ref.watch(ProviderList.memberProfileProvider);
    return Container(
      color: themeProvider.themeManager.secondaryBackgroundDefaultColor,
      margin: const EdgeInsets.only(top: 5),
      child: userProfileProvider.getUserSubscribedIssuesState ==
              StateEnum.loading
          ? Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: LoadingIndicator(
                  indicatorType: Indicator.lineSpinFadeLoader,
                  colors: [themeProvider.themeManager.primaryTextColor],
                  strokeWidth: 1.0,
                  backgroundColor: Colors.transparent,
                ),
              ),
            )
          : userProfileProvider.userSubscribedIssues.isEmpty
              ? Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/svg_images/empty_issues.svg'),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: width * 0.7,
                        child: CustomText(
                          'Issues subscribed by ${userProfileProvider.memberProfile['user_data']['display_name'].toString()} will appear here',
                          textAlign: TextAlign.center,
                          type: FontStyle.Small,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: userProfileProvider.userSubscribedIssues.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IssueDetail(
                              from: PreviousScreen.profileSubscribedIssues,
                              appBarTitle: userProfileProvider
                                  .userSubscribedIssues[index].name
                                  .toString(),
                              issueId: userProfileProvider
                                  .userSubscribedIssues[index].id!,
                              projID: userProfileProvider
                                  .userSubscribedIssues[index]
                                  .projectDetail!
                                  .id,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                                color: themeProvider
                                    .themeManager.borderSubtle01Color),
                            bottom: BorderSide(
                              color: index ==
                                      userProfileProvider
                                              .createdIssues!.length -
                                          1
                                  ? themeProvider
                                      .themeManager.borderSubtle01Color
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: themeProvider
                                          .themeManager.borderSubtle01Color),
                                  borderRadius: BorderRadius.circular(5),
                                  color: userProfileProvider
                                              .userSubscribedIssues[index]
                                              .priority ==
                                          'urgent'
                                      ? Colors.red
                                      : null),
                              margin: const EdgeInsets.only(right: 15),
                              height: 30,
                              width: 30,
                              child: userProfileProvider
                                          .userSubscribedIssues[index]
                                          .priority ==
                                      null
                                  ? Icon(
                                      Icons.do_disturb_alt_outlined,
                                      size: 18,
                                      color: themeProvider
                                          .themeManager.tertiaryTextColor,
                                    )
                                  : userProfileProvider
                                              .userSubscribedIssues[index]
                                              .priority ==
                                          'urgent'
                                      ? const Icon(
                                          Icons.error_outline_rounded,
                                          color: Colors.white,
                                          size: 18,
                                        )
                                      : userProfileProvider
                                                  .userSubscribedIssues[index]
                                                  .priority ==
                                              'high'
                                          ? const Icon(
                                              Icons.signal_cellular_alt,
                                              color: Color.fromRGBO(
                                                  249, 115, 23, 1),
                                              size: 18,
                                            )
                                          : userProfileProvider
                                                      .userSubscribedIssues[
                                                          index]
                                                      .priority ==
                                                  'medium'
                                              ? const Icon(
                                                  Icons
                                                      .signal_cellular_alt_2_bar,
                                                  color: Color.fromRGBO(
                                                      234, 179, 9, 1),
                                                  size: 18,
                                                )
                                              : const Icon(
                                                  Icons
                                                      .signal_cellular_alt_1_bar,
                                                  color: Color.fromRGBO(
                                                      34, 197, 94, 1),
                                                  size: 18,
                                                ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: CustomRichText(
                                type: FontStyle.Small,
                                color: themeProvider
                                    .themeManager.placeholderTextColor,
                                widgets: [
                                  TextSpan(
                                      text: userProfileProvider
                                          .userSubscribedIssues[index]
                                          .projectDetail!
                                          .identifier,
                                      style: TextStyle(
                                        color: themeProvider
                                            .themeManager.placeholderTextColor,
                                      )),
                                  TextSpan(
                                    text:
                                        '-${userProfileProvider.userSubscribedIssues[index].sequenceId}',
                                    style: TextStyle(
                                      color: themeProvider
                                          .themeManager.placeholderTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: CustomText(
                                  userProfileProvider
                                      .userSubscribedIssues[index].name
                                      .toString()
                                      .trim(),
                                  type: FontStyle.Small,
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                            userProfileProvider.userSubscribedIssues[index]
                                            .assigneeDetails !=
                                        null &&
                                    userProfileProvider
                                        .userSubscribedIssues[index]
                                        .assigneeDetails!
                                        .isNotEmpty
                                ? SizedBox(
                                    height: 30,
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 30,
                                      child: SquareAvatarWidget(
                                        details: userProfileProvider
                                            .userSubscribedIssues[index]
                                            .assigneesList!,
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 30,
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8, top: 5, bottom: 5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: themeProvider.themeManager
                                              .borderSubtle01Color),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Icon(
                                      Icons.groups_2_outlined,
                                      size: 18,
                                      color: themeProvider
                                          .themeManager.tertiaryTextColor,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
