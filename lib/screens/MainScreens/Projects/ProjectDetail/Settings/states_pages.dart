// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane_startup/bottom_sheets/delete_state_sheet.dart';
import 'package:plane_startup/provider/issues_provider.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/custom_toast.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_button.dart';

import 'package:plane_startup/widgets/custom_text.dart';

List states = ['backlog', 'unstarted', 'started', 'completed', 'cancelled'];

class StatesPage extends ConsumerStatefulWidget {
  const StatesPage({super.key});

  @override
  ConsumerState<StatesPage> createState() => _StatesPageState();
}

class _StatesPageState extends ConsumerState<StatesPage> {
  @override
  void initState() {
    super.initState();
    log(ref.read(ProviderList.issuesProvider).states.toString());
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var issuesProvider = ref.watch(ProviderList.issuesProvider);
    return Container(
      color: themeProvider.themeManager.primaryBackgroundDefaultColor,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: states.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    states[index].toString().replaceFirst(states[index][0],
                        states[index][0].toString().toUpperCase()),
                    // values['group'].replaceFirst(values['group'][0], values['group'][0].toUpperCase()),
                    type: FontStyle.H5,
                    fontWeight: FontWeightt.Medium,
                    color: themeProvider.themeManager.primaryTextColor,
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        enableDrag: true,
                        constraints: BoxConstraints(
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.8),
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: AddUpdateState(
                              groupIndex: index,
                              stateKey: states[index].toString().replaceFirst(
                                  states[index][0],
                                  states[index][0].toString().toUpperCase()),
                              method: CRUD.create,
                              stateId: '',
                              name: '',
                              color: '',
                            ),
                          );
                        },
                      );
                    },
                    icon: Icon(
                      Icons.add,
                      color: themeProvider.themeManager.placeholderTextColor,
                    ),
                  )
                ],
              ),
              ListView.builder(
                padding: EdgeInsets.zero,
                primary: false,
                shrinkWrap: true,
                itemCount: issuesProvider.statesData[states[index]].length,
                itemBuilder: (context, idx) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.only(
                      left: 14,
                    ),
                    decoration: BoxDecoration(
                        color: themeProvider
                            .themeManager.tertiaryBackgroundDefaultColor,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: themeProvider
                                .themeManager.borderSubtle01Color)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              states[index] == 'backlog'
                                  ? 'assets/svg_images/circle.svg'
                                  : states[index] == 'cancelled'
                                      ? 'assets/svg_images/cancelled.svg'
                                      : states[index] == 'completed'
                                          ? 'assets/svg_images/done.svg'
                                          : states[index] == 'started'
                                              ? 'assets/svg_images/in_progress.svg'
                                              : 'assets/svg_images/circle.svg',
                              colorFilter: ColorFilter.mode(
                                  getColorFromIssueProvider(
                                      issuesProvider, index, idx),
                                  BlendMode.srcIn),
                              height: 20,
                              width: 20,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            CustomText(
                              issuesProvider.statesData[states[index]][idx]
                                  ['name'],
                              type: FontStyle.Medium,
                              color:
                                  themeProvider.themeManager.primaryTextColor,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  constraints:
                                      BoxConstraints(maxHeight: height * 0.8),
                                  enableDrag: true,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20))),
                                  context: context,
                                  builder: (context) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: AddUpdateState(
                                        groupIndex: index,
                                        stateKey: issuesProvider
                                                .statesData[states[index]][idx]
                                            ["group"],
                                        method: CRUD.update,
                                        stateId: issuesProvider
                                                .statesData[states[index]][idx]
                                            ['id'],
                                        name: issuesProvider
                                                .statesData[states[index]][idx]
                                            ['name'],
                                        color: issuesProvider
                                                .statesData[states[index]][idx]
                                            ['color'],
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.edit_outlined,
                                color: themeProvider
                                    .themeManager.placeholderTextColor,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (issuesProvider.statesData[states[index]]
                                        [idx]['default'] ==
                                    true) {
                                  CustomToast.showToast(
                                    context,
                                    message: 'Cannot delete the default state',
                                    toastType: ToastType.failure,
                                  );
                                } else if (issuesProvider
                                        .statesData[states[index]].length ==
                                    1) {
                                  CustomToast.showToast(
                                    context,
                                    message: 'Cannot have an empty group',
                                    toastType: ToastType.failure,
                                  );
                                } else {
                                  showModalBottomSheet(
                                    constraints:
                                        const BoxConstraints(maxHeight: 310),
                                    enableDrag: true,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20))),
                                    context: context,
                                    builder: (context) {
                                      return DeleteStateSheet(
                                        stateName: issuesProvider
                                                .statesData[states[index]][idx]
                                            ['name'],
                                        stateId: issuesProvider
                                                .statesData[states[index]][idx]
                                            ['id'],
                                      );
                                    },
                                  );
                                }
                              },
                              icon: SvgPicture.asset(
                                'assets/svg_images/delete_icon.svg',
                                height: 20,
                                width: 20,
                                colorFilter: ColorFilter.mode(
                                    themeProvider.themeManager.textErrorColor,
                                    BlendMode.srcIn),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Color getColorFromIssueProvider(
      IssuesProvider issuesProvider, int index, int idx) {
    Color colorToReturnOnApiError = const Color.fromARGB(255, 200, 80, 80);
    String? colorData = issuesProvider.statesData[states[index]][idx]['color'];

    return (colorData == null || colorData[0] != '#')
        ? colorToReturnOnApiError
        : Color(int.parse("FF${colorData.replaceAll('#', '')}", radix: 16));
  }
}

// ignore: must_be_immutable
class AddUpdateState extends ConsumerStatefulWidget {
  final String stateKey;
  final CRUD method;
  final String stateId;
  final String name;
  int groupIndex;
  final String color;
  AddUpdateState(
      {required this.stateKey,
      required this.method,
      required this.groupIndex,
      required this.stateId,
      required this.name,
      required this.color,
      super.key});

  @override
  ConsumerState<AddUpdateState> createState() => _AddUpdateStateState();
}

class _AddUpdateStateState extends ConsumerState<AddUpdateState> {
  TextEditingController nameController = TextEditingController();
  String color = '';
  List colors = [
    '#FF6900',
    '#FCB900',
    '#7BDCB5',
    '#00D084',
    '#8ED1FC',
    '#0693E3',
    '#ABB8C3',
    '#EB144C',
    '#F78DA7',
    '#9900EF'
  ];
  bool showColoredBox = false;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.name.isNotEmpty ? widget.name : '';
    color = widget.color.isNotEmpty ? widget.color : '#ABB8C3';
    // log(widget.stateKey);
  }

  double height = 0.0;
  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    var issuesProvider = ref.watch(ProviderList.issuesProvider);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var box = context.findRenderObject() as RenderBox;
      height = box.size.height;
    });
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Wrap(
              children: [
                Wrap(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width * 0.7,
                          child: CustomText(
                            widget.method == CRUD.update
                                ? 'Update ${widget.name} state'
                                : 'Add ${widget.name} state',
                            type: FontStyle.H6,
                            fontWeight: FontWeightt.Semibold,
                            maxLines: 1,
                            fontSize: 22,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.close,
                              color:
                                  themeProvider.themeManager.primaryTextColor,
                            )),
                      ],
                    ),
                    Container(
                      height: 20,
                    ),
                    const CustomText(
                      'Color',
                      type: FontStyle.Small,
                    ),
                    Container(
                      height: 10,
                    ),
                    Row(
                      children: [
                        InkWell(
                            onTap: () {
                              setState(() {
                                showColoredBox = !showColoredBox;
                              });
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color(int.parse(
                                      '0xFF${color.toString().replaceAll('#', '')}'))),
                            )),
                        showColoredBox
                            ? Container(
                                margin: const EdgeInsets.only(left: 10),
                                width: 300,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: themeProvider.themeManager
                                      .secondaryBackgroundDefaultColor,
                                  boxShadow: const [
                                    BoxShadow(
                                        blurRadius: 2.0, color: greyColor),
                                  ],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: colors
                                      .map((e) => GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                color = e;
                                                showColoredBox = false;
                                              });
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Color(int.parse(
                                                    '0xFF${e.toString().replaceAll('#', '')}')),
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              )
                            : Container()
                      ],
                    ),
                    Container(
                      height: 15,
                    ),
                    const CustomText(
                      'Name *',
                      type: FontStyle.Small,
                    ),
                    Container(
                      height: 5,
                    ),
                    TextField(
                      controller: nameController,
                      decoration:
                          themeProvider.themeManager.textFieldDecoration,
                    ),
                    Container(
                      height: 20,
                    ),
                    widget.method == CRUD.create
                        ? Container()
                        : const CustomText(
                            'State *',
                            type: FontStyle.Small,
                          ),
                    widget.method == CRUD.create
                        ? Container()
                        : Container(
                            margin: const EdgeInsets.only(top: 4, bottom: 20),
                            height: 55,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: themeProvider
                                    .themeManager.borderSubtle01Color,
                              ),
                            ),
                            child: IgnorePointer(
                              ignoring: issuesProvider
                                          .statesData[states[widget.groupIndex]]
                                          .length ==
                                      1
                                  ? true
                                  : false,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButtonFormField(
                                    dropdownColor: themeProvider.themeManager
                                        .secondaryBackgroundDefaultColor,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      border: InputBorder.none,
                                    ),
                                    value: states[widget.groupIndex],
                                    items: states
                                        .map((e) => DropdownMenuItem(
                                              value: e.toString(),
                                              child: CustomText(
                                                e.toString().replaceFirst(
                                                    e[0], e[0].toUpperCase()),
                                                // color: Colors.white,
                                                type: FontStyle.Medium,
                                              ),
                                            ))
                                        .toList(),
                                    onChanged: (item) {
                                      widget.groupIndex = states.indexOf(item);
                                      //   log( widget.groupIndex.toString());
                                    }),
                              ),
                            ),
                          )
                  ],
                ),
                Button(
                  text: widget.method == CRUD.create
                      ? 'Add State'
                      : 'Update State',
                  ontap: () async {
                    if (nameController.text.isNotEmpty) {
                      await projectProvider.stateCrud(
                          slug: ref
                              .watch(ProviderList.workspaceProvider)
                              .selectedWorkspace!
                              .workspaceSlug,
                          projId: ref
                              .watch(ProviderList.projectProvider)
                              .currentProject['id'],
                          stateId: widget.stateId.isEmpty ? '' : widget.stateId,
                          method: widget.method,
                          context: context,
                          data: {
                            "name": nameController.text,
                            "color": color,
                            "group": states[widget.groupIndex],
                            "description": ""
                          },
                          ref: ref);
                      issuesProvider.getStates(
                        slug: ref
                            .watch(ProviderList.workspaceProvider)
                            .selectedWorkspace!
                            .workspaceSlug,
                        projID: ref
                            .watch(ProviderList.projectProvider)
                            .currentProject['id'],
                      );
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          projectProvider.stateCrudState == StateEnum.loading
              ? Container(
                  height: height - 32,
                  alignment: Alignment.center,
                  color:
                      themeProvider.themeManager.primaryBackgroundDefaultColor,
                  // height: 25,
                  // width: 25,
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
