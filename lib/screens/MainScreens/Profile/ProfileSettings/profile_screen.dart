import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/bottom_sheets/select_workspace.dart';
import 'package:plane_startup/provider/profile_provider.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/provider/theme_provider.dart';
import 'package:plane_startup/screens/Import%20&%20Export/import_export.dart';
import 'package:plane_startup/screens/MainScreens/Activity/activity.dart';
import 'package:plane_startup/screens/billing_plans.dart';
import 'package:plane_startup/screens/integrations.dart';
import 'package:plane_startup/screens/MainScreens/Profile/WorkpsaceSettings/members.dart';
import 'package:plane_startup/screens/MainScreens/Profile/ProfileSettings/profile_detail_screen.dart';
import 'package:plane_startup/screens/MainScreens/Profile/WorkpsaceSettings/workspace_general.dart';
import 'package:plane_startup/screens/on_boarding/auth/join_workspaces.dart';
import 'package:plane_startup/utils/constants.dart';

import 'package:plane_startup/widgets/custom_button.dart';
import 'package:plane_startup/config/const.dart';
import 'package:plane_startup/screens/on_boarding/on_boarding_screen.dart';
import 'package:plane_startup/widgets/custom_text.dart';

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
          'icon': Icon(
            Icons.person_outline,
            size: 18,
            color: Const.dark ? darkSecondaryTextColor : Colors.black,
          ),
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
          'icon': Icon(
            Icons.signal_cellular_alt,
            size: 18,
            color: Const.dark ? darkSecondaryTextColor : Colors.black,
          ),
          'onTap': (context) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Activity(),
              ),
            );
          }
        }
      ],
    },
    {
      'menu': 'Workspace Settings',
      'items': [
        {
          'title': 'General',
          'icon': Icon(
            Icons.workspaces_outline,
            size: 18,
            color: Const.dark ? darkSecondaryTextColor : Colors.black,
          ),
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
          'icon': Icon(
            Icons.people_outline,
            size: 18,
            color: Const.dark ? darkSecondaryTextColor : Colors.black,
          ),
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
        {
          'title': 'Billing & Plans',
          'icon': Icon(
            Icons.credit_card,
            size: 18,
            color: Const.dark ? darkSecondaryTextColor : Colors.black,
          ),
          'onTap': (context) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BillingPlans(),
              ),
            );
          }
        },
        {
          'title': 'Integrations',
          'icon': Icon(
            Icons.route,
            size: 18,
            color: Const.dark ? darkSecondaryTextColor : Colors.black,
          ),
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
          'icon': Icon(
            Icons.swap_vert_circle_outlined,
            size: 16,
            color: Const.dark ? darkSecondaryTextColor : Colors.black,
          ),
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
          'icon': Icon(
            Icons.upcoming_outlined,
            size: 16,
            color: Const.dark ? darkSecondaryTextColor : Colors.black,
          ),
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
      color: themeProvider.isDarkThemeEnabled
          ? darkPrimaryBackgroundDefaultColor
          : lightPrimaryBackgroundDefaultColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CustomText(
                  'Profile',
                  type: FontStyle.mainHeading,
                ),
                const Spacer(),
                MaterialButton(
                  onPressed: _showLogoutModelBottomBar,
                  child: const Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.red,
                        size: 16,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      CustomText(
                        'Logout',
                        color: Colors.red,
                        type: FontStyle.description,
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
          height: 300,
          child: Column(
            children: [
              Row(
                children: [
                  const CustomText(
                    'Logout',
                    type: FontStyle.mainHeading,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              const CustomText(
                'Are you sure you want to logout from your account?',
                type: FontStyle.subheading,
                textAlign: TextAlign.left,
                maxLines: 4,
              ),
              const Spacer(),
              Button(
                ontap: _onLogout,
                text: 'Logout',
              ),
            ],
          ),
        );
      },
    );
  }

  void _onLogout() {
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
        color: themeProvider.isDarkThemeEnabled
            ? darkSecondaryBackgroundDefaultColor
            : lightSecondaryBackgroundDefaultColor,
      ),
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Hero(
              tag: 'photo',
              child: profileProvider.userProfile.avatar != null &&
                      profileProvider.userProfile.avatar != ""
                  ? CircleAvatar(
                      radius: 45,
                      backgroundImage:
                          NetworkImage(profileProvider.userProfile.avatar!),
                    )
                  : Container(
                      height: 75,
                      width: 75,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: themeProvider.isDarkThemeEnabled
                            ? darkThemeBorder
                            : Colors.white,
                      ),
                      child: Icon(
                        Icons.person_2_outlined,
                        color: themeProvider.isDarkThemeEnabled
                            ? Colors.grey.shade500
                            : Colors.grey,
                        size: 35,
                      ))),
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
                  type: FontStyle.mainHeading,
                  maxLines: 1,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: width * 0.5,
                child: CustomText(
                  profileProvider.userProfile.email ??
                      'rameshkumar2299@gmail.com',
                  type: FontStyle.secondaryText,
                  maxLines: 1,
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
                color: primaryLightColor,
              ),
              child: GestureDetector(
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
                        type: FontStyle.description,
                        color: primaryColor,
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
                                          child: Image.network(
                                            workspaceProvider.selectedWorkspace!
                                                .workspaceLogo,
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
                                          color: Colors.white,
                                        ),
                                        child: Center(
                                          child: CustomText(
                                            workspaceProvider.selectedWorkspace!
                                                .workspaceName[0]
                                                .toUpperCase(),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: const Color.fromRGBO(
                                                48, 0, 240, 1),
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
                                  child: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: primaryColor,
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
                            menus[index]['items'][idx]['icon'],
                            const SizedBox(
                              width: 10,
                            ),
                            CustomText(
                              menus[index]['items'][idx]['title'],
                              type: FontStyle.title,
                              color: Const.dark
                                  ? darkSecondaryTextColor
                                  : Colors.black,
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: greyColor,
                        )
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        );
      },
    );
  }
}
