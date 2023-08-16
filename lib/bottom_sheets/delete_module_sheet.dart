// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/custom_toast.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/custom_button.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import 'package:plane_startup/widgets/loading_widget.dart';

class DeleteModules extends ConsumerStatefulWidget {
  final String moduleId;
  const DeleteModules({super.key, required this.moduleId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DeleteModulesState();
}

class _DeleteModulesState extends ConsumerState<DeleteModules> {
  @override
  Widget build(BuildContext context) {
    var modulesProvider = ref.watch(ProviderList.modulesProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Wrap(
      children: [
        LoadingWidget(
          loading: modulesProvider.moduleState == StateEnum.loading,
          widgetClass: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomText(
                          'Delete Module',
                          type: FontStyle.H6,
                          fontWeight: FontWeightt.Semibold,
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.close,
                              color: themeProvider.isDarkThemeEnabled
                                  ? lightSecondaryBackgroundColor
                                  : darkSecondaryBGC),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const CustomText(
                      'Are you sure you want to delete this module? All of the data related to the module will be permanently removed. This action cannot be undone.',
                      maxLines: 5,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
                Button(
                  color: Colors.redAccent,
                  text: 'Delete',
                  ontap: () async {
                    var projProv = ref.read(ProviderList.projectProvider);
                    if (projProv.role != Role.admin ||
                        projProv.role != Role.member) {
                      Navigator.of(context).pop();
                      CustomToast().showToast(
                          context, accessRestrictedMSG, themeProvider,
                          toastType: ToastType.failure);
                      return;
                    }
                    await modulesProvider.deleteModule(
                      slug: ref
                          .read(ProviderList.workspaceProvider)
                          .selectedWorkspace!
                          .workspaceSlug,
                      projId: ref
                          .read(ProviderList.projectProvider)
                          .currentProject['id'],
                      moduleId: widget.moduleId,
                    );

                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
