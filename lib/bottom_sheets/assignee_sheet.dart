import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/widgets/custom_button.dart';
import 'package:plane_startup/widgets/custom_text.dart';


class AssigneeSheet extends ConsumerStatefulWidget {
  final bool fromModuleDetail;
  const AssigneeSheet({super.key, this.fromModuleDetail = false});

  @override
  ConsumerState<AssigneeSheet> createState() => _AssigneeSheetState();
}

class _AssigneeSheetState extends ConsumerState<AssigneeSheet> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.read(ProviderList.themeProvider);
    var modulesProvider = ref.read(ProviderList.modulesProvider);
    var projectProvider = ref.read(ProviderList.projectProvider);

    return WillPopScope(
      onWillPop: () async {
        if (widget.fromModuleDetail) {
          modulesProvider.updateModules(
            disableLoading: true,
            slug: ref
                .read(ProviderList.workspaceProvider)
                .selectedWorkspace!
                .workspaceSlug,
            projId: ref.read(ProviderList.projectProvider).currentProject['id'],
            moduleId: modulesProvider.currentModule['id'],
            data: {'members_list': modulesProvider.currentModule['members']},
          );
        }
        return true;
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: themeProvider.isDarkThemeEnabled
              ? darkBackgroundColor
              : lightBackgroundColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
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
                        type: FontStyle.heading,
                      ),
                      IconButton(
                          onPressed: () {
                            if (widget.fromModuleDetail) {
                              modulesProvider.updateModules(
                                disableLoading: true,
                                slug: ref
                                    .read(ProviderList.workspaceProvider)
                                    .selectedWorkspace!
                                    .workspaceSlug,
                                projId: ref
                                    .read(ProviderList.projectProvider)
                                    .currentProject['id'],
                                moduleId: modulesProvider.currentModule['id'],
                                data: {
                                  'members_list':
                                      modulesProvider.currentModule['members']
                                },
                              );
                            }
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.close,
                            color: themeProvider.isDarkThemeEnabled
                                ? lightSecondaryBackgroundColor
                                : darkSecondaryBGC,
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
                          return GestureDetector(
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
                              decoration: BoxDecoration(
                                color: themeProvider.isDarkThemeEnabled
                                    ? darkSecondaryBGC
                                    : const Color.fromRGBO(248, 249, 250, 1),
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
                                    child: CustomText(
                                      projectProvider.projectMembers[index]
                                              ['member']['email'][0]
                                          .toString()
                                          .toUpperCase(),
                                      type: FontStyle.subheading,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    width: 10,
                                  ),
                                  CustomText(
                                    projectProvider.projectMembers[index]
                                            ['member']['first_name'] +
                                        " " +
                                        projectProvider.projectMembers[index]
                                            ['member']['last_name'],
                                    type: FontStyle.subheading,
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
    var modulesProvider = ref.watch(ProviderList.modulesProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
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
