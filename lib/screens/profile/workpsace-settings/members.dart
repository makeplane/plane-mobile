import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plane/bottom-sheets/delete_leave_project_sheet.dart';
import 'package:plane/bottom-sheets/delete_workspace_sheet.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/profile/user-profile/user_profile.dart';
import 'package:plane/screens/profile/workpsace-settings/invite_members.dart';
import 'package:plane/utils/color_manager.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/bottom-sheets/member_status.dart';
import 'package:plane/widgets/custom_app_bar.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/error_state.dart';
import 'package:plane/widgets/loading_widget.dart';
import 'package:plane/widgets/member_logo_alternative_widget.dart';
import 'package:plane/widgets/member_logo_widget.dart';

class Members extends ConsumerStatefulWidget {
  const Members({
    super.key,
    required this.fromWorkspace,
  });
  final bool fromWorkspace;

  @override
  ConsumerState<Members> createState() => _MembersState();
}

class _MembersState extends ConsumerState<Members> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final workspaceProvider = ref.read(ProviderList.workspaceProvider);
      workspaceProvider.getWorkspaceMembers();
      workspaceProvider.getWorkspaceMemberInvitations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    log(workspaceProvider.role.name);
    return Scaffold(
      backgroundColor: themeProvider.themeManager.primaryBackgroundDefaultColor,
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
  const MembersListWidget({
    super.key,
    required this.fromWorkspace,
  });
  final bool fromWorkspace;

  @override
  ConsumerState<MembersListWidget> createState() => _MembersListWidgetState();
}

class _MembersListWidgetState extends ConsumerState<MembersListWidget> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final projectsProvider = ref.watch(ProviderList.projectProvider);

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
  Role? role;

  @override
  Widget build(BuildContext context) {
    final workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final profileProvider = ref.watch(ProviderList.profileProvider);

    return RefreshIndicator(
      color: themeProvider.themeManager.primaryColour,
      backgroundColor: themeProvider.themeManager.primaryBackgroundDefaultColor,
      onRefresh: () async {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          final workspaceProvider = ref.read(ProviderList.workspaceProvider);
          workspaceProvider.getWorkspaceMembers();
          workspaceProvider.getWorkspaceMemberInvitations();
        });
      },
      child: ListView(
        children: [
          ListView.separated(
            primary: false,
            shrinkWrap: true,
            itemCount: workspaceProvider.workspaceMembers.length,
            separatorBuilder: (context, index) => Container(
              padding:
                  const EdgeInsets.only(left: 20, right: 20, top: 3, bottom: 3),
              child: Divider(
                  height: 1,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                  color: themeProvider.themeManager.borderSubtle01Color),
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => UserProfileScreen(
                              userID: workspaceProvider.workspaceMembers[index]
                                  ['member']["id"],
                            )),
                  );
                },
                leading: MemberLogoWidget(
                  colorForErrorWidget: ColorManager.getColorWithIndex(index),
                  imageUrl: workspaceProvider.workspaceMembers[index]['member']
                      ['avatar'],
                  memberNameFirstLetterForErrorWidget: workspaceProvider
                      .workspaceMembers[index]['member']['first_name'][0]
                      .toString()
                      .toUpperCase(),
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
                trailing: InkWell(
                  onTap: () {
                    if (fromRole(role: workspaceProvider.role) <
                        workspaceProvider.workspaceMembers[index]['role']) {
                      CustomToast.showToast(context,
                          message: accessRestrictedMSG,
                          toastType: ToastType.failure);
                    } else if (workspaceProvider.workspaceMembers[index]
                            ['member']["id"] ==
                        ref.read(ProviderList.profileProvider).userProfile.id) {
                      if (workspaceProvider.workspaceMembers[index]['role'] ==
                          15) {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          enableDrag: true,
                          constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.85),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          context: context,
                          builder: (BuildContext context) =>
                              DeleteOrLeaveWorkpace(
                            workspaceName: workspaceProvider
                                .selectedWorkspace.workspaceName,
                            role: getRole(),
                          ),
                        );
                      } else {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          enableDrag: true,
                          constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.85),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          context: context,
                          builder: (BuildContext context) =>
                              DeleteOrLeaveWorkpace(
                            workspaceName: workspaceProvider
                                .selectedWorkspace.workspaceName,
                            role: Role.none,
                          ),
                        );
                        // CustomToast.showToast(context,
                        //     message: "You can't change your own role",
                        //     toastType: ToastType.warning);
                      }
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
                            pendingInvite: false,
                          );
                        },
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    constraints: const BoxConstraints(maxWidth: 87),
                    child: Row(
                      children: [
                        const Spacer(),
                        SizedBox(
                          child: SizedBox(
                            child: CustomText(
                              workspaceProvider.workspaceMembers[index]
                                          ['role'] ==
                                      20
                                  ? 'Admin'
                                  : workspaceProvider.workspaceMembers[index]
                                              ['role'] ==
                                          15
                                      ? 'Member'
                                      : workspaceProvider
                                                      .workspaceMembers[index]
                                                  ['role'] ==
                                              10
                                          ? 'Viewer'
                                          : 'Guest',
                              type: FontStyle.Medium,
                              fontWeight: FontWeightt.Medium,
                              color: (workspaceProvider.workspaceMembers[index]
                                          ['member']["id"] ==
                                      profileProvider.userProfile.id)
                                  ? greyColor
                                  : themeProvider.themeManager.theme ==
                                              THEME.dark ||
                                          themeProvider.themeManager.theme ==
                                              THEME.darkHighContrast
                                      ? fromRole(
                                                  role:
                                                      workspaceProvider.role) >=
                                              workspaceProvider
                                                      .workspaceMembers[index]
                                                  ['role']
                                          ? Colors.white
                                          : darkSecondaryTextColor
                                      : fromRole(
                                                  role:
                                                      workspaceProvider.role) >=
                                              workspaceProvider
                                                      .workspaceMembers[index]
                                                  ['role']
                                          ? Colors.black
                                          : greyColor,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: (workspaceProvider.workspaceMembers[index]
                                      ['member']["id"] ==
                                  profileProvider.userProfile.id)
                              ? Colors.transparent
                              : fromRole(role: workspaceProvider.role) >=
                                      workspaceProvider.workspaceMembers[index]
                                          ['role']
                                  ? themeProvider.themeManager.primaryTextColor
                                  : Colors.transparent,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          ListView.separated(
              primary: false,
              shrinkWrap: true,
              itemCount: workspaceProvider.workspaceInvitationsMembers.length,
              separatorBuilder: (context, index) => Container(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 3, bottom: 3),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                      color: themeProvider.themeManager.borderSubtle01Color,
                    ),
                  ),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Stack(
                    children: [
                      MemberLogoWidget(
                        colorForErrorWidget:
                            ColorManager.getColorWithIndex(index),
                        imageUrl: '',
                        memberNameFirstLetterForErrorWidget: workspaceProvider
                            .workspaceInvitationsMembers[index]['email'][0]
                            .toString()
                            .toUpperCase(),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: themeProvider
                              .themeManager.primaryBackgroundDefaultColor,
                          child: CircleAvatar(
                            backgroundColor:
                                themeProvider.themeManager.textWarningColor,
                            radius: 9,
                            child: SvgPicture.asset(
                                'assets/svg_images/Pending.svg'),
                          ),
                        ),
                      )
                    ],
                  ),
                  title: CustomText(
                    workspaceProvider.workspaceInvitationsMembers[index]
                        ['email'],
                    type: FontStyle.H6,
                    fontWeight: FontWeightt.Medium,
                    maxLines: 1,
                    color: themeProvider.themeManager.primaryTextColor,
                  ),
                  subtitle: SizedBox(
                    child: CustomText(
                      workspaceProvider.workspaceInvitationsMembers[index]
                          ['email'],
                      color: themeProvider.themeManager.placeholderTextColor,
                      textAlign: TextAlign.left,
                      type: FontStyle.Small,
                    ),
                  ),
                  trailing: InkWell(
                    onTap: () {
                      if (fromRole(role: workspaceProvider.role) <
                          workspaceProvider.workspaceInvitationsMembers[index]
                              ['role']) {
                        CustomToast.showToast(context,
                            message: accessRestrictedMSG,
                            toastType: ToastType.failure);
                      } else if (workspaceProvider
                              .workspaceInvitationsMembers[index]["id"] ==
                          ref
                              .read(ProviderList.profileProvider)
                              .userProfile
                              .id) {
                        if (workspaceProvider.workspaceInvitationsMembers[index]
                                ['role'] ==
                            15) {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            enableDrag: true,
                            constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.85),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            context: context,
                            builder: (BuildContext context) =>
                                DeleteOrLeaveWorkpace(
                              workspaceName: workspaceProvider
                                  .selectedWorkspace.workspaceName,
                              role: getRole(),
                            ),
                          );
                        } else {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            enableDrag: true,
                            constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.85),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            context: context,
                            builder: (BuildContext context) =>
                                DeleteOrLeaveWorkpace(
                              workspaceName: workspaceProvider
                                  .selectedWorkspace.workspaceName,
                              role: Role.none,
                            ),
                          );
                        }
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
                              firstName: workspaceProvider
                                  .workspaceInvitationsMembers[index]['email'],
                              lastName: '',
                              role: {
                                "role": workspaceProvider
                                    .workspaceInvitationsMembers[index]['role']
                              },
                              userId: workspaceProvider
                                  .workspaceInvitationsMembers[index]['id'],
                              isInviteMembers: false,
                              pendingInvite: true,
                            );
                          },
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      constraints: const BoxConstraints(maxWidth: 87),
                      child: Row(
                        children: [
                          const Spacer(),
                          SizedBox(
                            child: SizedBox(
                              child: CustomText(
                                workspaceProvider.workspaceInvitationsMembers[
                                            index]['role'] ==
                                        20
                                    ? 'Admin'
                                    : workspaceProvider
                                                    .workspaceInvitationsMembers[
                                                index]['role'] ==
                                            15
                                        ? 'Member'
                                        : workspaceProvider
                                                        .workspaceInvitationsMembers[
                                                    index]['role'] ==
                                                10
                                            ? 'Viewer'
                                            : 'Guest',
                                type: FontStyle.Medium,
                                fontWeight: FontWeightt.Medium,
                                color: (workspaceProvider
                                                .workspaceInvitationsMembers[index]
                                            ["id"] ==
                                        profileProvider.userProfile.id)
                                    ? greyColor
                                    : themeProvider.themeManager.theme ==
                                                THEME.dark ||
                                            themeProvider.themeManager.theme ==
                                                THEME.darkHighContrast
                                        ? fromRole(role: workspaceProvider.role) >=
                                                workspaceProvider
                                                        .workspaceInvitationsMembers[
                                                    index]['role']
                                            ? Colors.white
                                            : darkSecondaryTextColor
                                        : fromRole(role: workspaceProvider.role) >=
                                                workspaceProvider
                                                        .workspaceInvitationsMembers[
                                                    index]['role']
                                            ? Colors.black
                                            : greyColor,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: (workspaceProvider
                                            .workspaceInvitationsMembers[index]
                                        ["id"] ==
                                    profileProvider.userProfile.id)
                                ? Colors.transparent
                                : fromRole(role: workspaceProvider.role) >=
                                        workspaceProvider
                                                .workspaceInvitationsMembers[
                                            index]['role']
                                    ? themeProvider
                                        .themeManager.primaryTextColor
                                    : Colors.transparent,
                            size: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }

  bool checkIfWorkspaceAdmin() {
    final workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    final profileProvider = ref.watch(ProviderList.profileProvider);
    bool isAdmin = false;
    for (final element in workspaceProvider.workspaceMembers) {
      if (element['member']['id'] == profileProvider.userProfile.id &&
          element['role'] == 20) {
        isAdmin = true;
      }
    }
    return isAdmin;
  }

  Role getRole() {
    final projectProvider = ref.watch(ProviderList.projectProvider);
    final profileProvider = ref.watch(ProviderList.profileProvider);
    int? userRole;
    final List members = projectProvider.projectMembers;
    for (final element in members) {
      if (element['member']['id'] == profileProvider.userProfile.id) {
        userRole = element['role'];
      }
    }
    switch (userRole) {
      case 20:
        return role = Role.admin;
      case 15:
        return role = Role.member;
      case 10:
        return role = Role.viewer;
      case 5:
        return role = Role.guest;
      default:
        return role = Role.guest;
    }
  }
}

class ProjectMembersWidget extends ConsumerStatefulWidget {
  const ProjectMembersWidget({super.key});

  @override
  ConsumerState<ProjectMembersWidget> createState() =>
      _ProjectMembersWidgetState();
}

class _ProjectMembersWidgetState extends ConsumerState<ProjectMembersWidget> {
  Role? role;
  @override
  Widget build(BuildContext context) {
    final projectsProvider = ref.watch(ProviderList.projectProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final profileProvider = ref.watch(ProviderList.profileProvider);
    final workspaceProvider = ref.watch(ProviderList.workspaceProvider);

    return ListView.separated(
      itemCount: projectsProvider.projectMembers.length,
      separatorBuilder: (context, index) => Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 3, bottom: 3),
        child: Divider(
            height: 1,
            thickness: 1,
            indent: 0,
            endIndent: 0,
            color: themeProvider.themeManager.borderSubtle01Color),
      ),
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            if (roleParser(
                    role: projectsProvider.projectMembers[index]['role']) ==
                Role.guest) {
              return;
            }

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => UserProfileScreen(
                  userID: projectsProvider.projectMembers[index]['member']
                      ["id"],
                ),
              ),
            );
          },
          leading: projectsProvider.projectMembers[index]['member']['avatar'] ==
                      null ||
                  projectsProvider.projectMembers[index]['member']['avatar'] ==
                      ""
              ? MemeberLogoAlternativeWidget(
                  projectsProvider.projectMembers[index]['member']['first_name']
                          [0]
                      .toString()
                      .toUpperCase(),
                  ColorManager.getColorWithIndex(index))
              : MemberLogoWidget(
                  imageUrl: projectsProvider.projectMembers[index]['member']
                      ['avatar'],
                  colorForErrorWidget: ColorManager.getColorWithIndex(index),
                  memberNameFirstLetterForErrorWidget: projectsProvider
                      .projectMembers[index]['member']['first_name'][0]
                      .toString()
                      .toUpperCase()),
          title: CustomText(
            '${projectsProvider.projectMembers[index]['member']['first_name']} ${projectsProvider.projectMembers[index]['member']['last_name'] ?? ''}',
            type: FontStyle.H6,
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
              type: FontStyle.Small,
            ),
          ),
          trailing: GestureDetector(
            onTap: () {
              if (fromRole(role: projectsProvider.role) <
                  projectsProvider.projectMembers[index]['role']) {
                CustomToast.showToast(context,
                    message: accessRestrictedMSG, toastType: ToastType.failure);
              } else if (projectsProvider.projectMembers[index]['member']
                      ["id"] ==
                  ref.read(ProviderList.profileProvider).userProfile.id) {
                if (projectsProvider.projectMembers[index]['role'] == 15) {
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
                        return DeleteLeaveProjectSheet(
                          data: {
                            'WORKSPACE_ID':
                                workspaceProvider.selectedWorkspace.workspaceId,
                            'WORKSPACE_NAME': workspaceProvider
                                .selectedWorkspace.workspaceName,
                            'WORKSPACE_SLUG': workspaceProvider
                                .selectedWorkspace.workspaceSlug,
                            'PROJECT_ID':
                                projectsProvider.projectDetailModel!.id,
                            'PROJECT_NAME':
                                projectsProvider.projectDetailModel!.name
                          },
                          role: getRole(),
                        );
                      });
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
                      return DeleteLeaveProjectSheet(
                        data: {
                          'WORKSPACE_ID':
                              workspaceProvider.selectedWorkspace.workspaceId,
                          'WORKSPACE_NAME':
                              workspaceProvider.selectedWorkspace.workspaceName,
                          'WORKSPACE_SLUG':
                              workspaceProvider.selectedWorkspace.workspaceSlug,
                          'PROJECT_ID': projectsProvider.projectDetailModel!.id,
                          'PROJECT_NAME':
                              projectsProvider.projectDetailModel!.name
                        },
                        role: Role.none,
                      );
                    },
                  );
                }
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
                      fromWorkspace: false,
                      firstName: projectsProvider.projectMembers[index]
                          ['member']['first_name'],
                      lastName: projectsProvider.projectMembers[index]['member']
                          ['last_name'],
                      role: {
                        "role": projectsProvider.projectMembers[index]['role']
                      },
                      userId: projectsProvider.projectMembers[index]['id'],
                      isInviteMembers: false,
                      pendingInvite: false,
                    );
                  },
                );
              }
            },
            child: Container(
              constraints: const BoxConstraints(maxWidth: 84),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
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
                        color: (projectsProvider.projectMembers[index]['member']
                                    ["id"] ==
                                profileProvider.userProfile.id)
                            ? greyColor
                            : themeProvider.themeManager.theme == THEME.dark ||
                                    themeProvider.themeManager.theme ==
                                        THEME.darkHighContrast
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
                    Icons.keyboard_arrow_down,
                    color: (projectsProvider.projectMembers[index]['member']
                                ["id"] ==
                            profileProvider.userProfile.id)
                        ? Colors.transparent
                        : fromRole(role: projectsProvider.role) >=
                                projectsProvider.projectMembers[index]['role']
                            ? themeProvider.themeManager.primaryTextColor
                            : Colors.transparent,
                    size: 20,
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
    final projectsProvider = ref.watch(ProviderList.projectProvider);
    final profileProvider = ref.watch(ProviderList.profileProvider);
    bool isAdmin = false;
    for (final element in projectsProvider.projectMembers) {
      if (element['member']['id'] == profileProvider.userProfile.id &&
          element['role'] == 20) {
        isAdmin = true;
      }
    }
    return isAdmin;
  }

  Role getRole() {
    final projectProvider = ref.watch(ProviderList.projectProvider);
    final profileProvider = ref.watch(ProviderList.profileProvider);
    int? userRole;
    final List members = projectProvider.projectMembers;
    for (final element in members) {
      if (element['member']['id'] == profileProvider.userProfile.id) {
        userRole = element['role'];
      }
    }
    switch (userRole) {
      case 20:
        return role = Role.admin;
      case 15:
        return role = Role.member;
      case 10:
        return role = Role.viewer;
      case 5:
        return role = Role.guest;
      default:
        return role = Role.guest;
    }
  }
}
