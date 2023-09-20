// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane/utils/color_manager.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_button.dart';
import 'package:plane/widgets/custom_text.dart';

class SelectIssueLabels extends ConsumerStatefulWidget {
  final bool createIssue;
  final String? issueId;

  const SelectIssueLabels({this.issueId, required this.createIssue, super.key});

  @override
  ConsumerState<SelectIssueLabels> createState() => _SelectIssueLabelsState();
}

class _SelectIssueLabelsState extends ConsumerState<SelectIssueLabels> {
  var labelContrtoller = TextEditingController();
  var colorController = TextEditingController();

  var selectedLabels = [];
  List issueDetailsLabels = [];
  var createNew = false;
  var showColorPallette = true;
  @override
  void initState() {
    ref.read(ProviderList.issuesProvider).getLabels(
        slug: ref
            .read(ProviderList.workspaceProvider)
            .selectedWorkspace
            .workspaceSlug,
        projID: widget.createIssue
            ? ref.read(ProviderList.issuesProvider).createIssueProjectData['id']
            : ref.read(ProviderList.projectProvider).currentProject['id']);
    colorController.text =
        colorsForLabel[Random().nextInt(colorsForLabel.length)]
            .replaceAll('#', '');
    //.replaceAll('#F', '');
    // 'BC009E';

    selectedLabels.addAll(
        (ref.read(ProviderList.issuesProvider).createIssuedata['labels'] ?? [])
            .map((e) => e['index'])
            .toList());
    if (!widget.createIssue) getIssueLabels();

    super.initState();
  }

  getIssueLabels() {
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
    return WillPopScope(
      onWillPop: () async {
        var prov = ref.read(ProviderList.issuesProvider);
        prov.createIssuedata['labels'] = selectedLabels.isEmpty
            ? null
            : selectedLabels
                .map((e) => {
                      'id': issuesProvider.labels[e]['id'],
                      'color': issuesProvider.labels[e]['color'],
                      'index': e
                    })
                .toList();
        prov.setsState();
        return true;
      },
      child: Container(
        height: issuesProvider.labels.isNotEmpty
            ? MediaQuery.of(context).size.height * 0.8
            : MediaQuery.of(context).size.height * 0.5,
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
                          var prov = ref.read(ProviderList.issuesProvider);
                          prov.createIssuedata['labels'] =
                              selectedLabels.isEmpty
                                  ? null
                                  : selectedLabels
                                      .map((e) => {
                                            'id': issuesProvider.labels[e]
                                                ['id'],
                                            'color': issuesProvider.labels[e]
                                                ['color'],
                                            'index': e
                                          })
                                      .toList();
                          prov.setsState();
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close,
                          color:
                              themeProvider.themeManager.placeholderTextColor,
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
                                  setState(() {
                                    if (widget.createIssue) {
                                      if (selectedLabels.contains(index)) {
                                        selectedLabels.remove(index);
                                      } else {
                                        selectedLabels.add(index);
                                      }
                                      var prov =
                                          ref.read(ProviderList.issuesProvider);
                                      prov.createIssuedata['labels'] =
                                          selectedLabels.isEmpty
                                              ? null
                                              : selectedLabels
                                                  .map((e) => {
                                                        'id': issuesProvider
                                                            .labels[e]['id'],
                                                        'color': issuesProvider
                                                            .labels[e]['color'],
                                                        'index': e
                                                      })
                                                  .toList();
                                      prov.setsState();
                                    } else {
                                      setState(() {
                                        if (issueDetailsLabels.contains(
                                            issuesProvider.labels[index]
                                                ['id'])) {
                                          issueDetailsLabels.remove(
                                              issuesProvider.labels[index]
                                                  ['id']);
                                        } else {
                                          issueDetailsLabels.add(issuesProvider
                                              .labels[index]['id']);
                                        }
                                      });
                                    }
                                  });
                                },
                                child: Container(
                                  //height: 40,
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
                                            backgroundColor: ColorManager
                                                .getColorFromHexaDecimal(
                                                    issuesProvider.labels[index]
                                                            ['color']
                                                        .toString()),
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
                                                  index)
                                              : issueDetailSelectedIconsWidget(
                                                  index),
                                          const SizedBox(width: 10)
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Container(
                                          height: 1,
                                          // margin: const EdgeInsets.only(bottom: 5),
                                          color: themeProvider
                                              .themeManager.borderSubtle01Color)
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
                                    // padding: EdgeInsets.all(5),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 7, vertical: 5),
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                      color:
                                          ColorManager.getColorFromHexaDecimal(
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
                                            colorController.text = e
                                                .toString()
                                                .replaceAll('#', '');
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
                                        onChanged: (value) {
                                          setState(() {});
                                        },
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                              RegExp("[0-9a-zA-Z]")),
                                        ],
                                        controller: colorController,
                                        decoration: themeProvider
                                            .themeManager.textFieldDecoration
                                            .copyWith(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 3,
                                                color: themeProvider
                                                    .themeManager
                                                    .primaryBackgroundSelectedColour), //<-- SEE HERE
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 3,
                                                color: themeProvider
                                                    .themeManager
                                                    .primaryBackgroundSelectedColour),
                                          ),
                                          filled: true,
                                          fillColor: themeProvider.themeManager
                                              .secondaryBackgroundDefaultColor,
                                          prefixIcon: Container(
                                            margin: const EdgeInsets.only(
                                                right: 10),
                                            width: 55,
                                            height: 55,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: themeProvider
                                                    .themeManager
                                                    .primaryBackgroundSelectedColour,
                                                borderRadius: const BorderRadius
                                                        .only(
                                                    topLeft: Radius.circular(5),
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

                      // height: 25,
                      // width: 25,
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
                              if (labelContrtoller.text.isNotEmpty) {
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
                                  // showColorPallette = false;
                                  colorController.clear();
                                  labelContrtoller.clear();
                                });
                                // Navigator.of(context).pop();
                              } else {
                                CustomToast.showToast(context,
                                    message: 'Label is empty',
                                    toastType: ToastType.warning);
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
                                  color:
                                      themeProvider.themeManager.primaryColour,
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
                                    color: themeProvider
                                        .themeManager.primaryColour,
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
      ),
    );
  }

  Widget createIssueSelectedIconsWidget(int idx) {
    return selectedLabels.contains(idx)
        ? const Icon(
            Icons.done,
            color: Color.fromRGBO(8, 171, 34, 1),
          )
        : const SizedBox();
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
