import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/custom_toast.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_button.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import 'package:plane_startup/widgets/loading_widget.dart';

class EditBlockSheet extends ConsumerStatefulWidget {
  const EditBlockSheet(
      {super.key, required this.title, required this.description});

  final String title;
  final String description;

  @override
  ConsumerState<EditBlockSheet> createState() => _TempEditBlockState();
}

class _TempEditBlockState extends ConsumerState<EditBlockSheet> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    titleController = TextEditingController(text: widget.title);
    descriptionController = TextEditingController(text: widget.description);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var pageProvider = ref.watch(ProviderList.pageProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return LoadingWidget(
      loading: pageProvider.pagesListState == StateEnum.loading ||
          pageProvider.blockState == StateEnum.loading,
      widgetClass: Container(
        padding: const EdgeInsets.only(top: 23, left: 23, right: 23),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CustomText(
                  'Update block',
                  type: FontStyle.H6,
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
            const SizedBox(height: 25),
            const Row(
              children: [
                CustomText(
                  'Title',
                  type: FontStyle.Small,
                  // color: themeProvider.secondaryTextColor,
                ),
                // CustomText(
                //   ' *',
                //   type: FontStyle.Small,
                //   color: Colors.red,
                // ),
              ],
            ),
            const SizedBox(height: 5),
            TextField(
              controller: titleController,
              maxLines: 1,
              decoration:
                  themeProvider.themeManager.textFieldDecoration.copyWith(
                fillColor: themeProvider.isDarkThemeEnabled
                    ? darkBackgroundColor
                    : lightBackgroundColor,
                filled: true,
              ),
            ),
            const SizedBox(height: 25),
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
            const SizedBox(height: 5),
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
            const SizedBox(height: 150),
            Button(
              text: 'Update Block',
              ontap: () async {
                if (titleController.text.isEmpty ||
                    titleController.text.trim() == "") {
                  CustomToast()
                      .showToast(context, 'Title and description is required');
                  return;
                }
                // await pageProvider.updateBlock(
                //     userId:
                //         ref.read(ProviderList.profileProvider).userProfile.id!,
                //     slug: workspaceProvider.selectedWorkspace!.workspaceSlug,
                //     projectId: projectProvider.currentProject['id'],
                //     pageId: pageProvider.selectedPage['id'],
                //     blockId: pageProvider.getSelectedPageBlock()['id'],
                //     blockTitle: titleController.text,
                //     blockDescription: descriptionController.text);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
