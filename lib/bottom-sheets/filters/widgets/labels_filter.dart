part of '../filter_sheet.dart';

class _LabelFilter extends ConsumerStatefulWidget {
  const _LabelFilter({required this.state});
  final _FilterState state;

  @override
  ConsumerState<_LabelFilter> createState() => __LabelFilterState();
}

class __LabelFilterState extends ConsumerState<_LabelFilter> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.read(ProviderList.themeProvider);
    final labelsProvider = ref.watch(ProviderList.labelProvider);
    
    return CustomExpansionTile(
      title: 'Labels',
      child: (widget.state.issueCategory == IssueCategory.myIssues
                  ? labelsProvider.workspaceLabels
                  : labelsProvider.projectLabels)
              .isEmpty
          ? Container(
              padding: const EdgeInsets.only(left: 25),
              child: CustomText(
                'No labels yet',
                color: themeProvider.themeManager.placeholderTextColor,
              ),
            )
          : Wrap(
              children: (widget.state.issueCategory == IssueCategory.myIssues
                      ? labelsProvider.workspaceLabels
                      : labelsProvider.projectLabels)
                  .values
                  .map((label) => GestureDetector(
                        onTap: () {
                          if (widget.state.filters.labels.contains(label.id)) {
                            widget.state.filters.labels.remove(label.id);
                          } else {
                            widget.state.filters.labels.add(label.id);
                          }
                          widget.state.setState();
                        },
                        child: RectangularChip(
                          ref: ref,
                          icon: CircleAvatar(
                              radius: 5,
                              backgroundColor: label.color.toColor()),
                          text: label.name,
                          selected:
                              widget.state.filters.labels.contains(label.id),
                          color: widget.state.filters.labels.contains(label.id)
                              ? themeProvider.themeManager.primaryColour
                              : themeProvider
                                  .themeManager.secondaryBackgroundDefaultColor,
                        ),
                      ))
                  .toList()),
    );
  }
}
