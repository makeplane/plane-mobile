import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/widgets/custom_button.dart';
import 'package:plane/widgets/custom_text.dart';

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

      try {
        descriptionController.text = pageProvider.blocks[widget.blockIndex!]
                ['description']["content"][0]["content"][0]['text']
            .toString();
      } catch (e) {
        log(e.toString());
      }
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
                    CustomText(
                      widget.operation == CRUD.create
                          ? 'Add Block'
                          : 'Update Block',
                      type: FontStyle.H4,
                      fontWeight: FontWeightt.Semibold,
                      color: themeProvider.themeManager.primaryTextColor,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        color: themeProvider.themeManager.placeholderTextColor,
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
                      fontWeight: FontWeightt.Regular,
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
                  decoration: themeProvider.themeManager.textFieldDecoration,
                ),
                Container(height: 20),
                const Row(
                  children: [
                    CustomText(
                      'Write something',
                      type: FontStyle.Small,
                      fontWeight: FontWeightt.Regular,
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
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
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
                        context: context,
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
                        description: descriptionController.text,
                        ref: ref);

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
                  color: themeProvider
                      .themeManager.secondaryBackgroundDefaultColor,
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
