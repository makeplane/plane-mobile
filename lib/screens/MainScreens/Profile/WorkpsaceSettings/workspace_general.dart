// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane/bottom_sheets/company_size_sheet.dart';
import 'package:plane/bottom_sheets/delete_workspace_sheet.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_app_bar.dart';
import 'package:plane/widgets/custom_button.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/loading_widget.dart';
import 'package:plane/widgets/workspace_logo_for_diffrent_extensions.dart';

class WorkspaceGeneral extends ConsumerStatefulWidget {
  const WorkspaceGeneral({super.key});

  @override
  ConsumerState<WorkspaceGeneral> createState() => _WorkspaceGeneralState();
}

class _WorkspaceGeneralState extends ConsumerState<WorkspaceGeneral> {
  final TextEditingController _workspaceNameController =
      TextEditingController();
  final TextEditingController _workspaceUrlController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _workspaceNameController.text = ref
          .read(ProviderList.workspaceProvider)
          .selectedWorkspace
          .workspaceName;

      ref.read(ProviderList.workspaceProvider).changeCompanySize(
          size: ref
              .read(ProviderList.workspaceProvider)
              .selectedWorkspace
              .workspaceSize
              .toString());

      dropDownValue = ref
          .read(ProviderList.workspaceProvider)
          .selectedWorkspace
          .workspaceSize
          .toString();

      _workspaceUrlController.text = ref
          .read(ProviderList.workspaceProvider)
          .selectedWorkspace
          .workspaceUrl;
    });
  }

  Role? role;

  String? dropDownValue;
  List<String> dropDownItems = ['5', '10', '25', '50'];
  File? coverImage;
  String? url;
  bool? expansionState;

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    final fileProvider = ref.watch(ProviderList.fileUploadProvider);

    return WillPopScope(
      onWillPop: () async {
        workspaceProvider.changeLogo(
            logo: workspaceProvider.selectedWorkspace.workspaceLogo);
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor:
              themeProvider.themeManager.primaryBackgroundDefaultColor,
          appBar: CustomAppBar(
            onPressed: () {
              workspaceProvider.changeLogo(
                  logo: workspaceProvider.selectedWorkspace.workspaceLogo);
              Navigator.of(context).pop();
            },
            text: 'Workspace General',
          ),
          body: LoadingWidget(
            loading: workspaceProvider.updateWorkspaceState ==
                    StateEnum.loading ||
                workspaceProvider.workspaceInvitationState == StateEnum.loading,
            widgetClass: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    height: 1,
                    width: MediaQuery.of(context).size.width,
                    color: themeProvider.themeManager.borderSubtle01Color,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: Row(
                      children: [
                        coverImage != null
                            ? Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.file(
                                      File(coverImage!.path),
                                      height: 45,
                                      width: 45,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  fileProvider.fileUploadState ==
                                          StateEnum.loading
                                      ? Container(
                                          height: 45,
                                          width: 45,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: Colors.grey.withOpacity(0.4),
                                          ),
                                          child: Center(
                                            child: SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: LoadingIndicator(
                                                indicatorType: Indicator
                                                    .lineSpinFadeLoader,
                                                colors: [
                                                  themeProvider.themeManager
                                                      .primaryTextColor
                                                ],
                                                strokeWidth: 1.0,
                                                backgroundColor:
                                                    Colors.transparent,
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox()
                                ],
                              )
                            : Container(
                                height: 45,
                                width: 45,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: workspaceProvider.tempLogo == ''
                                      ? themeProvider.themeManager.primaryColour
                                      : null,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                //image
                                child: workspaceProvider.tempLogo == ''
                                    ? SizedBox(
                                        child: CustomText(
                                          workspaceProvider
                                              .selectedWorkspace.workspaceName
                                              .toString()
                                              .toUpperCase()[0],
                                          type: FontStyle.Medium,
                                          fontWeight: FontWeightt.Semibold,
                                          // fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                          overrride: true,
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child:
                                            WorkspaceLogoForDiffrentExtensions(
                                          height: 45,
                                          width: 45,
                                          imageUrl: workspaceProvider.tempLogo,
                                          themeProvider: themeProvider,
                                          workspaceName: workspaceProvider
                                              .selectedWorkspace.workspaceName
                                              .toString(),
                                        ),
                                      ),
                              ),
                        getRole() == Role.admin
                            ? GestureDetector(
                                onTap: () async {
                                  if (workspaceProvider.role != Role.admin &&
                                      workspaceProvider.role != Role.member) {
                                    CustomToast.showToast(context,
                                        message:
                                            'You are not allowed to change the logo',
                                        toastType: ToastType.warning);
                                    return;
                                  }
                                  final file = await ImagePicker()
                                      .pickImage(source: ImageSource.gallery);
                                  if (file != null) {
                                    if (File(file.path).lengthSync() >
                                        5000000) {
                                      CustomToast.showToast(context,
                                          message:
                                              'Image size should be less than 5MB',
                                          toastType: ToastType.warning);
                                      return;
                                    }
                                    setState(() {
                                      coverImage = File(file.path);
                                    });
                                    url = await fileProvider.uploadFile(
                                      coverImage!,
                                      coverImage!.path.split('.').last,
                                    );
                                  }
                                  // showModalBottomSheet(
                                  //     isScrollControlled: true,
                                  //     enableDrag: true,
                                  //     constraints:
                                  //         const BoxConstraints(maxHeight: 370),
                                  //     shape: const RoundedRectangleBorder(
                                  //         borderRadius: BorderRadius.only(
                                  //       topLeft: Radius.circular(30),
                                  //       topRight: Radius.circular(30),
                                  //     )),
                                  //     context: context,
                                  //     builder: (ctx) {
                                  //       return const WorkspaceLogo();
                                  //     });
                                },
                                child: Container(
                                    margin: const EdgeInsets.only(left: 16),
                                    height: 45,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: themeProvider.themeManager
                                          .secondaryBackgroundDefaultColor,
                                      border: Border.all(
                                          color: themeProvider.themeManager
                                              .borderSubtle01Color),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.file_upload_outlined,
                                          color: themeProvider.themeManager
                                              .placeholderTextColor,
                                        ),
                                        const SizedBox(width: 5),
                                        const CustomText(
                                          'Upload',
                                          type: FontStyle.Small,
                                        ),
                                      ],
                                    )),
                              )
                            : Container(),
                        workspaceProvider.tempLogo != '' &&
                                getRole() == Role.admin
                            ? GestureDetector(
                                onTap: () {
                                  if (workspaceProvider.role != Role.admin &&
                                      workspaceProvider.role != Role.member) {
                                    CustomToast.showToast(context,
                                        message:
                                            'You are not allowed to change the logo',
                                        toastType: ToastType.warning);
                                    return;
                                  }
                                  workspaceProvider.removeLogo();
                                  // workspaceProvider.removeLogo();
                                },
                                child: Container(
                                    margin: const EdgeInsets.only(left: 16),
                                    height: 45,
                                    width: 100,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: themeProvider.themeManager
                                              .borderSubtle01Color),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: CustomText(
                                      'Remove',
                                      color: Colors.red.shade600,
                                      type: FontStyle.Small,
                                    )),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 5),
                      child: const Row(
                        children: [
                          CustomText(
                            'Workspace Name ',
                            type: FontStyle.Small,
                          ),
                          CustomText(
                            '*',
                            type: FontStyle.Small,
                            color: Colors.red,
                          ),
                        ],
                      )),
                  Container(
                    //  height: 50,
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: TextFormField(
                        enabled: checkUserAccess() ? true : false,
                        readOnly: workspaceProvider.role != Role.admin &&
                            workspaceProvider.role != Role.member,
                        controller: _workspaceNameController,
                        style: !checkUserAccess()
                            ? TextStyle(
                                color: themeProvider
                                    .themeManager.tertiaryTextColor,
                              )
                            : null,
                        decoration:
                            themeProvider.themeManager.textFieldDecoration),
                  ),
                  Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 5),
                      child: const Row(
                        children: [
                          CustomText(
                            'Workspace URL ',
                            type: FontStyle.Small,
                          ),
                          CustomText(
                            '*',
                            type: FontStyle.Small,
                            color: Colors.red,
                          ),
                        ],
                      )),
                  Container(
                    //  height: 50,
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: TextFormField(
                        controller: _workspaceUrlController,
                        //not editable
                        //enabled: true,
                        onTap: checkUserAccess()
                            ? null
                            : () {
                                CustomToast.showToast(context,
                                    message: accessRestrictedMSG,
                                    toastType: ToastType.failure);
                              },
                        readOnly: checkUserAccess() ? false : true,
                        //style: ,
                        decoration:
                            themeProvider.themeManager.textFieldDecoration),
                  ),
                  Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 5),
                      child: const Row(
                        children: [
                          CustomText(
                            'Company Size ',
                            type: FontStyle.Small,
                          ),
                          CustomText(
                            '*',
                            type: FontStyle.Small,
                            color: Colors.red,
                          ),
                        ],
                      )),
                  GestureDetector(
                    onTap: () {
                      if (workspaceProvider.role != Role.admin) {
                        CustomToast.showToast(context,
                            message: accessRestrictedMSG,
                            toastType: ToastType.failure);
                        return;
                      }
                      showModalBottomSheet(
                        context: context,
                        constraints: BoxConstraints(
                          minHeight: height * 0.5,
                          maxHeight: MediaQuery.of(context).size.height * 0.5,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        builder: (context) {
                          return const CompanySize();
                        },
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 10),
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                            color:
                                themeProvider.themeManager.borderSubtle01Color),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 16),
                            child: CustomText(
                              workspaceProvider.companySize == ''
                                  ? 'Select Company Size'
                                  : workspaceProvider.companySize,
                              type: FontStyle.Small,
                            ),
                          ),
                          checkUserAccess()
                              ? Container(
                                  margin: const EdgeInsets.only(right: 16),
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: themeProvider
                                        .themeManager.primaryTextColor,
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    ),
                    // ),
                  ),
                  checkUserAccess()
                      ? GestureDetector(
                          onTap: () async {
                            await workspaceProvider.updateWorkspace(data: {
                              'name': _workspaceNameController.text,
                              //convert to int
                              'organization_size':
                                  workspaceProvider.companySize,
                              if (url != null) 'logo': url,
                            }, ref: ref);
                            await workspaceProvider.getWorkspaces();
                            if (workspaceProvider.updateWorkspaceState ==
                                StateEnum.success) {
                              CustomToast.showToast(context,
                                  message: 'Workspace updated successfully',
                                  toastType: ToastType.success);
                              Navigator.pop(context);
                            }
                            if (workspaceProvider.updateWorkspaceState ==
                                StateEnum.error) {
                              CustomToast.showToast(context,
                                  message:
                                      'Something went wrong, please try again',
                                  toastType: ToastType.failure);
                            }
                            // refreshImage();
                          },
                          child: Container(
                            height: 45,
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(
                                top: 20, left: 20, right: 20),
                            decoration: BoxDecoration(
                              color: themeProvider.themeManager.primaryColour,
                              borderRadius: BorderRadius.circular(
                                  buttonBorderRadiusLarge),
                            ),
                            child: const Center(
                              child: CustomText(
                                'Update',
                                color: Colors.white,
                                type: FontStyle.Medium,
                                fontWeight: FontWeightt.Bold,
                                overrride: true,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  Container(
                    decoration: BoxDecoration(
                        //light red
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: expansionState == true
                                ? themeProvider.themeManager.textErrorColor
                                : themeProvider
                                    .themeManager.borderSubtle01Color)),
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: ExpansionTile(
                      onExpansionChanged: (value) {
                        setState(() {
                          expansionState = value;
                        });
                      },
                      childrenPadding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 10),
                      iconColor: themeProvider.themeManager.primaryTextColor,
                      collapsedIconColor:
                          themeProvider.themeManager.primaryTextColor,
                      backgroundColor: Colors.transparent,
                      collapsedBackgroundColor: Colors.transparent,
                      title: CustomText(
                        'Danger Zone',
                        textAlign: TextAlign.left,
                        type: FontStyle.H6,
                        fontWeight: FontWeightt.Semibold,
                        color: themeProvider.themeManager.tertiaryTextColor,
                      ),
                      children: [
                        CustomText(
                          getRole() == Role.admin
                              ? 'The danger zone of the workspace delete page is a critical area that requires careful consideration and attention. When deleting a workspace, all of the data and resources within that workspace will be permanently removed and cannot be recovered.'
                              : 'Once you leave the workspace, you will not be able to access any data associated with this workspace. All of your projects and issues associated with you will become inaccessible. You will only be able to rejoin this workspace when someone invites you back.',
                          type: FontStyle.Medium,
                          maxLines: 8,
                          textAlign: TextAlign.left,
                          color: themeProvider.themeManager.tertiaryTextColor,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Button(
                          text: getRole() == Role.admin
                              ? 'Delete Workspace'
                              : 'Leave Workspace',
                          ontap: () async {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              enableDrag: true,
                              constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.8),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                              context: context,
                              builder: (BuildContext context) => Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.viewInsetsOf(context)
                                        .bottom),
                                child: DeleteOrLeaveWorkpace(
                                  workspaceName: workspaceProvider
                                      .selectedWorkspace.workspaceName,
                                  role: getRole(),
                                ),
                              ),
                            );
                          },
                          color: (themeProvider.theme == THEME.dark ||
                                  themeProvider.theme ==
                                      THEME.darkHighContrast ||
                                  (themeProvider.theme ==
                                          THEME.systemPreferences &&
                                      SchedulerBinding
                                              .instance
                                              .platformDispatcher
                                              .platformBrightness ==
                                          Brightness.dark))
                              ? const Color.fromRGBO(95, 21, 21, 1)
                              : const Color.fromRGBO(254, 242, 242, 1),
                          textColor: themeProvider.themeManager.textErrorColor,
                          filledButton: false,
                          borderColor:
                              themeProvider.themeManager.textErrorColor,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool checkUserAccess() {
    final workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    final profileProvider = ref.watch(ProviderList.profileProvider);
    final List members = workspaceProvider.workspaceMembers;
    bool hasAccess = false;
    for (final element in members) {
      if ((element['member']['id'] == profileProvider.userProfile.id) &&
          (element['role'] == 20)) {
        hasAccess = true;
      }
    }
    return hasAccess;
  }

  Role getRole() {
    final workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    final profileProvider = ref.watch(ProviderList.profileProvider);
    int? userRole;
    final List members = workspaceProvider.workspaceMembers;
    for (final element in members) {
      if (element['member']['id'] == profileProvider.userProfile.id) {
        userRole = element['role'];
      }
    }
    switch (userRole) {
      case 20:
        return role = Role.admin;
      case 15:
        return role = Role.member;
      case 10:
        return role = Role.viewer;
      case 5:
        return role = Role.guest;
      default:
        return role = Role.guest;
    }
  }
}
