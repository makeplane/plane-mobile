import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/widgets/custom_button.dart';

import 'package:plane_startup/widgets/custom_text.dart';

class MemberStatus extends ConsumerStatefulWidget {
  final String firstName;
  final String lastName;
  final Map role;
  final String userId;
  final bool fromWorkspace;
  final bool isInviteMembers;
  const MemberStatus(
      {super.key,
      required this.firstName,
      required this.lastName,
      required this.role,
      required this.isInviteMembers,
      required this.fromWorkspace,
      required this.userId});

  @override
  ConsumerState<MemberStatus> createState() => _MemberStatusState();
}

class _MemberStatusState extends ConsumerState<MemberStatus> {
  List options = [
    {'role': 'Admin', 'value': 20},
    {'role': 'Member', 'value': 15},
    {'role': 'Viewer', 'value': 10},
    {'role': 'Guest', 'value': 5},
    {'role': 'Remove User', 'value': 0}
  ];
  String name = '';
  int selectedRole = 0;
  @override
  void initState() {
    super.initState();
    if (widget.isInviteMembers) {
      options = [
        {'role': 'Admin', 'value': 20},
        {'role': 'Member', 'value': 15},
        {'role': 'Viewer', 'value': 10},
        {'role': 'Guest', 'value': 5},
      ];
    } else {
      options = [
        {'role': 'Admin', 'value': 20},
        {'role': 'Member', 'value': 15},
        {'role': 'Viewer', 'value': 10},
        {'role': 'Guest', 'value': 5},
        {'role': 'Remove User', 'value': 0}
      ];
    }
    selectedRole = widget.role['role'];
    if (widget.lastName == '') {
      name = "${widget.firstName}'s Role";
    } else {
      name = "${widget.firstName} ${widget.lastName}'s Role";
    }
  }

  @override
  Widget build(BuildContext context) {
    var projectProvider = ref.watch(ProviderList.projectProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Stack(
      children: [
        Wrap(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 15, left: 5, right: 10),
              decoration: const BoxDecoration(
                //color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // const Text(
                      //   'Type',
                      //   style: TextStyle(
                      //     fontSize: 24,
                      //     fontWeight: FontWeight.w600,
                      //   ),
                      // ),
                      Container(
                        margin: const EdgeInsets.only(left: 15),
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: CustomText(
                          name,
                          type: FontStyle.heading,
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
                        icon: const Icon(
                          Icons.close,
                          size: 27,
                          color: Color.fromRGBO(143, 143, 147, 1),
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
                            return index == 0 &&
                                    projectProvider.role != Role.admin
                                ? Container()
                                : Column(
                                    children: [
                                      Row(
                                        children: [
                                          Radio(
                                            activeColor: primaryColor,
                                            value: options[index]['value'],
                                            groupValue: selectedRole,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedRole = value as int;
                                                if (widget.isInviteMembers) {
                                                  widget.role['role'] =
                                                      selectedRole;
                                                  ref
                                                          .read(ProviderList
                                                              .workspaceProvider)
                                                          .invitingMembersRole
                                                          .text =
                                                      options[index]['role'];
                                                }
                                              //  Navigator.pop(context);
                                              });
                                            },
                                          ),
                                          CustomText(
                                            options[index]['role'],
                                            type: FontStyle.subheading,
                                            color:
                                                themeProvider.isDarkThemeEnabled
                                                    ? darkSecondaryTextColor
                                                    : Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 2,
                                        width: double.infinity,
                                        color: themeProvider.isDarkThemeEnabled
                                            ? darkThemeBorder
                                            : strokeColor,
                                      ),
                                    ],
                                  );
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                  widget.isInviteMembers
                      ? Container()
                      : Button(
                          text: 'Update Changes',
                          ontap: () {
                            if (widget.fromWorkspace) {
                              ref
                                  .watch(ProviderList.workspaceProvider)
                                  .updateWorkspaceMember(
                                userId: widget.userId,
                                method: selectedRole == 0
                                    ? CRUD.delete
                                    : CRUD.update,
                                data: {'role': selectedRole.toString()},
                              );
                            } else {
                              ref
                                  .watch(ProviderList.projectProvider)
                                  .updateProjectMember(
                                slug: ref
                                    .watch(ProviderList.workspaceProvider)
                                    .selectedWorkspace!
                                    .workspaceSlug,
                                projId: ref
                                    .watch(ProviderList.projectProvider)
                                    .currentProject['id'],
                                userId: widget.userId,
                                method: selectedRole == 0
                                    ? CRUD.delete
                                    : CRUD.update,
                                data: {'role': selectedRole.toString()},
                              );
                            }
                            Navigator.of(context).pop();
                          },
                        ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ],
        ),
        projectProvider.updateProjectMemberState == StateEnum.loading
            ? Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: themeProvider.isDarkThemeEnabled
                      ? darkSecondaryBGC.withOpacity(0.7)
                      : lightSecondaryBackgroundColor.withOpacity(0.7),
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
                          themeProvider.isDarkThemeEnabled
                              ? darkPrimaryTextColor
                              : lightPrimaryTextColor
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
