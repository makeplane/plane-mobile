import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/core/extensions/string_extensions.dart';
import 'package:plane/widgets/custom_button.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/widgets/custom_text.dart';

class CreateLabel extends ConsumerStatefulWidget {
  const CreateLabel(
      {this.label,
      this.labelColor,
      required this.method,
      this.labelId,
      super.key});
  final String? label;
  final String? labelColor;
  final CRUD method;
  final String? labelId;

  @override
  ConsumerState<CreateLabel> createState() => _CreateLabelState();
}

class _CreateLabelState extends ConsumerState<CreateLabel> {
  TextEditingController lableController = TextEditingController();
  final colorController = TextEditingController();
  bool showColoredBox = false;

  @override
  void initState() {
    super.initState();
    lableController.text = widget.label ?? '';
    colorController.text =
        (widget.labelColor != '' && widget.labelColor != null)
            ? widget.labelColor!.replaceAll('#', '')
            : colorsForLabel[Random().nextInt(colorsForLabel.length)]
                .replaceAll('#', '');
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final labelNotifier = ref.read(ProviderList.labelProvider.notifier);
    return GestureDetector(
      onTap: () {
        setState(() {
          showColoredBox = false;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Wrap(
                children: [
                  Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          children: [
                            const SizedBox(height: 60),
                            TextField(
                              controller: lableController,
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
                                      controller: colorController,
                                      onChanged: (value) {
                                        if (value.length == 6 &&
                                            value.contains(
                                                RegExp("[^0-9a-fA-F]"))) {
                                          CustomToast.showToast(context,
                                              message: 'HexCode is not valid',
                                              toastType: ToastType.warning);
                                        }

                                        setState(() {});
                                      },
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
                      ),
                      Container(
                        height: 10,
                      ),
                    ],
                  ),
                  Container(
                    height: 20,
                  ),
                  Button(
                    text: widget.method == CRUD.update
                        ? 'Update Label'
                        : 'Add Label',
                    ontap: () {
                      if (lableController.text.trim() == '') {
                        CustomToast.showToast(context,
                            message: "Label is empty",
                            toastType: ToastType.failure);
                      } else if (colorController.text.length != 6) {
                        CustomToast.showToast(context,
                            message: "Color is not valid",
                            toastType: ToastType.failure);
                      } else {
                        if (widget.method == CRUD.update) {
                          labelNotifier.updateLabel({
                            "id": widget.labelId,
                            "name": lableController.text,
                            "color": '#${colorController.text}',
                          });
                        } else if (widget.method == CRUD.create) {
                          labelNotifier.createLabel({
                            "name": lableController.text,
                            "color": '#${colorController.text}',
                          });
                        }
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            ),
            Container(
              color: themeProvider.themeManager.primaryBackgroundDefaultColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    widget.method == CRUD.update ? ' Edit Label' : 'Add Label',
                    type: FontStyle.H6,
                    fontWeight: FontWeightt.Semibold,
                    fontSize: 22,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close,
                      color: themeProvider.themeManager.placeholderTextColor,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
