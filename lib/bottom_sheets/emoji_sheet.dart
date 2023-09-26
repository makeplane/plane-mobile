import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/constants.dart';

import 'package:plane/widgets/custom_text.dart';

import '../utils/enums.dart';

class EmojiSheet extends ConsumerStatefulWidget {
  const EmojiSheet({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EmojiSheetState();
}

class _EmojiSheetState extends ConsumerState<EmojiSheet> {
  int selected = 0;
  String selectedEmoji = '';
  String selectedIcon = '';
  bool showEMOJI = false;
  bool showColor = false;
  List<String> emojisWidgets = [];
  generateEmojis() {
    for (int i = 0; i < emojis.length; i++) {
      setState(() {
        emojisWidgets.add(emojis[i]);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    generateEmojis();
    colorController.text = colorsForLabel[0].toString().replaceAll('#', '');
  }

  final TextEditingController colorController = TextEditingController();
  String selectedColor = '#3A3A3A';

  List<String> topColors = [
    "#ff6b00",
    "#8cc1ff",
    "#fcbe1d",
    "#18904f",
    "#adf672",
    "#05c3ff",
    "#000000",
  ];

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        showColor = false;
        setState(() {});
      },
      child: Stack(
        children: [
          ListView(
            shrinkWrap: true,

            // physics: NeverScrollableScrollPhysics(),
            children: [
              const SizedBox(
                height: 105,
              ),
              selected == 0
                  ? Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 6,
                      runSpacing: 6,
                      children: emojisWidgets
                          .map(
                            (e) => InkWell(
                              onTap: () {
                                setState(() {
                                  selectedEmoji = e;
                                });
                                Navigator.pop(context,
                                    {'name': selectedEmoji, 'is_emoji': true});
                              },
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: Center(
                                  child: CustomText(
                                    String.fromCharCode(int.parse(e)),
                                    type: FontStyle.H4,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    )
                  : Container(),
              selected == 1
                  ? Container(
                      margin: const EdgeInsets.only(bottom: 10, top: 10),
                      height: 25,
                      //row containing 8 circles containing different colors
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ...topColors.map((e) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedColor = e;
                                });
                              },
                              child: Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                  color: Color(int.parse(
                                      "FF${e.toString().toUpperCase().replaceAll("#", "")}",
                                      radix: 16)),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            );
                          }).toList(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                showColor = !showColor;
                              });
                            },
                            child: Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                //gradient kind of a pie chart
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.yellow,
                                    Colors.red,
                                    Colors.green,
                                    Colors.blue,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              selected == 1
                  ? Center(
                      child: Stack(
                        children: [
                          Center(
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 6,
                              runSpacing: 6,
                              children: iconList.keys
                                  .map(
                                    (e) => InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedIcon = e;
                                        });
                                        Navigator.pop(context, {
                                          'name': selectedIcon,
                                          'is_emoji': false,
                                          'color': selectedColor
                                        });
                                      },
                                      child: SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: Center(
                                          child: Icon(
                                            iconList[e],
                                            color: Color(int.parse(
                                                "FF${selectedColor.toString().toUpperCase().replaceAll("#", "")}",
                                                radix: 16)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          showColor
                              ? Card(
                                  color: themeProvider.themeManager
                                      .secondaryBackgroundDefaultColor,
                                  margin: const EdgeInsets.only(
                                      right: 15, left: 15, bottom: 15),
                                  elevation: 10,
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 10, right: 10, top: 15),
                                        child: Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.start,
                                          alignment: WrapAlignment.start,
                                          runAlignment: WrapAlignment.start,
                                          spacing: 5,
                                          children: colorsForLabel
                                              .map(
                                                (e) => GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      colorController.text = e
                                                          .toString()
                                                          .toUpperCase()
                                                          .replaceAll("#", "");
                                                      selectedColor = e;
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 50,
                                                    width: 50,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 20),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    decoration: BoxDecoration(
                                                      color: Color(int.parse(
                                                          "FF${e.toString().toUpperCase().replaceAll("#", "")}",
                                                          radix: 16)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          blurRadius: 1.0,
                                                          color: greyColor,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 15, right: 15, bottom: 15),
                                        // height: 50,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 55,
                                              height: 50,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: int.tryParse("FF${colorController.text.toString().toUpperCase().replaceAll("#", "FF")}", radix: 16) == null ||
                                                          colorController.text
                                                              .trim()
                                                              .isEmpty
                                                      ? Color(int.parse(
                                                          colorsForLabel[0]
                                                              .toUpperCase()
                                                              .replaceAll(
                                                                  "#", "FF"),
                                                          radix: 16))
                                                      : Color(int.parse("FF${colorController.text.toString().toUpperCase().replaceAll("#", "")}",
                                                          radix: 16)),
                                                  borderRadius: const BorderRadius.only(
                                                      topLeft: Radius.circular(8),
                                                      bottomLeft: Radius.circular(8))),
                                              child: const CustomText(
                                                '#',
                                                color: Colors.white,
                                                fontWeight:
                                                    FontWeightt.Semibold,
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
                                                  colorController.text =
                                                      val.toUpperCase();
                                                  colorController.selection =
                                                      TextSelection.fromPosition(
                                                          TextPosition(
                                                              offset:
                                                                  colorController
                                                                      .text
                                                                      .length));

                                                  if (val.length == 6) {
                                                    if (int.tryParse(
                                                                "FF${colorController.text.toString().toUpperCase().replaceAll("#", "FF")}",
                                                                radix: 16) ==
                                                            null ||
                                                        colorController.text
                                                            .trim()
                                                            .isEmpty) {
                                                    } else {
                                                      selectedColor =
                                                          '#${colorController.text.toString()}';
                                                    }
                                                  }

                                                  setState(() {});
                                                },
                                                decoration: themeProvider
                                                    .themeManager
                                                    .textFieldDecoration
                                                    .copyWith(
                                                  counterText: '',
                                                  errorStyle: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Colors.red.shade600,
                                                        width: 1.0),
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(6),
                                                      bottomRight:
                                                          Radius.circular(6),
                                                    ),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Colors.red.shade600,
                                                        width: 2.0),
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(6),
                                                      bottomRight:
                                                          Radius.circular(6),
                                                    ),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: themeProvider
                                                            .themeManager
                                                            .borderSubtle01Color,
                                                        width: 1.0),
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(6),
                                                      bottomRight:
                                                          Radius.circular(6),
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: themeProvider
                                                            .themeManager
                                                            .borderSubtle01Color,
                                                        width: 1.0),
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(6),
                                                      bottomRight:
                                                          Radius.circular(6),
                                                    ),
                                                  ),
                                                  fillColor: themeProvider
                                                      .themeManager
                                                      .secondaryBackgroundActiveColor,
                                                  filled: true,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: themeProvider.themeManager.secondaryBackgroundDefaultColor,
            ),

            // height: 80,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: CustomText(
                        'Choose your project icon',
                        type: FontStyle.H4,
                        fontWeight: FontWeightt.Semibold,
                        color: themeProvider.themeManager.primaryTextColor,
                      ),
                    ),
                    // const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close,
                          size: 27,
                          color:
                              themeProvider.themeManager.placeholderTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selected = 0;
                          });
                        },
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: CustomText(
                                    'Emojis',
                                    color: selected == 0
                                        ? themeProvider
                                            .themeManager.primaryColour
                                        : themeProvider
                                            .themeManager.placeholderTextColor,
                                    type: FontStyle.H5,
                                    overrride: true,
                                  ),
                                ),
                              ],
                            ),
                            selected == 0
                                ? Container(
                                    height: 2,
                                    decoration: BoxDecoration(
                                        color: themeProvider
                                            .themeManager.primaryColour,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  )
                                : Container(
                                    height: 4,
                                  )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selected = 1;
                          });
                        },
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: CustomText(
                                    overrride: true,
                                    'Icons',
                                    color: selected == 1
                                        ? themeProvider
                                            .themeManager.primaryColour
                                        : themeProvider
                                            .themeManager.placeholderTextColor,
                                    type: FontStyle.H5,
                                  ),
                                ),
                              ],
                            ),
                            selected == 1
                                ? Container(
                                    height: 2,
                                    decoration: BoxDecoration(
                                        color: themeProvider
                                            .themeManager.primaryColour,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  )
                                : Container(
                                    height: 4,
                                  )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: themeProvider.themeManager.borderDisabledColor,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
