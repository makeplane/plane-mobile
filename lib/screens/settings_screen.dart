import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/bottom_sheets/create_estimate.dart';
import 'package:plane/bottom_sheets/project_invite_memebers_sheet.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/Settings/control_page.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/Settings/estimates_page.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/Settings/features_page.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/Settings/general_page.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/Settings/integrations_page.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/Settings/lables_page.dart';
import 'package:plane/screens/MainScreens/Profile/WorkpsaceSettings/members.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/Settings/states_pages.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/loading_widget.dart';

import 'MainScreens/Projects/ProjectDetail/Settings/create_label.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen>
    with TickerProviderStateMixin {
  List<String> tabs = [
    'General',
    'Control',
    'Members',
    'Features',
    'States',
    'Labels',
    'Integrations',
    'Estimates',
  ];

  var pageViewController = PageController(initialPage: 0);

  int selectedIndex = 0;
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabs.length, vsync: this);

    tabController!.addListener(() {
      log('executed');
      setState(() {
        selectedIndex = tabController!.index;
        // tabController!.animateTo(selectedIndex);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var projectprovider = ref.watch(ProviderList.projectProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var estimatesProvider = ref.watch(ProviderList.estimatesProvider);
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        // backgroundColor: themeProvider.secondaryBackgroundColor,
        appBar: AppBar(
            elevation: 0,
            //shadowColor: themeProvider.themeManager.borderSubtle01Color,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.close,
                color: themeProvider.themeManager.primaryTextColor,
              ),
            ),
            centerTitle: true,
            backgroundColor:
                themeProvider.themeManager.primaryBackgroundDefaultColor,
            title: CustomText(
              'Settings',
              type: FontStyle.Large,
              fontWeight: FontWeightt.Semibold,
              maxLines: 1,
              color: themeProvider.themeManager.primaryTextColor,
            ),
            bottom: hasAccess()
                ? PreferredSize(
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
                                    color: themeProvider
                                        .themeManager.primaryColour,
                                    width: 6,
                                  ),
                                ),
                              ),
                              // indicatorColor: primaryColor,
                              labelColor:
                                  themeProvider.themeManager.primaryColour,
                              indicatorWeight: 9,
                              splashFactory: NoSplash.splashFactory,
                              onTap: (index) {
                                setState(() {
                                  selectedIndex = index;
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
                                        color: tabs.indexOf(e) == selectedIndex
                                            ? themeProvider
                                                .themeManager.primaryColour
                                            : themeProvider.themeManager
                                                .secondaryTextColor,
                                        overrride: true,
                                      ),
                                    ),
                                  )
                                  .toList()),
                        ),
                      ],
                    ),
                  )
                : null),
        floatingActionButton: selectedIndex == 2 ||
                selectedIndex == 5 ||
                (selectedIndex == 7 && estimatesProvider.estimates.isNotEmpty)
            ? FloatingActionButton(
                onPressed: () {
                  if (selectedIndex == 2) {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      enableDrag: true,
                      constraints: BoxConstraints(maxHeight: height * 0.7),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      context: context,
                      builder: (ctx) {
                        return Container(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: const ProjectInviteMembersSheet());
                      },
                    );
                  }
                  if (selectedIndex == 5) {
                    showModalBottomSheet(
                      enableDrag: true,
                      isScrollControlled: true,
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.8,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: const CreateLabel(
                            method: CRUD.create,
                          ),
                        );
                      },
                    );
                  }
                  if (selectedIndex == 7) {
                    showModalBottomSheet(
                      enableDrag: true,
                      isScrollControlled: true,
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.8,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: const CreateEstimate(),
                        );
                      },
                    );
                  }
                },
                backgroundColor: themeProvider.themeManager.primaryColour,
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              )
            : Container(),
        body: LoadingWidget(
          loading: projectprovider.deleteProjectState == StateEnum.loading,
          widgetClass: SizedBox(
            height: height,
            child: Column(
              children: [
                Container(
                  height: 1,
                  //width: double.infinity,
                  color: themeProvider.themeManager.borderSubtle01Color,
                ),
                //grey line
                const SizedBox(
                  height: 1,
                  width: double.infinity,
                  // color: themeProvider.secondaryBackgroundColor,
                ),

                // SizedBox(
                //   //padding: const EdgeInsets.symmetric(horizontal: 20),
                //   // color: themeProvider.backgroundColor,
                //   height: 31,
                //   child: ListView.builder(
                //     padding: const EdgeInsets.only(left: 16),
                //     // physics: const BouncingScrollPhysics(),
                //     scrollDirection: Axis.horizontal,
                //     itemCount: tabs.length,
                //     itemBuilder: (context, index) {
                //       return GestureDetector(
                //         onTap: () {
                //           setState(() {
                //             selectedIndex = index;
                //           });
                //           pageViewController.jumpToPage(index);
                //         },
                //         child: Padding(
                //           padding: const EdgeInsets.only(right: 20),
                //           child: Column(
                //             children: [
                //               CustomText(
                //                 tabs[index],
                //                 type: FontStyle.Medium,
                //                 color: index == selectedIndex
                //                     ? primaryColor
                //                     : lightGreyTextColor,
                //               ),
                //               const SizedBox(height: 5),
                //               Container(
                //                 height: 7,
                //                 //set the width of the container to the length of the text
                //                 width: tabs[index].length * 10.1,
                //                 decoration: BoxDecoration(
                //                   color: selectedIndex == index
                //                       ? const Color.fromRGBO(63, 118, 255, 1)
                //                       : Colors.transparent,
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                // ),
                // Container(
                //   height: 2,
                //   width: MediaQuery.of(context).size.width,
                //   color: themeProvider.isDarkThemeEnabled
                //       ? darkThemeBorder
                //       : const Color(0xFFE5E5E5),
                // ),
                //grey line
                const SizedBox(
                  height: 1,
                  width: double.infinity,
                  // color: themeProvider.secondaryBackgroundColor,
                ),
                Expanded(
                  child: TabBarView(
                      controller: tabController,
                      physics: hasAccess()
                          ? const BouncingScrollPhysics()
                          : const NeverScrollableScrollPhysics(),
                      children: const [
                        GeneralPage(),
                        ControlPage(),
                        MembersListWidget(
                          fromWorkspace: false,
                        ),
                        FeaturesPage(),
                        StatesPage(),
                        LablesPage(),
                        IntegrationsWidget(),
                        EstimatsPage()
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool hasAccess() {
    var projectProvider = ref.watch(ProviderList.projectProvider);
    var profileProvider = ref.watch(ProviderList.profileProvider);
    List members = projectProvider.projectMembers;
    bool hasAccess = false;
    for (var element in members) {
      if ((element['member']['id'] == profileProvider.userProfile.id) &&
          (element['role'] == 20 || element['role'] == 15)) {
        hasAccess = true;
      }
    }
    return hasAccess;
  }
}
