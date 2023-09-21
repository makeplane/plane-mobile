import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/MainScreens/Profile/User_profile/assigned_issues.dart';
import 'package:plane/screens/MainScreens/Profile/User_profile/created_issue_page.dart.dart';
import 'package:plane/screens/MainScreens/Profile/User_profile/member_profile.dart';
import 'package:plane/screens/MainScreens/Profile/User_profile/over_view.dart';
import 'package:plane/screens/MainScreens/Profile/User_profile/subscribed_issues.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  final String userID;
  const UserProfileScreen(
      {required this.userID, super.key});

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen>
    with TickerProviderStateMixin {
  var pageViewController = PageController(initialPage: 0);

  TabController? tabController;

  List tabs = ['Details', 'Overview', 'Assigned', 'Created', 'Subscribed'];

  int currentIndex = 0;

  @override
  void initState() {
    tabController = TabController(length: tabs.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        var memberprofileProvider =
            ref.read(ProviderList.memberProfileProvider.notifier);
        memberprofileProvider.getMemberProfile(userID: widget.userID);
        memberprofileProvider.getUserStats(userId: widget.userID).then((value) {
          memberprofileProvider.getIssuesCountByState();
          memberprofileProvider.addColors();
        });
        memberprofileProvider.getUserActivity(userId: widget.userID);
        ref
            .read(ProviderList.memberProfileProvider.notifier)
            .getuserCreeatedIssues(
              userId: widget.userID,
              createdByUserId: widget.userID,
            );
        ref
            .read(ProviderList.memberProfileProvider.notifier)
            .getuserAssingedIssues(
              userId: widget.userID,
              assignedUserId: widget.userID,
            );
        ref
            .read(ProviderList.memberProfileProvider.notifier)
            .getuserSubscribedIssues(
              userId: widget.userID,
              subscribedByUserId: widget.userID,
            );
      },
    );
    tabController!.addListener(() {
      setState(() {
        currentIndex = tabController!.index;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor:
                themeProvider.themeManager.secondaryBackgroundDefaultColor,
            title: const CustomText('Profile'),
            elevation: 0.1,
            automaticallyImplyLeading: true,
            leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: themeProvider.themeManager.primaryTextColor,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size(width, 60),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    color: themeProvider.themeManager.borderSubtle01Color,
                    height: 1,
                  ),
                  Theme(
                    data: ThemeData(highlightColor: Colors.transparent),
                    child: TabBar(
                      controller: tabController,
                      indicator: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: themeProvider.themeManager.primaryColour,
                            width: 6,
                          ),
                        ),
                      ),
                      labelColor: themeProvider.themeManager.primaryColour,
                      indicatorWeight: 9,
                      splashFactory: NoSplash.splashFactory,
                      onTap: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      isScrollable: true,
                      tabs: tabs
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: CustomText(
                                tabs[tabs.indexOf(e)],
                                type: FontStyle.Medium,
                                color: tabs.indexOf(e) == currentIndex
                                    ? themeProvider.themeManager.primaryColour
                                    : themeProvider
                                        .themeManager.secondaryTextColor,
                                overrride: true,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            )),
        body: Column(
          children: [
            Container(
              height: 1,
              color: themeProvider.themeManager.borderSubtle01Color,
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  MemberProfile(
                    userID: widget.userID,
                  ),
                  OverViewScreen(
                    userId: widget.userID,
                  ),
                  const UserAssignedIssuesPage(),
                  const CreatedIssuesPage(),
                  const SubscribesIssuesPage()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
