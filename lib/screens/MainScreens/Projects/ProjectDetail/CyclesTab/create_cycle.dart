// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plane/config/const.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_app_bar.dart';
import 'package:plane/widgets/custom_button.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/loading_widget.dart';

class CreateCycle extends ConsumerStatefulWidget {
  const CreateCycle({super.key});

  @override
  ConsumerState<CreateCycle> createState() => _CreateCycleState();
}

class _CreateCycleState extends ConsumerState<CreateCycle> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController cycleNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime? dueDate;
  DateTime? startDate;

  @override
  void initState() {
    super.initState();
    log(ref
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace!
        .workspaceSlug
        .toString());
    log(ref.read(ProviderList.projectProvider).currentProject["id"]);
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    BuildContext mainBuildContext = context;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar(
          onPressed: () {
            Navigator.pop(context);
          },
          text: 'Create Cycle',
        ),
        backgroundColor:
            themeProvider.themeManager.primaryBackgroundDefaultColor,
        body: LoadingWidget(
          loading: cyclesProvider.cyclesState == StateEnum.loading,
          widgetClass: LayoutBuilder(builder: (context, constraints) {
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
                            height: 1,
                            width: MediaQuery.of(context).size.width,
                            color:
                                themeProvider.themeManager.borderSubtle01Color,
                          ),
                          Container(
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 5),
                              child: const Row(
                                children: [
                                  CustomText(
                                    'Cycle Title ',
                                    type: FontStyle.Small,
                                    fontWeight: FontWeightt.Regular,
                                  ),
                                  CustomText(
                                    '*',
                                    type: FontStyle.Small,
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
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter cycle name';
                                  }
                                  return null;
                                },
                                controller: cycleNameController,
                                decoration: themeProvider
                                    .themeManager.textFieldDecoration),
                          ),
                          // Container(
                          //   margin: const EdgeInsets.only(
                          //       left: 20, right: 20, top: 20, bottom: 5),
                          //   child: const CustomText(
                          //     'Description',
                          //     // color: themeProvider.secondaryTextColor,
                          //     type: FontStyle.Small,
                          //   ),
                          // ),
                          // Container(
                          //   padding: const EdgeInsets.only(left: 20, right: 20),
                          //   child: TextFormField(
                          //     maxLines: 7,
                          //     controller: descriptionController,
                          //     decoration: themeProvider.themeManager.textFieldDecoration.copyWith(
                          //       enabledBorder: OutlineInputBorder(
                          //         borderSide: BorderSide(
                          //             color: themeProvider.isDarkThemeEnabled
                          //                 ? darkThemeBorder
                          //                 : const Color(0xFFE5E5E5),
                          //             width: 1.0),
                          //         borderRadius:
                          //             const BorderRadius.all(Radius.circular(8)),
                          //       ),
                          //       disabledBorder: OutlineInputBorder(
                          //         borderSide: BorderSide(
                          //             color: themeProvider.isDarkThemeEnabled
                          //                 ? darkThemeBorder
                          //                 : const Color(0xFFE5E5E5),
                          //             width: 1.0),
                          //         borderRadius:
                          //             const BorderRadius.all(Radius.circular(8)),
                          //       ),
                          //       focusedBorder: const OutlineInputBorder(
                          //         borderSide:
                          //             BorderSide(color: primaryColor, width: 2.0),
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
                                    type: FontStyle.Small,
                                  ),
                                ],
                              )),
                          GestureDetector(
                            onTap: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              var date = await showDatePicker(
                                builder: (context, child) => Theme(
                                  data: themeProvider
                                      .themeManager.datePickerThemeData,
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
                                  vertical: 2, horizontal: 20),
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
                                      Icons.today,
                                      color: themeProvider
                                          .themeManager.placeholderTextColor,
                                    ),
                                  ),
                                  CustomText(
                                    startDate == null
                                        ? ''
                                        : DateFormat('yyyy-MM-dd')
                                            .format(startDate!),
                                    type: FontStyle.Medium,
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
                                    type: FontStyle.Small,
                                  ),
                                ],
                              )),
                          GestureDetector(
                            onTap: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              var date = await showDatePicker(
                                builder: (context, child) => Theme(
                                  data: themeProvider
                                      .themeManager.datePickerThemeData,
                                  child: child!,
                                ),
                                context: context,
                                initialDate: DateTime.now()
                                        .isBefore(startDate ?? DateTime.now())
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
                                  vertical: 2, horizontal: 20),
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
                                      Icons.event,
                                      color: themeProvider
                                          .themeManager.placeholderTextColor,
                                    ),
                                  ),
                                  CustomText(
                                    dueDate == null
                                        ? ''
                                        : DateFormat('yyyy-MM-dd')
                                            .format(dueDate!),
                                    type: FontStyle.Medium,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // const Spacer(),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 16),
                      child: Button(
                        text: 'Create Cycle',
                        ontap: () async {
                          if (formKey.currentState!.validate()) {
                            cyclesProvider.cyclesState = StateEnum.loading;
                            cyclesProvider.setState();
                            bool dateNotConflicted = false;
                            // if (startDate == null || dueDate == null) {
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     SnackBar(
                            //       backgroundColor: Colors.redAccent,
                            //       content: CustomText(
                            //         'Please select start and end date',
                            //         type: FontStyle.Medium,
                            //         color: Colors.white,
                            //       ),
                            //     ),
                            //   );
                            //   return;
                            // }

                            if (startDate != null && dueDate != null) {
                              if (startDate!.isAfter(dueDate!)) {
                                CustomToast.showToast(mainBuildContext,
                                    message:
                                        'Start date cannot be after end date',
                                    toastType: ToastType.failure);

                                return;
                              }

                              dateNotConflicted =
                                  await cyclesProvider.dateCheck(
                                slug: ref
                                    .read(ProviderList.workspaceProvider)
                                    .selectedWorkspace!
                                    .workspaceSlug,
                                projectId: ref
                                    .read(ProviderList.projectProvider)
                                    .currentProject["id"],
                                data: {
                                  "start_date": DateFormat('yyyy-MM-dd')
                                      .format(startDate!),
                                  "end_date":
                                      DateFormat('yyyy-MM-dd').format(dueDate!),
                                },
                              );
                            }

                            if (dateNotConflicted ||
                                (startDate == null && dueDate == null)) {
                              await cyclesProvider.cyclesCrud(
                                  slug: ref
                                      .read(ProviderList.workspaceProvider)
                                      .selectedWorkspace!
                                      .workspaceSlug,
                                  projectId: ref
                                      .read(ProviderList.projectProvider)
                                      .currentProject["id"],
                                  method: CRUD.create,
                                  query: '',
                                  data: {
                                    "name": cycleNameController.text,
                                    "description": descriptionController.text,
                                    "start_date": startDate == null
                                        ? null
                                        : DateFormat('yyyy-MM-dd')
                                            .format(startDate!),
                                    "end_date": dueDate == null
                                        ? null
                                        : DateFormat('yyyy-MM-dd')
                                            .format(dueDate!),
                                    "status": "started"
                                  },
                                  ref: ref,
                                  cycleId: '');

                              await cyclesProvider.cyclesCrud(
                                  slug: ref
                                      .read(ProviderList.workspaceProvider)
                                      .selectedWorkspace!
                                      .workspaceSlug,
                                  projectId: ref
                                      .read(ProviderList.projectProvider)
                                      .currentProject['id'],
                                  method: CRUD.read,
                                  query: 'all',
                                  ref: ref,
                                  cycleId: '');

                              for (int i = 0;
                                  i < cyclesProvider.queries.length;
                                  i++) {
                                ref
                                    .read(ProviderList.cyclesProvider)
                                    .cyclesCrud(
                                        slug: ref
                                            .read(
                                                ProviderList.workspaceProvider)
                                            .selectedWorkspace!
                                            .workspaceSlug,
                                        projectId: ref
                                            .read(ProviderList.projectProvider)
                                            .currentProject['id'],
                                        method: CRUD.read,
                                        query: cyclesProvider.queries[i],
                                        ref: ref,
                                        cycleId: '');
                              }
                              Navigator.pop(Const.globalKey.currentContext!);
                            } else {
                              CustomToast.showToast(mainBuildContext,
                                  message:
                                      'Cycle date is conflicted with other cycle',
                                  toastType: ToastType.failure);

                              return;
                            }
                          }
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
