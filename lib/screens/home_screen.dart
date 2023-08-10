import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plane_startup/screens/MainScreens/My_issues/my_issues_screen.dart';
import 'package:plane_startup/screens/MainScreens/Notification/notification.dart';
import 'package:plane_startup/screens/MainScreens/Profile/ProfileSettings/profile_screen.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import 'package:plane_startup/widgets/error_state.dart';

import 'MainScreens/Home/dash_board_screen.dart';
import 'MainScreens/Projects/project_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final bool fromSignUp;
  const HomeScreen({required this.fromSignUp, super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int currentIndex = 0;
  List navBarItems = [
    {'icon': 'assets/svg_images/home.svg', 'label': 'Home'},
    {'icon': 'assets/svg_images/projects.svg', 'label': 'Projects'},
    {'icon': 'assets/svg_images/issues.svg', 'label': 'My Issues'},
    {'icon': 'assets/svg_images/notification.svg', 'label': 'Updates'},
    {'icon': 'assets/svg_images/settings.svg', 'label': 'Settings'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.watch(ProviderList.myIssuesProvider).getMyIssues(
            slug: ref
                .watch(ProviderList.workspaceProvider)
                .selectedWorkspace!
                .workspaceSlug,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var profileProvider = ref.watch(ProviderList.profileProvider);
    themeProvider.context = context;
    final screens = [
      DashBoardScreen(
        fromSignUp: widget.fromSignUp,
      ),
      const ProjectScreen(),
      const MyIssuesScreen(),
      const NotifiactionScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      body: SafeArea(
        child: 
        profileProvider.getProfileState == StateEnum.success ?
        screens[currentIndex]
        : profileProvider.getProfileState == StateEnum.error ?
        errorState(context: context) : Container(),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: Platform.isAndroid ? const EdgeInsets.only(bottom: 10) : EdgeInsets.zero,
          height: 68,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                  color: themeProvider.themeManager.borderSubtle01Color,
                  width: 1),
            ),
          ),
          // padding: const EdgeInsets.only(
          //   top: 15,
          // ),
          child: Center(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: navBarItems
                    .asMap()
                    .map(
                      (i, e) => MapEntry(
                        i,
                        InkWell(
                          highlightColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            if (i == 0) {
                              ref
                                  .read(ProviderList.dashboardProvider)
                                  .getDashboard();
                            }
                            setState(() {
                              currentIndex = i;
                            });
                          },
                          child: Column(
                            children: [
                              Container(
                                height: 7,
                                width: 50,
                                color: currentIndex == i
                                    ? primaryColor
                                    : Colors.transparent,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SvgPicture.asset(e['icon'],
                                  height: 20,
                                  width: 20,
                                  colorFilter: ColorFilter.mode(
                                      currentIndex == i
                                          ? primaryColor
                                          : (themeProvider.themeManager.placeholderTextColor),
                                      BlendMode.srcIn)),
                              const SizedBox(
                                height: 8,
                              ),
                              CustomText(
                                e['label'],
                                type: FontStyle.Small,
                                color: currentIndex == i
                                    ? primaryColor
                                    : (themeProvider.themeManager.placeholderTextColor),
                                fontWeight: FontWeightt.Medium,
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                    .values
                    .toList()),
          ),
        ),
      ),
    );
  }
}
