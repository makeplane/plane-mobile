// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/mixins/widget_state_mixin.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/widgets/custom_button.dart';
import 'package:plane/widgets/custom_text.dart';

class DeleteCycleSheet extends ConsumerStatefulWidget {
  const DeleteCycleSheet(
      {required this.id,
      required this.name,
      required this.type,
      this.index,
      super.key});
  final String name;
  final String id;
  final String type;
  final int? index;

  @override
  ConsumerState<DeleteCycleSheet> createState() => _DeleteCycleSheetState();
}

class _DeleteCycleSheetState extends ConsumerState<DeleteCycleSheet>
    with WidgetStateMixin {
  @override
  LoadingType getLoading(WidgetRef ref) {
    return setWidgetState(
      [
        ref.watch(ProviderList.cyclesProvider).cyclesDetailState,
        ref.watch(ProviderList.modulesProvider).deleteModuleState,
        ref.watch(ProviderList.viewsProvider).viewsState,
        ref.watch(ProviderList.pageProvider).pagesListState
      ],
      loadingType: LoadingType.wrap,
    );
  }

  @override
  Widget render(BuildContext context) {
    final cyclesProvider = ref.read(ProviderList.cyclesProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    final projectProvider = ref.watch(ProviderList.projectProvider);
    return Wrap(
      children: [
        Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.4,
            minHeight: MediaQuery.of(context).size.height * 0.3,
          ),
          child: Container(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          'Delete ${widget.type}',
                          type: FontStyle.H4,
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
                      'Are you sure you want to delete ${widget.type.toLowerCase()} - ${widget.name}? All of the data related to the ${widget.type.toLowerCase()} will be permanently removed. This action cannot be undone.',
                      maxLines: 5,
                      type: FontStyle.H6,
                      textAlign: TextAlign.left,
                      color: themeProvider.themeManager.primaryTextColor,
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
                    if (projectProvider.role != Role.admin &&
                        projectProvider.role != Role.member) {
                      Navigator.of(context).pop();
                      CustomToast.showToast(context,
                          message: accessRestrictedMSG,
                          toastType: ToastType.failure);
                      return;
                    }
                    if (widget.type == 'Cycle') {
                      await cyclesProvider.cycleDetailsCrud(
                        slug: workspaceProvider.selectedWorkspace.workspaceSlug,
                        projectId: projectProvider.currentProject['id'],
                        method: CRUD.delete,
                        cycleId: widget.id,
                      );
                      cyclesProvider.cyclesCrud(
                          ref: ref,
                          slug:
                              workspaceProvider.selectedWorkspace.workspaceSlug,
                          projectId: projectProvider.currentProject['id'],
                          method: CRUD.read,
                          cycleId: '',
                          query: 'all');
                      cyclesProvider.cyclesCrud(
                          ref: ref,
                          slug:
                              workspaceProvider.selectedWorkspace.workspaceSlug,
                          projectId: projectProvider.currentProject['id'],
                          method: CRUD.read,
                          cycleId: '',
                          query: 'current');
                      cyclesProvider.cyclesCrud(
                          ref: ref,
                          slug:
                              workspaceProvider.selectedWorkspace.workspaceSlug,
                          projectId: projectProvider.currentProject['id'],
                          method: CRUD.read,
                          cycleId: '',
                          query: 'upcoming');
                      cyclesProvider.cyclesCrud(
                          ref: ref,
                          slug:
                              workspaceProvider.selectedWorkspace.workspaceSlug,
                          projectId: projectProvider.currentProject['id'],
                          method: CRUD.read,
                          cycleId: '',
                          query: 'completed');
                      cyclesProvider.cyclesCrud(
                          ref: ref,
                          slug:
                              workspaceProvider.selectedWorkspace.workspaceSlug,
                          projectId: projectProvider.currentProject['id'],
                          method: CRUD.read,
                          cycleId: '',
                          query: 'draft');
                    } else if (widget.type == 'Module') {
                      final modulesProvider =
                          ref.read(ProviderList.modulesProvider);
                      await modulesProvider.deleteModule(
                        slug: workspaceProvider.selectedWorkspace.workspaceSlug,
                        projId: projectProvider.currentProject['id'],
                        moduleId: widget.id,
                      );
                    } else if (widget.type == 'View') {
                      await ref
                          .watch(ProviderList.viewsProvider.notifier)
                          .deleteViews(
                            index: widget.index!,
                            id: widget.id,
                          );

                      log('View delete');
                    } else if (widget.type == 'Page') {
                      final pagesProvider = ref.read(ProviderList.pageProvider);
                      await pagesProvider.deletePage(
                        slug: workspaceProvider.selectedWorkspace.workspaceSlug,
                        projectId: projectProvider.currentProject['id'],
                        pageId: widget.id,
                      );

                      log('Page delete');
                    } else {
                      log('Unknown type');
                    }

                    CustomToast.showToast(context,
                        message: '${widget.type} deleted',
                        toastType: ToastType.success);

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
