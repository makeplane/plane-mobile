import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/custom_toast.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/screens/MainScreens/Profile/WorkpsaceSettings/invite_members.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/bottom_sheets/member_status.dart';
import 'package:plane_startup/widgets/custom_app_bar.dart';
import 'package:plane_startup/widgets/custom_text.dart';
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
                        type: FontStyle.title,
                        color: Color.fromRGBO(63, 118, 255, 1)),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: LoadingWidget(
          loading: workspaceProvider.getMembersState == StateEnum.loading,
          widgetClass: MembersListWidget(
            fromWorkspace: widget.fromWorkspace,
          ),
        ));
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
          color: themeProvider.isDarkThemeEnabled
              ? darkSecondaryBackgroundDefaultColor
              : lightSecondaryBackgroundDefaultColor,
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
    return ListView.builder(
        itemCount: workspaceProvider.workspaceMembers.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              if (fromRole(role: workspaceProvider.role) <
                  workspaceProvider.workspaceMembers[index]['role']) {
                CustomToast().showToast(context, accessRestrictedMSG);
              } else if (workspaceProvider.workspaceMembers[index]['member']
                      ["id"] ==
                  ref.read(ProviderList.profileProvider).userProfile.id) {
                CustomToast()
                    .showToast(context, "You can't change your own role");
              }
              // if ((ref.watch(ProviderList.profileProvider).userProfile.id ==
              //         workspaceProvider.workspaceMembers[index]['member']
              //             ['id']) &&
              //     workspaceProvider.workspaceMembers[index]['member']['role'] !=
              //         '20') {
              //   ScaffoldMessenger.of(Const.globalKey.currentContext!)
              //       .showSnackBar(
              //     const SnackBar(
              //       duration: Duration(seconds: 2),
              //       content: Text('Sorry, you can\'t make changes to anyone'),
              //     ),
              //   );
              // } else if (workspaceProvider.workspaceMembers[index]['role'] ==
              //     20) {
              //   ScaffoldMessenger.of(Const.globalKey.currentContext!)
              //       .showSnackBar(
              //     const SnackBar(
              //       duration: Duration(seconds: 2),
              //       content: Text('Sorry, you can\'t make changes to an admin'),
              //     ),
              //   );
              // }
              else {
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
                        userId: workspaceProvider.workspaceMembers[index]['id'],
                        isInviteMembers: false,
                      );
                    });
              }
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
                                ['email'][0]
                            .toString()
                            .toUpperCase(),
                        color: Colors.black,
                        type: FontStyle.boldTitle,
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
              type: FontStyle.heading2,
              maxLines: 1,
              fontSize: 18,
            ),
            subtitle: SizedBox(
              child: CustomText(
                workspaceProvider.workspaceMembers[index]['member']['email'],
                color: const Color.fromRGBO(133, 142, 150, 1),
                textAlign: TextAlign.left,
                type: FontStyle.subtitle,
              ),
            ),
            trailing: Container(
              constraints: const BoxConstraints(maxWidth: 80),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    child: SizedBox(
                      child: CustomText(
                        workspaceProvider.workspaceMembers[index]['role'] == 20
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
                        type: FontStyle.description,
                        fontWeight: FontWeight.w500,
                        color: themeProvider.isDarkThemeEnabled
                            ? fromRole(role: workspaceProvider.role) >=
                                    workspaceProvider.workspaceMembers[index]
                                        ['role']
                                ? Colors.white
                                : darkSecondaryTextColor
                            : fromRole(role: workspaceProvider.role) >=
                                    workspaceProvider.workspaceMembers[index]
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
                        ? fromRole(role: workspaceProvider.role) >=
                                workspaceProvider.workspaceMembers[index]
                                    ['role']
                            ? Colors.white
                            : darkSecondaryTextColor
                        : fromRole(role: workspaceProvider.role) >=
                                workspaceProvider.workspaceMembers[index]
                                    ['role']
                            ? Colors.black
                            : greyColor,
                  )
                ],
              ),
            ),
          );
        });
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

    return ListView.builder(
        itemCount: projectsProvider.projectMembers.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              if (fromRole(role: projectsProvider.role) <
                  projectsProvider.projectMembers[index]['role']) {
                CustomToast().showToast(context, accessRestrictedMSG);
              } else if (projectsProvider.projectMembers[index]['member']
                      ["id"] ==
                  ref.read(ProviderList.profileProvider).userProfile.id) {
                CustomToast()
                    .showToast(context, "You can't change your own role");
              }
              // if ((ref.watch(ProviderList.profileProvider).userProfile.id ==
              //         projectsProvider.projectMembers[index]['member']['id']) &&
              //     projectsProvider.projectMembers[index]['member']['role'] !=
              //         '20') {
              //   ScaffoldMessenger.of(Const.globalKey.currentContext!)
              //       .showSnackBar(
              //     const SnackBar(
              //       duration: Duration(seconds: 2),
              //       content: Text('Sorry, you can\'t make changes to anyone'),
              //     ),
              //   );
              // } else if (projectsProvider.projectMembers[index]['role'] == 20) {
              //   ScaffoldMessenger.of(Const.globalKey.currentContext!)
              //       .showSnackBar(
              //     const SnackBar(
              //       duration: Duration(seconds: 2),
              //       content: Text('Sorry, you can\'t make changes to an admin'),
              //     ),
              //   );
              // }

              else {
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
            leading: projectsProvider.projectMembers[index]['member']
                            ['avatar'] ==
                        null ||
                    projectsProvider.projectMembers[index]['member']
                            ['avatar'] ==
                        ""
                ? CircleAvatar(
                    radius: 20,
                    backgroundColor: strokeColor,
                    child: Center(
                      child: CustomText(
                        projectsProvider.projectMembers[index]['member']
                                ['email'][0]
                            .toString()
                            .toUpperCase(),
                        color: Colors.black,
                        type: FontStyle.boldTitle,
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
              type: FontStyle.heading2,
              maxLines: 1,
              fontSize: 18,
            ),
            subtitle: SizedBox(
              child: CustomText(
                projectsProvider.projectMembers[index]['member']['email'],
                color: const Color.fromRGBO(133, 142, 150, 1),
                textAlign: TextAlign.left,
                type: FontStyle.subtitle,
              ),
            ),
            trailing: GestureDetector(
              onTap: () {
                // var profileProv = ref.read(ProviderList.profileProvider);
                // if (profileProv.userProfile.id ==
                //     projectsProvider.projectMembers[index]['member']['id']) {
                //   ScaffoldMessenger.of(Const.globalKey.currentContext!)
                //       .showSnackBar(
                //     const SnackBar(
                //       backgroundColor: Colors.red,
                //       duration: Duration(seconds: 1),
                //       content:
                //           Text('Sorry, you can\'t make changes to yourself'),
                //     ),
                //   );
                // } else {
                if (fromRole(role: projectsProvider.role) <
                    projectsProvider.projectMembers[index]['role']) {
                  CustomToast().showToast(context, accessRestrictedMSG);
                } else if (projectsProvider.projectMembers[index]['member']
                        ["id"] ==
                    ref.read(ProviderList.profileProvider).userProfile.id) {
                  CustomToast()
                      .showToast(context, "You can't change your own role");
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
                            "role": projectsProvider.projectMembers[index]
                                ['role']
                          },
                          userId: projectsProvider.projectMembers[index]['id'],
                          isInviteMembers: false,
                        );
                      });
                }
                // }

                //}
              },
              child: Container(
                constraints: const BoxConstraints(maxWidth: 80),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SizedBox(
                      child: SizedBox(
                        child: CustomText(
                          projectsProvider.projectMembers[index]['role'] == 20
                              ? 'Admin'
                              : projectsProvider.projectMembers[index]
                                          ['role'] ==
                                      15
                                  ? 'Member'
                                  : projectsProvider.projectMembers[index]
                                              ['role'] ==
                                          10
                                      ? 'Viewer'
                                      : 'Guest',
                          type: FontStyle.description,
                          fontWeight: FontWeight.w500,
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
        });
  }
}
