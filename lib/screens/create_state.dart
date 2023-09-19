// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/color_manager.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/enums.dart';
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
  var selectedState = 'Backlog';
  TextEditingController colorController = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List lables = [
    '#B71F1F',
    '#08AB22',
    '#BC009E',
    '#F15700',
    '#290CDE',
    '#B1700D',
    '#08BECA',
    '#6500CA',
    '#E98787',
    '#ADC57C',
    '#75A0C8',
    '#E96B6B'
    // {'lable': 'Lable 1', 'color': Colors.orange},
    // {'lable': 'Lable 2', 'color': Colors.purple},
    // {'lable': 'Lable 3', 'color': Colors.blue},
    // {'lable': 'Lable 4', 'color': Colors.pink}
  ];
  @override
  void initState() {
    colorController.text = '08AB22';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var issuesProvider = ref.watch(ProviderList.issuesProvider);
    return Scaffold(
      appBar: CustomAppBar(
        onPressed: () {
          Navigator.pop(context);
        },
        text: 'Create State',
      ),
      body: LoadingWidget(
        loading: issuesProvider.statesState == StateEnum.loading,
        widgetClass: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Container(
              alignment: Alignment.center,
              //   color: Colors.black.withOpacity(0.5),
              child: Container(
                // padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                    //  color: Colors.white,
                    ),
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
                      // height: 45,
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
                          focusColor: Colors.amber,
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
                                        .replaceAll("#", "");
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  margin: const EdgeInsets.only(bottom: 20),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: ColorManager.getColorFromHexaDecimal(
                                        e.toString()),
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
                      // height: 50,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 55,
                            height: 55,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: ColorManager.getColorFromHexaDecimal(
                                    colorController.text.toString()),
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
                              controller: colorController,
                              maxLength: 6,
                              onChanged: (val) {
                                colorController.text = val.toUpperCase();
                                colorController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: colorController.text.length));
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
                          // color: themeProvider.secondaryTextColor,
                          type: FontStyle.Small,
                        )),
                    Container(
                      // height: 45,
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      child: TextFormField(
                        controller: description,
                        maxLines: 5,
                        decoration: themeProvider
                            .themeManager.textFieldDecoration
                            .copyWith(
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
                            await issuesProvider.createState(
                                slug: ref
                                    .read(ProviderList.workspaceProvider)
                                    .selectedWorkspace!
                                    .workspaceSlug,
                                projID: ref
                                    .read(ProviderList.projectProvider)
                                    .currentProject["id"],
                                data: {
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
