// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/bottom_sheets/company_size_sheet.dart';
import 'package:plane_startup/bottom_sheets/delete_workspace_sheet.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/bottom_sheets/workspace_logo.dart';
import 'package:plane_startup/utils/custom_toast.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_app_bar.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import 'package:plane_startup/widgets/loading_widget.dart';

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
    _workspaceNameController.text = ref
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace!
        .workspaceName;

    ref.read(ProviderList.workspaceProvider).changeCompanySize(
        size: ref
            .read(ProviderList.workspaceProvider)
            .selectedWorkspace!
            .workspaceSize
            .toString());

    dropDownValue = ref
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace!
        .workspaceSize
        .toString();

    _workspaceUrlController.text = ref
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace!
        .workspaceUrl;
  }

  String? dropDownValue;
  List<String> dropDownItems = ['5', '10', '25', '50'];
  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    // imageUrl = ref
    //     .read(ProviderList.workspaceProvider)
    //     .selectedWorkspace!
    //     .workspaceLogo;
    return WillPopScope(
      onWillPop: () async {
        workspaceProvider.changeLogo(
            logo: workspaceProvider.selectedWorkspace!.workspaceLogo);
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          onPressed: () {
            workspaceProvider.changeLogo(
                logo: workspaceProvider.selectedWorkspace!.workspaceLogo);
            Navigator.of(context).pop();
          },
          text: 'Workspace General',
        ),
        body: LoadingWidget(
          loading: workspaceProvider.updateWorkspaceState == StateEnum.loading,
          widgetClass: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  height: 1,
                  width: MediaQuery.of(context).size.width,
                  color: themeProvider.isDarkThemeEnabled
                      ? darkThemeBorder
                      : Colors.grey[300],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: Row(
                    children: [
                      GestureDetector(
                        child: Container(
                          height: 45,
                          width: 45,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: workspaceProvider.tempLogo == ''
                                ? primaryColor
                                : null,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          //image
                          child: workspaceProvider.tempLogo == ''
                              ? SizedBox(
                                  child: CustomText(
                                    workspaceProvider
                                        .selectedWorkspace!.workspaceName
                                        .toString()
                                        .toUpperCase()[0],
                                    type: FontStyle.Medium,
                                    fontWeight: FontWeightt.Semibold,
                                    // fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.network(
                                    workspaceProvider.tempLogo,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (workspaceProvider.role != Role.admin &&
                              workspaceProvider.role != Role.member) {
                            CustomToast().showToast(context,
                                'You are not allowed to change the logo');
                            return;
                          }
                          showModalBottomSheet(
                              isScrollControlled: true,
                              enableDrag: true,
                              constraints: const BoxConstraints(maxHeight: 370),
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              )),
                              context: context,
                              builder: (ctx) {
                                return const WorkspaceLogo();
                              });
                          // var file = await ImagePicker.platform
                          //     .pickImage(source: ImageSource.gallery);
                          // if (file != null) {
                          //   setState(() {
                          //     coverImage = File(file.path);
                          //   });
                          // }
                        },
                        child: Container(
                            margin: const EdgeInsets.only(left: 16),
                            height: 45,
                            width: 100,
                            decoration: BoxDecoration(
                              color: themeProvider.isDarkThemeEnabled
                                  ? darkSecondaryBGC
                                  : lightBackgroundColor,
                              border: Border.all(
                                  color: themeProvider.isDarkThemeEnabled
                                      ? darkThemeBorder
                                      : strokeColor),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.file_upload_outlined,
                                  color: themeProvider.isDarkThemeEnabled
                                      ? darkPrimaryTextColor
                                      : lightPrimaryTextColor,
                                ),
                                const SizedBox(width: 5),
                                const CustomText(
                                  'Upload',
                                  type: FontStyle.Small,
                                ),
                              ],
                            )),
                      ),
                      workspaceProvider.tempLogo != ''
                          ? GestureDetector(
                              onTap: () {
                                if (workspaceProvider.role != Role.admin &&
                                    workspaceProvider.role != Role.member) {
                                  CustomToast().showToast(context,
                                      'You are not allowed to change the logo');
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
                                        color: themeProvider.isDarkThemeEnabled
                                            ? darkThemeBorder
                                            : strokeColor),
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
                    readOnly: workspaceProvider.role != Role.admin &&
                        workspaceProvider.role != Role.member,
                    controller: _workspaceNameController,
                    decoration:
                        themeProvider.themeManager.textFieldDecoration.copyWith(
                      fillColor: themeProvider.isDarkThemeEnabled
                          ? darkBackgroundColor
                          : lightBackgroundColor,
                      filled: true,
                    ),
                  ),
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
                    onTap: () {
                      CustomToast().showToast(context, accessRestrictedMSG);
                    },
                    readOnly: true,
                    //style: ,
                    decoration:
                        themeProvider.themeManager.textFieldDecoration.copyWith(
                      fillColor: themeProvider.isDarkThemeEnabled
                          ? darkBackgroundColor
                          : lightBackgroundColor,
                      filled: true,
                    ),
                  ),
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
                // Container(
                //   height: 50,
                //   color: Colors.transparent,
                //   padding: const EdgeInsets.only(
                //     left: 20,
                //     right: 20,
                //   ),
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(8),
                //   border: Border.all(
                //     color: Colors.grey.shade500,
                //   ),
                // ),
                // padding: const EdgeInsets.symmetric(
                //     horizontal: 10, vertical: 4),
                // child: DropdownButtonFormField(
                //   dropdownColor: themeProvider.isDarkThemeEnabled
                //       ? darkSecondaryBGC
                //       : Colors.white,
                //   value: dropDownValue,
                //   elevation: 1,
                //   //padding to dropdown
                //   isExpanded: false,
                //   decoration: themeProvider.themeManager.textFieldDecoration.copyWith(
                //     ),

                //   // underline: Container(color: Colors.transparent),
                //   icon: const Icon(Icons.keyboard_arrow_down),
                //   items: dropDownItems.map((String items) {
                //     return DropdownMenuItem(
                //       value: items,
                //       child: SizedBox(
                //         // width: MediaQuery.of(context).size.width - 80,
                //         // child: Text(items),
                //         child: CustomText(
                //           items,
                //           type: FontStyle.Small,
                //         ),
                //       ),
                //     );
                //   }).toList(),
                //   onChanged: (String? newValue) {
                //     setState(() {
                //       dropDownValue = newValue!;
                //     });
                //   },
                // ),

                //convert above dropdown to bottomsheet
                // child:
                GestureDetector(
                  onTap: () {
                    if (workspaceProvider.role != Role.admin &&
                        workspaceProvider.role != Role.member) {
                      CustomToast().showToast(context, accessRestrictedMSG);
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
                        });
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                          color: themeProvider.isDarkThemeEnabled
                              ? darkThemeBorder
                              : Colors.grey.shade300),
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
                        Container(
                          margin: const EdgeInsets.only(right: 16),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: themeProvider.isDarkThemeEnabled
                                ? darkPrimaryTextColor
                                : lightPrimaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ),
                ),
                GestureDetector(
                  onTap: () async {
                    await workspaceProvider.updateWorkspace(data: {
                      'name': _workspaceNameController.text,
                      //convert to int
                      'organization_size': workspaceProvider.companySize,
                      'logo': workspaceProvider.tempLogo,
                    });
                    if (workspaceProvider.updateWorkspaceState ==
                        StateEnum.success) {
                      CustomToast()
                          .showToast(context, 'Workspace updated successfully');
                    }
                    if (workspaceProvider.updateWorkspaceState ==
                        StateEnum.error) {
                      CustomToast().showToast(
                          context, 'Something went wrong, please try again');
                    }
                    // refreshImage();
                  },
                  child: Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      margin:
                          const EdgeInsets.only(top: 20, left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(63, 118, 255, 1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Center(
                          child: CustomText(
                        'Update',
                        color: Colors.white,
                        type: FontStyle.Medium,
                        fontWeight: FontWeightt.Bold,
                      ))),
                ),
                Container(
                  decoration: BoxDecoration(
                      //light red
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: const Color.fromRGBO(255, 12, 12, 1))),
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: ExpansionTile(
                    childrenPadding:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                    iconColor: themeProvider.isDarkThemeEnabled
                        ? Colors.white
                        : greyColor,
                    collapsedIconColor: themeProvider.isDarkThemeEnabled
                        ? Colors.white
                        : greyColor,
                    backgroundColor: const Color.fromRGBO(255, 12, 12, 0.1),
                    collapsedBackgroundColor:
                        const Color.fromRGBO(255, 12, 12, 0.1),
                    title: const CustomText(
                      'Danger Zone',
                      textAlign: TextAlign.left,
                      type: FontStyle.H5,
                      color: Color.fromRGBO(255, 12, 12, 1),
                    ),
                    children: [
                      const CustomText(
                        'The danger zone of the workspace delete page is a critical area that requires careful consideration and attention. When deleting a workspace, all of the data and resources within that workspace will be permanently removed and cannot be recovered.',
                        type: FontStyle.Medium,
                        maxLines: 8,
                        textAlign: TextAlign.left,
                        color: Colors.grey,
                      ),
                      GestureDetector(
                        onTap: () async {
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
                                  bottom:
                                      MediaQuery.viewInsetsOf(context).bottom),
                              child: DeleteWorkspace(
                                workspaceName: workspaceProvider
                                    .selectedWorkspace!.workspaceName,
                              ),
                            ),
                          );
                        },
                        child: Container(
                            height: 45,
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(top: 20, bottom: 15),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(255, 12, 12, 1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Center(
                                child: CustomText(
                              'Delete Workspace',
                              color: Colors.white,
                              type: FontStyle.Medium,
                              fontWeight: FontWeightt.Bold,
                            ))),
                      ),
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
    );
  }
}
