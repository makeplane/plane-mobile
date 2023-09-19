import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:plane/config/const.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/CyclesTab/cycle_detail.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/IssuesTab/issue_detail.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:url_launcher/url_launcher.dart';

class OverViewScreen extends ConsumerStatefulWidget {
  final String userId;
  const OverViewScreen({required this.userId, super.key});

  @override
  ConsumerState<OverViewScreen> createState() => _OverViewScreenState();
}

class _OverViewScreenState extends ConsumerState<OverViewScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userProfileProvider = ref.watch(ProviderList.memberProfileProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Material(
      color: themeProvider.themeManager.primaryBackgroundDefaultColor,
      child: Container(
        color: themeProvider.themeManager.primaryBackgroundDefaultColor,
        child: userProfileProvider.getUserStatsState == StateEnum.loading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              )
            : Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      overViewWidget(),
                      const SizedBox(
                        height: 20,
                      ),
                      workloadWidget(),
                      const SizedBox(
                        height: 30,
                      ),
                      issueByPriorityWidget(),
                      const SizedBox(
                        height: 30,
                      ),
                      issuesByStateWidget(),
                      const SizedBox(
                        height: 30,
                      ),
                      userProfileProvider.userActivity.results!.isEmpty
                          ? Container()
                          : recentActivityWidget()
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget overViewWidget() {
    var userProfileProvider = ref.watch(ProviderList.memberProfileProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          'Overview',
          type: FontStyle.Large,
          color: themeProvider.themeManager.primaryTextColor,
        ),
        const SizedBox(
          height: 20,
        ),
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          primary: false,
          itemCount: 3,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: themeProvider.themeManager.borderSubtle01Color,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: themeProvider
                          .themeManager.tertiaryBackgroundDefaultColor,
                    ),
                    child: Icon(
                      index == 0
                          ? LucideIcons.plusSquare
                          : index == 1
                              ? LucideIcons.userCircle2
                              : LucideIcons.userPlus2,
                      color: themeProvider.themeManager.primaryTextColor,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        index == 0
                            ? 'Issues Created'
                            : index == 1
                                ? 'Issues Assinged'
                                : 'Issues Subscribed',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomText(
                        index == 0
                            ? userProfileProvider.userStats.createdIssues
                                .toString()
                            : index == 1
                                ? userProfileProvider.userStats.assignedIssues
                                    .toString()
                                : userProfileProvider.userStats.subscribedIssues
                                    .toString(),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        )
      ],
    );
  }

  Widget workloadWidget() {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var userProfileProvider = ref.watch(ProviderList.memberProfileProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText('Workload'),
        const SizedBox(
          height: 20,
        ),
        GridView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: userProfileProvider.issuesCountByState.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.9,
          ),
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: themeProvider.themeManager.borderSubtle01Color,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: userProfileProvider.issuesCountByState[index]
                          ['color'],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        userProfileProvider.issuesCountByState[index]['state'],
                        textAlign: TextAlign.start,
                      ),
                      CustomText(
                        userProfileProvider.issuesCountByState[index]['count']
                            .toString(),
                        type: FontStyle.Large,
                      )
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget issueByPriorityWidget() {
    // var themeProvider = ref.watch(ProviderList.themeProvider);
    var userProfileProvider = ref.watch(ProviderList.memberProfileProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText('Issues by priority'),
        const SizedBox(
          height: 20,
        ),
        SfCartesianChart(
          margin: EdgeInsets.zero,
          borderWidth: 0,
          primaryXAxis: CategoryAxis(
            isVisible: true,
            majorGridLines: const MajorGridLines(
              width: 0,
              color: Colors.red,
            ),
          ),
          series: <ChartSeries>[
            ColumnSeries<Map<String, dynamic>, String>(
              dataSource: userProfileProvider.issuesByPriority,
              
              xValueMapper: (Map<String, dynamic> priority, _) =>
                  priority['priority'].toString().replaceAll(
                        priority['priority'][0],
                        priority['priority'][0].toString().toUpperCase(),
                      ),
              yValueMapper: (Map<String, dynamic> priority, _) =>
                  priority['priority_count'],
              pointColorMapper: (Map<String, dynamic> priority, _) =>
                  priority['color'],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              width: userProfileProvider.issuesByPriority.length == 1
                  ? 0.2
                  : userProfileProvider.issuesByPriority.length == 2
                      ? 0.3
                      : 0.5,
            ),
          ],
        )
      ],
    );
  }

  Widget issuesByStateWidget() {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var userProfileProvider = ref.watch(ProviderList.memberProfileProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText('Issues by state'),
        const SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: themeProvider.themeManager.borderSubtle01Color),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                height: 140,
                child: SfCircularChart(
                  margin: EdgeInsets.zero,
                  series: <CircularSeries>[
                    DoughnutSeries<Map<String, dynamic>, String>(
                      dataSource: userProfileProvider.issuesCountByState,
                      xValueMapper: (Map<String, dynamic> data, _) =>
                          data['state'],
                      yValueMapper: (Map<String, dynamic> data, _) =>
                          data['count'],
                      pointColorMapper: (Map<String, dynamic> data, _) =>
                          data['color'],
                      dataLabelMapper: (Map<String, dynamic> data, _) =>
                          data['state_group'],
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: false),
                      innerRadius: '35',
                      radius: '60',
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  primary: false,
                  shrinkWrap: true,
                  itemCount: userProfileProvider.issuesCountByState.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: userProfileProvider
                                      .issuesCountByState[index]['color'],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              CustomText(
                                userProfileProvider.issuesCountByState[index]
                                    ['state'],
                                type: FontStyle.Small,
                              )
                            ],
                          ),
                          CustomText(
                            userProfileProvider.issuesCountByState[index]
                                    ['count']
                                .toString(),
                            type: FontStyle.Small,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget recentActivityWidget() {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var userProfileProvider = ref.watch(ProviderList.memberProfileProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText('Recent Activity'),
        const SizedBox(
          height: 20,
        ),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(
                color: themeProvider.themeManager.borderSubtle01Color),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            primary: false,
            shrinkWrap: true,
            itemCount: userProfileProvider.userActivity.results!.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () async {
                  if (userProfileProvider.userActivity.results![index].field ==
                          'link' ||
                      (userProfileProvider.userActivity.results![index].field ==
                              'attachment' &&
                          userProfileProvider
                                  .userActivity.results![index].verb ==
                              'created')) {
                    var url = userProfileProvider
                            .userActivity.results![index].newValue ??
                        userProfileProvider
                            .userActivity.results![index].oldValue;
                    await launchUrl(Uri.parse(url.toString()));
                  }
                  if (userProfileProvider.userActivity.results![index].field ==
                      'modules') {
                    Navigator.push(
                      Const.globalKey.currentContext!,
                      MaterialPageRoute(
                          builder: (context) => CycleDetail(
                                fromModule: true,
                                projId: userProfileProvider.userActivity
                                    .results![index].projectDetail!.id,
                                moduleId: userProfileProvider.userActivity
                                        .results![index].newIdentifier ??
                                    userProfileProvider.userActivity
                                        .results![index].oldIdentifier,
                                moduleName: userProfileProvider.userActivity
                                            .results![index].newValue !=
                                        ''
                                    ? userProfileProvider
                                        .userActivity.results![index].newValue
                                    : userProfileProvider.userActivity
                                            .results![index].oldValue ??
                                        '',
                              )),
                    );
                  }
                  if (userProfileProvider.userActivity.results![index].field ==
                      'cycles') {
                    Navigator.push(
                      Const.globalKey.currentContext!,
                      MaterialPageRoute(
                          builder: (context) => CycleDetail(
                                fromModule: false,
                                projId: userProfileProvider.userActivity
                                    .results![index].projectDetail!.id,
                                cycleId: userProfileProvider.userActivity
                                        .results![index].newIdentifier ??
                                    userProfileProvider.userActivity
                                        .results![index].oldIdentifier,
                                cycleName: userProfileProvider.userActivity
                                            .results![index].newValue !=
                                        ''
                                    ? userProfileProvider
                                        .userActivity.results![index].newValue
                                    : userProfileProvider.userActivity
                                            .results![index].oldValue ??
                                        '',
                              )),
                    );
                  }
                  if (userProfileProvider.userActivity.results![index].comment!
                          .contains('created the issue') ||
                      userProfileProvider.userActivity.results![index].field ==
                          'state' ||
                      userProfileProvider.userActivity.results![index].field ==
                          'start_date' ||
                      userProfileProvider.userActivity.results![index].field ==
                          'target_date' ||
                      userProfileProvider.userActivity.results![index].field ==
                          'assignees' ||
                      userProfileProvider.userActivity.results![index].field ==
                          'description' ||
                      userProfileProvider.userActivity.results![index].field ==
                          'name' ||
                      userProfileProvider.userActivity.results![index].field ==
                          'priority' ||
                      userProfileProvider.userActivity.results![index].field ==
                          'parent' ||
                      userProfileProvider.userActivity.results![index].field ==
                          'blocking' ||
                      userProfileProvider.userActivity.results![index].field ==
                          'blocks' ||
                      userProfileProvider.userActivity.results![index].field ==
                          'labels' ||
                      userProfileProvider.userActivity.results![index].field ==
                          'blocks' ||
                      (userProfileProvider.userActivity.results![index].field ==
                              'attachment' &&
                          userProfileProvider
                                  .userActivity.results![index].verb ==
                              'deleted')) {
                    Navigator.push(
                      Const.globalKey.currentContext!,
                      MaterialPageRoute(
                        builder: (context) => IssueDetail(
                          ref: ref.read(ProviderList.workspaceProvider).ref!,
                          from: PreviousScreen.userProfile,
                          appBarTitle: userProfileProvider
                              .userActivity.results![index].issueDetail!.name!,
                          projID: userProfileProvider
                              .userActivity.results![index].projectDetail!.id,
                          issueId: userProfileProvider
                              .userActivity.results![index].issueDetail!.id!,
                        ),
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: userProfileProvider.userActivity.results![index]
                                        .actorDetail!.avatar !=
                                    null &&
                                userProfileProvider.userActivity.results![index]
                                        .actorDetail!.avatar! !=
                                    ''
                            ? ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                child: Image.network(
                                  userProfileProvider.userActivity
                                      .results![index].actorDetail!.avatar!,
                                  fit: BoxFit.cover,
                                  height: 20,
                                  width: 20,
                                ),
                              )
                            : Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: themeProvider.themeManager
                                      .tertiaryBackgroundDefaultColor,
                                  border: Border.all(
                                    color: themeProvider
                                        .themeManager.primaryTextColor,
                                  ),
                                ),
                                child: Center(
                                  child: CustomText(
                                    userProfileProvider
                                        .userActivity
                                        .results![index]
                                        .actorDetail!
                                        .displayName![0],
                                    type: FontStyle.Small,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: width * 0.75,
                            child: CustomText(
                              userProfileProvider
                                          .userActivity.results![index].field ==
                                      'description'
                                  ? '${userProfileProvider.userActivity.results![index].actorDetail!.displayName!} ${userProfileProvider.userActivity.results![index].verb} the ${userProfileProvider.userActivity.results![index].field} for ${userProfileProvider.userActivity.results![index].projectDetail!.identifier}-${userProfileProvider.userActivity.results![index].issueDetail!.sequenceId.toString()}'
                                  : '${userProfileProvider.userActivity.results![index].actorDetail!.displayName!} ${userProfileProvider.userActivity.results![index].comment!} for ${userProfileProvider.userActivity.results![index].projectDetail!.identifier}-${userProfileProvider.userActivity.results![index].issueDetail!.sequenceId.toString()}',
                              maxLines: 2,
                              type: FontStyle.Small,
                            ),
                          ),
                          CustomText(
                            checkTimeDifferenc(userProfileProvider
                                .userActivity.results![index].createdAt!),
                            type: FontStyle.XSmall,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  String checkTimeDifferenc(String dateTime) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(DateTime.parse(dateTime));
    String? format;

    if (difference.inDays > 0) {
      format = '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      format = '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      format = '${difference.inMinutes} minutes ago';
    } else {
      format = '${difference.inSeconds} seconds ago';
    }

    return format;
  }
}
