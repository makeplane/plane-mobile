// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plane_startup/bottom_sheets/assignee_sheet.dart';
import 'package:plane_startup/bottom_sheets/lead_sheet.dart';
import 'package:plane_startup/bottom_sheets/status_sheet.dart';
import 'package:plane_startup/config/const.dart';
import 'package:plane_startup/widgets/custom_button.dart';
import 'package:plane_startup/widgets/loading_widget.dart';

import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_app_bar.dart';

class CreateModule extends ConsumerStatefulWidget {
  const CreateModule({super.key});

  @override
  ConsumerState<CreateModule> createState() => _CreateModuleState();
}

class _CreateModuleState extends ConsumerState<CreateModule> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var modulesProvider = ref.watch(ProviderList.modulesProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    return WillPopScope(
      onWillPop: () async {
        modulesProvider.createModule = {};
        return true;
      },
      child: LoadingWidget(
        loading: modulesProvider.createModuleState == StateEnum.loading,
        widgetClass: Scaffold(
          // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          appBar: CustomAppBar(
            onPressed: () {
              modulesProvider.createModule = {};
              Navigator.pop(context);
            },
            text: 'Create Module',
          ),
          backgroundColor: themeProvider.isDarkThemeEnabled
              ? darkSecondaryBGC
              : lightSecondaryBackgroundColor,
          body: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 5),
                              child: const Row(
                                children: [
                                  CustomText(
                                    'Module Title ',
                                    type: FontStyle.title,
                                  ),
                                  CustomText(
                                    '*',
                                    type: FontStyle.appbarTitle,
                                    color: Colors.red,
                                  ),
                                ],
                              )),
                          Container(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                            ),
                            child: TextFormField(
                              controller: titleController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter module name';
                                }
                                return null;
                              },
                              decoration: kTextFieldDecoration.copyWith(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: themeProvider.isDarkThemeEnabled
                                          ? darkThemeBorder
                                          : const Color(0xFFE5E5E5),
                                      width: 1.0),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: themeProvider.isDarkThemeEnabled
                                          ? darkThemeBorder
                                          : const Color(0xFFE5E5E5),
                                      width: 1.0),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: primaryColor, width: 2.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                              ),
                            ),
                          ),
                          // Container(
                          //   margin: const EdgeInsets.only(
                          //       left: 20, right: 20, top: 20, bottom: 5),
                          //   child: const CustomText(
                          //     'Description',
                          //     type: FontStyle.title,
                          //   ),
                          // ),
                          // Container(
                          //   padding: const EdgeInsets.only(left: 20, right: 20),
                          //   child: TextFormField(
                          //     maxLines: 5,
                          //     controller: descriptionController,
                          //     decoration: kTextFieldDecoration.copyWith(
                          //       enabledBorder: OutlineInputBorder(
                          //         borderSide: BorderSide(
                          //             color: themeProvider.isDarkThemeEnabled
                          //                 ? darkThemeBorder
                          //                 : const Color(0xFFE5E5E5),
                          //             width: 1.0),
                          //         borderRadius: const BorderRadius.all(
                          //             Radius.circular(8)),
                          //       ),
                          //       disabledBorder: OutlineInputBorder(
                          //         borderSide: BorderSide(
                          //             color: themeProvider.isDarkThemeEnabled
                          //                 ? darkThemeBorder
                          //                 : const Color(0xFFE5E5E5),
                          //             width: 1.0),
                          //         borderRadius: const BorderRadius.all(
                          //             Radius.circular(8)),
                          //       ),
                          //       focusedBorder: const OutlineInputBorder(
                          //         borderSide: BorderSide(
                          //             color: primaryColor, width: 2.0),
                          //         borderRadius:
                          //             BorderRadius.all(Radius.circular(8)),
                          //       ),
                          //     ),
                          //   ),
                          // ),

                          Container(
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 5),
                              child: const Row(
                                children: [
                                  CustomText(
                                    'Start Date ',
                                    type: FontStyle.title,
                                  ),
                                ],
                              )),

                          GestureDetector(
                            onTap: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              var date = await showDatePicker(
                                builder: (context, child) => Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: primaryColor,
                                    ),
                                  ),
                                  child: child!,
                                ),
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2025),
                              );
                              if (date != null) {
                                setState(() {
                                  startDate = date;
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                right: 20,
                              ),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: themeProvider.isDarkThemeEnabled
                                      ? darkThemeBorder
                                      : const Color(0xFFE5E5E5),
                                ),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: null,
                                    icon: Icon(
                                      Icons.calendar_today,
                                      color: themeProvider.isDarkThemeEnabled
                                          ? darkSecondaryTextColor
                                          : lightSecondaryTextColor,
                                    ),
                                  ),
                                  CustomText(
                                    startDate == null
                                        ? 'Select Date'
                                        : DateFormat('yyyy-MM-dd')
                                            .format(startDate!),
                                    type: FontStyle.description,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 5),
                              child: const Row(
                                children: [
                                  CustomText(
                                    'End Date ',
                                    // color: themeProvider.secondaryTextColor,
                                    type: FontStyle.title,
                                  ),
                                ],
                              )),
                          GestureDetector(
                            onTap: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              var date = await showDatePicker(
                                builder: (context, child) => Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: primaryColor,
                                    ),
                                  ),
                                  child: child!,
                                ),
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2025),
                              );
                              if (date != null) {
                                setState(() {
                                  endDate = date;
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                right: 20,
                              ),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: themeProvider.isDarkThemeEnabled
                                      ? darkThemeBorder
                                      : const Color(0xFFE5E5E5),
                                ),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: null,
                                    icon: Icon(
                                      Icons.calendar_today,
                                      color: themeProvider.isDarkThemeEnabled
                                          ? darkSecondaryTextColor
                                          : lightSecondaryTextColor,
                                    ),
                                  ),
                                  CustomText(
                                    endDate == null
                                        ? 'Select Date'
                                        : DateFormat('yyyy-MM-dd')
                                            .format(endDate!),
                                    type: FontStyle.description,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Container(
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 5),
                              child: const Row(
                                children: [
                                  CustomText(
                                    'Status ',
                                    type: FontStyle.title,
                                  ),
                                  CustomText(
                                    '*',
                                    type: FontStyle.appbarTitle,
                                    color: Colors.red,
                                  ),
                                ],
                              )),
                          GestureDetector(
                            onTap: () {
                              //open bottom sheet
                              showModalBottomSheet(
                                constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.5,
                                ),
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                context: context,
                                builder: (context) => const StatusSheet(),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                // vertical: 5,
                                horizontal: 20,
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: themeProvider.isDarkThemeEnabled
                                      ? darkThemeBorder
                                      : const Color(0xFFE5E5E5),
                                ),
                              ),
                              height: 50,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.window_sharp,
                                    color: themeProvider.isDarkThemeEnabled
                                        ? darkSecondaryTextColor
                                        : lightSecondaryTextColor,
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  CustomText(
                                    modulesProvider.createModule['status'] ==
                                            null
                                        ? 'Select Status'
                                        : modulesProvider.createModule['status']
                                            .toString(),
                                    type: FontStyle.description,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 5),
                              child: const Row(
                                children: [
                                  CustomText(
                                    'Lead ',
                                    type: FontStyle.title,
                                  ),
                                ],
                              )),
                          GestureDetector(
                            onTap: () {
                              //open bottom sheet
                              showModalBottomSheet(
                                constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.8,
                                ),
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                context: context,
                                builder: (context) => const LeadSheet(),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                // vertical: 5,
                                horizontal: 20,
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: themeProvider.isDarkThemeEnabled
                                      ? darkThemeBorder
                                      : const Color(0xFFE5E5E5),
                                ),
                              ),
                              height: 50,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.person_add_alt_1_sharp,
                                    color: themeProvider.isDarkThemeEnabled
                                        ? darkSecondaryTextColor
                                        : lightSecondaryTextColor,
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  CustomText(
                                    modulesProvider.createModule['lead'] == null
                                        ? 'Select Lead'
                                        : projectProvider.projectMembers
                                                    .firstWhere((element) =>
                                                        element['member']['id'] ==
                                                        modulesProvider.createModule['lead'])['member']
                                                ['first_name'] +
                                            ' ' +
                                            projectProvider.projectMembers
                                                .firstWhere((element) =>
                                                    element['member']['id'] ==
                                                    modulesProvider
                                                        .createModule['lead'])['member']['last_name'],
                                    type: FontStyle.description,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Container(
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 5),
                              child: const Row(
                                children: [
                                  CustomText(
                                    'Assignee ',
                                    type: FontStyle.title,
                                  ),
                                ],
                              )),

                          GestureDetector(
                            onTap: () {
                              //open bottom sheet
                              showModalBottomSheet(
                                constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.5,
                                ),
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                context: context,
                                builder: (context) => const AssigneeSheet(),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                // vertical: 5,
                                horizontal: 20,
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: themeProvider.isDarkThemeEnabled
                                      ? darkThemeBorder
                                      : const Color(0xFFE5E5E5),
                                ),
                              ),
                              height: 50,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.group_sharp,
                                    color: themeProvider.isDarkThemeEnabled
                                        ? darkSecondaryTextColor
                                        : lightSecondaryTextColor,
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  CustomText(
                                    (modulesProvider.createModule['members'] == null ||
                                            (modulesProvider.createModule['members'] as List)
                                                .isEmpty)
                                        ? 'Select Assignee'
                                        : (modulesProvider.createModule['members'] as List)
                                                    .length ==
                                                1
                                            ? projectProvider.projectMembers
                                                        .firstWhere((element) => element['member']['id'] == (modulesProvider.createModule['members'] as List)[0])['member']
                                                    ['first_name'] +
                                                ' ' +
                                                projectProvider.projectMembers
                                                    .firstWhere((element) =>
                                                        element['member']
                                                            ['id'] ==
                                                        (modulesProvider.createModule['members']
                                                            as List)[0])['member']['last_name']
                                            : 'Multiple Assignees',
                                    type: FontStyle.description,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // const Spacer(),
                          // Container(
                          //   margin: const EdgeInsets.all(20),
                          //   height: 45,
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(4),
                          //     color: const Color.fromRGBO(63, 118, 255, 1),
                          //   ),
                          //   alignment: Alignment.center,
                          //   width: MediaQuery.of(context).size.width,
                          //   child: CustomText(
                          //     'Create Module ',
                          //     type: FontStyle.buttonText,
                          //     color: Colors.white,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Button(
                        text: 'Create Module',
                        ontap: () async {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }
                          if (modulesProvider.createModule['status'] == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.redAccent,
                                content: CustomText(
                                  'Please select module status',
                                  type: FontStyle.description,
                                  color: Colors.white,
                                ),
                              ),
                            );
                            return;
                          }
                          modulesProvider.createModule['name'] =
                              titleController.text;
                          modulesProvider.createModule['description'] =
                              descriptionController.text;

                          if (startDate != null) {
                            modulesProvider.createModule['start_date'] =
                                DateFormat('yyyy-MM-dd').format(startDate!);
                          }
                          if (endDate != null) {
                            modulesProvider.createModule['target_date'] =
                                DateFormat('yyyy-MM-dd').format(endDate!);
                          }
                          if (modulesProvider.createModule['members'] != null) {
                            modulesProvider.createModule['members_list'] =
                                modulesProvider.createModule['members'];
                          }

                          log(modulesProvider.createModule.toString());

                          await modulesProvider.createNewModule(
                            slug: ref
                                .read(ProviderList.workspaceProvider)
                                .selectedWorkspace!
                                .workspaceSlug,
                            projId: ref
                                .read(ProviderList.projectProvider)
                                .currentProject['id'],
                          );

                          Navigator.pop(Const.globalKey.currentContext!);
                        },
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
