// ignore_for_file: use_build_context_synchronously
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/bottom_sheets/member_status.dart';
import 'package:plane_startup/bottom_sheets/select_emails.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/custom_toast.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/utils/global_functions.dart';
import 'package:plane_startup/widgets/submit_button.dart';
import 'package:plane_startup/widgets/loading_widget.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/widgets/custom_text.dart';

class ProjectInviteMembersSheet extends ConsumerStatefulWidget {
  const ProjectInviteMembersSheet({super.key});

  @override
  ConsumerState<ProjectInviteMembersSheet> createState() =>
      _ProjectInviteMembersSheetState();
}

class _ProjectInviteMembersSheetState
    extends ConsumerState<ProjectInviteMembersSheet> {
  TextEditingController emailController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<String> emailList = [];
  bool keypadVisible = false;
  Map selectedEmail = {};
  Map selectedRole = {'role': 10};
  bool isEmailEmpty = false;

  @override
  void initState() {
    super.initState();
    var workspaceProvider = ref.read(ProviderList.workspaceProvider);
    workspaceProvider.invitingMembersRole.text = 'Viewer';
    for (var element in workspaceProvider.workspaceMembers) {
      emailList.add(element['member']['email']);
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    BuildContext mainBuildContext = context;
    return LoadingWidget(
      loading: projectProvider.projectInvitationState == StateEnum.loading,
      widgetClass: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();

          setState(() {
            keypadVisible = false;
          });
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 25, bottom: 20),
                      child: Row(
                        children: [
                          const CustomText(
                            'Invite Members',
                            type: FontStyle.H6,
                            fontWeight: FontWeightt.Semibold,
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(
                              Icons.close,
                              color: themeProvider
                                  .themeManager.placeholderTextColor,
                            ),
                          )
                        ],
                      ),
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 5),
                            child: const Row(
                              children: [
                                CustomText(
                                  'Email',
                                  type: FontStyle.Small,
                                ),
                                CustomText(
                                  '*',
                                  type: FontStyle.Small,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: workspaceProvider.workspaceMembers.length > 1
                                ? () async {
                                    isEmailEmpty = false;
                                    await showModalBottomSheet(
                                        isScrollControlled: true,
                                        enableDrag: true,
                                        constraints: BoxConstraints(
                                            maxHeight: height * 0.8),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          topRight: Radius.circular(30),
                                        )),
                                        context: context,
                                        builder: (ctx) {
                                          return SelectEmails(
                                            email: selectedEmail,
                                          );
                                        });
                                    setState(() {});
                                    log(selectedEmail.toString());
                                  }
                                : () {
                                    CustomToast().showToast(
                                      context,
                                      'You are the only member of this workspace. Please add more members to workspace first.',
                                      themeProvider,
                                      //toastType: ToastType.warning
                                    );
                                  },
                            child: Container(
                                margin: const EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                ),
                                height: 48,
                                padding: const EdgeInsets.only(
                                  left: 10,
                                ),
                                decoration: BoxDecoration(
                                    color: themeProvider.themeManager
                                        .primaryBackgroundDefaultColor,
                                    border: Border.all(
                                        color: themeProvider
                                            .themeManager.borderSubtle01Color),
                                    borderRadius: BorderRadius.circular(6)),
                                child: Row(
                                  children: [
                                    CustomText(
                                      selectedEmail['email'] ?? '',
                                      fontSize: 16,
                                      color: themeProvider
                                          .themeManager.primaryTextColor,
                                    ),
                                    const Spacer(),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: themeProvider
                                          .themeManager.placeholderTextColor,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    )
                                  ],
                                )),
                          ),
                          isEmailEmpty
                              ? Container(
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20, bottom: 5),
                                  child: const CustomText(
                                    '*required',
                                    type: FontStyle.Small,
                                    fontSize: 14,
                                    color: Colors.red,
                                  ),
                                )
                              : Container(),
                          Container(
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 5),
                              child: const Row(
                                children: [
                                  CustomText(
                                    'Role',
                                    type: FontStyle.Small,
                                  ),
                                  CustomText(
                                    '*',
                                    type: FontStyle.Small,
                                    color: Colors.red,
                                  ),
                                ],
                              )),
                          InkWell(
                            onTap: () async {
                              await showModalBottomSheet(
                                  isScrollControlled: true,
                                  enableDrag: true,
                                  // constraints: BoxConstraints(
                                  //     maxHeight: height * 0.55),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  )),
                                  context: context,
                                  builder: (ctx) {
                                    return MemberStatus(
                                      fromWorkspace: true,
                                      firstName: 'Set User',
                                      lastName: '',
                                      role: {
                                        'role': getRoleIndex(workspaceProvider
                                            .invitingMembersRole.text)
                                      },
                                      userId: '',
                                      isInviteMembers: true,
                                    );
                                  });
                              log(selectedRole.toString());
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                controller:
                                    workspaceProvider.invitingMembersRole,
                                decoration: themeProvider
                                    .themeManager.textFieldDecoration
                                    .copyWith(
                                  fillColor: themeProvider.themeManager
                                      .primaryBackgroundDefaultColor,
                                  filled: true,
                                ),
                                enabled: false,
                              ),
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 5),
                              child: const CustomText(
                                'Message ',
                                type: FontStyle.Small,
                              )),
                          Container(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                            ),
                            child: TextFormField(
                              onTap: () {
                                setState(() {
                                  keypadVisible = true;
                                });
                              },
                              controller: messageController,
                              maxLines: 6,
                              decoration: themeProvider
                                  .themeManager.textFieldDecoration
                                  .copyWith(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 15),
                                fillColor: themeProvider
                                    .themeManager.primaryBackgroundDefaultColor,
                                filled: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 30,
                        bottom: 20,
                      ),
                      child: SubmitButton(
                        onPressed: () async {
                          bool isCorrect = formKey.currentState!.validate();
                          if (!isCorrect || selectedEmail['email'] == null) {
                            setState(() {
                              isEmailEmpty = true;
                            });
                            return;
                          }
                          // log( projectProvider.currentProject["id"]);
                          await projectProvider.inviteToProject(
                            context: mainBuildContext,
                            slug: workspaceProvider
                                .selectedWorkspace!.workspaceSlug,
                            projId: projectProvider.currentProject['id'],
                            data: {
                              "members": [
                                {
                                  'member_id': selectedEmail['id'],
                                  'role': selectedRole['role']
                                }
                              ]
                            },
                          );

                          if (projectProvider.projectInvitationState ==
                              StateEnum.success) {
                            postHogService(
                                eventName: 'PROJECT_MEMBER_INVITE',
                                properties: {
                                  'WORKSPACE_ID': workspaceProvider
                                      .selectedWorkspace!.workspaceId,
                                  'WORKSPACE_SLUG': workspaceProvider
                                      .selectedWorkspace!.workspaceSlug,
                                  'WORKSPACE_NAME': workspaceProvider
                                      .selectedWorkspace!.workspaceName,
                                  'PROJECT_ID':
                                      projectProvider.projectDetailModel!.id,
                                  'PROJECT_NAME':
                                      projectProvider.projectDetailModel!.name,
                                  'INVITED_PROJECT_MEMBER': emailController.text
                                },
                                ref: ref);
                            //show success snackbar

                            if (projectProvider.projectInvitationState ==
                                StateEnum.success) {
                              //show success snackbar
                              CustomToast().showToast(mainBuildContext,
                                  'Invitation sent successfully', themeProvider,
                                  toastType: ToastType.success);
                              Navigator.pop(mainBuildContext);
                            } else {
                              CustomToast().showToast(mainBuildContext,
                                  'Something went wrong', themeProvider,
                                  toastType: ToastType.failure);
                            }
                          } else {}
                        },
                        text: 'Invite',
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  int getRoleIndex(String value) {
    List<Map<String, int>> options = [
      {'Admin': 20},
      {'Member': 15},
      {'Viewer': 10},
      {'Guest': 5},
      {'Remove User': 0}
    ];

    for (Map<String, int> item in options) {
      if (item.containsKey(value)) {
        return item[value]!;
      }
    }
    return 10;
  }
}
