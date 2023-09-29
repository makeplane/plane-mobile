import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/widgets/custom_button.dart';

import 'package:plane/widgets/custom_text.dart';

class MemberStatus extends ConsumerStatefulWidget {
  const MemberStatus(
      {super.key,
      required this.firstName,
      required this.lastName,
      required this.role,
      required this.isInviteMembers,
      required this.fromWorkspace,
      required this.userId});
  final String firstName;
  final String lastName;
  final Map role;
  final String userId;
  final bool fromWorkspace;
  final bool isInviteMembers;

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
                                            workspaceProvider.role !=
                                                Role.admin) ||
                                        (index == 4 &&
                                            workspaceProvider.role !=
                                                Role.admin)
                                    : (index == 0 &&
                                            projectProvider.role !=
                                                Role.admin) ||
                                        (index == 4 &&
                                            projectProvider.role != Role.admin))
                                ? Container()
                                : Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedRole =
                                                options[index]['value'] as int;
                                            if (widget.isInviteMembers) {
                                              // widget.role['role'] =
                                              //     selectedRole;
                                              ref
                                                      .read(ProviderList
                                                          .workspaceProvider)
                                                      .invitingMembersRole
                                                      .text =
                                                  options[index]['role'];
                                            }
                                            // Navigator.pop(context);
                                          });
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
                                                setState(() {
                                                  selectedRole = options[index]
                                                      ['value'] as int;
                                                  if (widget.isInviteMembers) {
                                                    // widget.role['role'] =
                                                    //     selectedRole;
                                                    ref
                                                            .read(ProviderList
                                                                .workspaceProvider)
                                                            .invitingMembersRole
                                                            .text =
                                                        options[index]['role'];
                                                  }
                                                  // Navigator.pop(context);
                                                });
                                              },
                                            ),
                                            CustomText(options[index]['role'],
                                                type: FontStyle.Small,
                                                color: themeProvider
                                                    .themeManager
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
                                              .themeManager.borderSubtle01Color,
                                        ),
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
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Button(
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
                                      .selectedWorkspace
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
