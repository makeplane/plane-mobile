// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plane_startup/screens/home_screen.dart';
import 'package:plane_startup/screens/on_boarding/auth/join_workspaces.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_rich_text.dart';
import 'package:plane_startup/widgets/loading_widget.dart';

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
  List emails = [];
  TextEditingController inviteEmailController = TextEditingController();
  bool validEmail = false;
  @override
  Widget build(BuildContext context) {
    var prov = ref.watch(ProviderList.workspaceProvider);
    var profileProvider = ref.watch(ProviderList.profileProvider);
    return Scaffold(
      body: LoadingWidget(
        loading: prov.workspaceInvitationState == StateEnum.loading ||
            prov.workspaceInvitationState == StateEnum.loading,
        widgetClass: SafeArea(
          child: Container(
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
                  const CustomText(
                    'Invite co-workers to team',
                    type: FontStyle.headingH4SemiBold,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const CustomRichText(
                    widgets: [
                      TextSpan(text: 'Email'),
                      TextSpan(text: '*', style: TextStyle(color: Colors.red))
                    ],
                    type: RichFontStyle.paragraphSmallRegular,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: inviteEmailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: kTextFieldDecoration.copyWith(
                      suffixIcon: GestureDetector(
                        onTap: () {
                          if (validEmail) {
                            setState(() {
                              emails.add({
                                "email": inviteEmailController.text,
                                "role": 'Guest'
                              });
                              inviteEmailController.clear();
                              validEmail = false;
                            });
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              right: 10, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: validEmail ? primaryColor : lightGreeyColor,
                          ),
                          child: Icon(
                            Icons.check,
                            color: validEmail ? Colors.white : greyColor,
                          ),
                        ),
                      ),
                    ),
                    onChanged: (value) => formKey.currentState!.validate(),
                    validator: (email) {
                      if (RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(email!)) {
                        setState(() {
                          validEmail = true;
                        });
                      }
                      return null;
                    },
                  ),
                  emails.isEmpty
                      ? Container()
                      : Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: emails.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.purple,
                                          child: CustomText(
                                            emails[index]['email']
                                                .toString()
                                                .toUpperCase()[0],
                                            color: Colors.white,
                                            type: FontStyle.title,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              emails[index]['email'],
                                              type: FontStyle.title,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            const Row(
                                              children: [
                                                CustomText(
                                                  'Invited',
                                                  type: FontStyle.title,
                                                  fontWeight: FontWeight.w500,
                                                  color: greyColor,
                                                ),
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          emails.removeAt(index);
                                        });
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        size: 18,
                                        color: Colors.red,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                  const SizedBox(
                    height: 30,
                  ),
                  Hero(
                    tag: 'button2',
                    child: Button(
                      text: 'Continue',
                      disable: emails.isEmpty ? true : false,
                      ontap: () async {
                        if (emails.isEmpty) return;

                        var roles = {
                          'Admin': "15",
                          'Member': "10",
                          'Owner': "20",
                          'Guest': "5",
                        };

                        var data = emails
                            .map((e) => {
                                  "email": e['email'],
                                  "role": roles[e['role']],
                                })
                            .toList();
                        log(data.toString());
                        await prov.inviteToWorkspace(
                            slug: prov.workspaces.last['slug'] ??
                                profileProvider.userProfile
                                    .workspace!['last_workspace_slug'],
                            email: data);
                        await ref
                            .watch(ProviderList.workspaceProvider)
                            .getWorkspaceInvitations();
                        profileProvider.updateProfile(data: {
                          'onboarding_step': {
                            "workspace_join": false,
                            "profile_complete": true,
                            "workspace_create": true,
                            "workspace_invite": true
                          }
                        });
                        if (prov.workspaceInvitations.isNotEmpty) {
                          profileProvider.updateProfile(data: {
                            'onboarding_step': {
                              "workspace_join": false,
                              "profile_complete": true,
                              "workspace_create": true,
                              "workspace_invite": true
                            }
                          });
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const JoinWorkspaces(
                                fromOnboard: true,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        } else {
                          profileProvider.updateProfile(data: {
                            'onboarding_step': {
                              "workspace_join": true,
                              "profile_complete": true,
                              "workspace_create": true,
                              "workspace_invite": true
                            }
                          });
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(
                                fromSignUp: true,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        }
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
                    textColor: greyColor,
                    ontap: () async {
                      await prov.getWorkspaceInvitations();
                      if (prov.workspaceInvitations.isNotEmpty) {
                        profileProvider.updateProfile(data: {
                          'onboarding_step': {
                            "workspace_join": false,
                            "profile_complete": true,
                            "workspace_create": true,
                            "workspace_invite": true
                          }
                        });
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const JoinWorkspaces(
                              fromOnboard: true,
                            ),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      } else {
                        await prov.ref!
                            .read(ProviderList.profileProvider)
                            .updateIsOnBoarded(val: true);
                        await profileProvider.updateProfile(data: {
                          'onboarding_step': {
                            "workspace_join": true,
                            "profile_complete": true,
                            "workspace_create": true,
                            "workspace_invite": true
                          }
                        });
                        await ref
                            .read(ProviderList.workspaceProvider)
                            .getWorkspaces();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(
                              fromSignUp: true,
                            ),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.arrow_back,
                          color: greyColor,
                          size: 18,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const CustomText(
                            'Go back',
                            type: FontStyle.heading2,
                            color: greyColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
