// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/core/extensions/string_extensions.dart';
import 'package:plane/widgets/custom_button.dart';
import 'package:plane/widgets/custom_text.dart';

class SelectIssueLabels extends ConsumerStatefulWidget {
  SelectIssueLabels({required this.selectedLabels, super.key});
  List<String> selectedLabels;
  @override
  ConsumerState<SelectIssueLabels> createState() => _SelectIssueLabelsState();
}

class _SelectIssueLabelsState extends ConsumerState<SelectIssueLabels> {
  final labelContrtoller = TextEditingController();
  final colorController = TextEditingController();
  bool createNew = false;
  final showColorPallette = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final labelProvider = ref.watch(ProviderList.labelProvider);
    final labelNotifier = ref.read(ProviderList.labelProvider.notifier);
    return Container(
      padding: EdgeInsets.only(bottom: bottomSheetConstBottomPadding),
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: themeProvider.themeManager.secondaryBackgroundDefaultColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      width: double.infinity,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                      'Select Labels',
                      type: FontStyle.H4,
                      fontWeight: FontWeightt.Semibold,
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: themeProvider.themeManager.placeholderTextColor,
                      ),
                    )
                  ],
                ),
                Container(height: 15),
                Expanded(
                  child: labelProvider.projectLabels.isNotEmpty
                      ? ListView.builder(
                          itemCount: labelProvider.projectLabels.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final labelId = labelProvider.projectLabels.keys
                                .elementAt(index);
                            final label = labelProvider.projectLabels.values
                                .elementAt(index);
                            return InkWell(
                              onTap: () {
                                // setState(() {

                                setState(() {
                                  if (widget.selectedLabels.contains(labelId)) {
                                    widget.selectedLabels.remove(labelId);
                                  } else {
                                    widget.selectedLabels.add(labelId);
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                margin: labelProvider.projectLabels.length ==
                                        index + 1
                                    ? const EdgeInsets.only(bottom: 35)
                                    : null,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 8,
                                          backgroundColor:
                                              label.color.toColor(),
                                        ),
                                        Container(width: 10),
                                        SizedBox(
                                          width: width * 0.7,
                                          child: CustomText(
                                            label.name.toString(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            type: FontStyle.Medium,
                                            fontWeight: FontWeightt.Regular,
                                            color: themeProvider
                                                .themeManager.primaryTextColor,
                                          ),
                                        ),
                                        const Spacer(),
                                        widget.selectedLabels.contains(label.id)
                                            ? const Icon(
                                                Icons.done,
                                                color: Color.fromRGBO(
                                                    8, 171, 34, 1),
                                              )
                                            : const SizedBox(),
                                        const SizedBox(width: 10)
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Container(
                                        height: 1,
                                        color: themeProvider
                                            .themeManager.borderDisabledColor)
                                  ],
                                ),
                              ),
                            );
                          })
                      : const Center(
                          child: CustomText('No labels are created yet')),
                ),
                showColorPallette && createNew
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: labelContrtoller,
                              decoration: themeProvider
                                  .themeManager.textFieldDecoration
                                  .copyWith(
                                label: const Text('Label Text'),
                                prefixIconConstraints: const BoxConstraints(
                                    minWidth: 0, minHeight: 0),
                                prefixIcon: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 5),
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                    color: '#${colorController.text}'.toColor(),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 10,
                              children: colorsForLabel
                                  .map(
                                    (e) => GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          colorController.text =
                                              e.toString().replaceAll('#', '');
                                        });
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: e.toString().toColor(),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          boxShadow: const [
                                            BoxShadow(
                                                blurRadius: 1.0,
                                                color: greyColor),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            SizedBox(
                              height: 80,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      maxLength: 6,
                                      onChanged: (value) {
                                        setState(() {});
                                      },
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[0-9a-fA-F]")),
                                      ],
                                      controller: colorController,
                                      decoration: themeProvider
                                          .themeManager.textFieldDecoration
                                          .copyWith(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 3,
                                              color: themeProvider.themeManager
                                                  .primaryBackgroundSelectedColour),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 3,
                                              color: themeProvider.themeManager
                                                  .primaryBackgroundSelectedColour),
                                        ),
                                        filled: true,
                                        fillColor: themeProvider.themeManager
                                            .secondaryBackgroundDefaultColor,
                                        prefixIcon: Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          width: 55,
                                          height: 55,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: themeProvider.themeManager
                                                  .primaryBackgroundSelectedColour,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(5),
                                                      bottomLeft:
                                                          Radius.circular(5))),
                                          child: CustomText(
                                            '#',
                                            color: themeProvider.themeManager
                                                .placeholderTextColor,
                                            fontWeight: FontWeightt.Semibold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          labelProvider.labelState == DataState.loading
              ? Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: themeProvider
                          .themeManager.tertiaryBackgroundDefaultColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(23),
                        topRight: Radius.circular(23),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 25,
                          width: 25,
                          child: LoadingIndicator(
                            indicatorType: Indicator.lineSpinFadeLoader,
                            colors: [
                              themeProvider.themeManager.primaryTextColor
                            ],
                            strokeWidth: 1.0,
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
          Column(
            children: [
              Expanded(child: Container()),
              Container(
                margin: const EdgeInsets.only(
                    bottom: 10, top: 10, left: 10, right: 10),
                child: createNew
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Button(
                          text: 'Save Label',
                          ontap: () async {
                            if (labelContrtoller.text.isEmpty) {
                              CustomToast.showToast(context,
                                  message: 'Label is empty',
                                  toastType: ToastType.failure);
                            } else if (colorController.text.length != 6) {
                              CustomToast.showToast(context,
                                  message: 'Color is not valid',
                                  toastType: ToastType.failure);
                            } else {
                              await labelNotifier.updateLabel(
                                {
                                  'name': labelContrtoller.text,
                                  'color': colorController.text,
                                },
                              );
                              setState(() {
                                createNew = false;
                                colorController.clear();
                                labelContrtoller.clear();
                              });
                            }
                          },
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: InkWell(
                          child: Container(
                            height: 45,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: themeProvider.themeManager.primaryColour
                                  .withOpacity(0.2),
                              border: Border.all(
                                color: themeProvider.themeManager.primaryColour,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add,
                                    color: themeProvider
                                        .themeManager.primaryColour),
                                const SizedBox(width: 5),
                                CustomText(
                                  'Create New Label',
                                  color:
                                      themeProvider.themeManager.primaryColour,
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              createNew = true;
                            });
                          },
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
