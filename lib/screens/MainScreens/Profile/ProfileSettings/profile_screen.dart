import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
import 'package:plane/widgets/custom_divider.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/padding_widget.dart';
import 'package:plane/widgets/shimmer_effect_widget.dart';
import 'package:plane/widgets/workspace_logo_for_diffrent_extensions.dart';

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
    },
    {
      'menu': 'Logout',
    }
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final profileProvider = ref.watch(ProviderList.profileProvider);

    return Material(
      color: themeProvider.themeManager.primaryBackgroundDefaultColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headerWidget(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    profileCard(themeProvider, profileProvider),
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

  Widget headerWidget() {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(bottom: 15, left: 16, right: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom:
              BorderSide(color: themeProvider.themeManager.borderSubtle01Color),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                enableDrag: true,
                constraints: BoxConstraints(
                    minHeight: height * 0.5,
                    maxHeight: MediaQuery.of(context).size.height * 0.8),
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
            },
            child: Row(
              children: [
                !workspaceProvider.selectedWorkspace.workspaceId.isNotEmpty
                    ? Container()
                    : workspaceProvider.selectedWorkspace.workspaceLogo != ''
                        ? WorkspaceLogoForDiffrentExtensions(
                            imageUrl: workspaceProvider
                                .selectedWorkspace.workspaceLogo,
                            themeProvider: themeProvider,
                            workspaceName: workspaceProvider
                                .selectedWorkspace.workspaceName)
                        : Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: themeProvider.themeManager.primaryColour,
                            ),
                            child: Center(
                              child: CustomText(
                                workspaceProvider
                                    .selectedWorkspace.workspaceName[0]
                                    .toUpperCase(),
                                type: FontStyle.Medium,
                                fontWeight: FontWeightt.Bold,
                                color: Colors.white,
                                overrride: true,
                              ),
                            ),
                          ),
                const SizedBox(
                  width: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: width * 0.6),
                      child: CustomText(
                        workspaceProvider.selectedWorkspace.workspaceName,
                        type: FontStyle.H4,
                        fontWeight: FontWeightt.Semibold,
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down)
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutModelBottomBar() {
    final themeProvider = ref.watch(ProviderList.themeProvider);
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
                color: (themeProvider.theme == THEME.dark ||
                        themeProvider.theme == THEME.darkHighContrast ||
                        (themeProvider.theme == THEME.systemPreferences &&
                            SchedulerBinding.instance.platformDispatcher
                                    .platformBrightness ==
                                Brightness.dark))
                    ? const Color.fromRGBO(95, 21, 21, 1)
                    : const Color.fromRGBO(254, 242, 242, 1),
                textColor: themeProvider.themeManager.textErrorColor,
                filledButton: false,
                borderColor: themeProvider.themeManager.textErrorColor,
              ),
            ],
          ),
        );
      },
    );
  }

  void _onLogout() {
    final profileProvider = ref.read(ProviderList.profileProvider);
    final theme = profileProvider.userProfile.theme;
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
    return horizontalPaddingWidget(
      child: Container(
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
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            height: 90,
                            width: 90,
                            child: CachedNetworkImage(
                              imageUrl: profileProvider.userProfile.avatar!,
                              placeholder: (context, url) =>
                                  const ShimmerEffectWidget(
                                      height: 90, width: 90, borderRadius: 10),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Container(
                          height: 90,
                          width: 90,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
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
                          userID: profileProvider.userProfile.id!,
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
      ),
    );
  }

  Widget menuItems(ThemeProvider themeProvider) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: menus.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                if (index == menus.length - 1) {
                  _showLogoutModelBottomBar();
                }
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    index == menus.length - 1
                        ? const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.logout,
                              color: darkPrimaryButtonDangerSelectedColor,
                              size: 18,
                            ),
                          )
                        : const SizedBox.shrink(),
                    CustomText(
                      menus[index]['menu'],
                      type: index == menus.length - 1
                          ? FontStyle.Medium
                          : FontStyle.Small,
                      color: index == menus.length - 1
                          ? darkPrimaryButtonDangerSelectedColor
                          : themeProvider.themeManager.tertiaryTextColor,
                      textAlign: TextAlign.start,
                      fontWeight: index == menus.length - 1
                          ? FontWeightt.Medium
                          : FontWeightt.Regular,
                    ),
                  ],
                ),
              ),
            ),
            index == menus.length - 1
                ? const SizedBox.shrink()
                : Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: (menus[index]['items']).length,
                        padding: const EdgeInsets.only(bottom: 10),
                        itemBuilder: (context, idx) {
                          if ((index == 0) ||
                              (idx == 4 || idx == 0 || checkUserAccess())) {
                            return InkWell(
                              onTap: () {
                                menus[index]['items'][idx]['onTap'](context);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          menus[index]['items'][idx]['icon'],
                                          size: 18,
                                          color: themeProvider
                                              .themeManager.primaryTextColor,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        CustomText(
                                          menus[index]['items'][idx]['title'],
                                          type: FontStyle.Medium,
                                          color: themeProvider
                                              .themeManager.primaryTextColor,
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 12,
                                      color: themeProvider
                                          .themeManager.placeholderTextColor,
                                    )
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                      CustomDivider(
                        themeProvider: themeProvider,
                        width: 8,
                      ),
                    ],
                  )
          ],
        );
      },
    );
  }

  bool checkUserAccess() {
    final workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    final profileProvider = ref.watch(ProviderList.profileProvider);
    bool hasAccess = false;
    if (workspaceProvider.getMembersState == StateEnum.error) {
      return hasAccess;
    } else {
      for (final element in workspaceProvider.workspaceMembers) {
        if ((element['member']['id'] == profileProvider.userProfile.id) &&
            (element['role'] == 20 || element['role'] == 15)) {
          hasAccess = true;
        }
      }
    }
    return hasAccess;
  }
}
