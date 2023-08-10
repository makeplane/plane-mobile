import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/widgets/custom_button.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/widgets/custom_text.dart';

import '../utils/enums.dart';

class BlockSheet extends ConsumerStatefulWidget {
  const BlockSheet(
      {required this.pageID,
      this.blockIndex,
      required this.operation,
      super.key});
  final String pageID;
  final CRUD operation;
  final int? blockIndex;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BlockSheetState();
}

class _BlockSheetState extends ConsumerState<BlockSheet> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    var pageProvider = ref.read(ProviderList.pageProvider);
    if (widget.operation == CRUD.update) {
      titleController.text = pageProvider.blocks[widget.blockIndex!]['name'];
    }
    super.initState();
  }

  double height = 0;
  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var pageProvider = ref.watch(ProviderList.pageProvider);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var box = context.findRenderObject() as RenderBox;
      height = box.size.height;
    });
    return Container(
      padding: const EdgeInsets.only(top: 23, left: 23, right: 23),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Wrap(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CustomText(
                      'Add block',
                      type: FontStyle.H4,
                      fontWeight: FontWeightt.Semibold,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        color: themeProvider.isDarkThemeEnabled
                            ? lightBackgroundColor
                            : darkBackgroundColor,
                      ),
                    )
                  ],
                ),
                Container(height: 20),
                const Row(
                  children: [
                    CustomText(
                      'Title',
                      type: FontStyle.Small,
                    ),
                    CustomText(
                      ' *',
                      type: FontStyle.Small,
                      color: Colors.red,
                    ),
                  ],
                ),
                Container(height: 5),
                TextField(
                  controller: titleController,
                  decoration:
                      themeProvider.themeManager.textFieldDecoration.copyWith(
                    fillColor: themeProvider.isDarkThemeEnabled
                        ? darkBackgroundColor
                        : lightBackgroundColor,
                    filled: true,
                  ),
                ),
                Container(height: 20),
                const Row(
                  children: [
                    CustomText(
                      'Write something',
                      type: FontStyle.Small,
                    ),
                    // CustomText(
                    //   ' *',
                    //   type: FontStyle.Small,
                    //   color: Colors.red,
                    // ),
                  ],
                ),
                Container(height: 5),
                TextField(
                  controller: descriptionController,
                  maxLines: 4,
                  decoration:
                      themeProvider.themeManager.textFieldDecoration.copyWith(
                    fillColor: themeProvider.isDarkThemeEnabled
                        ? darkBackgroundColor
                        : lightBackgroundColor,
                    filled: true,
                  ),
                ),
                Container(height: 20),
                Button(
                  ontap: () async {
                    if (titleController.text.isEmpty ||
                        titleController.text.trim() == "") {
                      return;
                    }
                    await ref.read(ProviderList.pageProvider).handleBlocks(
                        blockID: widget.blockIndex != null
                            ? pageProvider.blocks[widget.blockIndex!]["id"]
                            : "",
                        httpMethod: widget.operation == CRUD.create
                            ? HttpMethod.post
                            : HttpMethod.patch,
                        slug: ref
                            .read(ProviderList.workspaceProvider)
                            .selectedWorkspace!
                            .workspaceSlug,
                        projectId: ref
                            .read(ProviderList.projectProvider)
                            .currentProject['id'],
                        pageID: widget.pageID,
                        name: titleController.text,
                        description: descriptionController.text);

                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
                  text: widget.operation == CRUD.create
                      ? 'Add Block'
                      : 'Update Block',
                ),
                Container(height: 20),
              ],
            ),
          ),
          pageProvider.blockSheetState == StateEnum.loading
              ? Container(
                  height: height - 32,
                  alignment: Alignment.center,
                  color: themeProvider.isDarkThemeEnabled
                      ? darkSecondaryBGC.withOpacity(0.7)
                      : lightSecondaryBackgroundColor.withOpacity(0.7),
                  // height: 25,
                  // width: 25,
                  child: Center(
                    child: SizedBox(
                      height: 25,
                      width: 25,
                      child: LoadingIndicator(
                        indicatorType: Indicator.lineSpinFadeLoader,
                        colors: [
                          themeProvider.isDarkThemeEnabled
                              ? Colors.white
                              : Colors.black
                        ],
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
