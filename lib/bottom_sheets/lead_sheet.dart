import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:plane/utils/enums.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/widgets/custom_text.dart';

class LeadSheet extends ConsumerStatefulWidget {
  final bool fromModuleDetail;
  final bool fromCycleDetail;
  const LeadSheet({
    super.key,
    this.fromModuleDetail = false,
    this.fromCycleDetail = false,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LeadSheetState();
}

class _LeadSheetState extends ConsumerState<LeadSheet> {
  @override
  Widget build(BuildContext context) {
    var modulesProvider = ref.watch(ProviderList.modulesProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.themeManager.primaryBackgroundDefaultColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50), topRight: Radius.circular(50)),
      ),
      width: double.infinity,
      //height: height * 0.5,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Wrap(
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
                    const CustomText(
                      'Lead',
                      type: FontStyle.H6,
                      fontWeight: FontWeightt.Semibold,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        size: 27,
                        color: themeProvider.themeManager.placeholderTextColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.7,
                  ),
                  child: ListView.builder(
                    itemCount: projectProvider.projectMembers.length,
                    shrinkWrap: true,
                    // physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          if (widget.fromCycleDetail) {
                            ref
                                .read(ProviderList.cyclesProvider)
                                .cycleDetailsCrud(
                              slug: ref
                                  .read(ProviderList.workspaceProvider)
                                  .selectedWorkspace!
                                  .workspaceSlug,
                              projectId: ref
                                  .read(ProviderList.projectProvider)
                                  .currentProject["id"],
                              method: CRUD.update,
                              cycleId: ref
                                  .read(ProviderList.cyclesProvider)
                                  .currentCycle["id"],
                              data: {
                                'owned_by': projectProvider
                                    .projectMembers[index]['member']
                              },
                            );

                            return;
                          }

                          if (widget.fromModuleDetail) {
                            modulesProvider.updateModules(
                                slug: ref
                                    .read(ProviderList.workspaceProvider)
                                    .selectedWorkspace!
                                    .workspaceSlug,
                                projId: ref
                                    .read(ProviderList.projectProvider)
                                    .currentProject["id"],
                                moduleId: ref
                                    .read(ProviderList.modulesProvider)
                                    .currentModule["id"],
                                data: {
                                  'lead': projectProvider.projectMembers[index]
                                      ['member']['id']
                                },
                                ref: ref);
                            Navigator.pop(context);
                            return;
                          }

                          modulesProvider.createModule['lead'] = projectProvider
                              .projectMembers[index]['member']['id'];
                          modulesProvider.setState();
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.only(
                            left: 5,
                          ),
                          decoration: BoxDecoration(
                            color: themeProvider
                                .themeManager.secondaryBackgroundDefaultColor,
                          ),
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(55, 65, 81, 1),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                alignment: Alignment.center,
                                child: CustomText(
                                  projectProvider.projectMembers[index]
                                          ['member']['first_name'][0]
                                      .toString()
                                      .toUpperCase(),
                                  type: FontStyle.Small,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                width: 10,
                              ),
                              CustomText(
                                projectProvider.projectMembers[index]['member']
                                        ['first_name'] +
                                    " " +
                                    projectProvider.projectMembers[index]
                                        ['member']['last_name'],
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
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget createIsseuSelectedMembersWidget(int idx) {
    var modulesProvider = ref.watch(ProviderList.modulesProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    return (widget.fromCycleDetail
            ? (ref.read(ProviderList.cyclesProvider).currentCycle['owned_by']
                    ['id'] ==
                projectProvider.projectMembers[idx]['member']['id'])
            : widget.fromModuleDetail
                ? (modulesProvider.currentModule['lead_detail']['id'] ==
                    projectProvider.projectMembers[idx]['member']['id'])
                : modulesProvider.createModule['lead'] != null &&
                    modulesProvider.createModule['lead'] ==
                        projectProvider.projectMembers[idx]['member']['id'])
        ? const Icon(
            Icons.done,
            color: Color.fromRGBO(8, 171, 34, 1),
          )
        : const SizedBox();
  }
}
