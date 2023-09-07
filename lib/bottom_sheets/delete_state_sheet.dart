// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_button.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/loading_widget.dart';

class DeleteStateSheet extends ConsumerStatefulWidget {
  final String stateName;
  final String stateId;
  const DeleteStateSheet(
      {required this.stateName, required this.stateId, super.key});

  @override
  ConsumerState<DeleteStateSheet> createState() => _DeleteStateSheetState();
}

class _DeleteStateSheetState extends ConsumerState<DeleteStateSheet> {
  @override
  Widget build(BuildContext context) {
    var projectProvider = ref.watch(ProviderList.projectProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var issuesProvider = ref.watch(ProviderList.issuesProvider);
    return LoadingWidget(
      loading: projectProvider.stateCrudState == StateEnum.loading,
      allowBorderRadius: true,
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
                      'Delete State',
                      type: FontStyle.H6,
                      fontWeight: FontWeightt.Semibold,
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.close,
                          color:
                              themeProvider.themeManager.placeholderTextColor),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomText(
                  'Are you sure you want to delete state- ${widget.stateName}? All of the data related to the state will be permanently removed. This action cannot be undone.',
                  maxLines: 5,
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
            Column(
              children: [
                Button(
                  color: Colors.redAccent,
                  text: 'Delete',
                  ontap: () async {
                    await projectProvider.stateCrud(
                        slug: ref
                            .watch(ProviderList.workspaceProvider)
                            .selectedWorkspace!
                            .workspaceSlug,
                        projId: ref
                            .watch(ProviderList.projectProvider)
                            .currentProject['id'],
                        method: CRUD.delete,
                        stateId: widget.stateId,
                        context: context,
                        data: {},
                        ref: ref);
                    issuesProvider.getStates(
                      slug: ref
                          .watch(ProviderList.workspaceProvider)
                          .selectedWorkspace!
                          .workspaceSlug,
                      projID: ref
                          .watch(ProviderList.projectProvider)
                          .currentProject['id'],
                    );
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
