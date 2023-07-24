import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/widgets/custom_text.dart';

class IssueDetailMoudlesList extends ConsumerStatefulWidget {
  final String moduleId;
  final String issueId;
  final String moduleIssueId;
  const IssueDetailMoudlesList(
      {required this.moduleId,
      required this.issueId,
      required this.moduleIssueId,
      super.key});

  @override
  ConsumerState<IssueDetailMoudlesList> createState() =>
      _IssueDetailMoudlesListState();
}

class _IssueDetailMoudlesListState
    extends ConsumerState<IssueDetailMoudlesList> {
  @override
  Widget build(BuildContext context) {
    var modulesProvider = ref.watch(ProviderList.modulesProvider);
    var issueProvider = ref.watch(ProviderList.issueProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var issuesProvider = ref.read(ProviderList.issuesProvider);
    var workspaceProvider = ref.read(ProviderList.workspaceProvider);
    var projectProvider = ref.read(ProviderList.projectProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Wrap(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                'Select Module',
                type: FontStyle.heading,
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  color: Color.fromRGBO(143, 143, 147, 1),
                ),
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
                                      .selectedWorkspace!
                                      .workspaceSlug,
                                  projID: ref
                                      .read(ProviderList.projectProvider)
                                      .currentProject['id'],
                                  issueId: widget.moduleIssueId,
                                  moduleId: widget.moduleId)
                              : modulesProvider.createModuleIssues(
                                  slug: ref
                                      .watch(ProviderList.workspaceProvider)
                                      .selectedWorkspace!
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
                          slug: workspaceProvider
                              .selectedWorkspace!.workspaceSlug,
                          projID: projectProvider.currentProject['id'],
                          issueID: widget.issueId,
                        );
                        modulesProvider.filterModuleIssues(
                          slug: workspaceProvider
                              .selectedWorkspace!.workspaceSlug,
                          projectId: projectProvider.currentProject['id'],
                        );
                        issuesProvider.filterIssues(
                            slug: workspaceProvider
                                .selectedWorkspace!.workspaceSlug,
                            projID: projectProvider.currentProject['id']);
                      });
                      Navigator.of(context).pop();
                    },
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              issueProvider.modulesList[index]['name'],
                              type: FontStyle.subheading,
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
                          height: 2,
                          margin: const EdgeInsets.only(bottom: 5, top: 10),
                          color: themeProvider.isDarkThemeEnabled
                              ? darkThemeBorder
                              : Colors.grey.shade300,
                        )
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
