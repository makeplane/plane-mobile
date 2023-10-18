import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/widgets/custom_button.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/member_logo_widget.dart';

import '../utils/enums.dart';

class AssigneeSheet extends ConsumerStatefulWidget {
  const AssigneeSheet({super.key, this.fromModuleDetail = false});
  final bool fromModuleDetail;

  @override
  ConsumerState<AssigneeSheet> createState() => _AssigneeSheetState();
}

class _AssigneeSheetState extends ConsumerState<AssigneeSheet> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.read(ProviderList.themeProvider);
    final modulesProvider = ref.read(ProviderList.modulesProvider);
    final projectProvider = ref.read(ProviderList.projectProvider);

    return WillPopScope(
      onWillPop: () async {
        if (widget.fromModuleDetail) {
          modulesProvider.updateModules(
              // disableLoading: true,
              slug: ref
                  .read(ProviderList.workspaceProvider)
                  .selectedWorkspace
                  .workspaceSlug,
              projId:
                  ref.read(ProviderList.projectProvider).currentProject['id'],
              moduleId: modulesProvider.currentModule['id'],
              data: {'members_list': modulesProvider.currentModule['members']},
              ref: ref);
        }
        return true;
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: themeProvider.themeManager.primaryBackgroundDefaultColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        width: double.infinity,
        //  height: height * 0.5,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(
                        'Select Assignees',
                        type: FontStyle.H4,
                        fontWeight: FontWeightt.Semibold,
                      ),
                      IconButton(
                          onPressed: () {
                            if (widget.fromModuleDetail) {
                              modulesProvider.updateModules(
                                  // disableLoading: true,
                                  slug: ref
                                      .read(ProviderList.workspaceProvider)
                                      .selectedWorkspace
                                      .workspaceSlug,
                                  projId: ref
                                      .read(ProviderList.projectProvider)
                                      .currentProject['id'],
                                  moduleId: modulesProvider.currentModule['id'],
                                  data: {
                                    'members_list':
                                        modulesProvider.currentModule['members']
                                  },
                                  ref: ref);
                            }
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.close,
                            color:
                                themeProvider.themeManager.placeholderTextColor,
                          ))
                    ],
                  ),
                  Container(
                    height: 15,
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: projectProvider.projectMembers.length,
                        // shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              if (widget.fromModuleDetail) {
                                if (modulesProvider.currentModule['members'] !=
                                        null &&
                                    modulesProvider.currentModule['members']
                                        .contains(projectProvider
                                                .projectMembers[index]['member']
                                            ['id'])) {
                                  modulesProvider.currentModule['members']
                                      .remove(
                                          projectProvider.projectMembers[index]
                                              ['member']['id']);
                                  modulesProvider.setState();
                                } else {
                                  if (modulesProvider
                                          .currentModule['members'] ==
                                      null) {
                                    modulesProvider.currentModule['members'] =
                                        [];
                                  }

                                  modulesProvider.currentModule['members'].add(
                                      projectProvider.projectMembers[index]
                                          ['member']['id']);
                                  modulesProvider.setState();
                                }
                              }

                              if (modulesProvider.createModule['members'] !=
                                      null &&
                                  modulesProvider.createModule['members']
                                      .contains(
                                          projectProvider.projectMembers[index]
                                              ['member']['id'])) {
                                modulesProvider.createModule['members'].remove(
                                    projectProvider.projectMembers[index]
                                        ['member']['id']);
                                modulesProvider.setState();
                              } else {
                                if (modulesProvider.createModule['members'] ==
                                    null) {
                                  modulesProvider.createModule['members'] = [];
                                }

                                modulesProvider.createModule['members'].add(
                                    projectProvider.projectMembers[index]
                                        ['member']['id']);
                                modulesProvider.setState();
                              }
                            },
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.only(
                                left: 5,
                              ),
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        color:
                                            const Color.fromRGBO(55, 65, 81, 1),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      alignment: Alignment.center,
                                      child: MemberLogoWidget(
                                          boarderRadius: 50,
                                          padding: EdgeInsets.zero,
                                          size: 30,
                                          imageUrl: projectProvider
                                                  .projectMembers[index]
                                              ['member']['avatar'],
                                          colorForErrorWidget:
                                              const Color.fromRGBO(
                                                  55, 65, 81, 1),
                                          memberNameFirstLetterForErrorWidget:
                                              projectProvider
                                                  .projectMembers[index]
                                                      ['member']['display_name']
                                                      [0]
                                                  .toString())),
                                  Container(
                                    width: 10,
                                  ),
                                  CustomText(
                                    projectProvider.projectMembers[index]
                                        ['member']['display_name'],
                                    type: FontStyle.Small,
                                  ),
                                  const Spacer(),
                                  createIsseuSelectedMembersWidget(index),
                                  const SizedBox(
                                    width: 10,
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                  Container(
                    height: 15,
                  ),
                  Button(
                    text: 'Select Assignees',
                    ontap: () {
                      if (widget.fromModuleDetail) {
                        modulesProvider.updateModules(
                            // disableLoading: true,
                            slug: ref
                                .read(ProviderList.workspaceProvider)
                                .selectedWorkspace
                                .workspaceSlug,
                            projId: ref
                                .read(ProviderList.projectProvider)
                                .currentProject['id'],
                            moduleId: modulesProvider.currentModule['id'],
                            data: {
                              'members_list':
                                  modulesProvider.currentModule['members']
                            },
                            ref: ref);
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createIsseuSelectedMembersWidget(int idx) {
    final modulesProvider = ref.watch(ProviderList.modulesProvider);
    final projectProvider = ref.watch(ProviderList.projectProvider);
    return (widget.fromModuleDetail
            ? (modulesProvider.currentModule['members'] != null &&
                modulesProvider.currentModule['members'].contains(
                    projectProvider.projectMembers[idx]['member']['id']))
            : modulesProvider.createModule['members'] != null &&
                modulesProvider.createModule['members'].contains(
                    projectProvider.projectMembers[idx]['member']['id']))
        ? const Icon(
            Icons.done,
            color: Color.fromRGBO(8, 171, 34, 1),
          )
        : const SizedBox();
  }
}
