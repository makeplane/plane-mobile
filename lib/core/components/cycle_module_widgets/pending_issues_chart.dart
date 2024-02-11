import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plane/models/cycle/cycle_detail.model.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class _ChartData {
  _ChartData(this.x, this.y);
  final DateTime x;
  final int y;
}

class ACycleCardPendingIssuesChart extends ConsumerStatefulWidget {
  const ACycleCardPendingIssuesChart({required this.activeCycle, super.key});
  final CycleDetailModel activeCycle;
  @override
  ConsumerState<ACycleCardPendingIssuesChart> createState() =>
      _ACycleCardPendingIssuesChartState();
}

class _ACycleCardPendingIssuesChartState
    extends ConsumerState<ACycleCardPendingIssuesChart> {
  List<_ChartData> pendingIssuesChartData = [];

  @override
  void initState() {
    pendingIssuesChartData = widget
            .activeCycle.distribution?.completion_chart.entries
            .map((entry) =>
                _ChartData(DateTime.parse(entry.key), entry.value ?? 0))
            .toList() ??
        [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ref.watch(ProviderList.themeProvider).themeManager;
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        backgroundColor: themeManager.primaryBackgroundDefaultColor,
        collapsedBackgroundColor: themeManager.primaryBackgroundDefaultColor,
        iconColor: themeManager.primaryTextColor,
        collapsedIconColor: themeManager.primaryTextColor,
        title: Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              'Pending Issues - ${widget.activeCycle.total_issues - widget.activeCycle.completed_issues}',
              type: FontStyle.Medium,
              fontWeight: FontWeightt.Medium,
            )),
        children: [
          Container(
            color: themeManager.primaryBackgroundDefaultColor,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            alignment: Alignment.center,
            child: widget.activeCycle.total_issues -
                        widget.activeCycle.completed_issues ==
                    0
                ? Container(
                    padding: const EdgeInsets.only(left: 20, bottom: 20),
                    alignment: Alignment.center,
                    child: CustomText(
                      'No pending issues',
                      color: themeManager.placeholderTextColor,
                    ),
                  )
                : Column(children: [
                    const SizedBox(height: 10),
                    SizedBox(
                        height: 200,
                        child: SfCartesianChart(
                            primaryYAxis: NumericAxis(
                              majorGridLines: const MajorGridLines(
                                  width: 0), // Remove major grid lines
                            ),
                            primaryXAxis: CategoryAxis(
                                labelPlacement: LabelPlacement
                                    .betweenTicks, // Adjust label placement
                                interval:
                                    pendingIssuesChartData.length > 5 ? 3 : 1,
                                majorGridLines: const MajorGridLines(
                                  width: 0,
                                ), // Remove major grid lines
                                minorGridLines: const MinorGridLines(width: 0),
                                axisLabelFormatter: (axisLabelRenderArgs) {
                                  return ChartAxisLabel(
                                      DateFormat('dd MMM').format(
                                          DateTime.parse(
                                              axisLabelRenderArgs.text)),
                                      const TextStyle(
                                          fontWeight: FontWeight.normal));
                                }),
                            series: <ChartSeries>[
                              // Renders area chart
                              AreaSeries<_ChartData, DateTime>(
                                  gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.white.withOpacity(0.5),
                                        Colors.white.withOpacity(0.2),
                                        primaryColor.withOpacity(0.2),
                                        primaryColor.withOpacity(0.3),
                                      ]),
                                  dataSource: pendingIssuesChartData,
                                  xValueMapper: (_ChartData data, _) => data.x,
                                  yValueMapper: (_ChartData data, _) => data.y),
                              LineSeries<_ChartData, DateTime>(
                                dashArray: [5.0, 5.0],
                                dataSource: <_ChartData>[
                                  _ChartData(
                                      pendingIssuesChartData.first.x,
                                      pendingIssuesChartData
                                          .first.y), // First data point
                                  _ChartData(pendingIssuesChartData.last.x,
                                      0), // Data point at current time with Y-value of last data point
                                ],
                                xValueMapper: (_ChartData data, _) => data.x,
                                yValueMapper: (_ChartData data, _) => data.y,
                              ),
                            ])),
                  ]),
          )
        ],
      ),
    );
  }
}
