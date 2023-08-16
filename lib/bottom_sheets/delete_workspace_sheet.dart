// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/custom_toast.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_text.dart';

class DeleteWorkspace extends ConsumerStatefulWidget {
  final String workspaceName;
  const DeleteWorkspace({required this.workspaceName, super.key});

  @override
  ConsumerState<DeleteWorkspace> createState() => _DeleteWorkspaceState();
}

class _DeleteWorkspaceState extends ConsumerState<DeleteWorkspace> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Form(
          key: _formKey,
          child: Wrap(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    'Delete Workspace',
                    type: FontStyle.H6,
                    fontWeight: FontWeightt.Semibold,
                  ),
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
              Container(
                height: 20,
              ),
              CustomText(
                'Are you sure you want to delete workspace ${widget.workspaceName}? All of the data related to the workspace will be permanently removed. This action cannot be undone.',
                type: FontStyle.H5,
                fontSize: 20,
              ),
              Container(
                height: 20,
              ),
              //itext instructing enter the project name
              RichText(
                text: TextSpan(
                  text: 'Enter the workspace name ',
                  style: TextStyle(
                    color: themeProvider.isDarkThemeEnabled
                        ? lightGreeyColor
                        : Colors.grey[700],
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(
                      text: widget.workspaceName,
                      style: TextStyle(
                        color: themeProvider.isDarkThemeEnabled
                            ? Colors.white
                            : Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    TextSpan(
                      text: ' to continue.',
                      style: TextStyle(
                        color: themeProvider.isDarkThemeEnabled
                            ? lightGreeyColor
                            : Colors.grey[700],
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
                  labelText: 'Workspace Name',
                  //avaid the label text from floating
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: true,
                ),
                validator: (value) {
                  if (value!.trim() != widget.workspaceName) {
                    return 'Workspace name does not match';
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
                    color: themeProvider.isDarkThemeEnabled
                        ? lightGreeyColor
                        : Colors.grey[700],
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(
                      text: 'delete my workspace ',
                      style: TextStyle(
                        color: themeProvider.isDarkThemeEnabled
                            ? Colors.white
                            : Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'below:',
                      style: TextStyle(
                        color: themeProvider.isDarkThemeEnabled
                            ? lightGreeyColor
                            : Colors.grey[700],
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
                        labelText: 'Enter "Delete my workspace"',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true),
                validator: (value) {
                  if (value!.trim().toLowerCase() != 'delete my workspace') {
                    return 'Please enter "Delete my workspace"';
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
                        color: themeProvider.isDarkThemeEnabled
                            ? darkSecondaryBGC
                            : lightSecondaryBackgroundColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: themeProvider.isDarkThemeEnabled
                              ? darkStrokeColor
                              : lightStrokeColor,
                        ),
                      ),
                      child: CustomText(
                        'Cancel',
                        type: FontStyle.Medium,
                        fontWeight: FontWeightt.Semibold,
                        color: themeProvider.isDarkThemeEnabled
                            ? Colors.white
                            : Colors.black,
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
                        if (workspaceProvider.role != Role.admin &&
                            workspaceProvider.role != Role.member) {
                          CustomToast().showToast(
                              context,
                              'You don\'t have permissions to delete this workspace',
                              themeProvider,
                              toastType: ToastType.failure);
                          return;
                        }

                        var isSuccesfullyDeleted =
                            await workspaceProvider.deleteWorkspace();
                        if (isSuccesfullyDeleted) {
                          //show snackbar
                          await ref
                              .watch(ProviderList.profileProvider)
                              .updateProfile(data: {
                            'last_workspace_id': workspaceProvider
                                .selectedWorkspace!.workspaceId,
                          });
                          await ref
                              .watch(ProviderList.projectProvider)
                              .getProjects(
                                  slug: workspaceProvider
                                      .selectedWorkspace!.workspaceSlug);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: CustomText(
                                'Workspace deleted successfully',
                                color: Colors.white,
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.of(context).pop();
                        } else {
                          //show snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: CustomText(
                                'Workspace could not be deleted',
                                color: Colors.white,
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                        Navigator.of(context).pop();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 12, 12, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: workspaceProvider.selectWorkspaceState ==
                              StateEnum.loading
                          ? const Center(
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : const CustomText(
                              'Delete Workspace',
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
