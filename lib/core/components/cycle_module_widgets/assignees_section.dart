// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/completion_percentage.dart';
import 'package:plane/widgets/custom_text.dart';

Widget assigneesWidget(
    {required WidgetRef ref,
    required Map detailData,
    required List<String> assignee_ids}) {
  final themeManager = ref.read(ProviderList.themeProvider).themeManager;
  return Column(
    children: [
      Align(
          alignment: Alignment.centerLeft,
          child: CustomText(
            'Assignees',
            type: FontStyle.Medium,
            fontWeight: FontWeightt.Medium,
            color: themeManager.primaryTextColor,
          )),
      const SizedBox(height: 10),
      detailData['assignees'].length == 0
          ? const CustomText('No data found.')
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: themeManager.primaryBackgroundDefaultColor,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: themeManager.borderSubtle01Color,
                ),
              ),
              child: Column(
                children: [
                  ...List.generate(
                    detailData['assignees'].length,
                    (idx) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: (assignee_ids
                                  .contains(detailData['assignees'][idx]
                                      ['assignee_id'])
                              ? themeManager.secondaryBackgroundDefaultColor
                              : themeManager.primaryBackgroundDefaultColor),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: detailData['assignees'][idx]
                                                    ['avatar'] !=
                                                null &&
                                            detailData['assignees'][idx]
                                                    ['avatar'] !=
                                                ''
                                        ? CircleAvatar(
                                            radius: 10,
                                            backgroundImage: NetworkImage(
                                                detailData['assignees'][idx]
                                                    ['avatar']),
                                          )
                                        : CircleAvatar(
                                            radius: 10,
                                            backgroundColor: themeManager
                                                .tertiaryBackgroundDefaultColor,
                                            child: Center(
                                              child: CustomText(
                                                detailData['assignees'][idx]
                                                            ['first_name'] !=
                                                        null
                                                    ? detailData['assignees']
                                                                [idx]
                                                            ['first_name'][0]
                                                        .toString()
                                                        .toUpperCase()
                                                    : '',
                                                type: FontStyle.Small,
                                              ),
                                            ),
                                          )),
                                CustomText(
                                  detailData['assignees'][idx]
                                          ['display_name'] ??
                                      'No Assignees',
                                  color: themeManager.secondaryTextColor,
                                ),
                              ],
                            ),
                            CompletionPercentage(
                              value: detailData['assignees'][idx]
                                  ['completed_issues'],
                              totalValue: detailData['assignees'][idx]
                                  ['total_issues'],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    ],
  );
}
