// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/Cycles/project_details_cycles.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/Issues/issues_tab.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/Modules/module_screen.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/Views/views.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/models/project_detail_models.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/widgets/project_detail_bottom_actions.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/widgets/project_detail_tabs.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/error_state.dart';

class ProjectDetailRoot extends ConsumerStatefulWidget {
  const ProjectDetailRoot(
      {required this.onTabChange, required this.selectedTab, super.key});
  final int selectedTab;
  final void Function(int index) onTabChange;

  @override
  ConsumerState<ProjectDetailRoot> createState() => _ProjectDetailRootState();
}

class _ProjectDetailRootState extends ConsumerState<ProjectDetailRoot> {
  List<ProjectDetailTab> TABS = [];
  final controller = PageController();

  void initializeTabs() {
    final projectProvider = ref.read(ProviderList.projectProvider);
    TABS = [
      ProjectDetailTab(title: 'Issues', width: 60, show: true),
      ProjectDetailTab(
          title: 'Cycles',
          width: 60,
          show: projectProvider.features[1]['show']),
      ProjectDetailTab(
          title: 'Modules',
          width: 75,
          show: projectProvider.features[2]['show']),
      ProjectDetailTab(
          title: 'Views', width: 60, show: projectProvider.features[3]['show']),
    ];
  }

  @override
  void initState() {
    initializeTabs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final projectProvider = ref.watch(ProviderList.projectProvider);
    final statesProvider = ref.watch(ProviderList.statesProvider);

    return projectProvider.projectDetailState == StateEnum.error
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
                  ? ProjectDetailTabs(
                      selectedTab: widget.selectedTab,
                      onTabChange: widget.onTabChange,
                      TABS: TABS,
                    )
                  : Container(),
              Container(
                height: 2,
                width: MediaQuery.of(context).size.width,
                color: themeProvider.themeManager.borderSubtle01Color,
              ),
              Expanded(
                child: PageView.builder(
                  controller: controller,
                  onPageChanged: (page) {
                    widget.onTabChange(page);
                  },
                  itemBuilder: (ctx, index) {
                    return widget.selectedTab == 0
                        ? const IssuesTab()
                        : widget.selectedTab == 1
                            ? const CycleWidget()
                            : widget.selectedTab == 2
                                ? const ModuleScreen()
                                : widget.selectedTab == 3
                                    ? const Views()
                                    : Container();
                  },
                  itemCount: TABS.length,
                ),
              ),
              ProjectDetailBottomActions(selectedTab: widget.selectedTab)
            ],
          );
  }
}
