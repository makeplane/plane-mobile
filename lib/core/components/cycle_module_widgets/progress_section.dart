import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/core/extensions/string_extensions.dart';
import 'package:plane/core/icons/state_group_icon.dart';
import 'package:plane/models/cycle/cycle_detail.model.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/provider/states/project_states_state.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/core/components/cycle_module_widgets/completion_percentage.dart';
import 'package:plane/widgets/custom_progress_bar.dart';
import 'package:plane/widgets/custom_text.dart';

class ACycleCardProgressSection extends ConsumerStatefulWidget {
  const ACycleCardProgressSection({required this.activeCycle, super.key});
  final CycleDetailModel activeCycle;
  @override
  ConsumerState<ACycleCardProgressSection> createState() =>
      _ACycleCardProgressSectionState();
}

class _ACycleCardProgressSectionState
    extends ConsumerState<ACycleCardProgressSection> {
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomText(
              'Progress',
              type: FontStyle.Medium,
              fontWeight: FontWeightt.Medium,
            ),
            CustomProgressBar.withColorOverride(
              width: MediaQuery.sizeOf(context).width * 0.5,
              itemValue: [
                widget.activeCycle.backlog_issues,
                widget.activeCycle.unstarted_issues,
                widget.activeCycle.started_issues,
                widget.activeCycle.cancelled_issues,
                widget.activeCycle.completed_issues,
              ],
              itemColors: const [
                Color(0xFFCED4DA),
                Color(0xFF26B5CE),
                Color(0xFFF7AE59),
                Color(0xFFD687FF),
                Color(0xFF09A953)
              ],
            )
          ],
        ),
        children: [
          Container(
            color: themeManager.primaryBackgroundDefaultColor,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: defaultStateGroups.map((group) {
                return Row(
                  children: [
                    const SizedBox(height: 40),
                    Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: StateGroupIcon(
                            group,
                            group == 'backlog'
                                ? const Color(0xFFCED4DA)
                                : group == 'unstarted'
                                    ? const Color(0xFF26B5CE)
                                    : group == 'started'
                                        ? const Color(0xFFF7AE59)
                                        : group == 'cancelled'
                                            ? const Color(0xFFD687FF)
                                            : const Color(0xFF09A953))),
                    CustomText(
                      group.capitalize(),
                      color: themeManager.secondaryTextColor,
                      type: FontStyle.Small,
                    ),
                    const Spacer(),
                    CompletionPercentage(
                        value: group == 'backlog'
                            ? widget.activeCycle.backlog_issues
                            : group == 'unstarted'
                                ? widget.activeCycle.unstarted_issues
                                : group == 'started'
                                    ? widget.activeCycle.started_issues
                                    : group == 'cancelled'
                                        ? widget.activeCycle.cancelled_issues
                                        : widget.activeCycle.completed_issues,
                        totalValue: widget.activeCycle.total_issues)
                  ],
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
