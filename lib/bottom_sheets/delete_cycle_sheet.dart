// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/utils/custom_toast.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/widgets/custom_button.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import 'package:plane_startup/widgets/loading_widget.dart';

class DeleteCycleSheet extends ConsumerStatefulWidget {
  final String cycleName;
  final String cycleId;
  const DeleteCycleSheet(
      {required this.cycleId, required this.cycleName, super.key});

  @override
  ConsumerState<DeleteCycleSheet> createState() => _DeleteCycleSheetState();
}

class _DeleteCycleSheetState extends ConsumerState<DeleteCycleSheet> {
  @override
  Widget build(BuildContext context) {
    var cyclesProvider = ref.read(ProviderList.cyclesProvider);
    var cyclesProviderWatch = ref.watch(ProviderList.cyclesProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Wrap(
      children: [
        LoadingWidget(
          loading: cyclesProviderWatch.cyclesDetailState == StateEnum.loading,
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
                          'Delete Cycle',
                          type: FontStyle.H6,
                          fontWeight: FontWeightt.Semibold,
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.close,
                            color:
                                themeProvider.themeManager.placeholderTextColor,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomText(
                      'Are you sure you want to delete cycle - ${widget.cycleName}? All of the data related to the cycle will be permanently removed. This action cannot be undone.',
                      maxLines: 5,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                Button(
                  color: Colors.redAccent,
                  text: 'Delete',
                  ontap: () async {
                    var projProv = ref.read(ProviderList.projectProvider);
                    print(projProv.role.toString());
                    if (projProv.role != Role.admin &&
                        projProv.role != Role.member) {
                      Navigator.of(context).pop();
                      CustomToast().showToast(
                          context, accessRestrictedMSG, themeProvider,
                          toastType: ToastType.failure);
                      return;
                    }
                    await cyclesProvider.cycleDetailsCrud(
                      slug: ref
                          .read(ProviderList.workspaceProvider)
                          .selectedWorkspace!
                          .workspaceSlug,
                      projectId: ref
                          .read(ProviderList.projectProvider)
                          .currentProject['id'],
                      method: CRUD.delete,
                      cycleId: widget.cycleId,
                    );
                    cyclesProvider.cyclesCrud(
                      ref: ref,
                        slug: ref
                            .read(ProviderList.workspaceProvider)
                            .selectedWorkspace!
                            .workspaceSlug,
                        projectId: ref
                            .read(ProviderList.projectProvider)
                            .currentProject['id'],
                        method: CRUD.read,
                        cycleId: '',
                        query: 'all');
                    cyclesProvider.cyclesCrud(
                      ref: ref,
                        slug: ref
                            .read(ProviderList.workspaceProvider)
                            .selectedWorkspace!
                            .workspaceSlug,
                        projectId: ref
                            .read(ProviderList.projectProvider)
                            .currentProject['id'],
                        method: CRUD.read,
                        cycleId: '',
                        query: 'current');
                    cyclesProvider.cyclesCrud(
                      ref: ref,
                        slug: ref
                            .read(ProviderList.workspaceProvider)
                            .selectedWorkspace!
                            .workspaceSlug,
                        projectId: ref
                            .read(ProviderList.projectProvider)
                            .currentProject['id'],
                        method: CRUD.read,
                        cycleId: '',
                        query: 'upcoming');
                    cyclesProvider.cyclesCrud(
                      ref: ref,
                        slug: ref
                            .read(ProviderList.workspaceProvider)
                            .selectedWorkspace!
                            .workspaceSlug,
                        projectId: ref
                            .read(ProviderList.projectProvider)
                            .currentProject['id'],
                        method: CRUD.read,
                        cycleId: '',
                        query: 'completed');
                    cyclesProvider.cyclesCrud(
                      ref: ref,
                        slug: ref
                            .read(ProviderList.workspaceProvider)
                            .selectedWorkspace!
                            .workspaceSlug,
                        projectId: ref
                            .read(ProviderList.projectProvider)
                            .currentProject['id'],
                        method: CRUD.read,
                        cycleId: '',
                        query: 'draft');
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
