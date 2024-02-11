import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane/bottom-sheets/block_sheet.dart';
import 'package:plane/bottom-sheets/label_sheet.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/core/extensions/string_extensions.dart';
import 'package:plane/widgets/custom_app_bar.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/widgets/custom_text.dart';

class PageDetail extends ConsumerStatefulWidget {
  const PageDetail({required this.index, super.key});
  final int index;
  @override
  ConsumerState<PageDetail> createState() => _PageDetailState();
}

class _PageDetailState extends ConsumerState<PageDetail> {
  TextEditingController colorController = TextEditingController();
  TextEditingController titleController = TextEditingController();
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
  ];

  Map deletedLabel = {};
  bool isBlocksLoading = false;
  bool showLockLoading = false;
  late InAppWebViewController controller;
  @override
  void initState() {
    final prov = ref.read(ProviderList.pageProvider);
    prov.handleBlocks(
        context: context,
        blockID: "",
        httpMethod: HttpMethod.get,
        pageID: prov.pages[prov.selectedFilter]![widget.index]["id"],
        slug: ref
            .read(ProviderList.workspaceProvider)
            .selectedWorkspace
            .workspaceSlug,
        projectId: ref.read(ProviderList.projectProvider).currentProject["id"],
        ref: ref);
    ref.read(ProviderList.labelProvider.notifier).getProjectLabels();
    for (final element in (prov.pages[prov.selectedFilter]![widget.index]
        ['label_details'] as List)) {
      prov.selectedLabels.add(element['id']);
    }
    ref.read(ProviderList.issueProvider).initCookies();

    titleController.text =
        prov.pages[prov.selectedFilter]![widget.index]['name'] ?? '';
    colorController.text =
        prov.pages[prov.selectedFilter]![widget.index]['color'] ?? lables[0];
    super.initState();
  }

  bool showColor = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final pageProvider = ref.watch(ProviderList.pageProvider);
    final workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    final projectProvider = ref.watch(ProviderList.projectProvider);
    final page = pageProvider.pages[pageProvider.selectedFilter]![widget.index];
    log('https://0bba-2401-4900-1c32-1549-3421-5545-6e4f-e949.ngrok-free.app/${workspaceProvider.selectedWorkspace.workspaceSlug}/projects/${page['project']}/pages/${page['page']}/blocks');
    return Scaffold(
      appBar: CustomAppBar(
        onPressed: () {
          int.tryParse("FF${colorController.text.toString().toUpperCase().replaceAll("#", "FF")}",
                          radix: 16) ==
                      null ||
                  colorController.text.trim().isEmpty
              ? colorController.text = lables[0]
              : null;
          pageProvider.pages[pageProvider.selectedFilter]![widget.index]
              ['color'] = '#${colorController.text}';
          pageProvider.pages[pageProvider.selectedFilter]![widget.index]
              ['name'] = titleController.text;
          pageProvider.editPage(
              context: context,
              slug: workspaceProvider.selectedWorkspace.workspaceSlug,
              projectId: projectProvider.currentProject['id'],
              pageId: pageProvider
                  .pages[pageProvider.selectedFilter]![widget.index]['id'],
              data: {
                "color": '#${colorController.text}',
                "name": titleController.text
              },
              fromDispose: true,
              ref: ref);
          Navigator.pop(context);
        },
        text: pageProvider.pages[pageProvider.selectedFilter]![widget.index]
                ['name'] ??
            'Error',
        elevation: false,
      ),
      body: WillPopScope(
        onWillPop: () async {
          int.tryParse("FF${colorController.text.toString().toUpperCase().replaceAll("#", "FF")}",
                          radix: 16) ==
                      null ||
                  colorController.text.trim().isEmpty
              ? colorController.text = lables[0]
              : null;

          pageProvider.pages[pageProvider.selectedFilter]![widget.index]
              ['color'] = '#${colorController.text}';
          pageProvider.pages[pageProvider.selectedFilter]![widget.index]
              ['name'] = titleController.text;
          pageProvider.editPage(
              context: context,
              slug: workspaceProvider.selectedWorkspace.workspaceSlug,
              projectId: projectProvider.currentProject['id'],
              pageId: pageProvider
                  .pages[pageProvider.selectedFilter]![widget.index]['id'],
              data: {
                "color": '#${colorController.text}',
                "name": titleController.text
              },
              ref: ref);

          return true;
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 1,
              color: themeProvider.themeManager.borderSubtle01Color,
              width: double.infinity,
            ),
            //contaier containing a text ands four small icons
            checkAccess()
                ? Column(
                    children: [
                      Container(
                        color: themeProvider
                            .themeManager.primaryBackgroundSelectedColour,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Row(
                          children: [
                            //container containing a add icon and a text
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    enableDrag: true,
                                    constraints: BoxConstraints(
                                        maxHeight:
                                            MediaQuery.of(context).size.height *
                                                0.8),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30),
                                    )),
                                    context: context,
                                    builder: (ctx) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        child: LabelSheet(
                                          selectedLabels: pageProvider.pages[
                                                      pageProvider
                                                          .selectedFilter]![
                                                  widget.index]["labels"] ??
                                              [],
                                          pageIndex: widget.index,
                                        ),
                                      );
                                    });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: themeProvider.themeManager
                                        .primaryBackgroundDefaultColor,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: themeProvider
                                            .themeManager.borderSubtle01Color)),
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    //add icon
                                    Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      child: Icon(
                                        Icons.add,
                                        color: themeProvider
                                            .themeManager.secondaryTextColor,
                                        size: 22,
                                      ),
                                    ),
                                    CustomText(
                                      'Add Labels',
                                      type: FontStyle.Small,
                                      color: themeProvider
                                          .themeManager.secondaryTextColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Spacer(),
                            //four small icons

                            //icon 2
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    showColor = !showColor;
                                  });
                                  int.tryParse("FF${colorController.text.toString().toUpperCase().replaceAll("#", "FF")}",
                                                  radix: 16) ==
                                              null ||
                                          colorController.text.trim().isEmpty
                                      ? colorController.text = lables[0]
                                      : null;
                                  if (showColor == false) {
                                    pageProvider.pages[pageProvider
                                            .selectedFilter]![widget.index]
                                        ['color'] = '#${colorController.text}';
                                    pageProvider.editPage(
                                        context: context,
                                        slug: workspaceProvider
                                            .selectedWorkspace.workspaceSlug,
                                        projectId: projectProvider
                                            .currentProject['id'],
                                        pageId: pageProvider.pages[pageProvider
                                                .selectedFilter]![widget.index]
                                            ['id'],
                                        data: {
                                          "color": '#${colorController.text}'
                                        },
                                        ref: ref);
                                  }
                                },
                                icon: Icon(
                                  Icons.color_lens,
                                  color: int.tryParse(
                                                  "FF${colorController.text.toString().toUpperCase().replaceAll("#", "FF")}",
                                                  radix: 16) ==
                                              null ||
                                          colorController.text.trim().isEmpty
                                      ? Color(int.parse(
                                          lables[0]
                                              .toUpperCase()
                                              .replaceAll("#", "FF"),
                                          radix: 16))
                                      : Color(int.parse(
                                          "FF${colorController.text.toString().toUpperCase().replaceAll("#", "")}",
                                          radix: 16)),
                                  size: 22,
                                ),
                              ),
                            ),
                            //icon 3
                            showLockLoading == true
                                ? Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    height: 15,
                                    width: 15,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1.0,
                                      color: themeProvider
                                          .themeManager.placeholderTextColor,
                                    ),
                                  )
                                : InkWell(
                                    onTap: () async {
                                      showLockLoading = !showLockLoading;
                                      await pageProvider
                                          .editPage(
                                              context: context,
                                              pageId: pageProvider.pages[
                                                      pageProvider
                                                          .selectedFilter]![
                                                  widget.index]['id'],
                                              slug: workspaceProvider
                                                  .selectedWorkspace
                                                  .workspaceSlug,
                                              projectId: projectProvider
                                                  .currentProject['id'],
                                              data: {
                                                "access": pageProvider.pages[
                                                        pageProvider
                                                            .selectedFilter]![
                                                    widget.index]['access']
                                              },
                                              ref: ref)
                                          .then((value) {
                                        if (pageProvider.blockSheetState ==
                                            DataState.success) {
                                          pageProvider.pages[pageProvider
                                                      .selectedFilter]![
                                                  widget.index]
                                              ['access'] = pageProvider.pages[
                                                          pageProvider
                                                              .selectedFilter]![
                                                      widget.index]['access'] ==
                                                  1
                                              ? 0
                                              : 1;
                                        }
                                      });
                                      showLockLoading = !showLockLoading;
                                      setState(() {});
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      child: pageProvider.pages[pageProvider
                                                      .selectedFilter]![
                                                  widget.index]['access'] ==
                                              0 // 1 = locked || 0 = unlocked
                                          ? Icon(
                                              Icons.lock_open_outlined,
                                              size: 20,
                                              color: themeProvider.themeManager
                                                  .placeholderTextColor,
                                            )
                                          : Icon(
                                              Icons.lock_clock_outlined,
                                              size: 20,
                                              color: themeProvider.themeManager
                                                  .placeholderTextColor,
                                            ),
                                    ),
                                  ),
                            //icon 4
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: pageProvider.pages[pageProvider
                                              .selectedFilter]![widget.index]
                                          ['is_favorite'] ==
                                      true
                                  ? InkWell(
                                      onTap: () {
                                        setState(() {
                                          pageProvider.pages[pageProvider
                                                      .selectedFilter]![
                                                  widget.index]['is_favorite'] =
                                              !pageProvider.pages[pageProvider
                                                      .selectedFilter]![
                                                  widget.index]['is_favorite'];
                                        });
                                        pageProvider.makePageFavorite(
                                            pageId: pageProvider.pages[
                                                    pageProvider
                                                        .selectedFilter]![
                                                widget.index]['id'],
                                            slug: workspaceProvider
                                                .selectedWorkspace
                                                .workspaceSlug,
                                            projectId: projectProvider
                                                .currentProject['id'],
                                            shouldItBeFavorite: false);
                                      },
                                      child: Icon(Icons.star,
                                          size: 20,
                                          color: themeProvider
                                              .themeManager.secondaryIcon))
                                  : InkWell(
                                      onTap: () {
                                        setState(() {
                                          pageProvider.pages[pageProvider
                                                      .selectedFilter]![
                                                  widget.index]['is_favorite'] =
                                              !pageProvider.pages[pageProvider
                                                      .selectedFilter]![
                                                  widget.index]['is_favorite'];
                                        });
                                        pageProvider.makePageFavorite(
                                            pageId: pageProvider.pages[
                                                    pageProvider
                                                        .selectedFilter]![
                                                widget.index]['id'],
                                            slug: workspaceProvider
                                                .selectedWorkspace
                                                .workspaceSlug,
                                            projectId: projectProvider
                                                .currentProject['id'],
                                            shouldItBeFavorite: true);
                                      },
                                      child: Icon(
                                        Icons.star_border,
                                        size: 20,
                                        color: themeProvider
                                            .themeManager.placeholderTextColor,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        color: themeProvider.themeManager.borderSubtle01Color,
                        width: double.infinity,
                      ),
                    ],
                  )
                : Container(),
            const SizedBox(
              height: 15,
            ),
            showColor
                ? Card(
                    color: themeProvider
                        .themeManager.secondaryBackgroundDefaultColor,
                    margin:
                        const EdgeInsets.only(right: 15, left: 15, bottom: 15),
                    elevation: 10,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, top: 15),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.start,
                            alignment: WrapAlignment.start,
                            runAlignment: WrapAlignment.start,
                            spacing: 5,
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
                                        color: e.toString().toColor(),
                                        borderRadius: BorderRadius.circular(5),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 55,
                                height: 60,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: int.tryParse("FF${colorController.text.toString().toUpperCase().replaceAll("#", "FF")}",
                                                    radix: 16) ==
                                                null ||
                                            colorController.text.trim().isEmpty
                                        ? Color(int.parse(
                                            lables[0]
                                                .toUpperCase()
                                                .replaceAll("#", "FF"),
                                            radix: 16))
                                        : Color(int.parse(
                                            "FF${colorController.text.toString().toUpperCase().replaceAll("#", "")}",
                                            radix: 16)),
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
                                            offset:
                                                colorController.text.length));
                                    setState(() {});
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
                                          color: Colors.red.shade600,
                                          width: 1.0),
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(6),
                                        bottomRight: Radius.circular(6),
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red.shade600,
                                          width: 2.0),
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(6),
                                        bottomRight: Radius.circular(6),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: themeProvider
                                              .themeManager.borderSubtle01Color,
                                          width: 1.0),
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(6),
                                        bottomRight: Radius.circular(6),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: themeProvider
                                              .themeManager.borderSubtle01Color,
                                          width: 1.0),
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(6),
                                        bottomRight: Radius.circular(6),
                                      ),
                                    ),
                                    fillColor: themeProvider.themeManager
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
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: Wrap(
                  runSpacing: 10,
                  spacing: 10,
                  direction: Axis.horizontal,
                  children: (pageProvider
                              .pages[pageProvider.selectedFilter]![widget.index]
                          ['label_details'] as List)
                      .map((element) {
                    return InkWell(
                      onTap: () {
                        if (checkAccess()) {
                          setState(() {
                            deletedLabel.addAll(element);
                            pageProvider.selectedLabels.remove(element['id']);
                            (pageProvider.pages[pageProvider.selectedFilter]![
                                    widget.index]['label_details'] as List)
                                .remove(element);
                            log((pageProvider.pages[pageProvider
                                        .selectedFilter]![widget.index]
                                    ['label_details'] as List)
                                .toString());
                          });
                          pageProvider
                              .editPage(
                                  context: context,
                                  slug: workspaceProvider
                                      .selectedWorkspace.workspaceSlug,
                                  projectId:
                                      projectProvider.currentProject['id'],
                                  pageId: pageProvider.pages[pageProvider
                                      .selectedFilter]![widget.index]['id'],
                                  data: {
                                    "labels_list": pageProvider.selectedLabels,
                                  },
                                  ref: ref)
                              .then((value) {
                            if (pageProvider.blockSheetState ==
                                DataState.error) {
                              setState(() {
                                (pageProvider.pages[pageProvider
                                            .selectedFilter]![widget.index]
                                        ['label_details'] as List)
                                    .add(deletedLabel);
                              });
                            }
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: themeProvider
                                  .themeManager.borderSubtle01Color),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            //container 1
                            CircleAvatar(
                              radius: 5,
                              backgroundColor:
                                  element['color'].toString().toColor(),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            //container 2
                            CustomText(
                              element["name"],
                              type: FontStyle.Small,
                              color:
                                  themeProvider.themeManager.secondaryTextColor,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList()),
            ),
            (pageProvider.pages[pageProvider.selectedFilter]![widget.index]
                        ['label_details'] as List)
                    .isNotEmpty
                ? const SizedBox(
                    height: 20,
                  )
                : const SizedBox(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              alignment: Alignment.centerLeft,
              child: TextFormField(
                decoration: const InputDecoration(border: InputBorder.none),
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.themeManager.primaryTextColor),
                controller: titleController,
                maxLines: null,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            checkAccess()
                ? GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        enableDrag: true,
                        constraints: BoxConstraints(
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.8),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        context: context,
                        builder: (ctx) {
                          return Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: BlockSheet(
                                operation: CRUD.create,
                                pageID: pageProvider.pages[pageProvider
                                    .selectedFilter]![widget.index]['id'],
                              ));
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Row(
                        children: [
                          //add icon
                          Icon(
                            Icons.add,
                            color: themeProvider.themeManager.primaryTextColor,
                            size: 22,
                          ),

                          //text
                          CustomText(
                            'Add new block',
                            type: FontStyle.Small,
                            color: themeProvider.themeManager.primaryColour,
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),

            Expanded(
              child: page['blocks'].isEmpty
                  ? Center(
                      child: Text(
                        'No blocks found',
                        style: TextStyle(
                            color: themeProvider.themeManager.primaryTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : Stack(
                      children: [
                        InAppWebView(
                          contextMenu: ContextMenu(
                            menuItems: [],
                            options: ContextMenuOptions(
                              hideDefaultSystemContextMenuItems: true,
                            ),
                          ),
                          onLoadStart: (controller, url) => setState(() {
                            isBlocksLoading = true;
                          }),
                          onLoadStop: (controller, url) => setState(() {
                            isBlocksLoading = false;
                          }),
                          onWebViewCreated: (controller) =>
                              this.controller = controller,
                          pullToRefreshController: PullToRefreshController(
                            options: PullToRefreshOptions(
                              color:
                                  themeProvider.themeManager.primaryTextColor,
                            ),
                            onRefresh: () async {
                              controller.reload();
                            },
                          ),
                          initialUrlRequest: URLRequest(
                              url: Uri.parse(
                                  'https://0bba-2401-4900-1c32-1549-3421-5545-6e4f-e949.ngrok-free.app/${workspaceProvider.selectedWorkspace.workspaceSlug}/projects/${page['project']}/pages/${page['id']}/blocks')),
                        ),
                        isBlocksLoading
                            ? Container(
                                alignment: Alignment.center,
                                color: themeProvider
                                    .themeManager.primaryBackgroundDefaultColor,
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: LoadingIndicator(
                                    indicatorType: Indicator.lineSpinFadeLoader,
                                    colors: [
                                      themeProvider
                                          .themeManager.primaryTextColor
                                    ],
                                    strokeWidth: 1.0,
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }

  bool checkAccess() {
    final projectProvider = ref.watch(ProviderList.projectProvider);
    final profileProvider = ref.watch(ProviderList.profileProvider);
    bool hasAccess = false;

    for (final element in projectProvider.projectMembers) {
      if (element['member']['id'] == profileProvider.userProfile.id &&
          (element['role'] == 20 || element['role'] == 15)) {
        hasAccess = true;
      } else {
        hasAccess = false;
      }
    }

    return hasAccess;
  }
}
