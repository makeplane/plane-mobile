// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:plane/bottom_sheets/assignee_sheet.dart';
import 'package:plane/bottom_sheets/lead_sheet.dart';
import 'package:plane/bottom_sheets/status_sheet.dart';
import 'package:plane/config/const.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/widgets/custom_button.dart';
import 'package:plane/widgets/loading_widget.dart';

import 'package:plane/provider/provider_list.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_app_bar.dart';

class CreateModule extends ConsumerStatefulWidget {
  const CreateModule({super.key});

  @override
  ConsumerState<CreateModule> createState() => _CreateModuleState();
}

class _CreateModuleState extends ConsumerState<CreateModule> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? startDate;
  DateTime? dueDate;
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
      child: Material(
        child: LoadingWidget(
          loading: modulesProvider.createModuleState == StateEnum.loading,
          widgetClass: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
              appBar: CustomAppBar(
                elevation: false,
                onPressed: () {
                  modulesProvider.createModule = {};
                  Navigator.pop(context);
                },
                text: 'Create Module',
              ),
              backgroundColor:
                  themeProvider.themeManager.primaryBackgroundDefaultColor,
              body: LayoutBuilder(builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 15),
                              Container(
                                  height: 2,
                                  width: MediaQuery.of(context).size.width,
                                  color: themeProvider.themeManager
                                      .primaryBackgroundSelectedColour),
                              Container(
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20, top: 20, bottom: 5),
                                  child: Row(
                                    children: [
                                      CustomText(
                                        'Module Title ',
                                        type: FontStyle.Small,
                                        fontWeight: FontWeightt.Regular,
                                        color: themeProvider
                                            .themeManager.tertiaryTextColor,
                                      ),
                                      CustomText(
                                        '*',
                                        type: FontStyle.Small,
                                        color: themeProvider
                                            .themeManager.textErrorColor,
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
                                    decoration: themeProvider
                                        .themeManager.textFieldDecoration
                                        .copyWith()),
                              ),

                              Container(
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20, top: 20, bottom: 5),
                                  child: Row(
                                    children: [
                                      CustomText(
                                        'Start Date ',
                                        type: FontStyle.Small,
                                        fontWeight: FontWeightt.Regular,
                                        color: themeProvider
                                            .themeManager.tertiaryTextColor,
                                      ),
                                    ],
                                  )),

                              GestureDetector(
                                onTap: () async {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  var date = await showDatePicker(
                                    builder: (context, child) => Theme(
                                      data: themeProvider.themeManager.theme ==
                                                  THEME.dark ||
                                              themeProvider
                                                      .themeManager.theme ==
                                                  THEME.darkHighContrast
                                          ? ThemeData.dark().copyWith(
                                              dialogBackgroundColor: themeProvider
                                                  .themeManager
                                                  .tertiaryBackgroundDefaultColor,
                                              colorScheme: ColorScheme.dark(
                                                primary: themeProvider
                                                    .themeManager.primaryColour,
                                                surface: themeProvider
                                                    .themeManager.primaryColour,
                                              ),
                                            )
                                          : ThemeData.light().copyWith(
                                              colorScheme: ColorScheme.light(
                                                primary: themeProvider
                                                    .themeManager.primaryColour,
                                              ),
                                            ),
                                      child: child!,
                                    ),
                                    context: context,
                                    initialDate: DateTime.now()
                                            .isAfter(dueDate ?? DateTime.now())
                                        ? dueDate ?? DateTime.now()
                                        : DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: dueDate ?? DateTime(2025),
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
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: themeProvider
                                          .themeManager.borderSubtle01Color,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: null,
                                        icon: Icon(
                                          Icons.today_outlined,
                                          color: themeProvider.themeManager
                                              .placeholderTextColor,
                                        ),
                                      ),
                                      CustomText(
                                        startDate == null
                                            ? ''
                                            : DateFormat('yyyy-MM-dd')
                                                .format(startDate!),
                                        type: FontStyle.Medium,
                                        color: themeProvider
                                            .themeManager.tertiaryTextColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20, top: 20, bottom: 5),
                                  child: Row(
                                    children: [
                                      CustomText(
                                        'Target Date',
                                        // color: themeProvider.secondaryTextColor,
                                        type: FontStyle.Small,
                                        fontWeight: FontWeightt.Regular,
                                        color: themeProvider
                                            .themeManager.tertiaryTextColor,
                                      ),
                                    ],
                                  )),
                              GestureDetector(
                                onTap: () async {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  var date = await showDatePicker(
                                    builder: (context, child) => Theme(
                                      data: themeProvider.themeManager.theme ==
                                                  THEME.dark ||
                                              themeProvider
                                                      .themeManager.theme ==
                                                  THEME.darkHighContrast
                                          ?  ThemeData.dark().copyWith(
                                              dialogBackgroundColor: themeProvider
                                                  .themeManager
                                                  .tertiaryBackgroundDefaultColor,
                                              colorScheme: ColorScheme.dark(
                                                primary: themeProvider
                                                    .themeManager.primaryColour,
                                                surface: themeProvider
                                                    .themeManager.primaryColour,
                                              ),
                                            )
                                          : ThemeData.light().copyWith(
                                              colorScheme: ColorScheme.light(
                                                primary: themeProvider
                                                    .themeManager.primaryColour,
                                              ),
                                            ),
                                      child: child!,
                                    ),
                                    context: context,
                                    initialDate: DateTime.now().isBefore(
                                            startDate ?? DateTime.now())
                                        ? startDate ?? DateTime.now()
                                        : DateTime.now(),
                                    firstDate: startDate ?? DateTime(2020),
                                    lastDate: DateTime(2025),
                                  );
                                  if (date != null) {
                                    setState(() {
                                      dueDate = date;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                    right: 20,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: themeProvider
                                          .themeManager.borderSubtle01Color,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: null,
                                        icon: Icon(
                                          Icons.event_outlined,
                                          color: themeProvider.themeManager
                                              .placeholderTextColor,
                                        ),
                                      ),
                                      CustomText(
                                        dueDate == null
                                            ? ''
                                            : DateFormat('yyyy-MM-dd')
                                                .format(dueDate!),
                                        type: FontStyle.Medium,
                                        color: themeProvider
                                            .themeManager.tertiaryTextColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              Container(
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20, top: 20, bottom: 5),
                                  child: Row(
                                    children: [
                                      CustomText(
                                        'Status ',
                                        type: FontStyle.Small,
                                        fontWeight: FontWeightt.Regular,
                                        color: themeProvider
                                            .themeManager.tertiaryTextColor,
                                      ),
                                      CustomText(
                                        '*',
                                        type: FontStyle.Small,
                                        color: themeProvider
                                            .themeManager.textErrorColor,
                                      ),
                                    ],
                                  )),
                              GestureDetector(
                                onTap: () {
                                  //open bottom sheet
                                  showModalBottomSheet(
                                    constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                              0.5,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: themeProvider
                                          .themeManager.borderSubtle01Color,
                                    ),
                                  ),
                                  height: 50,
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/svg_images/home.svg",
                                        width: 20,
                                        colorFilter: ColorFilter.mode(
                                            themeProvider.themeManager
                                                .placeholderTextColor,
                                            BlendMode.srcIn),
                                      ),

                                      // Icon(
                                      //       Icons.bento_outlined,
                                      //   color: themeProvider
                                      //       .themeManager.placeholderTextColor,
                                      // ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      CustomText(
                                        modulesProvider
                                                    .createModule['status'] ==
                                                null
                                            ? ''
                                            : modulesProvider
                                                .createModule['status']
                                                .toString(),
                                        type: FontStyle.Medium,
                                      ),
                                      const Spacer(),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        color: themeProvider
                                            .themeManager.primaryTextColor,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20, top: 20, bottom: 5),
                                  child: Row(
                                    children: [
                                      CustomText(
                                        'Lead ',
                                        type: FontStyle.Small,
                                        fontWeight: FontWeightt.Regular,
                                        color: themeProvider
                                            .themeManager.tertiaryTextColor,
                                      ),
                                    ],
                                  )),
                              GestureDetector(
                                onTap: () {
                                  //open bottom sheet
                                  showModalBottomSheet(
                                    constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                              0.8,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: themeProvider
                                          .themeManager.borderSubtle01Color,
                                    ),
                                  ),
                                  height: 50,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.account_circle_outlined,
                                        color: themeProvider
                                            .themeManager.placeholderTextColor,
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      CustomText(
                                        modulesProvider.createModule['lead'] == null
                                            ? ''
                                            : projectProvider.projectMembers
                                                        .firstWhere((element) =>
                                                            element['member']['id'] ==
                                                            modulesProvider.createModule['lead'])['member']
                                                    ['first_name'] +
                                                ' ' +
                                                projectProvider.projectMembers
                                                        .firstWhere((element) =>
                                                            element['member']
                                                                ['id'] ==
                                                            modulesProvider.createModule['lead'])['member']
                                                    ['last_name'],
                                        type: FontStyle.Medium,
                                      ),
                                      const Spacer(),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        color: themeProvider
                                            .themeManager.primaryTextColor,
                                      )
                                    ],
                                  ),
                                ),
                              ),

                              Container(
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20, top: 20, bottom: 5),
                                  child: Row(
                                    children: [
                                      CustomText(
                                        'Assignee ',
                                        type: FontStyle.Small,
                                        fontWeight: FontWeightt.Regular,
                                        color: themeProvider
                                            .themeManager.tertiaryTextColor,
                                      ),
                                    ],
                                  )),

                              GestureDetector(
                                onTap: () {
                                  //open bottom sheet
                                  showModalBottomSheet(
                                    constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                              0.5,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: themeProvider
                                          .themeManager.borderSubtle01Color,
                                    ),
                                  ),
                                  height: 50,
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/svg_images/assignee.svg",
                                        width: 25,
                                        colorFilter: ColorFilter.mode(
                                            themeProvider.themeManager
                                                .placeholderTextColor,
                                            BlendMode.srcIn),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      CustomText(
                                        (modulesProvider.createModule['members'] == null ||
                                                (modulesProvider.createModule['members'] as List)
                                                    .isEmpty)
                                            ? ''
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
                                        type: FontStyle.Medium,
                                      ),
                                      const Spacer(),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        color: themeProvider
                                            .themeManager.primaryTextColor,
                                      )
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
                              //     type: FontStyle.Medium,
                              //    fontWeight: FontWeightt.Bold,
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
                              if (modulesProvider.createModule['status'] ==
                                  null) {
                                CustomToast.showToast(context,
                                    message: 'Please select module status',
                                    toastType: ToastType.warning);
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
                              if (dueDate != null) {
                                modulesProvider.createModule['target_date'] =
                                    DateFormat('yyyy-MM-dd').format(dueDate!);
                              }
                              if (modulesProvider.createModule['members'] !=
                                  null) {
                                modulesProvider.createModule['members_list'] =
                                    modulesProvider.createModule['members'];
                              }

                              log(modulesProvider.createModule.toString());

                              await modulesProvider.createNewModule(
                                  slug: ref
                                      .read(ProviderList.workspaceProvider)
                                      .selectedWorkspace
                                      .workspaceSlug,
                                  projId: ref
                                      .read(ProviderList.projectProvider)
                                      .currentProject['id'],
                                  ref: ref);

                              Navigator.pop(Const.globalKey.currentContext!);
                            },
                            textColor: themeProvider.themeManager.textonColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
