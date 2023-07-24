import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plane_startup/screens/MainScreens/Activity/activity.dart';
import 'package:plane_startup/screens/MainScreens/My_issues/my_issues_screen.dart';
import 'package:plane_startup/screens/MainScreens/Profile/ProfileSettings/profile_screen.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/widgets/custom_text.dart';

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
    {'icon': 'assets/svg_images/activity.svg', 'label': 'Activity'},
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
    themeProvider.context = context;
    final screens = [
      DashBoardScreen(
        fromSignUp: widget.fromSignUp,
      ),
      const ProjectScreen(),
      const MyIssuesScreen(),
      const Activity(),
      const ProfileScreen(),
    ];
    return Scaffold(
        body: SafeArea(
          child: screens[currentIndex],
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 63,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                    color: themeProvider.isDarkThemeEnabled
                        ? darkThemeBorder
                        : strokeColor,
                    width: 2),
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
                              if(i==0){
                                ref.read(ProviderList.dashboardProvider).getDashboard();
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
                                SvgPicture.asset(
                                  e['icon'],
                                  height: 20,
                                  width: 20,
                                    colorFilter:  ColorFilter.mode(currentIndex == i
                                      ? primaryColor
                                      : (themeProvider.isDarkThemeEnabled
                                          ? darkSecondaryTextColor
                                          : bottomNavTextColor), BlendMode.srcIn)
                            
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                CustomText(
                                  e['label'],
                                  type: FontStyle.smallText,
                                  color: currentIndex == i
                                      ? primaryColor
                                      : (themeProvider.isDarkThemeEnabled
                                          ? darkSecondaryTextColor
                                          : bottomNavTextColor),
                                  fontWeight: FontWeight.w500,
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
        )
        // BottomNavigationBar(
        //   onTap: (value) {
        //     setState(() {
        //       currentIndex = value;
        //     });
        //   },
        //   currentIndex: currentIndex,
        //   type: BottomNavigationBarType.fixed,
        //   selectedItemColor: primaryColor,

        //   // unselectedItemColor: themeProvider.secondaryTextColor,
        //   unselectedItemColor: themeProvider.isDarkThemeEnabled
        //       ? darkSecondaryTextColor
        //       : lightSecondaryTextColor,
        //   // backgroundColor: themeProvider.secondaryBackgroundColor,
        //   backgroundColor: themeProvider.isDarkThemeEnabled
        //       ? darkBackgroundColor
        //       : lightBackgroundColor,

        //   elevation: 5,
        //   items: [
        //     BottomNavigationBarItem(
        //       icon: SvgPicture.asset(
        //         'assets/svg_images/home.svg',
        //         color: currentIndex == 0 ? primaryColor : greyColor,
        //       ),
        //       label: 'Home',
        //     ),
        //     BottomNavigationBarItem(
        //         icon: SvgPicture.asset(
        //           'assets/svg_images/projects.svg',
        //           color: currentIndex == 1 ? primaryColor : greyColor,
        //         ),
        //         label: 'Projects'),
        //     BottomNavigationBarItem(
        //         icon: SvgPicture.asset(
        //           'assets/svg_images/issues.svg',
        //           color: currentIndex == 2 ? primaryColor : greyColor,
        //         ),
        //         label: 'Issues'),
        //     BottomNavigationBarItem(
        //         icon: SvgPicture.asset(
        //           'assets/svg_images/activity.svg',
        //           color: currentIndex == 3 ? primaryColor : greyColor,
        //         ),
        //         label: 'Activity'),
        //     BottomNavigationBarItem(
        //         icon: SvgPicture.asset(
        //           'assets/svg_images/profile.svg',
        //           color: currentIndex == 4 ? primaryColor : greyColor,
        //         ),
        //         label: 'Profile')
        //   ],
        // ),

        );
  }
}
