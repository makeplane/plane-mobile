import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/completion_percentage.dart';
import 'package:plane/widgets/custom_text.dart';

Widget statesWidget({required WidgetRef ref, required Map detailData}) {
  final List states = [
      "Backlog",
      "Unstarted",
      "Started",
      "Cancelled",
      "Completed",
    ];
    final themeProvider = ref.watch(ProviderList.themeProvider);

    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              'States',
              type: FontStyle.Medium,
              fontWeight: FontWeightt.Medium,
              color: themeProvider.themeManager.primaryTextColor,
            )),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: themeProvider.themeManager.primaryBackgroundDefaultColor,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: themeProvider.themeManager.borderSubtle01Color,
            ),
          ),
          child: Column(
            children: [
              ...List.generate(
                states.length,
                (index) => Row(
                  children: [
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: SvgPicture.asset(
                          states[index] == 'Backlog'
                              ? 'assets/svg_images/circle.svg'
                              : states[index] == 'Unstarted'
                                  ? 'assets/svg_images/in_progress.svg'
                                  : states[index] == 'Started'
                                      ? 'assets/svg_images/done.svg'
                                      : states[index] == 'Cancelled'
                                          ? 'assets/svg_images/cancelled.svg'
                                          : 'assets/svg_images/circle.svg',
                          height: 22,
                          width: 22,
                          colorFilter: ColorFilter.mode(
                              index == 0
                                  ? const Color(0xFFCED4DA)
                                  : index == 1
                                      ? const Color(0xFF26B5CE)
                                      : index == 2
                                          ? const Color(0xFFF7AE59)
                                          : index == 3
                                              ? const Color(0xFFD687FF)
                                              : greenHighLight,
                              BlendMode.srcIn)),
                    ),
                    CustomText(
                      states[index],
                      type: FontStyle.Large,
                      fontWeight: FontWeightt.Regular,
                      color: themeProvider.themeManager.secondaryTextColor,
                    ),
                    const Spacer(),
                    index == 0
                        ? CompletionPercentage(
                            value: detailData['backlog_issues'],
                            totalValue: detailData['total_issues'])
                        : index == 1
                            ? CompletionPercentage(
                                value: detailData['unstarted_issues'],
                                totalValue: detailData['total_issues'])
                            : index == 2
                                ? CompletionPercentage(
                                    value: detailData['started_issues'],
                                    totalValue: detailData['total_issues'])
                                : index == 3
                                    ? CompletionPercentage(
                                        value: detailData['cancelled_issues'],
                                        totalValue: detailData['total_issues'])
                                    : CompletionPercentage(
                                        value: detailData['completed_issues'],
                                        totalValue: detailData['total_issues'],
                                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
}
