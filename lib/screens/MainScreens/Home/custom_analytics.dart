import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CustomAnalyticsWidget extends ConsumerStatefulWidget {
  const CustomAnalyticsWidget({super.key});

  @override
  ConsumerState<CustomAnalyticsWidget> createState() =>
      _CustomAnalyticsWidgetState();
}

class _CustomAnalyticsWidgetState extends ConsumerState<CustomAnalyticsWidget> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return ListView(
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {},
              child: Row(
                children: [
                  const CustomText('Filters'),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: themeProvider.isDarkThemeEnabled
                        ? Colors.white
                        : Colors.black,
                  )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        // chartWidget(),
        countWidget()
      ],
    );
  }

  Widget chartWidget() {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var prov = ref.watch(ProviderList.workspaceCustomAnalyticsProvider);

    List<Map<String, dynamic>> chartData = [];
    List newData = [];

    for (var item in prov.customData!.extras.assigneeDetails) {
      Map<String, dynamic> convertedIssue = {
        "assignees__avatar": item.avatar,
        "assignees__email": item.email,
        "assignees__first_name": item.firstName,
        "assignees__last_name": item.lastName
      };
      chartData.add(convertedIssue);
    }

    return Container(
      width: width,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color:
              themeProvider.isDarkThemeEnabled ? darkThemeBorder : strokeColor,
        ),
      ),
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
          // isVisible: false
        ),
        series: <ColumnSeries<Map<String, dynamic>, String>>[
          ColumnSeries<Map<String, dynamic>, String>(
            dataSource: chartData,
            xValueMapper: (Map<String, dynamic> issue, _) =>
                issue['assignees__first_name'],
            yValueMapper: (Map<String, dynamic> issue, _) => issue['count'],
            width: 0.2,
            spacing: 0.2,
          ),
        ],
      ),
    );
  }

  countWidget() {
    var prov = ref.watch(ProviderList.workspaceCustomAnalyticsProvider);

    List data = [];

    prov.customData!.distribution.forEach(
      (key, value) {
        data.add(value.first.count);
      },
    );

    return SizedBox(
      width: width,
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration:
                      BoxDecoration(border: Border.all(color: darkThemeBorder)),
                  child: const Row(
                    children: [
                      CustomText('Assignee'),
                    ],
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  primary: false,
                  shrinkWrap: true,
                  itemCount: prov.customData!.extras.assigneeDetails.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          border: Border.all(color: darkThemeBorder)),
                      child: CustomText(prov
                          .customData!.extras.assigneeDetails[index].firstName),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            width: 120,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration:
                      BoxDecoration(border: Border.all(color: darkThemeBorder)),
                  child: const Row(
                    children: [
                      CustomText('Issue count'),
                    ],
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: prov.customData!.distribution.length,
                  itemBuilder: (context, index) {
                    return index == prov.customData!.distribution.length - 1
                        ? Container()
                        : Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                border: Border.all(color: darkThemeBorder)),
                            child: CustomText(data[index].toString()),
                          );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
