import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/provider/provider_list.dart';

import 'package:plane/widgets/custom_text.dart';

class MemberStatus extends ConsumerStatefulWidget {
  const MemberStatus(
      {super.key,
      required this.firstName,
      required this.lastName,
      required this.role,
      required this.isInviteMembers,
      required this.fromWorkspace,
      required this.userId,
      required this.pendingInvite});
  final String firstName;
  final String lastName;
  final Map role;
  final String userId;
  final bool fromWorkspace;
  final bool isInviteMembers;
  final bool pendingInvite;

  @override
  ConsumerState<MemberStatus> createState() => _MemberStatusState();
}

class _MemberStatusState extends ConsumerState<MemberStatus> {
  List options = [
    {'role': 'Admin', 'value': 20},
    {'role': 'Member', 'value': 15},
    {'role': 'Viewer', 'value': 10},
    {'role': 'Guest', 'value': 5},
  ];
  String name = '';
  int selectedRole = 0;
  @override
  void initState() {
    super.initState();
    selectedRole = widget.role['role'];

    if (widget.lastName == '') {
      name = "${widget.firstName}'s Role";
    } else {
      name = "${widget.firstName} ${widget.lastName}'s Role";
    }

    if (widget.isInviteMembers) {
      name = widget.firstName;
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider = ref.watch(ProviderList.projectProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    return Stack(
      children: [
        Wrap(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 15, left: 5, right: 10),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 15),
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: CustomText(
                          widget.pendingInvite ? '' : name,
                          type: FontStyle.H4,
                          fontWeight: FontWeightt.Semibold,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close,
                          size: 27,
                          color:
                              themeProvider.themeManager.placeholderTextColor,
                        ),
                      ),
                    ],
                  ),
                  // list containing radio buttons and role text and radio button should change according to selectedRole
                  Column(
                    children: [
                      ListView.builder(
                          itemCount: options.length,
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (context, index) {
                            return (widget.fromWorkspace
                                    ? (index == 0 &&
                                        workspaceProvider.role != Role.admin)
                                    : (index == 0 &&
                                        projectProvider.role != Role.admin))
                                ? Container()
                                : Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (widget.pendingInvite) {
                                            CustomToast.showToast(context,
                                                message:
                                                    'Member hasn\'t joined yet',
                                                toastType: ToastType.defult);
                                          } else {
                                            setState(() {
                                              selectedRole = options[index]
                                                  ['value'] as int;
                                              if (widget.isInviteMembers) {
                                                workspaceProvider
                                                        .invitingMembersRole
                                                        .text =
                                                    options[index]['role'];
                                              } else {
                                                if (widget.fromWorkspace) {
                                                  workspaceProvider
                                                      .updateWorkspaceMember(
                                                    userId: widget.userId,
                                                    method: selectedRole == 0
                                                        ? CRUD.delete
                                                        : CRUD.update,
                                                    data: {
                                                      'role': selectedRole
                                                          .toString()
                                                    },
                                                  );
                                                } else {
                                                  projectProvider
                                                      .updateProjectMember(
                                                    slug: workspaceProvider
                                                        .selectedWorkspace
                                                        .workspaceSlug,
                                                    projId: projectProvider
                                                        .currentProject['id'],
                                                    userId: widget.userId,
                                                    method: selectedRole == 0
                                                        ? CRUD.delete
                                                        : CRUD.update,
                                                    data: {
                                                      'role': selectedRole
                                                          .toString()
                                                    },
                                                  );
                                                }
                                              }

                                              Navigator.pop(context);
                                            });
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            Radio(
                                              activeColor: selectedRole ==
                                                      options[index]['value']
                                                  ? null
                                                  : themeProvider.themeManager
                                                      .primaryColour,
                                              fillColor: selectedRole !=
                                                      options[index]['value']
                                                  ? MaterialStateProperty
                                                      .all<Color>(themeProvider
                                                          .themeManager
                                                          .borderSubtle01Color)
                                                  : null,
                                              value: options[index]['value'],
                                              groupValue: selectedRole,
                                              onChanged: (value) {
                                                if (!widget.pendingInvite) {
                                                  setState(() {
                                                    selectedRole =
                                                        options[index]['value']
                                                            as int;
                                                    if (widget
                                                        .isInviteMembers) {
                                                      // widget.role['role'] =
                                                      //     selectedRole;
                                                      workspaceProvider
                                                              .invitingMembersRole
                                                              .text =
                                                          options[index]
                                                              ['role'];
                                                    } else {
                                                      if (widget
                                                          .fromWorkspace) {
                                                        workspaceProvider
                                                            .updateWorkspaceMember(
                                                          userId: widget.userId,
                                                          method:
                                                              selectedRole == 0
                                                                  ? CRUD.delete
                                                                  : CRUD.update,
                                                          data: {
                                                            'role': selectedRole
                                                                .toString()
                                                          },
                                                        );
                                                      } else {
                                                        projectProvider
                                                            .updateProjectMember(
                                                          slug: workspaceProvider
                                                              .selectedWorkspace
                                                              .workspaceSlug,
                                                          projId: projectProvider
                                                                  .currentProject[
                                                              'id'],
                                                          userId: widget.userId,
                                                          method:
                                                              selectedRole == 0
                                                                  ? CRUD.delete
                                                                  : CRUD.update,
                                                          data: {
                                                            'role': selectedRole
                                                                .toString()
                                                          },
                                                        );
                                                      }
                                                    }

                                                    Navigator.pop(context);
                                                  });
                                                }
                                              },
                                            ),
                                            CustomText(options[index]['role'],
                                                type: FontStyle.Small,
                                                color: widget.pendingInvite
                                                    ? themeProvider.themeManager
                                                        .tertiaryTextColor
                                                    : themeProvider.themeManager
                                                        .primaryTextColor),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Container(
                                          height: 1,
                                          width: double.infinity,
                                          color: themeProvider
                                              .themeManager.borderDisabledColor,
                                        ),
                                      ),
                                    ],
                                  );
                          }),
                      const SizedBox(height: 20),
                    ],
                  ),
                  widget.isInviteMembers ||
                          ((widget.fromWorkspace &&
                                  workspaceProvider.role != Role.admin) ||
                              (!widget.fromWorkspace &&
                                  projectProvider.role != Role.admin))
                      ? Container()
                      : Column(
                          children: [
                            const SizedBox(height: 25),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: GestureDetector(
                                onTap: () {
                                  if (widget.fromWorkspace) {
                                    if (widget.pendingInvite) {
                                      workspaceProvider
                                          .removeWorkspaceMemberInvitations(
                                              userId: widget.userId)
                                          .then((value) => workspaceProvider
                                              .getWorkspaceMemberInvitations());
                                    } else {
                                      workspaceProvider.updateWorkspaceMember(
                                        userId: widget.userId,
                                        method: CRUD.delete,
                                        data: {'role': 0},
                                      );
                                    }
                                  } else {
                                    projectProvider.updateProjectMember(
                                      slug: workspaceProvider
                                          .selectedWorkspace.workspaceSlug,
                                      projId:
                                          projectProvider.currentProject['id'],
                                      userId: widget.userId,
                                      method: CRUD.delete,
                                      data: {'role': 0},
                                    );
                                  }

                                  Navigator.pop(context);
                                },
                                child: CustomText(
                                  "Remove",
                                  type: FontStyle.H5,
                                  fontWeight: FontWeightt.Medium,
                                  color:
                                      themeProvider.themeManager.textErrorColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ],
        ),
        projectProvider.updateProjectMemberState == DataState.loading
            ? Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:
                      themeProvider.themeManager.primaryBackgroundDefaultColor,
                  //color: Colors.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                alignment: Alignment.center,

                // height: 25,
                // width: 25,
                child: Wrap(
                  children: [
                    SizedBox(
                      height: 25,
                      width: 25,
                      child: LoadingIndicator(
                        indicatorType: Indicator.lineSpinFadeLoader,
                        colors: [
                          themeProvider
                              .themeManager.primaryBackgroundDefaultColor
                        ],
                        strokeWidth: 1.0,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
