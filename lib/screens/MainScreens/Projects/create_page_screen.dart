import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/custom_toast.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import 'package:plane_startup/widgets/custom_app_bar.dart';
import 'package:plane_startup/widgets/custom_button.dart';
import 'package:plane_startup/widgets/loading_widget.dart';

class CreatePage extends ConsumerWidget {
  const CreatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var pageProvider = ref.watch(ProviderList.pageProvider);
    TextEditingController pageTitleController = TextEditingController();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor:
            themeProvider.themeManager.primaryBackgroundDefaultColor,
        appBar: CustomAppBar(
          onPressed: () {
            Navigator.pop(context);
          },
          text: 'Create Page',
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return LoadingWidget(
            loading: pageProvider.pagesListState == StateEnum.loading,
            widgetClass: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //form conatining title and description
                          Row(
                            children: [
                              CustomText(
                                'Page Title',
                                type: FontStyle.Small,
                                color: themeProvider
                                    .themeManager.tertiaryTextColor,
                              ),
                              const CustomText(
                                ' *',
                                type: FontStyle.Small,
                                color: Colors.red,
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          TextField(
                              controller: pageTitleController,
                              decoration: themeProvider
                                  .themeManager.textFieldDecoration),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 16),
                      child: Button(
                        text: 'Create Page',
                        ontap: () async {
                          if (pageTitleController.text.isEmpty ||
                              pageTitleController.text.trim() == "") {
                            CustomToast().showToast(
                                context, 'Title is required', themeProvider,
                                toastType: ToastType.warning);
                            return;
                          }
                          await ref.read(ProviderList.pageProvider).addPage(
                                userId: ref
                                    .read(ProviderList.profileProvider)
                                    .userProfile
                                    .id!,
                                pageTitle: pageTitleController.text,
                                projectId: ref
                                    .read(ProviderList.projectProvider)
                                    .currentProject['id'],
                                slug: ref
                                    .read(ProviderList.workspaceProvider)
                                    .selectedWorkspace!
                                    .workspaceSlug,
                                ref: ref
                              );
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        },
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
