import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/mixins/widget_state_mixin.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';

class ProjectLeadAssigneeSheet extends ConsumerStatefulWidget {
  const ProjectLeadAssigneeSheet(
      {required this.title,
      required this.leadId,
      required this.assigneId,
      super.key});
  final String title;
  final String leadId;
  final String assigneId;

  @override
  ConsumerState<ProjectLeadAssigneeSheet> createState() =>
      _ProjectLeadAssigneeSheetState();
}

class _ProjectLeadAssigneeSheetState
    extends ConsumerState<ProjectLeadAssigneeSheet> with WidgetStateMixin {
  int currentIndex = 0;
  double height = 0;

  @override
  LoadingType getLoading(WidgetRef ref) {
    return setWidgetState(
        [ref.read(ProviderList.projectProvider).updateProjectState],
        allowError: false, loadingType: LoadingType.wrap);
  }

  @override
  Widget render(BuildContext context) {
    final projectProvider = ref.watch(ProviderList.projectProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final box = context.findRenderObject() as RenderBox;
      height = box.size.height;
    });
    return SizedBox(
      // height: height * 0.7,
      child:
          //  LoadingWidget(
          //   loading: projectProvider.updateProjectState == StateEnum.loading,
          //   allowBorderRadius: true,
          //   widgetClass:
          Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Wrap(
            children: [
              Container(
                height: 15,
              ),
              Row(
                children: [
                  CustomText(
                    'Select ${widget.title}',
                    type: FontStyle.H4,
                    fontWeight: FontWeightt.Semibold,
                    color: themeProvider.themeManager.primaryTextColor,
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
              Container(
                height: 10,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: projectProvider.projectMembers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          currentIndex = index;
                        });
                        projectProvider
                            .updateProject(
                          slug: ref
                              .watch(ProviderList.workspaceProvider)
                              .selectedWorkspace
                              .workspaceSlug,
                          projId: ref
                              .read(ProviderList.projectProvider)
                              .currentProject['id'],
                          ref: ref,
                          data: widget.title == 'Lead '
                              ? widget.leadId ==
                                      projectProvider.projectMembers[index]
                                          ['member']['id']
                                  ? {
                                      'project_lead': null,
                                      'default_assignee': widget.assigneId != ''
                                          ? widget.assigneId
                                          : null,
                                    }
                                  : {
                                      'project_lead':
                                          projectProvider.projectMembers[index]
                                              ['member']['id'],
                                      'default_assignee': widget.assigneId != ''
                                          ? widget.assigneId
                                          : null,
                                    }
                              : widget.assigneId ==
                                      projectProvider.projectMembers[index]
                                          ['member']['id']
                                  ? {
                                      'project_lead': widget.leadId != ''
                                          ? widget.leadId
                                          : null,
                                      'default_assignee': null,
                                    }
                                  : {
                                      'project_lead': widget.leadId != ''
                                          ? widget.leadId
                                          : null,
                                      'default_assignee':
                                          projectProvider.projectMembers[index]
                                              ['member']['id'],
                                    },
                        )
                            .then((value) {
                          if (projectProvider.updateProjectState ==
                              StateEnum.success) {
                            projectProvider
                                .getProjectDetails(
                              slug: ref
                                  .watch(ProviderList.workspaceProvider)
                                  .selectedWorkspace
                                  .workspaceSlug,
                              projId: ref
                                  .read(ProviderList.projectProvider)
                                  .currentProject['id'],
                            )
                                .then((value) {
                              setState(() {
                                projectProvider.lead.text = projectProvider
                                            .projectDetailModel!.projectLead ==
                                        null
                                    ? ''
                                    : projectProvider.projectDetailModel!
                                        .projectLead!['display_name'];
                                projectProvider.assignee.text = projectProvider
                                            .projectDetailModel!
                                            .defaultAssignee ==
                                        null
                                    ? ''
                                    : projectProvider.projectDetailModel!
                                        .defaultAssignee!['display_name'];
                              });
                              Navigator.of(context).pop();
                            });
                          }
                        });
                      },
                      child: Row(
                        children: [
                          projectProvider.projectMembers[index]['member']
                                          ['avatar'] ==
                                      null ||
                                  projectProvider.projectMembers[index]
                                          ['member']['avatar'] ==
                                      ""
                              ? CircleAvatar(
                                  radius: 20,
                                  backgroundColor: strokeColor,
                                  child: Center(
                                    child: CustomText(
                                      projectProvider.projectMembers[index]
                                              ['member']['display_name'][0]
                                          .toString()
                                          .toUpperCase(),
                                      color: Colors.black,
                                      type: FontStyle.Medium,
                                      fontWeight: FontWeightt.Semibold,
                                    ),
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 16,
                                  backgroundImage: NetworkImage(
                                      projectProvider.projectMembers[index]
                                          ['member']['avatar']),
                                ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: CustomText(
                              '${projectProvider.projectMembers[index]['member']['display_name']}',
                              type: FontStyle.Medium,
                              maxLines: 1,
                              color:
                                  themeProvider.themeManager.primaryTextColor,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          (widget.title == 'Lead '
                                      ? widget.leadId
                                      : widget.assigneId) ==
                                  projectProvider.projectMembers[index]
                                      ['member']['id']
                              ? Icon(
                                  Icons.check,
                                  color: themeProvider
                                      .themeManager.textSuccessColor,
                                )
                              : Container()
                        ],
                      ),
                    ),
                  );
                  // ListTile(
                  //   leading: projectProvider.projectMembers[index]['member']
                  //                   ['avatar'] ==
                  //               null ||
                  //           projectProvider.projectMembers[index]['member']
                  //                   ['avatar'] ==
                  //               ""
                  //       ? CircleAvatar(
                  //           radius: 20,
                  //           backgroundColor: strokeColor,
                  //           child: Center(
                  //             child: CustomText(
                  //               projectProvider.projectMembers[index]['member']
                  //                       ['first_name'][0]
                  //                   .toString()
                  //                   .toUpperCase(),
                  //               color: Colors.black,
                  //               type: FontStyle.Medium,
                  ///       fontWeight: FontWeightt.Semibold,
                  //             ),
                  //           ),
                  //         )
                  //       : CircleAvatar(
                  //           radius: 20,
                  //           backgroundImage: NetworkImage(projectProvider
                  //               .projectMembers[index]['member']['avatar']),
                  //         ),
                  //   title: CustomText(
                  //     '${projectProvider.projectMembers[index]['member']['first_name']} ${projectProvider.projectMembers[index]['member']['last_name'] ?? ''}',
                  //     type: FontStyle.H5,
                  //     maxLines: 1,
                  //     fontSize: 18,
                  //   ),
                  // );
                },
              ),
            ],
          ),
        ),
      ),
      // ),
    );
  }
}
