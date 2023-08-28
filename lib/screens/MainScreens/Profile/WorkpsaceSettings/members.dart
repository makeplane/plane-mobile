import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/screens/MainScreens/Profile/member_profile.dart';
import 'package:plane_startup/utils/custom_toast.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/screens/MainScreens/Profile/WorkpsaceSettings/invite_members.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/bottom_sheets/member_status.dart';
import 'package:plane_startup/widgets/custom_app_bar.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import 'package:plane_startup/widgets/error_state.dart';
import 'package:plane_startup/widgets/loading_widget.dart';

class Members extends ConsumerStatefulWidget {
  final bool fromWorkspace;
  const Members({
    super.key,
    required this.fromWorkspace,
  });

  @override
  ConsumerState<Members> createState() => _MembersState();
}

class _MembersState extends ConsumerState<Members> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var workspaceProvider = ref.read(ProviderList.workspaceProvider);
      workspaceProvider.getWorkspaceMembers();
    });
  }

  @override
  Widget build(BuildContext context) {
    var workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    log(workspaceProvider.role.name);
    return Scaffold(
      // backgroundColor: themeProvider.isDarkThemeEnabled
      //     ? darkSecondaryBackgroundColor
      //     : lightSecondaryBackgroundColor,
      appBar: CustomAppBar(
        onPressed: () {
          Navigator.of(context).pop();
        },
        text: 'Members',
        actions: [
          //row of add button and Add text
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const InviteMembers(
                        isProject: false,
                      )));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.add,
                    color: Color.fromRGBO(63, 118, 255, 1),
                  ),
                  CustomText('Add',
                      type: FontStyle.Small,
                      color: Color.fromRGBO(63, 118, 255, 1)),
                ],
              ),
            ),
          ),
        ],
      ),
      body: LoadingWidget(
        loading: workspaceProvider.getMembersState == StateEnum.loading,
        widgetClass: workspaceProvider.getMembersState == StateEnum.success
            ? MembersListWidget(
                fromWorkspace: widget.fromWorkspace,
              )
            : errorState(context: context),
      ),
    );
  }
}

class MembersListWidget extends ConsumerStatefulWidget {
  final bool fromWorkspace;
  const MembersListWidget({
    super.key,
    required this.fromWorkspace,
  });

  @override
  ConsumerState<MembersListWidget> createState() => _MembersListWidgetState();
}

class _MembersListWidgetState extends ConsumerState<MembersListWidget> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var projectsProvider = ref.watch(ProviderList.projectProvider);

    return LoadingWidget(
      loading: projectsProvider.updateProjectMemberState == StateEnum.loading,
      widgetClass: Container(
          color: themeProvider.themeManager.primaryBackgroundDefaultColor,
          child: widget.fromWorkspace
              ? const WrokspaceMebersWidget()
              : const ProjectMembersWidget()),
    );
  }
}

class WrokspaceMebersWidget extends ConsumerStatefulWidget {
  const WrokspaceMebersWidget({super.key});

  @override
  ConsumerState<WrokspaceMebersWidget> createState() =>
      _WrokspaceMebersWidgetState();
}

class _WrokspaceMebersWidgetState extends ConsumerState<WrokspaceMebersWidget> {
  @override
  Widget build(BuildContext context) {
    var workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return ListView.separated(
        itemCount: workspaceProvider.workspaceMembers.length,
        separatorBuilder: (context, index) => Container(
              padding:
                  const EdgeInsets.only(left: 20, right: 20, top: 3, bottom: 3),
              child: Divider(
                  height: 1,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                  color: themeProvider.themeManager.borderSubtle01Color
                  // themeProvider.isDarkThemeEnabled
                  //     ? darkThemeBorder
                  //     : const Color.fromRGBO(
                  //         238, 238, 238, 1),
                  ),
            ),
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              if (roleParser(
                      role: workspaceProvider.workspaceMembers[index]
                          ['role']) ==
                  Role.guest) {
                return;
              }

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => MemberProfile(
                      userID: workspaceProvider.workspaceMembers[index]
                          ['member']["id"])));
            },
            leading: workspaceProvider.workspaceMembers[index]['member']
                            ['avatar'] ==
                        null ||
                    workspaceProvider.workspaceMembers[index]['member']
                            ['avatar'] ==
                        ""
                ? CircleAvatar(
                    radius: 20,
                    backgroundColor: strokeColor,
                    child: Center(
                      child: CustomText(
                        workspaceProvider.workspaceMembers[index]['member']
                                ['first_name'][0]
                            .toString()
                            .toUpperCase(),
                        color: Colors.black,
                        type: FontStyle.Medium,
                        fontWeight: FontWeightt.Semibold,
                      ),
                    ),
                  )
                : CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(workspaceProvider
                        .workspaceMembers[index]['member']['avatar']),
                  ),
            title: CustomText(
              '${workspaceProvider.workspaceMembers[index]['member']['first_name']} ${workspaceProvider.workspaceMembers[index]['member']['last_name'] ?? ''}',
              type: FontStyle.H6,
              fontWeight: FontWeightt.Medium,
              maxLines: 1,
              color: themeProvider.themeManager.primaryTextColor,
            ),
            subtitle: SizedBox(
              child: CustomText(
                checkIfWorkspaceAdmin()
                    ? workspaceProvider.workspaceMembers[index]['member']
                        ['email']
                    : workspaceProvider.workspaceMembers[index]['member']
                        ['display_name'],
                color: themeProvider.themeManager.placeholderTextColor,
                textAlign: TextAlign.left,
                type: FontStyle.Small,
              ),
            ),
            trailing: GestureDetector(
              onTap: () {
                if (fromRole(role: workspaceProvider.role) <
                    workspaceProvider.workspaceMembers[index]['role']) {
                  CustomToast().showToast(
                      context, accessRestrictedMSG, themeProvider,
                      toastType: ToastType.failure);
                } else if (workspaceProvider.workspaceMembers[index]['member']
                        ["id"] ==
                    ref.read(ProviderList.profileProvider).userProfile.id) {
                  CustomToast().showToast(
                      context, "You can't change your own role", themeProvider,
                      toastType: ToastType.warning);
                } else {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      enableDrag: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                      context: context,
                      builder: (ctx) {
                        return MemberStatus(
                          fromWorkspace: true,
                          firstName: workspaceProvider.workspaceMembers[index]
                              ['member']['first_name'],
                          lastName: workspaceProvider.workspaceMembers[index]
                              ['member']['last_name'],
                          role: {
                            "role": workspaceProvider.workspaceMembers[index]
                                ['role']
                          },
                          userId: workspaceProvider.workspaceMembers[index]
                              ['id'],
                          isInviteMembers: false,
                        );
                      });
                }
              },
              child: Container(
                constraints: const BoxConstraints(maxWidth: 87),
                child: Row(
                  // crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Spacer(),
                    SizedBox(
                      child: SizedBox(
                        child: CustomText(
                          workspaceProvider.workspaceMembers[index]['role'] ==
                                  20
                              ? 'Admin'
                              : workspaceProvider.workspaceMembers[index]
                                          ['role'] ==
                                      15
                                  ? 'Member'
                                  : workspaceProvider.workspaceMembers[index]
                                              ['role'] ==
                                          10
                                      ? 'Viewer'
                                      : 'Guest',
                          type: FontStyle.Medium,
                          fontWeight: FontWeightt.Medium,
                          color: themeProvider.themeManager.primaryTextColor,
                          // themeProvider.isDarkThemeEnabled
                          //     ? fromRole(role: workspaceProvider.role) >=
                          //             workspaceProvider.workspaceMembers[index]
                          //                 ['role']
                          //         ? Colors.white
                          //         : darkSecondaryTextColor
                          //     : fromRole(role: workspaceProvider.role) >=
                          //             workspaceProvider.workspaceMembers[index]
                          //                 ['role']
                          //         ? Colors.black
                          //         : greyColor,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_drop_down,
                        color: themeProvider.themeManager.primaryTextColor
                        // themeProvider.isDarkThemeEnabled
                        //     ? fromRole(role: workspaceProvider.role) >=
                        //             workspaceProvider.workspaceMembers[index]
                        //                 ['role']
                        //         ? Colors.white
                        //         : darkSecondaryTextColor
                        //     : fromRole(role: workspaceProvider.role) >=
                        //             workspaceProvider.workspaceMembers[index]
                        //                 ['role']
                        //         ? Colors.black
                        //         : greyColor,
                        )
                  ],
                ),
              ),
            ),
          );
        });
  }

  bool checkIfWorkspaceAdmin() {
    var workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    var profileProvider = ref.watch(ProviderList.profileProvider);
    bool isAdmin = false;
    for (var element in workspaceProvider.workspaceMembers) {
      if (element['member']['id'] == profileProvider.userProfile.id &&
          element['role'] == 20) {
        isAdmin = true;
      }
    }
    return isAdmin;
  }
}

class ProjectMembersWidget extends ConsumerStatefulWidget {
  const ProjectMembersWidget({super.key});

  @override
  ConsumerState<ProjectMembersWidget> createState() =>
      _ProjectMembersWidgetState();
}

class _ProjectMembersWidgetState extends ConsumerState<ProjectMembersWidget> {
  @override
  Widget build(BuildContext context) {
    var projectsProvider = ref.watch(ProviderList.projectProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);

    return ListView.separated(
      itemCount: projectsProvider.projectMembers.length,
      separatorBuilder: (context, index) => Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 3, bottom: 3),
        child: Divider(
            height: 1,
            thickness: 1,
            indent: 0,
            endIndent: 0,
            color: themeProvider.themeManager.borderSubtle01Color
            // themeProvider.isDarkThemeEnabled
            //     ? darkThemeBorder
            //     : const Color.fromRGBO(
            //         238, 238, 238, 1),
            ),
      ),
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            if (roleParser(
                    role: projectsProvider.projectMembers[index]['role']) ==
                Role.guest) {
              return;
            }

            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => MemberProfile(
                    userID: projectsProvider.projectMembers[index]['member']
                        ["id"])));
          },
          leading: projectsProvider.projectMembers[index]['member']['avatar'] ==
                      null ||
                  projectsProvider.projectMembers[index]['member']['avatar'] ==
                      ""
              ? CircleAvatar(
                  radius: 20,
                  backgroundColor: strokeColor,
                  child: Center(
                    child: CustomText(
                      projectsProvider.projectMembers[index]['member']
                              ['first_name'][0]
                          .toString()
                          .toUpperCase(),
                      color: Colors.black,
                      type: FontStyle.Medium,
                      fontWeight: FontWeightt.Semibold,
                    ),
                  ),
                )
              : CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(projectsProvider
                      .projectMembers[index]['member']['avatar']),
                ),
          title: CustomText(
            '${projectsProvider.projectMembers[index]['member']['first_name']} ${projectsProvider.projectMembers[index]['member']['last_name'] ?? ''}',
            type: FontStyle.H5,
            maxLines: 1,
            fontSize: 18,
          ),
          subtitle: SizedBox(
            child: CustomText(
              checkIfProjectAdmin()
                  ? projectsProvider.projectMembers[index]['member']['email']
                  : projectsProvider.projectMembers[index]['member']
                      ['display_name'],
              color: const Color.fromRGBO(133, 142, 150, 1),
              textAlign: TextAlign.left,
              type: FontStyle.Medium,
            ),
          ),
          trailing: GestureDetector(
            onTap: () {
              if (fromRole(role: projectsProvider.role) <
                  projectsProvider.projectMembers[index]['role']) {
                CustomToast().showToast(
                    context, accessRestrictedMSG, themeProvider,
                    toastType: ToastType.failure);
              } else if (projectsProvider.projectMembers[index]['member']
                      ["id"] ==
                  ref.read(ProviderList.profileProvider).userProfile.id) {
                CustomToast().showToast(
                    context, "You can't change your own role", themeProvider,
                    toastType: ToastType.warning);
              } else {
                // if (projectsProvider.role == Role.admin) {
                showModalBottomSheet(
                    isScrollControlled: true,
                    enableDrag: true,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    )),
                    context: context,
                    builder: (ctx) {
                      return MemberStatus(
                        fromWorkspace: false,
                        firstName: projectsProvider.projectMembers[index]
                            ['member']['first_name'],
                        lastName: projectsProvider.projectMembers[index]
                            ['member']['last_name'],
                        role: {
                          "role": projectsProvider.projectMembers[index]['role']
                        },
                        userId: projectsProvider.projectMembers[index]['id'],
                        isInviteMembers: false,
                      );
                    });
              }
            },
            child: Container(
     
              constraints: const BoxConstraints(maxWidth: 84),
              child: Row(
                // crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Spacer(),
                  SizedBox(
                    child: SizedBox(
                      child: CustomText(
                        projectsProvider.projectMembers[index]['role'] == 20
                            ? 'Admin'
                            : projectsProvider.projectMembers[index]['role'] ==
                                    15
                                ? 'Member'
                                : projectsProvider.projectMembers[index]
                                            ['role'] ==
                                        10
                                    ? 'Viewer'
                                    : 'Guest',
                        type: FontStyle.Medium,
                        fontWeight: FontWeightt.Medium,
                        color: themeProvider.isDarkThemeEnabled
                            ? fromRole(role: projectsProvider.role) >=
                                    projectsProvider.projectMembers[index]
                                        ['role']
                                ? Colors.white
                                : darkSecondaryTextColor
                            : fromRole(role: projectsProvider.role) >=
                                    projectsProvider.projectMembers[index]
                                        ['role']
                                ? Colors.black
                                : greyColor,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: themeProvider.isDarkThemeEnabled
                        ? fromRole(role: projectsProvider.role) >=
                                projectsProvider.projectMembers[index]['role']
                            ? Colors.white
                            : darkSecondaryTextColor
                        : fromRole(role: projectsProvider.role) >=
                                projectsProvider.projectMembers[index]['role']
                            ? Colors.black
                            : greyColor,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool checkIfProjectAdmin() {
    var projectsProvider = ref.watch(ProviderList.projectProvider);
    var profileProvider = ref.watch(ProviderList.profileProvider);
    bool isAdmin = false;
    for (var element in projectsProvider.projectMembers) {
      if (element['member']['id'] == profileProvider.userProfile.id &&
          element['role'] == 20) {
        isAdmin = true;
      }
    }
    return isAdmin;
  }
}
