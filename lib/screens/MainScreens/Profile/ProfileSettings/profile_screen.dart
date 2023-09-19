import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/bottom_sheets/select_workspace.dart';
import 'package:plane/provider/profile_provider.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/provider/theme_provider.dart';
import 'package:plane/screens/Import%20&%20Export/import_export.dart';
import 'package:plane/screens/MainScreens/Activity/activity.dart';
import 'package:plane/screens/MainScreens/Profile/User_profile/user_profile.dart';
import 'package:plane/screens/Theming/prefrences.dart';
import 'package:plane/screens/integrations.dart';
import 'package:plane/screens/MainScreens/Profile/WorkpsaceSettings/members.dart';
import 'package:plane/screens/MainScreens/Profile/ProfileSettings/profile_detail_screen.dart';
import 'package:plane/screens/MainScreens/Profile/WorkpsaceSettings/workspace_general.dart';
import 'package:plane/screens/on_boarding/auth/join_workspaces.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/enums.dart';

import 'package:plane/widgets/custom_button.dart';
import 'package:plane/screens/on_boarding/on_boarding_screen.dart';
import 'package:plane/widgets/custom_text.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  List menus = [
    {
      'menu': 'Profile Setttings',
      'items': [
        {
          'title': 'General',
          'icon': Icons.person_outline,
          'onTap': (context) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileDetailScreen(),
              ),
            );
          }
        },
        {
          'title': 'Activity',
          'icon': Icons.signal_cellular_alt,
          'onTap': (context) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Activity(),
              ),
            );
          }
        },
        {
          'title': 'Preferences',
          'icon': Icons.tune,
          'onTap': (context) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PrefrencesScreen()));
          }
        }
      ],
    },
    {
      'menu': 'Workspace Settings',
      'items': [
        {
          'title': 'General',
          'icon': Icons.workspaces_outline,
          'onTap': (context) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WorkspaceGeneral(),
              ),
            );
          }
        },
        {
          'title': 'Members',
          'icon': Icons.people_outline,
          'onTap': (context) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Members(
                  fromWorkspace: true,
                ),
              ),
            );
          }
        },
        // {
        //   'title': 'Billing & Plans',
        //   'icon': Icons.credit_card,
        //   'onTap': (context) {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => const BillingPlans(),
        //       ),
        //     );
        //   }
        // },
        {
          'title': 'Integrations',
          'icon': Icons.route,
          'onTap': (context) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Integrations(),
              ),
            );
          }
        },
        {
          'title': 'Import/Export',
          'icon': Icons.swap_vert_circle_outlined,
          'onTap': (context) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ImportEport(),
              ),
            );
          }
        },
        {
          'title': 'Workspace Invites',
          'icon': Icons.upcoming_outlined,
          'onTap': (context) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const JoinWorkspaces(
                  fromOnboard: false,
                ),
              ),
            );
          }
        },
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var profileProvider = ref.watch(ProviderList.profileProvider);

    return Material(
      color: themeProvider.themeManager.primaryBackgroundDefaultColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomText(
                  'Profile',
                  type: FontStyle.H4,
                  fontWeight: FontWeightt.Semibold,
                  color: themeProvider.themeManager.primaryTextColor,
                ),
                const Spacer(),
                MaterialButton(
                  onPressed: _showLogoutModelBottomBar,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.logout,
                        color: Colors.red,
                        size: 16,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      CustomText(
                        'Logout',
                        color: themeProvider.themeManager.textErrorColor,
                        type: FontStyle.Medium,
                      )
                    ],
                  ),
                )
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    profileCard(themeProvider, profileProvider),
                    const SizedBox(
                      height: 20,
                    ),
                    menuItems(themeProvider)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showLogoutModelBottomBar() {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomText(
                    'Logout',
                    type: FontStyle.H4,
                    fontWeight: FontWeightt.Semibold,
                    color: themeProvider.themeManager.primaryTextColor,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      color: themeProvider.themeManager.placeholderTextColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              CustomText(
                'Are you sure you want to logout from your account?',
                type: FontStyle.H5,
                textAlign: TextAlign.left,
                maxLines: 4,
                color: themeProvider.themeManager.primaryTextColor,
              ),
              const Spacer(),
              Button(
                ontap: _onLogout,
                text: 'Logout',
                color: themeProvider.themeManager.textErrorColor,
              ),
            ],
          ),
        );
      },
    );
  }

  void _onLogout() {
    var profileProvider = ref.read(ProviderList.profileProvider);
    var theme = profileProvider.userProfile.theme;
    theme!['theme'] = fromTHEME(theme: THEME.light);

    ref.read(ProviderList.bottomNavProvider).setIndex(0);

    ref.read(ProviderList.themeProvider).changeTheme(
      data: {'theme': theme},
      context: context,
      fromLogout: true,
    );
    ProviderList.clear(ref: ref);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const OnBoardingScreen()),
        (route) => false);
  }

  Widget profileCard(
      ThemeProvider themeProvider, ProfileProvider profileProvider) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: themeProvider.themeManager.secondaryBackgroundDefaultColor,
      ),
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileDetailScreen(),
                ),
              );
            },
            child: Hero(
                tag: 'photo',
                child: profileProvider.userProfile.avatar != null &&
                        profileProvider.userProfile.avatar != ""
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(900),
                        child: SizedBox(
                          height: 90,
                          width: 90,
                          child: CachedNetworkImage(
                            imageUrl: profileProvider.userProfile.avatar!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Container(
                        height: 75,
                        width: 75,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: themeProvider
                              .themeManager.tertiaryBackgroundDefaultColor,
                        ),
                        child: Icon(
                          Icons.person_2_outlined,
                          color:
                              themeProvider.themeManager.placeholderTextColor,
                          size: 35,
                        ))),
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: width * 0.5,
                child: CustomText(
                  profileProvider.userProfile.firstName ?? 'User name',
                  type: FontStyle.H4,
                  fontWeight: FontWeightt.Semibold,
                  maxLines: 1,
                ),
              ),
              const SizedBox(
                height: 0,
              ),
              SizedBox(
                width: width * 0.5,
                child: CustomText(
                  profileProvider.userProfile.email ?? '',
                  type: FontStyle.Medium,
                  color: themeProvider.themeManager.placeholderTextColor,
                  maxLines: 1,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => UserProfileScreen(
                        index: 0,
                        userID: profileProvider.userProfile.id!,
                        userName: profileProvider.userProfile.firstName!,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  width: width * 0.5,
                  //color: Colors.red,
                  child: CustomText(
                    'View Profile',
                    type: FontStyle.Medium,
                    fontWeight: FontWeightt.Medium,
                    color: themeProvider.themeManager.primaryColour,
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget menuItems(ThemeProvider themeProvider) {
    var workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: menus.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color:
                    themeProvider.themeManager.secondaryBackgroundActiveColor,
              ),
              child: InkWell(
                onTap: menus[index]['menu'] == 'Workspace Settings'
                    ? () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          enableDrag: true,
                          constraints: BoxConstraints(
                              minHeight: height * 0.5,
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.8),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          )),
                          context: context,
                          builder: (ctx) {
                            return const SelectWorkspace();
                          },
                        );
                      }
                    : () {},
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 105,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 10),
                      child: CustomText(
                        menus[index]['menu'],
                        type: FontStyle.Medium,
                        color: themeProvider.themeManager.primaryColour,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    menus[index]['menu'] != 'Workspace Settings'
                        ? Container()
                        : Container(
                            height: 35,
                            width: 65,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              //color: const Color.fromRGBO(48, 0, 240, 1),
                            ),
                            child: Row(
                              children: [
                                workspaceProvider
                                            .selectedWorkspace!.workspaceLogo !=
                                        ''
                                    ? Container(
                                        margin: const EdgeInsets.all(5),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: CachedNetworkImage(
                                            imageUrl: workspaceProvider
                                                .selectedWorkspace!
                                                .workspaceLogo,
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                color: themeProvider
                                                    .themeManager
                                                    .primaryBackgroundDefaultColor,
                                              ),
                                              child: Center(
                                                child: CustomText(
                                                  workspaceProvider
                                                      .selectedWorkspace!
                                                      .workspaceName[0]
                                                      .toUpperCase(),
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeightt.Semibold,
                                                  // color: const Color.fromRGBO(
                                                  //     48, 0, 240, 1),
                                                ),
                                              ),
                                            ),
                                            width: 25,
                                            height: 35,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: 25,
                                        height: 35,
                                        margin: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          color: themeProvider.themeManager
                                              .primaryBackgroundDefaultColor,
                                        ),
                                        child: Center(
                                          child: CustomText(
                                            workspaceProvider.selectedWorkspace!
                                                .workspaceName[0]
                                                .toUpperCase(),
                                            fontSize: 14,
                                            fontWeight: FontWeightt.Semibold,
                                            // color: const Color.fromRGBO(
                                            //     48, 0, 240, 1),
                                          ),
                                        ),
                                      ),
                                // Container(
                                //   margin: const EdgeInsets.only(left: 5, right: 5,top: 5,bottom: 5),
                                //   height: 35,
                                //   width: 25,
                                //   decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(3),
                                //     color: Colors.white,
                                //   ),
                                // ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: themeProvider
                                        .themeManager.primaryColour,
                                  ),
                                )
                              ],
                            ),
                          )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: (menus[index]['items']).length,
              padding: const EdgeInsets.only(bottom: 15),
              itemBuilder: (context, idx) {
                if ((index == 0) ||
                    (idx == 5 || idx == 0 || checkUserAccess())) {
                  return InkWell(
                    onTap: () {
                      menus[index]['items'][idx]['onTap'](context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                menus[index]['items'][idx]['icon'],
                                size: 18,
                                color: themeProvider
                                    .themeManager.placeholderTextColor,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              CustomText(
                                menus[index]['items'][idx]['title'],
                                type: FontStyle.Small,
                                color:
                                    themeProvider.themeManager.primaryTextColor,
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                            color:
                                themeProvider.themeManager.placeholderTextColor,
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            )
          ],
        );
      },
    );
  }

  bool checkUserAccess() {
    var workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    var profileProvider = ref.watch(ProviderList.profileProvider);
    bool hasAccess = false;
    if (workspaceProvider.getMembersState == StateEnum.error) {
      return hasAccess;
    } else {
      for (var element in workspaceProvider.workspaceMembers) {
        if ((element['member']['id'] == profileProvider.userProfile.id) &&
            (element['role'] == 20 || element['role'] == 15)) {
          hasAccess = true;
        }
      }
    }
    return hasAccess;
  }
}
