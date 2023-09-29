import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane/bottom_sheets/delete_labels_sheet.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/Settings/create_label.dart';
import 'package:plane/utils/color_manager.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/provider/provider_list.dart';

import 'package:plane/widgets/empty.dart';
import 'package:plane/widgets/loading_widget.dart';
import 'package:plane/widgets/custom_text.dart';

class LablesPage extends ConsumerStatefulWidget {
  const LablesPage({super.key});

  @override
  ConsumerState<LablesPage> createState() => _LablesPageState();
}

class _LablesPageState extends ConsumerState<LablesPage> {
  List expanded = [];
  bool isChildAvailable(String id) {
    final issuesProv = ref.read(ProviderList.issuesProvider);
    for (final element in issuesProv.labels) {
      if (element["parent"] == id) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final issuesProvider = ref.watch(ProviderList.issuesProvider);
    return LoadingWidget(
      loading: issuesProvider.labelState == StateEnum.loading,
      widgetClass: Container(
        color: themeProvider.themeManager.primaryBackgroundDefaultColor,
        child: issuesProvider.labels.isEmpty
            ? EmptyPlaceholder.emptyLabels(context, ref)
            : ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemCount: issuesProvider.labels.length,
                itemBuilder: (context, index) {
                  final isChildAvail =
                      isChildAvailable(issuesProvider.labels[index]["id"]);
                  return issuesProvider.labels[index]["parent"] == null
                      ? Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                              color: themeProvider
                                  .themeManager.primaryBackgroundDefaultColor,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: themeProvider
                                      .themeManager.borderSubtle01Color)),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 0),
                                padding: const EdgeInsets.only(
                                    left: 10, top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        !isChildAvail
                                            ? CircleAvatar(
                                                radius: 6,
                                                backgroundColor: ColorManager
                                                    .getColorFromHexaDecimal(
                                                        issuesProvider
                                                                .labels[index]
                                                            ['color']),
                                              )
                                            : SvgPicture.asset(
                                                "assets/svg_images/label_group.svg",
                                                colorFilter: ColorFilter.mode(
                                                    ColorManager
                                                        .getColorFromHexaDecimal(
                                                            issuesProvider
                                                                .labels[index]
                                                                    ['color']
                                                                .toString()),
                                                    BlendMode.srcIn),
                                              ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        LimitedBox(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: CustomText(
                                            issuesProvider.labels[index]
                                                ['name'],
                                            type: FontStyle.H5,
                                            maxLines: 1,
                                            color: themeProvider
                                                .themeManager.primaryTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        PopupMenuButton(
                                          icon: Icon(
                                            Icons.edit_outlined,
                                            color: themeProvider.themeManager
                                                .placeholderTextColor,
                                          ),
                                          color: themeProvider.themeManager
                                              .tertiaryBackgroundDefaultColor,
                                          onSelected: (val) {
                                            if (val == 'EDIT') {
                                              showModalBottomSheet(
                                                enableDrag: true,
                                                isScrollControlled: true,
                                                constraints: BoxConstraints(
                                                  maxHeight:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.8,
                                                ),
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    topRight:
                                                        Radius.circular(20),
                                                  ),
                                                ),
                                                context: context,
                                                builder: (context) {
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: MediaQuery.of(
                                                                context)
                                                            .viewInsets
                                                            .bottom),
                                                    child: CreateLabel(
                                                      label: issuesProvider
                                                              .labels[index]
                                                          ['name'],
                                                      labelColor: issuesProvider
                                                              .labels[index]
                                                          ['color'],
                                                      labelId: issuesProvider
                                                          .labels[index]['id'],
                                                      method: CRUD.update,
                                                    ),
                                                  );
                                                },
                                              );
                                            } else if (val == 'CONVERT' ||
                                                val == 'ADD') {
                                              showModalBottomSheet(
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        MediaQuery.sizeOf(
                                                                    context)
                                                                .height *
                                                            0.8),
                                                enableDrag: true,
                                                isScrollControlled: true,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    topRight:
                                                        Radius.circular(20),
                                                  ),
                                                ),
                                                context: context,
                                                builder: (context) {
                                                  return SingleLabelSelect(
                                                    labelID: issuesProvider
                                                        .labels[index]["id"],
                                                  );
                                                },
                                              );
                                            } else {
                                              showModalBottomSheet(
                                                constraints:
                                                    const BoxConstraints(
                                                        maxHeight: 300),
                                                enableDrag: true,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    topRight:
                                                        Radius.circular(20),
                                                  ),
                                                ),
                                                context: context,
                                                builder: (context) {
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: MediaQuery.of(
                                                                context)
                                                            .viewInsets
                                                            .bottom),
                                                    child: DeleteLabelSheet(
                                                      labelName: issuesProvider
                                                              .labels[index]
                                                          ['name'],
                                                      labelId: issuesProvider
                                                          .labels[index]['id'],
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          itemBuilder: (ctx) => [
                                            PopupMenuItem(
                                              value: 'CONVERT',
                                              child: Row(
                                                children: [
                                                  isChildAvail
                                                      ? Icon(
                                                          Icons.add,
                                                          size: 19,
                                                          color: themeProvider
                                                              .themeManager
                                                              .secondaryTextColor,
                                                        )
                                                      : SvgPicture.asset(
                                                          "assets/svg_images/label_group.svg",
                                                          colorFilter:
                                                              ColorFilter.mode(
                                                                  themeProvider
                                                                      .themeManager
                                                                      .secondaryTextColor,
                                                                  BlendMode
                                                                      .srcIn),
                                                        ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  CustomText(
                                                    isChildAvail
                                                        ? 'Add more labels'
                                                        : 'Convert to group',
                                                    color: themeProvider
                                                        .themeManager
                                                        .secondaryTextColor,
                                                  )
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 'EDIT',
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.edit,
                                                    size: 19,
                                                    color: themeProvider
                                                        .themeManager
                                                        .secondaryTextColor,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  CustomText(
                                                    'Edit Label',
                                                    color: themeProvider
                                                        .themeManager
                                                        .secondaryTextColor,
                                                  )
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 'DELETE',
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.delete,
                                                    size: 19,
                                                    color: themeProvider
                                                        .themeManager
                                                        .secondaryTextColor,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  CustomText(
                                                    'Delete Label',
                                                    color: themeProvider
                                                        .themeManager
                                                        .secondaryTextColor,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        !isChildAvail
                                            ? Container()
                                            : Container(
                                                margin: const EdgeInsets.only(
                                                    right: 5),
                                                child: GestureDetector(
                                                    onTap: () {
                                                      if (expanded
                                                          .contains(index)) {
                                                        expanded.remove(index);
                                                      } else {
                                                        expanded.add(index);
                                                      }
                                                      setState(() {});
                                                    },
                                                    child:
                                                        expanded.contains(index)
                                                            ? Icon(
                                                                Icons
                                                                    .keyboard_arrow_up,
                                                                color: themeProvider
                                                                    .themeManager
                                                                    .secondaryTextColor,
                                                              )
                                                            : Icon(
                                                                Icons
                                                                    .keyboard_arrow_down_outlined,
                                                                color: themeProvider
                                                                    .themeManager
                                                                    .secondaryTextColor,
                                                              )),
                                              ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Column(
                                  children: expanded.contains(index)
                                      ? issuesProvider.labels.map(
                                          (e) {
                                            return e["parent"] ==
                                                    issuesProvider.labels[index]
                                                        ["id"]
                                                ? Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 15,
                                                            left: 15,
                                                            right: 15),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10,
                                                            top: 5,
                                                            bottom: 5),
                                                    decoration: BoxDecoration(
                                                        color: themeProvider
                                                            .themeManager
                                                            .primaryBackgroundDefaultColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        border: Border.all(
                                                            color: themeProvider
                                                                .themeManager
                                                                .borderSubtle01Color)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            CircleAvatar(
                                                              radius: 6,
                                                              backgroundColor: ColorManager
                                                                  .getColorFromHexaDecimal(
                                                                      e['color']
                                                                          .toString()),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            CustomText(
                                                              e['name'],
                                                              type: FontStyle
                                                                  .Medium,
                                                              maxLines: 3,
                                                            ),
                                                          ],
                                                        ),
                                                        PopupMenuButton(
                                                          icon: Icon(
                                                            Icons.more_vert,
                                                            color: themeProvider
                                                                .themeManager
                                                                .placeholderTextColor,
                                                          ),
                                                          color: themeProvider
                                                              .themeManager
                                                              .tertiaryBackgroundDefaultColor,
                                                          onSelected: (val) {
                                                            if (val == 'EDIT') {
                                                              showModalBottomSheet(
                                                                enableDrag:
                                                                    true,
                                                                isScrollControlled:
                                                                    true,
                                                                constraints:
                                                                    BoxConstraints(
                                                                  maxHeight: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.8,
                                                                ),
                                                                shape:
                                                                    const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            20),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            20),
                                                                  ),
                                                                ),
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return Padding(
                                                                    padding: EdgeInsets.only(
                                                                        bottom: MediaQuery.of(context)
                                                                            .viewInsets
                                                                            .bottom),
                                                                    child:
                                                                        CreateLabel(
                                                                      label: e[
                                                                          'name'],
                                                                      labelColor:
                                                                          e['color'],
                                                                      labelId: e[
                                                                          'id'],
                                                                      method: CRUD
                                                                          .update,
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            } else if (val ==
                                                                'CONVERT') {
                                                              issuesProvider
                                                                  .issueLabels(
                                                                      slug: ref
                                                                          .watch(ProviderList
                                                                              .workspaceProvider)
                                                                          .selectedWorkspace
                                                                          .workspaceSlug,
                                                                      projID: ref
                                                                              .watch(ProviderList
                                                                                  .projectProvider)
                                                                              .currentProject[
                                                                          'id'],
                                                                      method: CRUD
                                                                          .update,
                                                                      data: {
                                                                        "parent":
                                                                            null,
                                                                      },
                                                                      labelId: e[
                                                                          "id"],
                                                                      ref: ref);
                                                            } else {
                                                              showModalBottomSheet(
                                                                constraints:
                                                                    const BoxConstraints(
                                                                        maxHeight:
                                                                            300),
                                                                enableDrag:
                                                                    true,
                                                                shape:
                                                                    const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            20),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            20),
                                                                  ),
                                                                ),
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return Padding(
                                                                    padding: EdgeInsets.only(
                                                                        bottom: MediaQuery.of(context)
                                                                            .viewInsets
                                                                            .bottom),
                                                                    child:
                                                                        DeleteLabelSheet(
                                                                      labelName:
                                                                          e['name'],
                                                                      labelId: e[
                                                                          'id'],
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            }
                                                          },
                                                          itemBuilder: (ctx) =>
                                                              [
                                                            PopupMenuItem(
                                                              value: 'CONVERT',
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons.close,
                                                                    size: 19,
                                                                    color: themeProvider
                                                                        .themeManager
                                                                        .secondaryTextColor,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  CustomText(
                                                                    'Remove from group',
                                                                    color: themeProvider
                                                                        .themeManager
                                                                        .secondaryTextColor,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            PopupMenuItem(
                                                              value: 'EDIT',
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons.edit,
                                                                    size: 19,
                                                                    color: themeProvider
                                                                        .themeManager
                                                                        .secondaryTextColor,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  CustomText(
                                                                    'Edit Label',
                                                                    color: themeProvider
                                                                        .themeManager
                                                                        .secondaryTextColor,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            PopupMenuItem(
                                                              value: 'DELETE',
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .delete,
                                                                    size: 19,
                                                                    color: themeProvider
                                                                        .themeManager
                                                                        .secondaryTextColor,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  CustomText(
                                                                    'Delete Label',
                                                                    color: themeProvider
                                                                        .themeManager
                                                                        .secondaryTextColor,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Container();
                                          },
                                        ).toList()
                                      : [])
                            ],
                          ),
                        )
                      : Container();
                },
              ),
      ),
    );
  }
}

class SingleLabelSelect extends ConsumerStatefulWidget {
  const SingleLabelSelect({required this.labelID, super.key});
  final String labelID;
  @override
  ConsumerState<SingleLabelSelect> createState() => _SingleLabelSelectState();
}

class _SingleLabelSelectState extends ConsumerState<SingleLabelSelect> {
  double height = 0.0;
  bool isChildAvailable(String id) {
    final issuesProv = ref.read(ProviderList.issuesProvider);
    for (final element in issuesProv.labels) {
      if (element["parent"] == id) return true;
    }
    return false;
  }

  bool isLabelsAvailable({int index = 0, bool iterate = false}) {
    final issuesProvider = ref.read(ProviderList.issuesProvider);
    if (iterate) {
      for (final element in issuesProvider.labels) {
        if (!(element["id"] == widget.labelID ||
            element["parent"] == widget.labelID ||
            element["parent"] != null ||
            isChildAvailable(element["id"]))) return false;
      }
      return true;
    }
    return issuesProvider.labels[index]["id"] == widget.labelID ||
        issuesProvider.labels[index]["parent"] == widget.labelID ||
        issuesProvider.labels[index]["parent"] != null ||
        isChildAvailable(issuesProvider.labels[index]["id"]);
  }

  @override
  Widget build(BuildContext context) {
    final issuesProvider = ref.watch(ProviderList.issuesProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final box = context.findRenderObject() as RenderBox;
      height = box.size.height;
    });
    return Container(
      decoration: BoxDecoration(
        color: themeProvider.themeManager.primaryBackgroundDefaultColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      width: double.infinity,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Wrap(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                      'Select Labels',
                      type: FontStyle.H6,
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
                isLabelsAvailable(iterate: true)
                    ? EmptyPlaceholder.emptyLabels(context, ref)
                    : ListView.builder(
                        itemCount: issuesProvider.labels.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return isLabelsAvailable(index: index)
                              ? Container()
                              : InkWell(
                                  onTap: () {
                                    issuesProvider.issueLabels(
                                        slug: ref
                                            .watch(
                                                ProviderList.workspaceProvider)
                                            .selectedWorkspace
                                            .workspaceSlug,
                                        projID: ref
                                            .watch(ProviderList.projectProvider)
                                            .currentProject['id'],
                                        method: CRUD.update,
                                        data: {
                                          "parent": widget.labelID,
                                        },
                                        labelId: issuesProvider.labels[index]
                                            ["id"],
                                        ref: ref);

                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 8,
                                              backgroundColor: ColorManager
                                                  .getColorFromHexaDecimal(
                                                      issuesProvider
                                                          .labels[index]
                                                              ['color']
                                                          .toString()),
                                            ),
                                            Container(width: 10),
                                            CustomText(
                                              issuesProvider.labels[index]
                                                      ['name']
                                                  .toString(),
                                              type: FontStyle.Small,
                                            ),
                                            const Spacer(),
                                            const SizedBox(width: 10)
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Container(
                                          height: 1,
                                          color: themeProvider
                                              .themeManager.borderSubtle01Color,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                        }),
              ],
            ),
          ),
          issuesProvider.labelState == StateEnum.loading
              ? Container(
                  height: height - 32,
                  alignment: Alignment.center,
                  color: themeProvider
                      .themeManager.secondaryBackgroundDefaultColor,
                  child: Center(
                    child: SizedBox(
                      height: 25,
                      width: 25,
                      child: LoadingIndicator(
                        indicatorType: Indicator.lineSpinFadeLoader,
                        colors: [themeProvider.themeManager.primaryTextColor],
                        strokeWidth: 1.0,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
