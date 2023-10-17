// ignore_for_file: use_build_context_synchronously


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/utils/extensions/string_extensions.dart';
import 'package:plane/widgets/custom_button.dart';
import 'package:plane/widgets/custom_text.dart';

class SelectIssueLabels extends ConsumerStatefulWidget {
  const SelectIssueLabels({this.issueId, required this.createIssue, super.key});
  final bool createIssue;
  final String? issueId;

  @override
  ConsumerState<SelectIssueLabels> createState() => _SelectIssueLabelsState();
}

class _SelectIssueLabelsState extends ConsumerState<SelectIssueLabels> {
  final labelContrtoller = TextEditingController();
  final colorController = TextEditingController();

  List issueDetailsLabels = [];
  bool createNew = false;
  final showColorPallette = true;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
    if (!widget.createIssue) getIssueLabels();
    });
    super.initState();
  }

  void getIssueLabels() {
    final issueProvider = ref.read(ProviderList.issueProvider);
    for (int i = 0;
        i < issueProvider.issueDetails['label_details'].length;
        i++) {
      issueDetailsLabels
          .add(issueProvider.issueDetails['label_details'][i]['id']);
    }
  }

  @override
  Widget build(BuildContext context) {
    final issuesProvider = ref.watch(ProviderList.issuesProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
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
                  child: issuesProvider.labels.isNotEmpty
                      ? ListView.builder(
                          itemCount: issuesProvider.labels.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                // setState(() {
                                  if (widget.createIssue) {
                                    if (issuesProvider.selectedLabels.contains(
                                        issuesProvider.labels[index])) {
                                      issuesProvider.selectedLabels
                                          .remove(issuesProvider.labels[index]);
                                    } else {
                                      issuesProvider.selectedLabels
                                          .add(issuesProvider.labels[index]);
                                    }
                                    final prov =
                                        ref.watch(ProviderList.issuesProvider);
                                    prov.createIssuedata['labels'] =
                                        issuesProvider.selectedLabels.isEmpty
                                            ? null
                                            : issuesProvider.selectedLabels;
                                    prov.setsState();
                                  } else {
                                    setState(() {
                                      if (issueDetailsLabels.contains(
                                          issuesProvider.labels[index]['id'])) {
                                        issueDetailsLabels.remove(
                                            issuesProvider.labels[index]['id']);
                                      } else {
                                        issueDetailsLabels.add(
                                            issuesProvider.labels[index]['id']);
                                      }
                                    });
                                  }
                                // });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                margin:
                                    issuesProvider.labels.length == index + 1
                                        ? const EdgeInsets.only(bottom: 35)
                                        : null,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 8,
                                          backgroundColor: issuesProvider
                                              .labels[index]['color']
                                              .toString()
                                              .toColor(),
                                        ),
                                        Container(width: 10),
                                        CustomText(
                                          issuesProvider.labels[index]['name']
                                              .toString(),
                                          type: FontStyle.Medium,
                                          fontWeight: FontWeightt.Regular,
                                          color: themeProvider
                                              .themeManager.primaryTextColor,
                                        ),
                                        const Spacer(),
                                        widget.createIssue
                                            ? createIssueSelectedIconsWidget(
                                                issuesProvider.labels[index])
                                            : issueDetailSelectedIconsWidget(
                                                index),
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
                widget.createIssue
                    ? const Column(
                        children: [
                          SizedBox(
                            height: 60,
                          )
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
          issuesProvider.labelState == StateEnum.loading
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
                              await issuesProvider.issueLabels(
                                  slug: ref
                                      .read(ProviderList.workspaceProvider)
                                      .selectedWorkspace
                                      .workspaceSlug,
                                  projID: widget.createIssue
                                      ? ref
                                          .read(ProviderList.issuesProvider)
                                          .createIssueProjectData['id']
                                      : ref
                                          .read(ProviderList.projectProvider)
                                          .currentProject['id'],
                                  data: {
                                    "name": labelContrtoller.text,
                                    "color": "#${colorController.text}"
                                  },
                                  ref: ref);
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

  Widget createIssueSelectedIconsWidget(Map<String, dynamic> data) {
    var issuesProvider = ref.watch(ProviderList.issuesProvider);
      return issuesProvider.selectedLabels.contains(data)
          ? const Icon(
              Icons.done,
              color: Color.fromRGBO(8, 171, 34, 1),
            )
          : const SizedBox.shrink();
  }

  Widget issueDetailSelectedIconsWidget(int idx) {
    final issuesProvider = ref.watch(ProviderList.issuesProvider);
    return issueDetailsLabels.contains(issuesProvider.labels[idx]['id'])
        ? const Icon(
            Icons.done,
            color: Color.fromRGBO(8, 171, 34, 1),
          )
        : const SizedBox();
  }
}
