// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_button.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/loading_widget.dart';

class DeleteModules extends ConsumerStatefulWidget {
  const DeleteModules({super.key, required this.moduleId});
  final String moduleId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DeleteModulesState();
}

class _DeleteModulesState extends ConsumerState<DeleteModules> {
  @override
  Widget build(BuildContext context) {
    final modulesProvider = ref.watch(ProviderList.modulesProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    return Wrap(
      children: [
        Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.4,
            minHeight: MediaQuery.of(context).size.height * 0.3,
          ),
          child: LoadingWidget(
            loading: modulesProvider.deleteModuleState == DataState.loading,
            widgetClass: Container(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 20, bottom: 30),
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
                                color: themeProvider
                                    .themeManager.placeholderTextColor),
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
                      final projProv = ref.read(ProviderList.projectProvider);
                      if (projProv.role != Role.admin &&
                          projProv.role != Role.member) {
                        Navigator.of(context).pop();
                        CustomToast.showToast(context,
                            message: accessRestrictedMSG,
                            toastType: ToastType.failure);
                        return;
                      }
                      await modulesProvider.deleteModule(
                        slug: ref
                            .read(ProviderList.workspaceProvider)
                            .selectedWorkspace
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
        ),
      ],
    );
  }
}
