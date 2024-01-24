import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plane/models/chart_model.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

  Widget progressWidget({required WidgetRef ref, required List<ChartData> chartData}) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: CustomText(
            'Progress',
            type: FontStyle.Medium,
            fontWeight: FontWeightt.Medium,
            color: themeProvider.themeManager.primaryTextColor,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding:
              const EdgeInsets.only(left: 20, right: 30, top: 35, bottom: 20),
          decoration: BoxDecoration(
            color: themeProvider.themeManager.primaryBackgroundDefaultColor,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: themeProvider.themeManager.borderSubtle01Color,
            ),
          ),
          child: SizedBox(
            height: 200,
            child: SfCartesianChart(
              plotAreaBorderColor: Colors.transparent,
              margin: EdgeInsets.zero,
              primaryYAxis: NumericAxis(
                majorGridLines:
                    const MajorGridLines(width: 0), // Remove major grid lines
              ),
              primaryXAxis: CategoryAxis(
                labelPlacement:
                    LabelPlacement.betweenTicks, // Adjust label placement
                interval: chartData.length > 5 ? 3 : 1,
                majorGridLines: const MajorGridLines(
                  width: 0,
                ), // Remove major grid lines
                minorGridLines: const MinorGridLines(width: 0),
                axisLabelFormatter: (axisLabelRenderArgs) {
                  return ChartAxisLabel(
                    DateFormat('dd MMM').format(
                      DateTime.parse(axisLabelRenderArgs.text),
                    ),
                    const TextStyle(fontWeight: FontWeight.normal),
                  );
                },
              ),
              series: <ChartSeries>[
                // Renders area chart
                AreaSeries<ChartData, DateTime>(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.transparent,
                      themeProvider.themeManager.primaryColour.withOpacity(0.2),
                      themeProvider.themeManager.primaryColour.withOpacity(0.3),
                    ],
                  ),
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                ),
                LineSeries<ChartData, DateTime>(
                  dashArray: [5.0, 5.0],
                  dataSource: chartData.isNotEmpty
                      ? <ChartData>[
                          ChartData(chartData.first.x,
                              chartData.first.y), // First data point
                          ChartData(chartData.last.x,
                              0.0), // Data point at current time with Y-value of last data point
                        ]
                      : [],
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  
  }
