import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plane/bottom_sheets/permission_role_sheet.dart';
import 'package:plane/screens/home_screen.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/loading_widget.dart';
import '../../../provider/provider_list.dart';
import '../../../widgets/custom_button.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_text.dart';

class InviteCOWorkers extends ConsumerStatefulWidget {
  const InviteCOWorkers({super.key});

  @override
  ConsumerState<InviteCOWorkers> createState() => _InviteCOWorkersState();
}

class _InviteCOWorkersState extends ConsumerState<InviteCOWorkers> {
  final formKey = GlobalKey<FormState>();
  List invitations = [
    {'email': TextEditingController(), 'role': Role.guest, "is_valid": true}
  ];

  bool validateEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  TextEditingController inviteEmailController = TextEditingController();
  bool allFine = false;
  @override
  Widget build(BuildContext context) {
    var prov = ref.watch(ProviderList.workspaceProvider);
    var profileProvider = ref.watch(ProviderList.profileProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    log(prov.workspaces.toString());
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: LoadingWidget(
          loading: prov.workspaceInvitationState == StateEnum.loading ||
              prov.workspaceInvitationState == StateEnum.loading,
          widgetClass: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset('assets/svg_images/logo.svg'),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomText(
                        'Invite co-workers to team',
                        type: FontStyle.H4,
                        fontWeight: FontWeightt.Semibold,
                        color: themeProvider.themeManager.primaryTextColor,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: invitations.length,
                          itemBuilder: (ctx, index) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText('Co-workers Email',
                                                type: FontStyle.Small,
                                                color: themeProvider
                                                    .themeManager
                                                    .tertiaryTextColor),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            TextFormField(
                                              controller: invitations[index]
                                                  ['email'],
                                              style: themeProvider.themeManager
                                                  .textFieldTextStyle,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              decoration: themeProvider
                                                  .themeManager
                                                  .textFieldDecoration
                                                  .copyWith(),
                                              onChanged: (value) => formKey
                                                  .currentState!
                                                  .validate(),
                                              validator: (email) {
                                                if (RegExp(
                                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                    .hasMatch(email!)) {
                                                  invitations[index]
                                                      ["is_valid"] = true;
                                                  return null;
                                                }
                                                invitations[index]["is_valid"] =
                                                    false;
                                                return null;
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText('Role',
                                                type: FontStyle.Small,
                                                color: themeProvider
                                                    .themeManager
                                                    .tertiaryTextColor),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                await showModalBottomSheet(
                                                    context: context,
                                                    constraints: BoxConstraints(
                                                      maxHeight:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.5,
                                                    ),
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(20),
                                                        topRight:
                                                            Radius.circular(20),
                                                      ),
                                                    ),
                                                    builder: (context) {
                                                      return PermissionRoleSheet(
                                                        data:
                                                            invitations[index],
                                                      );
                                                    });
                                                if (invitations[index]
                                                        ['role'] ==
                                                    Role.none) {
                                                  invitations.removeAt(index);
                                                }
                                                setState(() {});
                                              },
                                              child: TextFormField(
                                                enabled: false,
                                                style: themeProvider
                                                    .themeManager
                                                    .textFieldTextStyle
                                                    .copyWith(
                                                  fontSize:
                                                      fontSIZE[FontStyle.Small],
                                                  height: lineHeight[
                                                      FontStyle.Small],
                                                ),
                                                controller: TextEditingController(
                                                    text: (invitations[index]
                                                                    ['role']
                                                                as Role)
                                                            .name
                                                            .toUpperCase()[0] +
                                                        (invitations[index]
                                                                    ['role']
                                                                as Role)
                                                            .name
                                                            .substring(1)),
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                decoration: themeProvider
                                                    .themeManager
                                                    .textFieldDecoration
                                                    .copyWith(
                                                        suffixIcon: Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: themeProvider
                                                      .themeManager
                                                      .primaryTextColor,
                                                )),
                                                onChanged: (value) => formKey
                                                    .currentState!
                                                    .validate(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  invitations[index]['is_valid'] == false
                                      ? CustomText('* Please enter valid email',
                                          type: FontStyle.Small,
                                          color: themeProvider
                                              .themeManager.textErrorColor)
                                      : Container(),
                                ],
                              ),
                            );
                          }),
                      GestureDetector(
                        onTap: () {
                          formKey.currentState!.validate();
                          for (var item in invitations) {
                            if (item["is_valid"] == false) {
                              setState(() {});
                              log("HERRE");
                              return;
                            }
                          }
                          invitations.add({
                            'email': TextEditingController(),
                            'role': Role.guest,
                            "is_valid": true
                          });
                          inviteEmailController.clear();
                          setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 10),
                          child: Row(
                            children: [
                              //add icon
                              Icon(
                                Icons.add,
                                color: themeProvider.themeManager.primaryColour,
                                size: 20,
                              ),

                              //text
                              CustomText(
                                'Add another',
                                type: FontStyle.Small,
                                fontWeight: FontWeightt.Medium,
                                color: themeProvider.themeManager.primaryColour,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Hero(
                        tag: 'button2',
                        child: Button(
                          textColor: invitations.isEmpty ||
                                  !validateEmail(invitations[0]['email'].text)
                              ? themeProvider.themeManager.placeholderTextColor
                              : Colors.white,
                          color: invitations.isEmpty ||
                                  !validateEmail(invitations[0]['email'].text)
                              ? themeProvider.themeManager.disabledButtonColor
                              : themeProvider.themeManager.primaryColour,
                          text: 'Continue',
                          disable: invitations.isEmpty ||
                                  !validateEmail(invitations[0]['email'].text)
                              ? true
                              : false,
                          ontap: () async {
                            formKey.currentState!.validate();
                            for (var item in invitations) {
                              if (item["is_valid"] == false) {
                                setState(() {});
                                log("HERRE");
                                return;
                              }
                            }

                            var data = invitations
                                .map((e) => {
                                      "email": e['email'].text,
                                      "role": fromRole(role: e['role']),
                                    })
                                .toList();
                            log(data.toString());

                            await prov.getWorkspaces().then((value) async {
                              log(prov.selectedWorkspace!.workspaceName
                                  .toString());

                              prov.inviteToWorkspace(
                                  slug: prov.workspaces.last['slug'] ??
                                      profileProvider.userProfile
                                          .workspace!['last_workspace_slug'],
                                  email: data);

                              ref
                                  .read(ProviderList.profileProvider)
                                  .updateIsOnBoarded(val: true);
                              ref
                                  .read(ProviderList.profileProvider)
                                  .updateProfile(data: {
                                'onboarding_step': {
                                  "workspace_join": true,
                                  "profile_complete": true,
                                  "workspace_create": true,
                                  "workspace_invite": true
                                }
                              });

                              ref
                                  .read(ProviderList.projectProvider)
                                  .getProjects(
                                      slug: prov
                                          .selectedWorkspace!.workspaceSlug);

                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(
                                    fromSignUp: true,
                                  ),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            });
                            // }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Button(
                        text: 'Skip',
                        filledButton: false,
                        removeStroke: true,
                        textColor:
                            themeProvider.themeManager.placeholderTextColor,
                        ontap: () async {
                          await prov.getWorkspaces().then((value) {
                            log(prov.selectedWorkspace!.workspaceName
                                .toString());

                            ref
                                .read(ProviderList.profileProvider)
                                .updateIsOnBoarded(val: true);
                            ref
                                .read(ProviderList.profileProvider)
                                .updateProfile(data: {
                              'onboarding_step': {
                                "workspace_join": true,
                                "profile_complete": true,
                                "workspace_create": true,
                                "workspace_invite": true
                              }
                            });

                            ref.read(ProviderList.projectProvider).getProjects(
                                slug: prov.selectedWorkspace!.workspaceSlug);

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(
                                  fromSignUp: true,
                                ),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 20),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_back,
                                color: themeProvider
                                    .themeManager.placeholderTextColor,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              CustomText(
                                'Go back',
                                type: FontStyle.Small,
                                color: themeProvider
                                    .themeManager.placeholderTextColor,
                                fontWeight: FontWeightt.Semibold,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
