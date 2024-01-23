// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/Cycles/project_details_cycles.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/Views/views.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/widgets/floating_action_button.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/empty.dart';
import 'widgets/project_detail_appbar.dart';
import 'widgets/project_detail_root.dart';

class ProjectDetail extends ConsumerStatefulWidget {
  const ProjectDetail({super.key, required this.index});
  final int index;

  @override
  ConsumerState<ProjectDetail> createState() => _ProjectDetailState();
}

class _ProjectDetailState extends ConsumerState<ProjectDetail> {
  final controller = PageController(initialPage: 0);
  int selectedTab = 0;

  void onTabChange(int index) {
    setState(() {
      selectedTab = index;
    });
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
    final issueProvider = ref.read(ProviderList.issuesProvider);
    final statesProvider = ref.read(ProviderList.statesProvider);
    issueProvider.orderByState = StateEnum.loading;
    statesProvider.statesState = StateEnum.restricted;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      issueProvider.setsState();
      statesProvider.statesState = StateEnum.restricted;
      ref.read(ProviderList.projectProvider).initializeProject(ref: ref);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider = ref.watch(ProviderList.projectProvider);
    final statesProvider = ref.watch(ProviderList.statesProvider);

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
              : ProjectDetailRoot(
                  onTabChange: onTabChange,
                  selectedTab: selectedTab,
                )),
    );
  }
}

Widget cycles() {
  return const CycleWidget();
}

Widget view(WidgetRef ref) {
  final themeProvider = ref.read(ProviderList.themeProvider);
  return Container(
    color: themeProvider.themeManager.primaryBackgroundDefaultColor,
    padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Views()
      ],
    ),
  );
}

