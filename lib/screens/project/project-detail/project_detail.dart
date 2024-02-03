// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/project/cycles/project_details_cycles.dart';
import 'package:plane/screens/project/issues/issues-root/project_issues_root.dart';
import 'package:plane/screens/project/modules/project_detail_modules.dart';
import 'package:plane/screens/project/views/project_views.dart';
import 'package:plane/screens/project/widgets/issues_layout_bottom_actions.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/empty.dart';
import 'package:plane/widgets/error_state.dart';
import '../widgets/floating_action_button.dart';
import 'widgets/project_detail_appbar.dart';

class ProjectDetail extends ConsumerStatefulWidget {
  const ProjectDetail({super.key, required this.index});
  final int index;

  @override
  ConsumerState<ProjectDetail> createState() => _ProjectDetailState();
}

class _ProjectDetailState extends ConsumerState<ProjectDetail> {
  int selectedTab = 0;
  final PageController pageController = PageController(initialPage: 0);
  List TABS = [];

  void initializeTabs() {
    final projectProvider = ref.read(ProviderList.projectProvider);
    TABS = [
      {
        'title': 'Issues',
        'show': true,
      },
      {
        'title': 'Cycles',
        'show': projectProvider.features[1]['show'],
      },
      {
        'title': 'Modules',
        'show': projectProvider.features[2]['show'],
      },
      {
        'title': 'Views',
        'show': projectProvider.features[3]['show'],
      },
    ];
  }

  void settingsOntap() {
    final projectProvider = ref.read(ProviderList.projectProvider);
    int count = 0;
    for (int i = 0; i < projectProvider.features.length; i++) {
      if (projectProvider.features[i]['show']) {
        count++;
      }
    }
    if (count < selectedTab + 1) {
      setState(() {
        selectedTab = count - 1;
      });
    }
  }

  @override
  void initState() {
    initializeTabs();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(ProviderList.projectProvider).initializeProject(ref: ref);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider = ref.watch(ProviderList.projectProvider);
    final statesProvider = ref.watch(ProviderList.statesProvider);
    final themeManager = ref.watch(ProviderList.themeProvider).themeManager;
    final issuesProvider =
        ref.watch(ProviderList.projectIssuesProvider.notifier);
    final issuesState = ref.watch(ProviderList.projectIssuesProvider);

    return Scaffold(
      appBar: ProjectDetailAppbar(
        context,
        ref: ref,
        settingsOntap: settingsOntap,
      ),
      floatingActionButton:
          FLActionButton(context, ref: ref, selected: selectedTab),
      body: SafeArea(
          child: statesProvider.statesState == StateEnum.restricted
              ? EmptyPlaceholder.joinProject(
                  context,
                  ref,
                  projectProvider.currentProject['id'],
                  ref
                      .read(ProviderList.workspaceProvider)
                      .selectedWorkspace
                      .workspaceSlug)
              : projectProvider.projectDetailState == StateEnum.error
                  ? errorState(
                      context: context,
                      ontap: () {
                        ref
                            .read(ProviderList.projectProvider)
                            .initializeProject(ref: ref);
                      })
                  : Column(
                      children: [
                        statesProvider.statesState != StateEnum.loading
                            ? Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: TABS.map((tab) {
                                  final tabIndex = TABS.indexOf(tab);
                                  return tab['show']
                                      ? Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedTab = tabIndex;
                                              });
                                              pageController.animateToPage(
                                                  tabIndex,
                                                  duration: const Duration(
                                                    milliseconds: 200,
                                                  ),
                                                  curve: Curves.easeIn);
                                            },
                                            child: Column(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(vertical: 8),
                                                  child: CustomText(
                                                    tab['title'],
                                                    color: tabIndex ==
                                                            selectedTab
                                                        ? themeManager
                                                            .primaryColour
                                                        : themeManager
                                                            .placeholderTextColor,
                                                    overrride: true,
                                                    type: FontStyle.Medium,
                                                    fontWeight:
                                                        tabIndex == selectedTab
                                                            ? FontWeightt.Medium
                                                            : null,
                                                  ),
                                                ),
                                                selectedTab ==
                                                            TABS.indexOf(tab) &&
                                                        TABS.elementAt(
                                                            tabIndex)['show']
                                                    ? Container(
                                                        height: 6,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: themeManager
                                                              .primaryColour,
                                                        ),
                                                      )
                                                    : Container(
                                                        height: 6,
                                                      )
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container();
                                }).toList(),
                              )
                            : Container(),
                        Container(
                          height: 2,
                          width: MediaQuery.of(context).size.width,
                          color: themeManager.borderSubtle01Color,
                        ),
                        Expanded(
                          child: PageView.builder(
                            controller: pageController,
                            onPageChanged: (page) {
                              setState(() {
                                selectedTab = page;
                              });
                            },
                            itemBuilder: (ctx, index) {
                              switch (index) {
                                case 0:
                                  return const ProjectIssuesRoot();
                                case 1:
                                  return const CycleWidget();
                                case 2:
                                  return const ModuleScreen();
                                case 3:
                                  return const Views();
                                default:
                                  return Container();
                              }
                            },
                            itemCount: TABS.length,
                          ),
                        ),
                        IssuesLayoutBottomActions(
                            selectedTab: selectedTab,
                            issuesProvider: issuesProvider,
                            issuesState: issuesState)
                      ],
                    )),
    );
  }
}
