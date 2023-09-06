// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/custom_toast.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/utils/global_functions.dart';
import 'package:plane_startup/widgets/custom_text.dart';

class DeleteLeaveProjectSheet extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;
  final Role? role;
  const DeleteLeaveProjectSheet(
      {required this.data, required this.role, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DeleteLeaveProjectSheetState();
}

class _DeleteLeaveProjectSheetState
    extends ConsumerState<DeleteLeaveProjectSheet> {
  final TextEditingController projectName = TextEditingController();
  final TextEditingController deleteProject = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Form(
          key: _formKey,
          child: Wrap(
            children: [
              CustomText(
                widget.role == Role.admin ? 'Delete Project' : 'Leave Project',
                type: FontStyle.H6,
                fontWeight: FontWeightt.Semibold,
              ),
              Container(
                height: 20,
              ),
              CustomText(
                widget.role == Role.admin
                    ? 'Are you sure you want to delete this project?'
                    : 'Are you sure you want to leave this project?',
                type: FontStyle.H5,
                fontSize: 20,
              ),
              Container(
                height: 20,
              ),
              //itext instructing enter the project name
              widget.role == Role.admin
                  ? Column(
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Enter the project name ',
                            style: TextStyle(
                              color:
                                  themeProvider.themeManager.tertiaryTextColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                            children: [
                              TextSpan(
                                text: projectProvider.currentProject['name'],
                                style: TextStyle(
                                  color: themeProvider
                                      .themeManager.primaryTextColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: ' to continue.',
                                style: TextStyle(
                                  color: themeProvider
                                      .themeManager.tertiaryTextColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(height: 8),
                        TextFormField(
                          // controller: projectName,
                          decoration: themeProvider
                              .themeManager.textFieldDecoration
                              .copyWith(
                            // hintText: 'Enter project name',
                            labelText: 'Project Name',
                            //avaid the label text from floating
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            filled: true,
                          ),
                          validator: (value) {
                            if (value!.trim().toLowerCase() !=
                                projectProvider.currentProject['name']
                                    .toLowerCase()) {
                              return 'Project name does not match';
                            }
                            return null;
                          },
                        ),
                        Container(height: 20),
                        // CustomText(
                        //   'To confirm, type "delete my project".',
                        //   type: FontStyle.Small,
                        // ),
                        //use textspan to bold "delete my project"
                        RichText(
                          text: TextSpan(
                            text: 'To confirm, type ',
                            style: TextStyle(
                              color:
                                  themeProvider.themeManager.tertiaryTextColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                            children: [
                              TextSpan(
                                text: '"Delete my project"',
                                style: TextStyle(
                                  color: themeProvider
                                      .themeManager.primaryTextColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: '.',
                                style: TextStyle(
                                  color: themeProvider
                                      .themeManager.tertiaryTextColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(height: 8),
                        TextFormField(
                          // controller: projectName,
                          decoration: themeProvider
                              .themeManager.textFieldDecoration
                              .copyWith(
                                  // hintText: 'Enter detele my project',
                                  labelText: 'Enter "Delete my project"',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  filled: true),
                          validator: (value) {
                            if (value!.trim().toLowerCase() !=
                                'delete my project') {
                              return 'Please enter "Delete my project"';
                            }
                            return null;
                          },
                        ),
                        Container(height: 20),
                      ],
                    )
                  : Container(),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: themeProvider
                            .themeManager.secondaryBackgroundDefaultColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: themeProvider.themeManager.borderSubtle01Color,
                        ),
                      ),
                      child: CustomText(
                        'Cancel',
                        type: FontStyle.Medium,
                        fontWeight: FontWeightt.Semibold,
                        color: themeProvider.themeManager.primaryTextColor,
                      ),
                    ),
                  ),
                  Container(
                    width: 10,
                  ),

                  //container with red background having delete text
                  GestureDetector(
                    onTap: () async {
                      if (widget.role == Role.guest ||
                          widget.role == Role.viewer || widget.role == Role.member) {
                        var leftSuccessfully =
                            await projectProvider.leaveProject(
                                slug: ref
                                    .watch(ProviderList.workspaceProvider)
                                    .selectedWorkspace!
                                    .workspaceSlug,
                                projId: projectProvider.currentProject['id'],
                                index: 0);
                        if (leftSuccessfully) {
                          CustomToast().showToast(
                            context,
                            'Left project successfully',
                            themeProvider,
                          );
                          postHogService(
                              eventName: 'LEAVE_PROJECT',
                              properties: widget.data,
                              ref: ref);
                          Navigator.of(context)
                            ..pop()
                            ..pop()
                            ..pop();
                        }
                      } else {
                        if (_formKey.currentState!.validate()) {
                          await projectProvider
                              .deleteProject(
                                  slug: ref
                                      .read(ProviderList.workspaceProvider)
                                      .selectedWorkspace!
                                      .workspaceSlug,
                                  projId: projectProvider.currentProject['id'])
                              .then((value) {
                            if (projectProvider.deleteProjectState ==
                                StateEnum.success) {
                              CustomToast().showToast(
                                context,
                                'Deleted project successfully',
                                themeProvider,
                              );
                              postHogService(
                                  eventName: 'DELETE_PROJECT',
                                  properties: widget.data,
                                  ref: ref);
                            }
                          });
                          Navigator.of(context)
                            ..pop()
                            ..pop()
                            ..pop();
                          projectProvider.getProjects(
                            slug: ref
                                .read(ProviderList.workspaceProvider)
                                .selectedWorkspace!
                                .workspaceSlug,
                          );
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 12, 12, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: projectProvider.deleteProjectState ==
                                  StateEnum.loading ||
                              projectProvider.leaveProjectState ==
                                  StateEnum.loading
                          ? Center(
                              child: CircularProgressIndicator(
                                color:
                                    themeProvider.themeManager.primaryTextColor,
                              ),
                            )
                          : CustomText(
                              widget.role == Role.admin
                                  ? 'Delete Project'
                                  : 'Leave Project',
                              type: FontStyle.Medium,
                              fontWeight: FontWeightt.Semibold,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
