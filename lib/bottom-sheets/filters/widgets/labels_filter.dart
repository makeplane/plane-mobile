import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/models/project/issue-filter-properties-and-view/issue_filter_and_properties.dart';
import 'package:plane/models/project/label/label.model.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/core/extensions/string_extensions.dart';
import 'package:plane/widgets/custom_expansion_tile.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/rectangular_chip.dart';

class LabelFilter extends ConsumerStatefulWidget {
  const LabelFilter(
      {required this.filter, required this.labels, required this.onChange,super.key});
  final FiltersModel filter;
  final List<LabelModel> labels;
  final Function(String labelId) onChange;

  @override
  ConsumerState<LabelFilter> createState() => _LabelFilterState();
}

class _LabelFilterState extends ConsumerState<LabelFilter> {
  @override
  Widget build(BuildContext context) {
    final themeManager = ref.read(ProviderList.themeProvider).themeManager;
    return CustomExpansionTile(
      title: 'Labels',
      child: widget.labels.isEmpty
          ? Container(
              padding: const EdgeInsets.only(left: 25),
              child: CustomText(
                'No labels yet',
                color: themeManager.placeholderTextColor,
              ),
            )
          : Wrap(
              children: widget.labels
                  .map((label) => GestureDetector(
                        onTap: () => widget.onChange(label.id),
                        child: RectangularChip(
                          ref: ref,
                          icon: CircleAvatar(
                              radius: 5,
                              backgroundColor: label.color.toColor()),
                          text: label.name,
                          selected: widget.filter.labels.contains(label.id),
                          color: widget.filter.labels.contains(label.id)
                              ? themeManager.primaryColour
                              : themeManager.secondaryBackgroundDefaultColor,
                        ),
                      ))
                  .toList()),
    );
  }
}
