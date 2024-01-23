import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plane/bottom_sheets/issues_list_sheet.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/provider/theme_provider.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/Cycles/create_cycle.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/Issues/CreateIssue/create_issue.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/Modules/create_module.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/Settings/create_label.dart';
import 'package:plane/screens/MainScreens/Projects/create_page_screen.dart';
import 'package:plane/screens/MainScreens/Projects/create_project_screen.dart';
import 'package:plane/screens/create_view_screen.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';

import 'custom_text.dart';

class EmptyPlaceholder {
  static Widget emptyCycles(BuildContext context, WidgetRef ref) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final projectProvider = ref.watch(ProviderList.projectProvider);
    return Container(
      alignment: Alignment.center,
      child: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/svg_images/empty_cycles.svg",
            width: 130,
          ),
          Container(
            padding: const EdgeInsets.only(top: 35),
            child: CustomText(
              'Cycles',
              type: FontStyle.H5,
              fontWeight: FontWeightt.Semibold,
              color: themeProvider.themeManager.primaryTextColor,
            ),
          ),
          Container(
            width: 300,
            padding: const EdgeInsets.only(top: 10),
            child: CustomText(
              'Sprint more effectively with Cycles by confining your project to a fixed amount of time. Create new cycle now.',
              color: themeProvider.themeManager.placeholderTextColor,
              textAlign: TextAlign.center,
              type: FontStyle.Small,
              maxLines: 3,
            ),
          ),
          projectProvider.role != Role.admin &&
                  projectProvider.role != Role.member
              ? noPermsionToCreateWidget('cycle', themeProvider)
              : GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateCycle()));
                  },
                  child: Container(
                    height: 40,
                    width: 150,
                    margin: const EdgeInsets.only(top: 30),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(buttonBorderRadiusMedium),
                      color: themeProvider.themeManager.primaryColour,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        CustomText(
                          'Add Cycle',
                          type: FontStyle.Small,
                          fontWeight: FontWeightt.Medium,
                          color: Colors.white,
                          overrride: true,
                        )
                      ],
                    ),
                  ),
                )
        ],
      ),
    );
  }

  static Widget emptySubIssues(
    WidgetRef ref,
  ) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    return Container(
      alignment: Alignment.center,
      child: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/svg_images/empty_issues.svg",
            width: 130,
          ),
          Container(
            padding: const EdgeInsets.only(top: 35),
            child: CustomText(
              'No Issues yet',
              type: FontStyle.H5,
              fontWeight: FontWeightt.Semibold,
              color: themeProvider.themeManager.primaryTextColor,
            ),
          ),
          Container(
            width: 300,
            padding: const EdgeInsets.only(top: 10),
            child: CustomText(
              'You have not created any issues yet. Create issues to select them for your issues.',
              color: themeProvider.themeManager.placeholderTextColor,
              textAlign: TextAlign.center,
              type: FontStyle.Small,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }

  static Widget emptyArchives() {
    return Container(
      alignment: Alignment.center,
      child: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/svg_images/issue_archive.svg",
            width: 130,
          ),
          Container(
            padding: const EdgeInsets.only(top: 35),
            child: const CustomText(
              'Archived Issues will be shown here',
              type: FontStyle.H5,
              fontWeight: FontWeightt.Semibold,
            ),
          ),
          Container(
            width: 300,
            padding: const EdgeInsets.only(top: 10),
            child: const CustomText(
              'All the issues that have been in the completed or cancelled groups for the configured period of time can be viewed here.',
              color: Colors.grey,
              textAlign: TextAlign.center,
              type: FontStyle.Small,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }

  static Widget noPermsionToCreateWidget(
      String name, ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: themeProvider.themeManager.secondaryBackgroundSelectedColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.gpp_maybe_outlined,
              color: themeProvider.themeManager.placeholderTextColor),
          const SizedBox(width: 5),
          CustomText(
            "No permission to create $name",
            color: themeProvider.themeManager.placeholderTextColor,
            fontWeight: FontWeightt.Medium,
          ),
        ],
      ),
    );
  }

  static Widget emptyIssues(BuildContext context,
      {String? cycleId,
      String? moduleId,
      String? projectId,
      Map<String, dynamic>? assignee,
      WidgetRef? ref,
      IssueCategory? type}) {
    final themeProvider = ref!.watch(ProviderList.themeProvider);
    final projectProvider = ref.watch(ProviderList.projectProvider);
    return Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 35),
            child: CustomText(
              'Create New Issue',
              type: FontStyle.H5,
              fontWeight: FontWeightt.Semibold,
              color: themeProvider.themeManager.primaryTextColor,
            ),
          ),
          Container(
            width: 300,
            padding: const EdgeInsets.only(top: 10),
            child: CustomText(
              //create issues text
              'Issues help you track individual pieces of work. With Issues, keep track of what\'s going on, who is working on it, and what\'s done.',

              color: themeProvider.themeManager.placeholderTextColor,
              textAlign: TextAlign.center,
              type: FontStyle.Small,
              maxLines: 6,
            ),
          ),
          projectProvider.role != Role.admin &&
                  projectProvider.role != Role.member
              ? noPermsionToCreateWidget('issue', themeProvider)
              : GestureDetector(
                  onTap: () {
                    if (type == IssueCategory.myIssues) {
                      ref.watch(ProviderList.projectProvider).currentProject =
                          ref.watch(ProviderList.projectProvider).projects[0];
                      ref.watch(ProviderList.projectProvider).setState();
                    }

                    ref
                            .read(ProviderList.issuesProvider)
                            .createIssuedata['prioriry'] =
                        'de3c90cd-25cd-42ec-ac6c-a66caf8029bc';

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateIssue(
                                  projectId: projectId ??
                                      (type == IssueCategory.myIssues
                                          ? ref
                                              .read(
                                                  ProviderList.projectProvider)
                                              .projects[0]['id']
                                          : null),
                                  cycleId: cycleId,
                                  moduleId: moduleId,
                                  assignee: assignee,
                                  fromMyIssues: type == IssueCategory.myIssues,
                                )));
                  },
                  child: Container(
                    height: 40,
                    width: 150,
                    margin: const EdgeInsets.only(top: 30),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(buttonBorderRadiusMedium),
                      color: themeProvider.themeManager.primaryColour,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        CustomText('Add Issues',
                            type: FontStyle.Small,
                            fontWeight: FontWeightt.Medium,
                            overrride: true,
                            color: Colors.white)
                      ],
                    ),
                  ),
                ),
          (cycleId != null || moduleId != null) &&
                  (projectProvider.role == Role.admin ||
                      projectProvider.role == Role.member)
              ? GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.85,
                        minHeight: MediaQuery.of(context).size.height * 0.5,
                      ),
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (ctx) => IssuesListSheet(
                        // parent: false,
                        type: cycleId != null
                            ? IssueDetailCategory.addCycleIssue
                            : IssueDetailCategory.addModuleIssue,
                        issueId: '',
                        createIssue: false,
                        // blocking: true,
                      ),
                    );
                  },
                  child: Container(
                    width: 215,
                    height: 40,
                    margin: const EdgeInsets.only(top: 30),
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(buttonBorderRadiusMedium),
                      color: themeProvider.themeManager.primaryColour,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        CustomText('Add Existing Issues',
                            type: FontStyle.Small,
                            fontWeight: FontWeightt.Medium,
                            overrride: true,
                            color: Colors.white)
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  static Widget emptySubscribedIssue(
    WidgetRef ref,
  ) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    return Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 35),
            child: CustomText(
              'No Subscribed Issues',
              type: FontStyle.H5,
              fontWeight: FontWeightt.Semibold,
              color: themeProvider.themeManager.primaryTextColor,
            ),
          ),
          Container(
            width: 300,
            padding: const EdgeInsets.only(top: 10),
            child: CustomText(
              //create issues text
              'You have not subscribed to any issues yet. Subscribe to issues to get notified about any changes in the issue.',

              color: themeProvider.themeManager.placeholderTextColor,
              textAlign: TextAlign.center,
              type: FontStyle.Small,
              maxLines: 6,
            ),
          ),
        ],
      ),
    );
  }

  static Widget emptyModules(BuildContext context, WidgetRef ref) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final projectProvider = ref.watch(ProviderList.projectProvider);
    return Container(
      alignment: Alignment.center,
      child: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/svg_images/empty_modules.svg",
            width: 130,
          ),
          Container(
            padding: const EdgeInsets.only(top: 35),
            child: CustomText(
              'Modules',
              type: FontStyle.H5,
              fontWeight: FontWeightt.Semibold,
              color: themeProvider.themeManager.primaryTextColor,
            ),
          ),
          Container(
            width: 300,
            padding: const EdgeInsets.only(top: 10),
            child: CustomText(
              'Modules are smaller, focused projects that help you group and organize issues within a specific time frame.',
              color: themeProvider.themeManager.placeholderTextColor,
              textAlign: TextAlign.center,
              type: FontStyle.Small,
              maxLines: 3,
            ),
          ),
          projectProvider.role != Role.admin &&
                  projectProvider.role != Role.member
              ? noPermsionToCreateWidget('module', themeProvider)
              : GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateModule()));
                  },
                  child: Container(
                    height: 40,
                    width: 150,
                    margin: const EdgeInsets.only(top: 30),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(buttonBorderRadiusMedium),
                      color: themeProvider.themeManager.primaryColour,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        CustomText('Add Module',
                            type: FontStyle.Small,
                            fontWeight: FontWeightt.Medium,
                            overrride: true,
                            color: Colors.white)
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  static Widget emptyNotification(WidgetRef ref) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    return Container(
      alignment: Alignment.center,
      child: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/svg_images/empty_notification.svg",
            width: 130,
          ),
          Container(
            padding: const EdgeInsets.only(top: 35),
            child: CustomText(
              'Notifications',
              type: FontStyle.H5,
              fontWeight: FontWeightt.Semibold,
              color: themeProvider.themeManager.primaryTextColor,
            ),
          ),
          Container(
            width: 300,
            padding: const EdgeInsets.only(top: 10),
            child: const CustomText(
              "You're updated with all the notifications",
              color: Color.fromRGBO(133, 142, 150, 1),
              textAlign: TextAlign.center,
              type: FontStyle.Small,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }

  static Widget emptyPages(BuildContext context, WidgetRef ref) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    return Container(
      alignment: Alignment.center,
      child: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/svg_images/empty_pages.svg",
            width: 130,
          ),
          Container(
            padding: const EdgeInsets.only(top: 35),
            child: CustomText(
              'Pages',
              type: FontStyle.H5,
              fontWeight: FontWeightt.Semibold,
              color: themeProvider.themeManager.primaryTextColor,
            ),
          ),
          Container(
            width: 300,
            padding: const EdgeInsets.only(top: 10),
            child: CustomText(
              'Create and document issues effortlessly in one place with Plane Notes, AI-powered for ease.',
              color: themeProvider.themeManager.placeholderTextColor,
              maxLines: 3,
              textAlign: TextAlign.center,
              type: FontStyle.Small,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CreatePage()));
            },
            child: Container(
              height: 40,
              width: 150,
              margin: const EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(buttonBorderRadiusMedium),
                color: themeProvider.themeManager.primaryColour,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CustomText('Add Page',
                      type: FontStyle.Small,
                      fontWeight: FontWeightt.Medium,
                      overrride: true,
                      color: Colors.white)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  static Widget emptyView(BuildContext context, WidgetRef ref) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final projectProvider = ref.watch(ProviderList.projectProvider);
    return Container(
      alignment: Alignment.center,
      //  margin: const EdgeInsets.only(top: 150),
      child: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // Stack(
          //   children: [
          //     Container(
          //       margin: const EdgeInsets.only(left: 30),
          //       height: 85,
          //       width: 300,
          //       decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(6),
          //           border: Border.all(color: Colors.grey.shade300)),
          //       child: Container(
          //         padding: const EdgeInsets.only(left: 10, top: 10),
          //         child: const CustomText(
          //           'Completed Urgent Issues',
          //           type: FontStyle.XSmall,
          //           color: Color.fromRGBO(133, 142, 150, 1),
          //         ),
          //       ),
          //     ),
          //     Container(
          //       margin: const EdgeInsets.only(top: 30),
          //       height: 85,
          //       width: 300,
          //       decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(6),
          //           border: Border.all(color: Colors.grey.shade300)),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Container(
          //             padding: const EdgeInsets.only(left: 10, top: 10),
          //             child: const CustomText(
          //               'Active High Priority Issues',
          //               type: FontStyle.XSmall,
          //               color: Color.fromRGBO(133, 142, 150, 1),
          //             ),
          //           ),
          //           const SizedBox(
          //             height: 10,
          //           ),
          //           Container(
          //             margin: const EdgeInsets.only(left: 15, right: 15),
          //             child: SvgPicture.asset(
          //               "assets/svg_images/view_empty.svg",
          //               width: 300,
          //               fit: BoxFit.cover,
          //             ),
          //           )
          //         ],
          //       ),
          //     )
          //   ],
          // ),
          SvgPicture.asset(
            "assets/svg_images/empty_views.svg",
            width: 130,
          ),
          Container(
            padding: const EdgeInsets.only(top: 35),
            child: CustomText(
              'Views',
              type: FontStyle.H5,
              fontWeight: FontWeightt.Semibold,
              color: themeProvider.themeManager.primaryTextColor,
            ),
          ),
          Container(
            width: 300,
            padding: const EdgeInsets.only(top: 10),
            child: CustomText(
              'Views aid in saving your issues by applying various filters and grouping options.',
              textAlign: TextAlign.center,
              type: FontStyle.Small,
              color: themeProvider.themeManager.placeholderTextColor,
              maxLines: 3,
            ),
          ),
          projectProvider.role != Role.admin &&
                  projectProvider.role != Role.member
              ? noPermsionToCreateWidget('view', themeProvider)
              : GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateView()));
                  },
                  child: Container(
                    height: 40,
                    width: 150,
                    margin: const EdgeInsets.only(top: 30),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(buttonBorderRadiusMedium),
                      color: themeProvider.themeManager.primaryColour,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        CustomText('Add View',
                            type: FontStyle.Small,
                            overrride: true,
                            fontWeight: FontWeightt.Medium,
                            color: Colors.white),
                      ],
                    ),
                  ),
                )
        ],
      ),
    );
  }

  static Widget joinProject(
      BuildContext context, WidgetRef ref, String projectId, String slug) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    return Container(
      alignment: Alignment.center,
      child: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SvgPicture.asset("assets/svg_images/empty_project.svg"),
          Container(
            padding: const EdgeInsets.only(top: 35),
            width: width * 0.7,
            child: CustomText(
              'You are not a member of this project',
              type: FontStyle.H5,
              fontWeight: FontWeightt.Semibold,
              color: themeProvider.themeManager.primaryTextColor,
              textAlign: TextAlign.center,
              maxLines: 5,
            ),
          ),
          Container(
            width: 300,
            padding: const EdgeInsets.only(top: 10),
            child: const CustomText(
              'You are not a member of this project, but you can join this project by clicking the button below.',
              textAlign: TextAlign.center,
              type: FontStyle.Small,
              color: Color.fromRGBO(133, 142, 150, 1),
              maxLines: 3,
            ),
          ),
          GestureDetector(
            onTap: () {
              final issueProvider = ref.read(ProviderList.issuesProvider);
              issueProvider
                  .joinProject(projectId: projectId, slug: slug, refs: ref)
                  .then((_) {
                if (issueProvider.joinprojectState == StateEnum.success) {
                  CustomToast.showToast(context,
                      message: "joined project successfully",
                      toastType: ToastType.success);
                } else if (issueProvider.joinprojectState == StateEnum.error) {
                  CustomToast.showToast(context,
                      message: "Something gone wrong",
                      toastType: ToastType.failure);
                }
                ref.read(ProviderList.projectProvider).getProjects(slug: slug);
              });
            },
            child: Container(
              height: 40,
              width: 150,
              margin: const EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(buttonBorderRadiusMedium),
                color: themeProvider.themeManager.primaryColour,
              ),
              child: ref.watch(ProviderList.issuesProvider).joinprojectState ==
                      StateEnum.loading
                  ? const Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        CustomText('Click to join',
                            type: FontStyle.Small,
                            fontWeight: FontWeightt.Medium,
                            color: Colors.white),
                      ],
                    ),
            ),
          )
        ],
      ),
    );
  }

  static Widget emptyProject(
      BuildContext context, Future<void> Function() onRefresh, WidgetRef ref) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    return RefreshIndicator(
      color: themeProvider.themeManager.primaryColour,
      backgroundColor: themeProvider.themeManager.primaryBackgroundDefaultColor,
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height - 200,
          child: Wrap(
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/svg_images/empty_project.svg",
                width: 130,
              ),
              Container(
                padding: const EdgeInsets.only(top: 35),
                child: CustomText(
                  'No projects yet',
                  type: FontStyle.H5,
                  fontWeight: FontWeightt.Semibold,
                  color: themeProvider.themeManager.primaryTextColor,
                ),
              ),
              Container(
                width: 300,
                padding: const EdgeInsets.only(top: 10),
                child: CustomText(
                  'Get started by creating your first project.',
                  color: themeProvider.themeManager.placeholderTextColor,
                  textAlign: TextAlign.center,
                  type: FontStyle.Small,
                  maxLines: 3,
                ),
              ),
              !workspaceProvider.isAdminOrMember()
                  ? noPermsionToCreateWidget('project', themeProvider)
                  : GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CreateProject()));
                      },
                      child: Container(
                        height: 40,
                        width: 150,
                        margin: const EdgeInsets.only(top: 30),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(buttonBorderRadiusMedium),
                          color: themeProvider.themeManager.primaryColour,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 24,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            CustomText('Add Project',
                                type: FontStyle.Small,
                                overrride: true,
                                fontWeight: FontWeightt.Medium,
                                color: Colors.white)
                          ],
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  static Widget emptyFavoriteProject(
      BuildContext context, WidgetRef ref, Future<void> Function() onRefresh) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    return RefreshIndicator(
      color: themeProvider.themeManager.primaryColour,
      backgroundColor: themeProvider.themeManager.primaryBackgroundDefaultColor,
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height - 200,
          child: Column(
            children: [
              const Spacer(),
              SvgPicture.asset(
                "assets/svg_images/empty_project.svg",
                width: 130,
              ),
              Container(
                padding: const EdgeInsets.only(top: 35),
                child: CustomText(
                  'No Favorites yet',
                  type: FontStyle.Medium,
                  fontWeight: FontWeightt.Semibold,
                  color: themeProvider.themeManager.primaryTextColor,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  static Widget emptyUnstaredProject(
      BuildContext context, WidgetRef ref, Future<void> Function() onRefresh) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    return RefreshIndicator(
      color: themeProvider.themeManager.primaryColour,
      backgroundColor: themeProvider.themeManager.primaryBackgroundDefaultColor,
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height - 200,
          child: Column(
            children: [
              const Spacer(),
              SvgPicture.asset(
                "assets/svg_images/empty_project.svg",
                width: 130,
              ),
              Container(
                padding: const EdgeInsets.only(top: 35),
                child: CustomText(
                  'No  Projects yet',
                  type: FontStyle.H5,
                  fontWeight: FontWeightt.Semibold,
                  color: themeProvider.themeManager.primaryTextColor,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  static Widget emptyUnjoinedProject(
      BuildContext context, WidgetRef ref, Future<void> Function() onRefresh) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    return RefreshIndicator(
      color: themeProvider.themeManager.primaryColour,
      backgroundColor: themeProvider.themeManager.primaryBackgroundDefaultColor,
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          // color: Colors.black,
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height - 200,
          child: Column(
            children: [
              const Spacer(),
              SvgPicture.asset(
                "assets/svg_images/empty_project.svg",
                width: 130,
              ),
              Container(
                padding: const EdgeInsets.only(top: 35),
                child: CustomText(
                  'No Projects to Join',
                  type: FontStyle.Medium,
                  fontWeight: FontWeightt.Semibold,
                  color: themeProvider.themeManager.primaryTextColor,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  static Widget emptyLabels(BuildContext context, WidgetRef ref) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    return Container(
      alignment: Alignment.center,
      child: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/svg_images/labels_empty.svg",
            width: 130,
          ),
          Container(
            padding: const EdgeInsets.only(top: 35),
            child: CustomText(
              'No labels yet',
              type: FontStyle.H5,
              fontWeight: FontWeightt.Semibold,
              color: themeProvider.themeManager.primaryTextColor,
            ),
          ),
          Container(
            width: 300,
            padding: const EdgeInsets.only(top: 10),
            child: CustomText(
              'Create labels to help organize and filter issues in you project',
              color: themeProvider.themeManager.placeholderTextColor,
              textAlign: TextAlign.center,
              type: FontStyle.Small,
              maxLines: 3,
            ),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                enableDrag: true,
                isScrollControlled: true,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                context: context,
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: const CreateLabel(
                      method: CRUD.create,
                    ),
                  );
                },
              );
            },
            child: Container(
              height: 40,
              width: 150,
              margin: const EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(buttonBorderRadiusMedium),
                color: themeProvider.themeManager.primaryColour,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CustomText('Add Label',
                      type: FontStyle.Small,
                      overrride: true,
                      fontWeight: FontWeightt.Medium,
                      color: Colors.white)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
