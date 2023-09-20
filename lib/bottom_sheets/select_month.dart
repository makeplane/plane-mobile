import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/widgets/custom_button.dart';
import 'package:plane/widgets/custom_text.dart';

import '../utils/enums.dart';

class SelectMonthSheet extends ConsumerStatefulWidget {
  final bool isCloseIn;
  const SelectMonthSheet({super.key, required this.isCloseIn});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectMonthSheetState();
}

class _SelectMonthSheetState extends ConsumerState<SelectMonthSheet> {
  List durations = [
    {'val': 1, 'text': '1 Month'},
    {'val': 3, 'text': '3 Months'},
    {'val': 6, 'text': '6 Months'},
    {'val': 9, 'text': '9 Months'},
    {'val': 12, 'text': '12 Months'},
    {'val': -1, 'text': 'Custom Time Range'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.isCloseIn) {
      bool found = false;
      for (int i = 0; i < durations.length; i++) {
        if (durations[i]['val'] ==
            ref.read(ProviderList.projectProvider).currentProject['close_in']) {
          found = true;
          selectedIdx = i;
          break;
        }
      }
      if (!found) {
        selectedIdx = 5;
        custom.text = ref
            .read(ProviderList.projectProvider)
            .currentProject['close_in']
            .toString();
      }
    } else {
      bool found = false;
      for (int i = 0; i < durations.length; i++) {
        if (durations[i]['val'] ==
            ref
                .read(ProviderList.projectProvider)
                .currentProject['archive_in']) {
          found = true;
          selectedIdx = i;
          break;
        }
      }
      if (!found) {
        selectedIdx = 5;
        custom.text = ref
            .read(ProviderList.projectProvider)
            .currentProject['archive_in']
            .toString();
      }
    }
  }

  int selectedIdx = 0;

  final TextEditingController custom = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    return Padding(
      padding: EdgeInsets.only(
          top: 23,
          left: 23,
          right: 23,
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Wrap(
          children: [
            Row(
              children: [
                const CustomText(
                  'Select Duration',
                  type: FontStyle.H6,
                  fontWeight: FontWeightt.Semibold,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    size: 27,
                    color: themeProvider.themeManager.placeholderTextColor,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),

            //list of durations
            ListView.separated(
              itemCount: durations.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  height: 50,
                  width: double.infinity,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedIdx = index;
                      });
                    },
                    child: Row(
                      children: [
                        //radio button
                        Radio(
                          value: index,
                          groupValue: selectedIdx,
                          visualDensity: const VisualDensity(
                            horizontal: VisualDensity.minimumDensity,
                            vertical: VisualDensity.minimumDensity,
                          ),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          fillColor: selectedIdx == index
                              ? null
                              : MaterialStateProperty.all<Color>(
                                  themeProvider
                                      .themeManager.borderSubtle01Color,
                                ),
                          onChanged: (value) {
                            setState(() {
                              selectedIdx = value as int;
                            });
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        CustomText(
                          durations[index]['text'],
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 1,
                  width: double.infinity,
                  child: Container(
                    color: themeProvider.themeManager.borderSubtle01Color,
                  ),
                );
              },
            ),

            selectedIdx == 5
                ?
                //text field
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: TextField(
                      decoration: themeProvider.themeManager.textFieldDecoration
                          .copyWith(
                              suffixIcon: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        child: CustomText(
                          'Months   ',
                          color: themeProvider.themeManager.tertiaryTextColor,
                        ),
                      )),
                      controller: custom,
                      keyboardType: TextInputType.number,

                      //restricting to only numbers
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  )
                : const SizedBox.shrink(),

            Container(
              height: 20,
            ),
            Button(
                text: 'Submit',
                ontap: () {
                  if (selectedIdx != 5) {
                    if (widget.isCloseIn) {
                      projectProvider.currentProject['close_in'] =
                          durations[selectedIdx]['val'];
                    } else {
                      projectProvider.currentProject['archive_in'] =
                          durations[selectedIdx]['val'];
                    }
                    projectProvider.setState();
                    projectProvider.updateProject(
                      slug: ref
                          .read(ProviderList.workspaceProvider)
                          .selectedWorkspace
                          .workspaceSlug,
                      projId: ref
                          .read(ProviderList.projectProvider)
                          .currentProject['id'],
                      ref: ref,
                      data: widget.isCloseIn
                          ? {
                              'close_in': durations[selectedIdx]['val'],
                            }
                          : {
                              'archive_in': durations[selectedIdx]['val'],
                            },
                    );
                  } else {
                    if (custom.text.trim().isEmpty) {
                      CustomToast.showToast(context,
                          message: 'Invalid duration',
                          toastType: ToastType.warning);
                      return;
                    }
                    if (int.parse(custom.text.trim()) <= 0) {
                      CustomToast.showToast(context,
                          message: 'Duration must be greater than 0',
                          toastType: ToastType.warning);
                      return;
                    }

                    if (int.parse(custom.text.trim()) > 12) {
                      CustomToast.showToast(context,
                          message: 'Duration must be less than 12 months',
                          toastType: ToastType.warning);
                      return;
                    }

                    if (widget.isCloseIn) {
                      projectProvider.currentProject['close_in'] =
                          int.parse(custom.text);
                    } else {
                      projectProvider.currentProject['archive_in'] =
                          int.parse(custom.text);
                    }
                    projectProvider.setState();
                    projectProvider.updateProject(
                      slug: ref
                          .read(ProviderList.workspaceProvider)
                          .selectedWorkspace
                          .workspaceSlug,
                      projId: ref
                          .read(ProviderList.projectProvider)
                          .currentProject['id'],
                      ref: ref,
                      data: widget.isCloseIn
                          ? {
                              'close_in': int.parse(custom.text),
                            }
                          : {
                              'archive_in': int.parse(custom.text),
                            },
                    );
                  }
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }
}
