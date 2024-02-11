import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/core/extensions/string_extensions.dart';
import 'package:plane/models/cycle/cycle_detail.model.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';
import 'completion_percentage.dart';

class ACycleCardLabelsSection extends ConsumerStatefulWidget {
  const ACycleCardLabelsSection({required this.activeCycle, super.key});
  final CycleDetailModel activeCycle;

  @override
  ConsumerState<ACycleCardLabelsSection> createState() =>
      _ACycleCardLabelsSectionState();
}

class _ACycleCardLabelsSectionState
    extends ConsumerState<ACycleCardLabelsSection> {
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
        title: const Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              'Labels',
              type: FontStyle.Medium,
              fontWeight: FontWeightt.Medium,
            )),
        children: [
          Container(
            color: themeManager.primaryBackgroundDefaultColor,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                 widget.activeCycle.distribution == null ||
                widget.activeCycle.distribution!.labels.isEmpty
                    ? Container(
                        padding: const EdgeInsets.only(left: 20, bottom: 20),
                        alignment: Alignment.center,
                        child: CustomText(
                          'No Labels',
                          color: themeManager.placeholderTextColor,
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount:
                            widget.activeCycle.distribution!.labels.length,
                        itemBuilder: (context, index) {
                          final labelDistribution =
                              widget.activeCycle.distribution!.labels[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      size: 10,
                                      color: labelDistribution.color.isEmpty
                                          ? themeManager.placeholderTextColor
                                          : labelDistribution.color.toColor(),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      child: CustomText(
                                        labelDistribution.label_name,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    CompletionPercentage(
                                        value:
                                            widget.activeCycle.completed_issues,
                                        totalValue:
                                            widget.activeCycle.total_issues)
                                  ],
                                )
                              ],
                            ),
                          );
                        })
              ],
            ),
          )
        ],
      ),
    );
  }
}
