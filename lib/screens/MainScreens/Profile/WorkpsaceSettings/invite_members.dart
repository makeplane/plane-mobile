// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/bottom_sheets/member_status.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/utils/global_functions.dart';
import 'package:plane_startup/widgets/custom_app_bar.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import 'package:plane_startup/widgets/submit_button.dart';
import 'package:plane_startup/widgets/loading_widget.dart';

class InviteMembers extends ConsumerStatefulWidget {
  final bool isProject;
  const InviteMembers({super.key, required this.isProject});

  @override
  ConsumerState<InviteMembers> createState() => _InviteMembersState();
}

class _InviteMembersState extends ConsumerState<InviteMembers> {
  TextEditingController emailController = TextEditingController();
  String displayEmail = '';
  TextEditingController messageController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<String> emailList = [];

  @override
  void initState() {
    super.initState();
    var workspaceProvider = ref.read(ProviderList.workspaceProvider);
    workspaceProvider.invitingMembersRole.text = 'Member';
    for (var element in workspaceProvider.workspaceMembers) {
      emailList.add(element['member']['email']);
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        // backgroundColor: themeProvider.isDarkThemeEnabled
        //     ? darkSecondaryBackgroundColor
        //     : lightSecondaryBackgroundColor,
        appBar: CustomAppBar(
          onPressed: () {
            Navigator.of(context).pop();
          },
          text: 'Invite Members',
        ),
        body: LoadingWidget(
          loading: !widget.isProject
              ? workspaceProvider.workspaceInvitationState == StateEnum.loading
              : projectProvider.projectInvitationState == StateEnum.loading,
          widgetClass: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            height: 1,
                            width: MediaQuery.of(context).size.width,
                            color: themeProvider.isDarkThemeEnabled
                                ? darkThemeBorder
                                : Colors.grey[300],
                          ),
                          Container(
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 5),
                              child: Row(
                                children: [
                                  CustomText('Email',
                                      type: FontStyle.Small,
                                      color: themeProvider
                                          .themeManager.tertiaryTextColor),
                                  CustomText(
                                    '*',
                                    type: FontStyle.Small,
                                    color: themeProvider
                                        .themeManager.textErrorColor,
                                  ),
                                ],
                              )),
                          !widget.isProject
                              ? Container(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                  ),
                                  child: TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter email';
                                        } else if (!RegExp(
                                                r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                            .hasMatch(value)) {
                                          return 'Please enter valid email';
                                        }
                                        return null;
                                      },
                                      controller: emailController,
                                      decoration: themeProvider
                                          .themeManager.textFieldDecoration),
                                )
                              :
                              // Dropdown to choose email form email list
                              Container(
                                  margin: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                  ),
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                  ),
                                  decoration: BoxDecoration(
                                      color: themeProvider.isDarkThemeEnabled
                                          ? darkBackgroundColor
                                          : lightBackgroundColor,
                                      border: Border.all(color: greyColor),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: DropdownButtonFormField(
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Please select an email';
                                        }
                                        return null;
                                      },
                                      dropdownColor:
                                          themeProvider.isDarkThemeEnabled
                                              ? darkSecondaryBGC
                                              : lightSecondaryBackgroundColor,
                                      decoration: themeProvider
                                          .themeManager.textFieldDecoration
                                          .copyWith(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: themeProvider
                                                      .isDarkThemeEnabled
                                                  ? darkThemeBorder
                                                  : const Color(0xFFE5E5E5),
                                              width: 1.0),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8)),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: themeProvider
                                                      .isDarkThemeEnabled
                                                  ? darkThemeBorder
                                                  : const Color(0xFFE5E5E5),
                                              width: 1.0),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: themeProvider
                                                  .themeManager.primaryColour,
                                              width: 2.0),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8)),
                                        ),
                                      ),
                                      items: emailList.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: CustomText(
                                            value,
                                            type: FontStyle.Medium,
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        setState(() {
                                          displayEmail = val.toString();
                                        });
                                      }),
                                ),

                          Container(
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 5),
                              child: Row(
                                children: [
                                  CustomText(
                                    'Role',
                                    type: FontStyle.Small,
                                    color: themeProvider
                                        .themeManager.tertiaryTextColor,
                                  ),
                                  CustomText(
                                    '*',
                                    type: FontStyle.Small,
                                    color: themeProvider
                                        .themeManager.textErrorColor,
                                  ),
                                ],
                              )),
                          InkWell(
                            onTap: () async {
                              await showModalBottomSheet(
                                  isScrollControlled: true,
                                  enableDrag: true,
                                  constraints:
                                      BoxConstraints(maxHeight: height * 0.8),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  )),
                                  context: context,
                                  builder: (ctx) {
                                    return const MemberStatus(
                                      fromWorkspace: true,
                                      firstName: 'Set Role',
                                      lastName: '',
                                      role: {'role': 15},
                                      userId: '',
                                      isInviteMembers: true,
                                    );
                                  });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: TextFormField(
                                onTap: () async {
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
                                        return const MemberStatus(
                                          fromWorkspace: true,
                                          firstName: 'Set Role',
                                          lastName: '',
                                          role: {'role': 15},
                                          userId: '',
                                          isInviteMembers: true,
                                        );
                                      });
                                },
                                controller:
                                    workspaceProvider.invitingMembersRole,
                                decoration: themeProvider
                                    .themeManager.textFieldDecoration,
                                enabled: false,
                              ),
                            ),
                          ),
                          // Container(
                          //   margin: const EdgeInsets.only(
                          //     left: 20,
                          //     right: 20,
                          //   ),
                          //   padding: const EdgeInsets.only(
                          //     left: 10,
                          //   ),
                          //   decoration: BoxDecoration(
                          //       color: themeProvider.isDarkThemeEnabled
                          //           ? darkBackgroundColor
                          //           : lightBackgroundColor,
                          //       border: Border.all(color: greyColor),
                          //       borderRadius: BorderRadius.circular(4)),
                          //   child: DropdownButtonFormField(
                          //       validator: (value) {
                          //         if (value == null) {
                          //           return 'Please select role';
                          //         }
                          //       },
                          //       dropdownColor: themeProvider.isDarkThemeEnabled
                          //           ? darkSecondaryBGC
                          //           : lightSecondaryBackgroundColor,
                          //       decoration: const InputDecoration(
                          //         border: InputBorder.none,
                          //       ),
                          //       items: [
                          //         DropdownMenuItem(
                          //           value: 'Admin',
                          //           child: CustomText(
                          //             'Admin',
                          //             type: FontStyle.Medium,
                          //             fontWeight: FontWeight.bold,
                          //           ),
                          //         ),
                          //         DropdownMenuItem(
                          //           value: 'Member',
                          //           child: CustomText(
                          //             'Member',
                          //             type: FontStyle.Medium,
                          //             fontWeight: FontWeight.bold,
                          //           ),
                          //         ),
                          //         DropdownMenuItem(
                          //           value: 'Viewer',
                          //           child: CustomText(
                          //             'Viewer',
                          //             type: FontStyle.Medium,
                          //             fontWeight: FontWeight.bold,
                          //           ),
                          //         ),
                          //         DropdownMenuItem(
                          //           value: 'Guest',
                          //           child: CustomText(
                          //             'Guest',
                          //             type: FontStyle.Medium,
                          //             fontWeight: FontWeight.bold,
                          //           ),
                          //         ),
                          //       ],
                          //       onChanged: (val) {
                          //         setState(() {
                          //           _displayRole = val!;
                          //           if (_displayRole == 'Admin') {
                          //             _role = '20';
                          //           } else if (_displayRole == 'Member') {
                          //             _role = '15';
                          //           } else if (_displayRole == 'Viewer') {
                          //             _role = '10';
                          //           } else if (_displayRole == 'Guest') {
                          //             _role = '5';
                          //           }
                          //         });
                          //       }),
                          // ),

                          Container(
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 5),
                              child: CustomText(
                                'Message ',
                                type: FontStyle.Small,
                                color: themeProvider
                                    .themeManager.tertiaryTextColor,
                              )),
                          Container(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                            ),
                            child: TextFormField(
                              controller: messageController,
                              maxLines: 6,
                              decoration: themeProvider
                                  .themeManager.textFieldDecoration
                                  .copyWith(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: themeProvider
                                          .themeManager.borderSubtle01Color,
                                      width: 1.0),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: themeProvider.isDarkThemeEnabled
                                          ? darkThemeBorder
                                          : const Color(0xFFE5E5E5),
                                      width: 1.0),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: themeProvider
                                          .themeManager.primaryColour,
                                      width: 2.0),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                ),
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
                        top: 20,
                        bottom: 20,
                      ),
                      child: SubmitButton(
                        onPressed: () async {
                          bool isCorrect = formKey.currentState!.validate();
                          if (!isCorrect) {
                            return;
                          }

                          !widget.isProject
                              ? await workspaceProvider.inviteToWorkspace(
                                  slug: workspaceProvider
                                      .selectedWorkspace!.workspaceSlug,
                                  email: emailController.text,
                                  role: workspaceProvider
                                              .invitingMembersRole.text ==
                                          'Admin'
                                      ? '20'
                                      : workspaceProvider
                                                  .invitingMembersRole.text ==
                                              'Member'
                                          ? '15'
                                          : workspaceProvider
                                                      .invitingMembersRole
                                                      .text ==
                                                  'Viewer'
                                              ? '10'
                                              : '5')
                              : await projectProvider.inviteToProject(
                                  context: context,
                                  slug: workspaceProvider
                                      .selectedWorkspace!.workspaceSlug,
                                  projId: projectProvider.currentProject['id'],
                                  data: {
                                    'email': emailController.text,
                                  },
                                );

                          if (!widget.isProject &&
                              workspaceProvider.workspaceInvitationState ==
                                  StateEnum.success) {
                                    postHogService(
                                      eventName: 'WORKSPACE_USER_INVITE',
                                      properties: {
                                        'INVITED_USER_EMAIL': emailController.text,
                                      },
                                    ref: ref
                                );
                            //show success snackbar
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: CustomText(
                                'Invitation sent successfully',
                                type: FontStyle.Medium,
                                color: Colors.white,
                              ),
                              backgroundColor: Colors.green,
                            ));
                            Navigator.of(context).pop();
                          }
                          if (widget.isProject &&
                              projectProvider.projectInvitationState ==
                                  StateEnum.success) {
                            //show success snackbar
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: CustomText(
                                'Invitation sent successfully',
                                type: FontStyle.Medium,
                                color: Colors.white,
                              ),
                              backgroundColor: greenHighLight,
                            ));
                          }
                        },
                        text: 'Invite',
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
