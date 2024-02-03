import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/widgets/custom_text.dart';

import '../utils/enums.dart';

class IssueDetailMoudlesList extends ConsumerStatefulWidget {
  const IssueDetailMoudlesList(
      {required this.moduleId,
      required this.issueId,
      required this.moduleIssueId,
      super.key});
  final String moduleId;
  final String issueId;
  final String moduleIssueId;

  @override
  ConsumerState<IssueDetailMoudlesList> createState() =>
      _IssueDetailMoudlesListState();
}

class _IssueDetailMoudlesListState
    extends ConsumerState<IssueDetailMoudlesList> {
  @override
  Widget build(BuildContext context) {
    final modulesProvider = ref.watch(ProviderList.modulesProvider);
    final issueProvider = ref.watch(ProviderList.issueProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final workspaceProvider = ref.read(ProviderList.workspaceProvider);
    final projectProvider = ref.read(ProviderList.projectProvider);
    return Container(
      decoration: BoxDecoration(
        color: themeProvider.themeManager.secondaryBackgroundDefaultColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Wrap(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                'Select Module',
                type: FontStyle.H4,
                fontWeight: FontWeightt.Semibold,
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close,
                    color: themeProvider.themeManager.placeholderTextColor),
              )
            ],
          ),
          Container(
            height: 15,
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: issueProvider.modulesList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: InkWell(
                    onTap: () {
                      (issueProvider.modulesList[index]['name'] == 'None'
                              ? modulesProvider.deleteModuleIssues(
                                  slug: ref
                                      .watch(ProviderList.workspaceProvider)
                                      .selectedWorkspace
                                      .workspaceSlug,
                                  projID: ref
                                      .read(ProviderList.projectProvider)
                                      .currentProject['id'],
                                  issueId: widget.moduleIssueId,
                                  moduleId: widget.moduleId)
                              : modulesProvider.createModuleIssues(
                                  slug: ref
                                      .watch(ProviderList.workspaceProvider)
                                      .selectedWorkspace
                                      .workspaceSlug,
                                  projID: ref
                                      .read(ProviderList.projectProvider)
                                      .currentProject['id'],
                                  issues: [widget.issueId],
                                  moduleId: issueProvider.modulesList[index]
                                      ['id'],
                                ))
                          .then((value) async {
                        issueProvider.getIssueDetails(
                          slug:
                              workspaceProvider.selectedWorkspace.workspaceSlug,
                          projID: projectProvider.currentProject['id'],
                          issueID: widget.issueId,
                        );
                        modulesProvider.filterModuleIssues(
                          slug:
                              workspaceProvider.selectedWorkspace.workspaceSlug,
                          projectId: projectProvider.currentProject['id'],
                          ref: ref
                        );
                      });
                      Navigator.of(context).pop();
                    },
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //radio
                            CustomText(
                              issueProvider.modulesList[index]['name'],
                              type: FontStyle.Medium,
                              fontWeight: FontWeightt.Regular,
                              color:
                                  themeProvider.themeManager.primaryTextColor,
                            ),
                            widget.moduleId != '' &&
                                    widget.moduleId ==
                                        issueProvider.modulesList[index]['id']
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  )
                                : Container()
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                            height: 1,
                            margin: const EdgeInsets.only(bottom: 5, top: 10),
                            color:
                                themeProvider.themeManager.borderDisabledColor)
                      ],
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
