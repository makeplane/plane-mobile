// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plane/config/const.dart';
import 'package:plane/models/cycle/cycle_detail.model.dart';
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
  bool isCreating = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? dueDate;
  DateTime? startDate;

  Future<void> handleCreateCycle(BuildContext context) async {
    final cycleNotifier = ref.read(ProviderList.cycleProvider.notifier);
    if (formKey.currentState!.validate()) {
      // start_date cannot be after end_date
      if (startDate != null && dueDate != null) {
        if (startDate!.isAfter(dueDate!)) {
          CustomToast.showToast(context,
              message: 'Start date cannot be after end date',
              toastType: ToastType.failure);

          return;
        }
      }
      setState(() {
        isCreating = true;
      });
      // Payload to create cycle
      final payload = CycleDetailModel.initial().copyWith(
          name: nameController.text,
          description: descriptionController.text,
          start_date: startDate != null
              ? DateFormat('yyyy-MM-dd').format(startDate!)
              : null,
          end_date: dueDate != null
              ? DateFormat('yyyy-MM-dd').format(dueDate!)
              : null,
          project: ref.read(ProviderList.projectProvider).currentProject["id"]);

      // Create cycle
      cycleNotifier.createCycle(payload).then((value) {
        value.fold((err) {
          CustomToast.showToast(context,
              message: err.messsage, toastType: ToastType.failure);
        }, (cycle) {
          CustomToast.showToast(context,
              message: 'Cycle created successfully',
              toastType: ToastType.success);
        });
      }).whenComplete(() {
        setState(() {
          isCreating = false;
        });
      });
    }

    Navigator.pop(Const.globalKey.currentContext!);
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ref.watch(ProviderList.themeProvider).themeManager;
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
        backgroundColor: themeManager.primaryBackgroundDefaultColor,
        body: LoadingWidget(
          loading: isCreating,
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
                            width: MediaQuery.sizeOf(context).width,
                            color: themeManager.borderSubtle01Color,
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
                                controller: nameController,
                                decoration: themeManager.textFieldDecoration),
                          ),
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
                              final date = await showDatePicker(
                                builder: (context, child) => Theme(
                                  data: themeManager.datePickerThemeData,
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
                                  color: themeManager.borderSubtle01Color,
                                ),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: null,
                                    icon: Icon(
                                      Icons.today,
                                      color: themeManager.placeholderTextColor,
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
                              final date = await showDatePicker(
                                builder: (context, child) => Theme(
                                  data: themeManager.datePickerThemeData,
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
                                  color: themeManager.borderSubtle01Color,
                                ),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: null,
                                    icon: Icon(
                                      Icons.event,
                                      color: themeManager.placeholderTextColor,
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
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 16),
                      child: Button(
                        text: 'Create Cycle',
                        ontap: () async {},
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
