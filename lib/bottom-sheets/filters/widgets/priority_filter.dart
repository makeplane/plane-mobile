import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/core/icons/priority_icon.dart';
import 'package:plane/models/project/issue-filter-properties-and-view/issue_filter_and_properties.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/widgets/custom_expansion_tile.dart';
import 'package:plane/widgets/rectangular_chip.dart';

class PriorityFilter extends ConsumerStatefulWidget {
  const PriorityFilter({required this.filter, required this.onChange});
  final FiltersModel filter;
  final Function(String priority) onChange;

  @override
  ConsumerState<PriorityFilter> createState() => _PriorityFilterState();
}

class _PriorityFilterState extends ConsumerState<PriorityFilter> {
  final priorities = ['urgent', 'high', 'medium', 'low', 'none'];

  @override
  Widget build(BuildContext context) {
    final themeManager = ref.read(ProviderList.themeProvider).themeManager;
    return CustomExpansionTile(
      title: 'Priority',
      child: Wrap(
          children: priorities
              .map((priority) => GestureDetector(
                  onTap: () => widget.onChange(priority),
                  child: RectangularChip(
                      ref: ref,
                      icon: PriorityIcon(priority),
                      text: priority,
                      color: widget.filter.priority.contains(priority)
                          ? themeManager.primaryColour
                          : themeManager.secondaryBackgroundDefaultColor,
                      selected: widget.filter.priority.contains(priority))))
              .toList()),
    );
  }
}
