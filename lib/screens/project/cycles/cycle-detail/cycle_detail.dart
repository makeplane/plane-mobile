// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane/bottom-sheets/select_cycle_sheet.dart';
import 'package:plane/models/chart_model.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/project/issues/issue_detail.dart';
import 'package:plane/screens/project/issues/issues-root/cycle_issues_root.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_app_bar.dart';
import 'package:plane/widgets/custom_text.dart';
import 'widgets/cycle_detail_header_tabs.dart';
import 'package:plane/bottom-sheets/assignee_sheet.dart';
import 'package:plane/screens/project/widgets/assignee_widget.dart';
import 'package:plane/core/components/cycle_module_widgets/progress_chart_section.dart';
import 'package:plane/core/components/cycle_module_widgets/states_section.dart';
import 'package:plane/utils/extensions/string_extensions.dart';
import 'package:plane/widgets/completion_percentage.dart';
import 'package:plane/widgets/square_avatar_widget.dart';
/// Tabs
part './cycle-detail-tabs/cycle_detail_issues_tab.dart';
part './cycle-detail-tabs/cycle_detail_detail_tab.dart';

class CycleDetail extends ConsumerStatefulWidget {
  const CycleDetail(
      {super.key, this.cycleId, this.cycleName, this.projId, this.from});
  final String? cycleName;
  final String? cycleId;
  final String? projId;
  final PreviousScreen? from;

  @override
  ConsumerState<CycleDetail> createState() => _CycleDetailState();
}

class _CycleDetailState extends ConsumerState<CycleDetail> {
  List<ChartData> chartData = [];
  PageController pageController = PageController(initialPage: 0);
  int selectedTab = 0;
  DateTime? dueDate;
  DateTime? startDate;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getCycleData();
    });
    super.initState();
  }

  Future getCycleData() async {
    final cyclesProvider = ref.read(ProviderList.cyclesProvider);
    final cycleIssuesNotifer =
        ref.read(ProviderList.cycleIssuesProvider.notifier);

    cyclesProvider.cyclesDetailState = StateEnum.loading;
    pageController = PageController(
        initialPage: cyclesProvider.cycleDetailSelectedIndex,
        keepPage: true,
        viewportFraction: 1);

    await cyclesProvider
        .cycleDetailsCrud(
            slug: ref
                .read(ProviderList.workspaceProvider)
                .selectedWorkspace
                .workspaceSlug,
            projectId: widget.projId ??
                ref.read(ProviderList.projectProvider).currentProject['id'],
            method: CRUD.read,
            disableLoading: true,
            cycleId: widget.cycleId!)
        .then((value) => getChartData(cyclesProvider
            .cyclesDetailsData['distribution']['completion_chart']));

    cycleIssuesNotifer
        .fetchLayoutProperties()
        .then((value) => cycleIssuesNotifer.fetchIssues());
  }

  Future getChartData(Map<String, dynamic> data) async {
    data.forEach((key, value) {
      chartData.add(
          ChartData(DateTime.parse(key), value != null ? value.toDouble() : 0));
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final cyclesProvider = ref.watch(ProviderList.cyclesProvider);
    final projectProvider = ref.read(ProviderList.projectProvider);
    return Scaffold(
      floatingActionButton: cyclesProvider.cyclesIssueState ==
                  StateEnum.loading &&
              (cyclesProvider.cyclesDetailsData['backlog_issues'] != 0 &&
                  cyclesProvider.cyclesDetailsData['started_issues'] != 0 &&
                  cyclesProvider.cyclesDetailsData['unstarted_issues'] != 0)
          ? FloatingActionButton(
              backgroundColor: themeProvider.themeManager.primaryColour,
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  enableDrag: true,
                  constraints:
                      BoxConstraints(maxHeight: height * 0.8, minHeight: 250),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  context: context,
                  builder: (ctx) {
                    return const SelectCycleSheet();
                  },
                );
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: themeProvider.themeManager.primaryColour,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.error_outline_outlined,
                  color: Colors.white,
                ),
              ),
            )
          : null,
      appBar: CustomAppBar(
        centerTitle: true,
        onPressed: () {
          if (widget.from == PreviousScreen.myIssues) {
            Navigator.pop(context);
            return;
          }
          cyclesProvider.changeTabIndex(0);
          cyclesProvider.changeState(StateEnum.empty);
          Navigator.pop(context);
        },
        text: widget.projId == null
            ? projectProvider.currentProject['name']
            : projectProvider.projects.firstWhere(
                (element) => element['id'] == widget.projId)['name'],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CycleDetailTabs(
            onTabChange: (value) => setState(() {
              selectedTab = value;
            }),
            selectedTab: selectedTab,
            pageController: pageController,
            cycleName: widget.cycleName,
          ),
          Container(
            height: 2,
            width: MediaQuery.of(context).size.width,
            color: themeProvider.themeManager.borderSubtle01Color,
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (value) {
                if (value == 0) {
                  cyclesProvider.changeTabIndex(0);
                } else {
                  cyclesProvider.changeTabIndex(1);
                }
              },
              children: [
                const IssuesTAB(),
                const DetailsTAB()
                // CycleDetailsPage(
                //   cycleId: widget.cycleId!,
                //   chartData: chartData,
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
