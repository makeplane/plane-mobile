// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/custom_toast.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/utils/global_functions.dart';
import 'package:plane_startup/widgets/custom_text.dart';

class DeleteProjectSheet extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;
  const DeleteProjectSheet({required this.data, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DeleteProjectSheetState();
}

class _DeleteProjectSheetState extends ConsumerState<DeleteProjectSheet> {
  final TextEditingController projectName = TextEditingController();
  final TextEditingController deleteProject = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var projectProviderRead = ref.watch(ProviderList.projectProvider);
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Form(
          key: _formKey,
          child: Wrap(
            children: [
              const CustomText(
                'Delete Project',
                type: FontStyle.H6,
                fontWeight: FontWeightt.Semibold,
              ),
              Container(
                height: 20,
              ),
              const CustomText(
                'Are you sure you want to delete this project?',
                type: FontStyle.H5,
                fontSize: 20,
              ),
              Container(
                height: 20,
              ),
              //itext instructing enter the project name
              RichText(
                text: TextSpan(
                  text: 'Enter the project name ',
                  style: TextStyle(
                    color: themeProvider.themeManager.tertiaryTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(
                      text: projectProviderRead.currentProject['name'],
                      style: TextStyle(
                        color: themeProvider.themeManager.primaryTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: ' to continue.',
                      style: TextStyle(
                        color: themeProvider.themeManager.tertiaryTextColor,
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
                decoration:
                    themeProvider.themeManager.textFieldDecoration.copyWith(
                  // hintText: 'Enter project name',
                  labelText: 'Project Name',
                  //avaid the label text from floating
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: true,
                ),
                validator: (value) {
                  if (value!.trim().toLowerCase() !=
                      projectProviderRead.currentProject['name']
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
                    color: themeProvider.themeManager.tertiaryTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(
                      text: '"Delete my project"',
                      style: TextStyle(
                        color: themeProvider.themeManager.primaryTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: '.',
                      style: TextStyle(
                        color: themeProvider.themeManager.tertiaryTextColor,
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
                decoration:
                    themeProvider.themeManager.textFieldDecoration.copyWith(
                        // hintText: 'Enter detele my project',
                        labelText: 'Enter "Delete my project"',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true),
                validator: (value) {
                  if (value!.trim().toLowerCase() != 'delete my project') {
                    return 'Please enter "Delete my project"';
                  }
                  return null;
                },
              ),
              Container(height: 20),
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
                      if (_formKey.currentState!.validate()) {
                        //close the sheet without popping the screen.
                        if (projectProviderRead.role != Role.admin &&
                            projectProviderRead.role != Role.member) {
                          Navigator.of(context).pop();
                          CustomToast.showToast(
                              context, message:accessRestrictedMSG,
                              toastType: ToastType.failure);
                          return;
                        }
                        await projectProviderRead
                            .deleteProject(
                                slug: ref
                                    .read(ProviderList.workspaceProvider)
                                    .selectedWorkspace!
                                    .workspaceSlug,
                                projId:
                                    projectProviderRead.currentProject['id'])
                            .then((value) {
                          if (projectProviderRead.deleteProjectState ==
                              StateEnum.success) {
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
                        projectProviderRead.getProjects(
                          slug: ref
                              .read(ProviderList.workspaceProvider)
                              .selectedWorkspace!
                              .workspaceSlug,
                        );
                        projectProviderRead.getProjects(
                          slug: ref
                              .read(ProviderList.workspaceProvider)
                              .selectedWorkspace!
                              .workspaceSlug,
                        );
                        projectProviderRead.favouriteProjects(
                            slug: ref
                                .read(ProviderList.workspaceProvider)
                                .selectedWorkspace!
                                .workspaceSlug,
                            method: HttpMethod.get,
                            projectID: "",
                            index: 0);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 12, 12, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: projectProviderRead.projectDetailState ==
                              StateEnum.loading
                          ? Center(
                              child: CircularProgressIndicator(
                                color:
                                    themeProvider.themeManager.primaryTextColor,
                              ),
                            )
                          : const CustomText(
                              'Delete Project',
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
