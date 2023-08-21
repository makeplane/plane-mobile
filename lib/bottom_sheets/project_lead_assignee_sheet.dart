import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_text.dart';

class ProjectLeadAssigneeSheet extends ConsumerStatefulWidget {
  final String title;
  final String leadId;
  final String assigneId;
  const ProjectLeadAssigneeSheet(
      {required this.title,
      required this.leadId,
      required this.assigneId,
      super.key});

  @override
  ConsumerState<ProjectLeadAssigneeSheet> createState() =>
      _ProjectLeadAssigneeSheetState();
}

class _ProjectLeadAssigneeSheetState
    extends ConsumerState<ProjectLeadAssigneeSheet> {
  int currentIndex = 0;
  double height = 0;
  @override
  Widget build(BuildContext context) {
    var projectProvider = ref.watch(ProviderList.projectProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var box = context.findRenderObject() as RenderBox;
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
          child: Stack(
            children: [
              Wrap(
                children: [
                  Container(
                    height: 15,
                  ),
                  Row(
                    children: [
                      CustomText(
                        'Select ${widget.title}',
                        type: FontStyle.H6,
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
                          color:
                              themeProvider.themeManager.placeholderTextColor,
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
                                  .selectedWorkspace!
                                  .workspaceSlug,
                              projId: ref
                                  .read(ProviderList.projectProvider)
                                  .currentProject['id'],
                              data: widget.title == 'Lead'
                                  ? {
                                      'project_lead':
                                          projectProvider.projectMembers[index]
                                              ['member']['id'],
                                      'default_assignee': widget.assigneId != ''
                                          ? widget.assigneId
                                          : null,
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
                                      .selectedWorkspace!
                                      .workspaceSlug,
                                  projId: ref
                                      .read(ProviderList.projectProvider)
                                      .currentProject['id'],
                                )
                                    .then((value) {
                                  setState(() {
                                    projectProvider.lead.text = projectProvider
                                                .projectDetailModel!
                                                .projectLead ==
                                            null
                                        ? 'Select lead'
                                        : projectProvider.projectDetailModel!
                                            .projectLead!['first_name'];
                                    projectProvider.assignee.text =
                                        projectProvider.projectDetailModel!
                                                    .defaultAssignee ==
                                                null
                                            ? 'Select Assingnee'
                                            : projectProvider
                                                .projectDetailModel!
                                                .defaultAssignee!['first_name'];
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
                                                  ['member']['first_name'][0]
                                              .toString()
                                              .toUpperCase(),
                                          color: Colors.black,
                                          type: FontStyle.Medium,
                                          fontWeight: FontWeightt.Semibold,
                                        ),
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(
                                          projectProvider.projectMembers[index]
                                              ['member']['avatar']),
                                    ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: CustomText(
                                  '${projectProvider.projectMembers[index]['member']['first_name']} ${projectProvider.projectMembers[index]['member']['last_name'] ?? ''}',
                                  type: FontStyle.H5,
                                  maxLines: 1,
                                  color: themeProvider
                                      .themeManager.primaryTextColor,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              (widget.title == 'Lead'
                                          ? widget.leadId
                                          : widget.assigneId) ==
                                      projectProvider.projectMembers[index]
                                          ['member']['id']
                                  ? Icon(
                                      Icons.check,
                                      color: themeProvider
                                          .themeManager.placeholderTextColor,
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
              projectProvider.updateProjectState == StateEnum.loading
                  ? Container(
                      height: height,
                      alignment: Alignment.center,
                      color: themeProvider.isDarkThemeEnabled
                          ? darkSecondaryBGC.withOpacity(0.7)
                          : lightSecondaryBackgroundColor.withOpacity(0.7),
                      // height: 25,
                      // width: 25,
                      child: Center(
                        child: SizedBox(
                          height: 25,
                          width: 25,
                          child: LoadingIndicator(
                            indicatorType: Indicator.lineSpinFadeLoader,
                            colors: [
                              themeProvider.isDarkThemeEnabled
                                  ? Colors.white
                                  : Colors.black
                            ],
                            strokeWidth: 1.0,
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
      // ),
    );
  }
}
