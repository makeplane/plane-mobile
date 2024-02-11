// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/core/extensions/string_extensions.dart';
import 'package:plane/widgets/custom_app_bar.dart';
import 'package:plane/widgets/custom_button.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/loading_widget.dart';

class CreateState extends ConsumerStatefulWidget {
  const CreateState({super.key});

  @override
  ConsumerState<CreateState> createState() => _CreateStateState();
}

class _CreateStateState extends ConsumerState<CreateState> {
  String selectedState = 'Backlog';
  TextEditingController colorController = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List lables = [
    "#FF6900",
    "#FCB900",
    "#7BDCB5",
    "#00D084",
    "#8ED1FC",
    "#0693E3",
    "#ABB8C3",
    "#EB144C",
    "#F78DA7",
    "#9900EF",
  ];
  @override
  void initState() {
    colorController.text = '08AB22';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final statesProvider = ref.watch(ProviderList.statesProvider);
    final statesNotifier = ref.read(ProviderList.statesProvider.notifier);
    return Scaffold(
      appBar: CustomAppBar(
        onPressed: () {
          Navigator.pop(context);
        },
        text: 'Create State',
      ),
      body: LoadingWidget(
        loading: statesProvider.statesState == DataState.loading,
        widgetClass: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Container(
              alignment: Alignment.center,
              child: Container(
                decoration: const BoxDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 1,
                      color: themeProvider.themeManager.borderStrong01Color,
                    ),
                    Container(
                        margin: const EdgeInsets.only(
                            left: 15, right: 20, top: 15, bottom: 5),
                        child: Row(
                          children: [
                            CustomText(
                              'Name ',
                              color:
                                  themeProvider.themeManager.tertiaryTextColor,
                              type: FontStyle.Small,
                            ),
                            CustomText(
                              '*',
                              color: themeProvider.themeManager.textErrorColor,
                              type: FontStyle.Small,
                            ),
                          ],
                        )),
                    Container(
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      child: TextFormField(
                        controller: name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '*required';
                          }
                          return null;
                        },
                        decoration: themeProvider
                            .themeManager.textFieldDecoration
                            .copyWith(
                          border: InputBorder.none,
                          errorStyle: const TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                              fontWeight: FontWeight.w600),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: themeProvider
                                    .themeManager.borderStrong01Color,
                                width: 1.0),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: themeProvider
                                    .themeManager.borderStrong01Color,
                                width: 1.0),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                          ),
                          fillColor: themeProvider
                              .themeManager.secondaryBackgroundDefaultColor,
                          filled: true,
                        ),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(
                            left: 15, right: 20, top: 20, bottom: 5),
                        child: Row(
                          children: [
                            CustomText(
                              'State ',
                              color:
                                  themeProvider.themeManager.tertiaryTextColor,
                              type: FontStyle.Small,
                            ),
                            CustomText(
                              '*',
                              color: themeProvider.themeManager.textErrorColor,
                              type: FontStyle.Small,
                            ),
                          ],
                        )),
                    Container(
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      height: 50,
                      padding: const EdgeInsets.only(left: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: themeProvider
                            .themeManager.secondaryBackgroundDefaultColor,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: themeProvider.themeManager.borderStrong01Color,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<String>(
                          value: selectedState,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          alignment: Alignment.centerLeft,
                          items: const [
                            DropdownMenuItem<String>(
                              value: 'Backlog',
                              child: CustomText(
                                'Backlog',
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: 'Cancelled',
                              child: CustomText('Cancelled'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'Completed',
                              child: CustomText('Completed'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'Started',
                              child: CustomText('Started'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'Unstarted',
                              child: CustomText('Unstarted'),
                            ),
                          ],
                          dropdownColor: themeProvider
                              .themeManager.secondaryBackgroundDefaultColor,
                          onChanged: (value) {
                            selectedState = value!;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        margin: const EdgeInsets.only(
                            right: 20, left: 15, bottom: 10),
                        child: Row(
                          children: [
                            CustomText(
                              'Color ',
                              color:
                                  themeProvider.themeManager.tertiaryTextColor,
                              type: FontStyle.Small,
                            ),
                            CustomText(
                              '*',
                              color: themeProvider.themeManager.textErrorColor,
                              type: FontStyle.Small,
                            ),
                          ],
                        )),
                    Container(
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      child: Wrap(
                        spacing: 10,
                        children: lables
                            .map(
                              (e) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    colorController.text = e
                                        .toString()
                                        .toUpperCase()
                                        .replaceAll('#', '');
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  margin: const EdgeInsets.only(bottom: 20),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: e.toString().toColor(),
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: const [
                                      BoxShadow(
                                          blurRadius: 1.0, color: greyColor),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 55,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: "#${colorController.text.toString()}"
                                    .toColor(),
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8))),
                            child: const CustomText(
                              '#',
                              color: Colors.white,
                              fontWeight: FontWeightt.Semibold,
                              fontSize: 20,
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '*required';
                                }
                                return null;
                              },
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9a-zA-Z]")),
                              ],
                              controller: colorController,
                              maxLength: 6,
                              onChanged: (value) {
                                if (value.length == 6 &&
                                    value.contains(RegExp("[^0-9a-fA-F]"))) {
                                  CustomToast.showToast(context,
                                      message: 'HexCode is not valid',
                                      toastType: ToastType.warning);
                                }

                                setState(() {});
                              },
                              decoration: themeProvider
                                  .themeManager.textFieldDecoration
                                  .copyWith(
                                counterText: '',
                                errorStyle: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.red.shade600, width: 1.0),
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(6),
                                    bottomRight: Radius.circular(6),
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.red.shade600, width: 2.0),
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(6),
                                    bottomRight: Radius.circular(6),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: themeProvider
                                          .themeManager.borderStrong01Color,
                                      width: 1.0),
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(6),
                                    bottomRight: Radius.circular(6),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: themeProvider
                                          .themeManager.borderStrong01Color,
                                      width: 1.0),
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(6),
                                    bottomRight: Radius.circular(6),
                                  ),
                                ),
                                fillColor: themeProvider.themeManager
                                    .secondaryBackgroundDefaultColor,
                                filled: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        margin:
                            const EdgeInsets.only(top: 20, bottom: 5, left: 15),
                        child: const CustomText(
                          'Description ',
                          type: FontStyle.Small,
                        )),
                    Container(
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      child: TextFormField(
                        controller: description,
                        maxLines: 5,
                        decoration: themeProvider
                            .themeManager.textFieldDecoration
                            .copyWith(
                          contentPadding: const EdgeInsets.all(10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: themeProvider
                                    .themeManager.borderStrong01Color,
                                width: 1.0),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: themeProvider
                                    .themeManager.borderStrong01Color,
                                width: 1.0),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                          ),
                          fillColor: themeProvider
                              .themeManager.secondaryBackgroundDefaultColor,
                          filled: true,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      child: Button(
                          text: 'Create State',
                          ontap: () async {
                            if (!formKey.currentState!.validate()) return;
                            await statesNotifier.createState(data: {
                              "name": name.text,
                              "color": "#${colorController.text}",
                              "group": selectedState.toLowerCase(),
                            });
                            Navigator.pop(context);
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
