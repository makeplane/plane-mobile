// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/project/issues/issues-root/cycle_issues_root.dart';
import 'package:plane/widgets/custom_app_bar.dart';
import 'package:plane/widgets/loading_widget.dart';
import 'widgets/cycle_detail_header_tabs.dart';

/// Tabs
part 'cycle-detail-tabs/issues_tab.dart';
part 'cycle-detail-tabs/detail_tab.dart';

class CycleDetail extends ConsumerStatefulWidget {
  const CycleDetail({super.key, required this.cycleId});
  final String cycleId;

  @override
  ConsumerState<CycleDetail> createState() => _CycleDetailState();
}

class _CycleDetailState extends ConsumerState<CycleDetail> {
  PageController pageController =
      PageController(initialPage: 0, keepPage: true, viewportFraction: 1);
  int selectedTab = 0;

  Future<void> fetchcycleDetails() async {
    final cycleNotifier = ref.read(ProviderList.cycleProvider.notifier);
    final cycleIssuesNotifer =
        ref.read(ProviderList.cycleIssuesProvider.notifier);
    // Fetch cycle details
    await cycleNotifier.fetchCycleDetails(widget.cycleId);
    // Fetch cycle-issues-layout-properties
    await cycleIssuesNotifer.fetchLayoutProperties();
    // Fetch cycle-issues
    await cycleIssuesNotifer.fetchIssues();
  }

  @override
  void initState() {
    fetchcycleDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final projectProvider = ref.read(ProviderList.projectProvider);
    final cycleDetails = ref.watch(ProviderList.cycleProvider
        .select((value) => value.currentCycleDetails));

    return Scaffold(
      floatingActionButton: cycleDetails != null &&
              (cycleDetails.backlog_issues != 0 &&
                  cycleDetails.started_issues != 0 &&
                  cycleDetails.unstarted_issues != 0)
          ? FloatingActionButton(
              backgroundColor: themeProvider.themeManager.primaryColour,
              onPressed: () {
                //TODO: tranfer issues
                // showModalBottomSheet(
                //   isScrollControlled: true,
                //   enableDrag: true,
                //   constraints:
                //       BoxConstraints(maxHeight: height * 0.8, minHeight: 250),
                //   shape: const RoundedRectangleBorder(
                //     borderRadius: BorderRadius.only(
                //       topLeft: Radius.circular(30),
                //       topRight: Radius.circular(30),
                //     ),
                //   ),
                //   context: context,
                //   builder: (ctx) {
                //     return  SelectCycleSheet();
                //   },
                // );
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
          Navigator.pop(context);
        },
        text: projectProvider.currentProject['name'],
      ),
      body: LoadingWidget(
        loading: cycleDetails == null,
        widgetClass: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CycleDetailTabs(
              onTabChange: (value) => setState(() {
                selectedTab = value;
              }),
              selectedTab: selectedTab,
              pageController: pageController,
              cycleName: cycleDetails!.name,
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
                  setState(() {
                    selectedTab = value;
                  });
                },
                children: const [IssuesTAB(), DetailsTAB()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
