import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/custom_toast.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_button.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import 'package:plane_startup/widgets/loading_widget.dart';

import '../provider/provider_list.dart';

class EditPageSheet extends ConsumerStatefulWidget {
  EditPageSheet({super.key, required this.page});
  Map page;

  @override
  ConsumerState<EditPageSheet> createState() => _EditPageSheetState();
}

class _EditPageSheetState extends ConsumerState<EditPageSheet> {
  TextEditingController pageTitleController = TextEditingController();
  @override
  void initState() {
    pageTitleController = TextEditingController(text: widget.page['name']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    var pageProvider = ref.watch(ProviderList.pageProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return LoadingWidget(
      loading: pageProvider.pagesListState == StateEnum.loading,
      widgetClass: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(height: 50),
                const CustomText(
                  'Update Page',
                  type: FontStyle.heading,
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
            //form conatining title and description
            const CustomText(
              'Page Title',
              type: FontStyle.title,
              // color: themeProvider.secondaryTextColor,
            ),
            const SizedBox(height: 5),
            TextField(
              controller: pageTitleController,
              decoration: kTextFieldDecoration.copyWith(
                fillColor: themeProvider.isDarkThemeEnabled
                    ? darkBackgroundColor
                    : lightBackgroundColor,
                filled: true,
              ),
            ),
            const Spacer(),
            Button(
              text: 'Update Page',
              ontap: () async {
                if (pageTitleController.text.isEmpty ||
                    pageTitleController.text.trim() == "") {
                  CustomToast().showToast(context, 'Title is required');
                  return;
                }
                await ref.read(ProviderList.pageProvider).editPage(

                      data: {"name": pageTitleController.text},
                      pageId: widget.page['id'],
                      projectId: ref
                          .read(ProviderList.projectProvider)
                          .currentProject['id'],
                      slug: ref
                          .read(ProviderList.workspaceProvider)
                          .selectedWorkspace!
                          .workspaceSlug,
                    );
                Navigator.pop(context);
              },
              textColor: Colors.white,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
