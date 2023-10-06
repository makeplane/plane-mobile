// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/utils/global_functions.dart';
import 'package:plane/widgets/custom_text.dart';

class DeleteOrLeaveWorkpace extends ConsumerStatefulWidget {
  const DeleteOrLeaveWorkpace(
      {required this.workspaceName, required this.role, super.key});
  final String workspaceName;
  final Role role;

  @override
  ConsumerState<DeleteOrLeaveWorkpace> createState() =>
      _DeleteOrLeaveWorkpaceState();
}

class _DeleteOrLeaveWorkpaceState extends ConsumerState<DeleteOrLeaveWorkpace> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Form(
            key: _formKey,
            child: Wrap(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      widget.role == Role.admin
                          ? 'Delete Workspace'
                          : 'Leave Workspace',
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
                  widget.role == Role.admin
                      ? 'Are you sure you want to delete workspace ${widget.workspaceName}? All of the data related to the workspace will be permanently removed. This action cannot be undone.'
                      : 'Are you sure you want to leave the workspce?',
                  type: FontStyle.H5,
                  fontSize: 20,
                ),
                Container(
                  height: 20,
                ),
                //itext instructing enter the project name
                widget.role == Role.admin
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'Enter the workspace name ',
                              style: TextStyle(
                                color: themeProvider
                                    .themeManager.tertiaryTextColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                              children: [
                                TextSpan(
                                  text: widget.workspaceName,
                                  style: TextStyle(
                                    color: themeProvider
                                        .themeManager.primaryTextColor,
                                    fontSize: 18,
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
                              labelText: 'Workspace Name',
                              //avaid the label text from floating
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
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
                                color: themeProvider
                                    .themeManager.tertiaryTextColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                              children: [
                                TextSpan(
                                  text: 'delete my workspace ',
                                  style: TextStyle(
                                    color: themeProvider
                                        .themeManager.primaryTextColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: 'below:',
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
                                    labelText: 'Enter "Delete my workspace"',
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    filled: true),
                            validator: (value) {
                              if (value!.trim().toLowerCase() !=
                                  'delete my workspace') {
                                return 'Please enter "Delete my workspace"';
                              }
                              return null;
                            },
                          ),
                          Container(height: 20),
                        ],
                      )
                    : const SizedBox(
                        height: 50,
                      ),
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
                            color:
                                themeProvider.themeManager.borderSubtle01Color,
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
                            widget.role == Role.viewer ||
                            widget.role == Role.none) {
                          final isSuccessfullyLeft = await workspaceProvider
                              .leaveWorkspace(context, ref);
                          if (isSuccessfullyLeft) {
                            postHogService(
                                eventName: 'LEAVE_WORKSPACE',
                                properties: {
                                  'WORKSPACE_NAME': widget.workspaceName
                                },
                                ref: ref);
                            await ref
                                .watch(ProviderList.profileProvider)
                                .updateProfile(data: {
                              'last_workspace_id': workspaceProvider
                                  .selectedWorkspace.workspaceId,
                            });
                            await ref
                                .watch(ProviderList.projectProvider)
                                .getProjects(
                                    slug: workspaceProvider
                                        .selectedWorkspace.workspaceSlug);
                            CustomToast.showToast(
                              context,
                              message: 'Left workspace successfully',
                              toastType: ToastType.success,
                            );
                            Navigator.of(context).pop();
                          }
                          Navigator.of(context).pop();
                        } else {
                          if (_formKey.currentState!.validate()) {
                            // if (workspaceProvider.role != Role.admin &&
                            //     workspaceProvider.role != Role.member) {
                            //   CustomToast.showToast(
                            //       context,
                            //       'You don\'t have permissions to delete this workspace',
                            //       themeProvider,
                            //       toastType: ToastType.failure);
                            //   return;
                            // }
                            final isSuccesfullyDeleted =
                                await workspaceProvider.deleteWorkspace();
                            if (isSuccesfullyDeleted) {
                              postHogService(
                                  eventName: 'DELETE_WORKSPACE',
                                  properties: {
                                    'WORKSPACE_NAME': widget.workspaceName
                                  },
                                  ref: ref);
                              await ref
                                  .watch(ProviderList.profileProvider)
                                  .updateProfile(data: {
                                'last_workspace_id': workspaceProvider
                                    .selectedWorkspace.workspaceId,
                              });
                              await ref
                                  .watch(ProviderList.projectProvider)
                                  .getProjects(
                                      slug: workspaceProvider
                                          .selectedWorkspace.workspaceSlug);
                              CustomToast.showToast(
                                context,
                                message: 'Workspace deleted successfully',
                                toastType: ToastType.success,
                              );
                              Navigator.of(context).pop();
                            } else {
                              //show snackbar
                              CustomToast.showToast(
                                context,
                                message: 'Workspace could not be deleted',
                                toastType: ToastType.warning,
                              );
                            }
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
                                    StateEnum.loading ||
                                workspaceProvider.leaveWorspaceState ==
                                    StateEnum.loading
                            ? Center(
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: themeProvider
                                        .themeManager.primaryTextColor,
                                  ),
                                ),
                              )
                            : CustomText(
                                widget.role == Role.admin
                                    ? 'Delete Workspace'
                                    : 'Leave workspace',
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
      ),
    );
  }
}
