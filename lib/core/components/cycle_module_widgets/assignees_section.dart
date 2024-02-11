import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/core/extensions/string_extensions.dart';
import 'package:plane/models/cycle/cycle_detail.model.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';
import 'completion_percentage.dart';

class ACycleCardAssigneesSection extends ConsumerStatefulWidget {
  const ACycleCardAssigneesSection({required this.activeCycle, super.key});
  final CycleDetailModel activeCycle;
  @override
  ConsumerState<ACycleCardAssigneesSection> createState() =>
      _ACycleCardAssigneesSectionState();
}

class _ACycleCardAssigneesSectionState
    extends ConsumerState<ACycleCardAssigneesSection> {
  @override
  Widget build(BuildContext context) {
    final themeManager = ref.read(ProviderList.themeProvider).themeManager;
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
              'Assignees',
              type: FontStyle.Medium,
              fontWeight: FontWeightt.Medium,
            )),
        children: [
          Container(
            color: themeManager.primaryBackgroundDefaultColor,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: widget.activeCycle.distribution == null ||
                    widget.activeCycle.distribution!.assignees.isEmpty
                ? Container(
                    padding: const EdgeInsets.only(left: 20, bottom: 20),
                    alignment: Alignment.center,
                    child: CustomText(
                      'No assignees',
                      color: themeManager.placeholderTextColor,
                    ),
                  )
                : Column(
                    children: widget.activeCycle.distribution!.assignees
                        .map(
                          (assignee) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: assignee.avatar.isNotEmpty
                                          ? CircleAvatar(
                                              radius: 10,
                                              backgroundImage:
                                                  NetworkImage(assignee.avatar),
                                            )
                                          : CircleAvatar(
                                              radius: 10,
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      29, 30, 32, 1),
                                              child: Center(
                                                child: CustomText(
                                                  assignee.display_name
                                                      .capitalize(),
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                    ),
                                    CustomText(
                                      assignee.display_name,
                                      fontWeight: FontWeightt.Regular,
                                      color: themeManager.secondaryTextColor,
                                      type: FontStyle.Large,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    CompletionPercentage(
                                        value:
                                            widget.activeCycle.completed_issues,
                                        totalValue:
                                            widget.activeCycle.total_issues),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
          )
        ],
      ),
    );
  }
}
