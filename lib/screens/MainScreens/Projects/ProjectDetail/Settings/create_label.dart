import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/utils/color_manager.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/widgets/custom_button.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/widgets/custom_text.dart';

class CreateLabel extends ConsumerStatefulWidget {
  final String? label;
  final String? labelColor;
  final CRUD method;
  final String? labelId;
  const CreateLabel(
      {this.label,
      this.labelColor,
      required this.method,
      this.labelId,
      super.key});

  @override
  ConsumerState<CreateLabel> createState() => _CreateLabelState();
}

class _CreateLabelState extends ConsumerState<CreateLabel> {
  TextEditingController lableController = TextEditingController();
  var colorController = TextEditingController();
  //String lable = '';
  // List colors = [
  //   '#FF6900',
  //   '#FCB900',
  //   '#7BDCB5',
  //   '#00D084',
  //   '#8ED1FC',
  //   '#0693E3',
  //   '#ABB8C3',
  //   '#EB144C',
  //   '#F78DA7',
  //   '#9900EF'
  // ];
  bool showColoredBox = false;

  @override
  void initState() {
    super.initState();
    lableController.text = widget.label ?? '';
    // lable = widget.labelColor ??
    //     colorsForLabel[Random().nextInt(colorsForLabel.length)];
    colorController.text =
        colorsForLabel[Random().nextInt(colorsForLabel.length)]
            .replaceAll('#', '');
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var issuesProvider = ref.read(ProviderList.issuesProvider);
    return GestureDetector(
      onTap: () {
        setState(() {
          showColoredBox = false;
        });
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: SingleChildScrollView(
              child: Wrap(
                //  crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    //  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            widget.method == CRUD.update
                                ? ' Edit Label'
                                : 'Add Label',
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
                              color: themeProvider
                                  .themeManager.placeholderTextColor,
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            TextField(
                              controller: lableController,
                              decoration: themeProvider
                                  .themeManager.textFieldDecoration
                                  .copyWith(
                                label: const Text('Label Text'),
                                prefixIconConstraints: const BoxConstraints(
                                    minWidth: 0, minHeight: 0),
                                prefixIcon: Container(
                                  // padding: EdgeInsets.all(5),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 5),
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                    color: ColorManager.getColorFromHexaDecimal(
                                        '#${colorController.text}'),
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
                                          // .toUpperCase()
                                          // .replaceAll("#", "");
                                        });
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: ColorManager
                                              .getColorFromHexaDecimal(
                                                  e.toString()),
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
                              height: 50,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[0-9a-zA-Z]")),
                                      ],
                                      controller: colorController,
                                      onChanged: (value) {
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
                      } else {
                        issuesProvider.issueLabels(
                            slug: ref
                                .watch(ProviderList.workspaceProvider)
                                .selectedWorkspace!
                                .workspaceSlug,
                            projID: ref
                                .watch(ProviderList.projectProvider)
                                .currentProject['id'],
                            method: widget.method,
                            data: {
                              "name": lableController.text,
                              "color": '#${colorController.text}',
                            },
                            labelId: widget.labelId,
                            ref: ref);
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
