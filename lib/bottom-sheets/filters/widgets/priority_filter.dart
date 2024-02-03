part of '../filter_sheet.dart';

class _PriorityFilter extends ConsumerStatefulWidget {
  const _PriorityFilter({required this.state});
  final _FilterState state;

  @override
  ConsumerState<_PriorityFilter> createState() => __PriorityFilterState();
}

class __PriorityFilterState extends ConsumerState<_PriorityFilter> {
  final priorities = ['urgent', 'high', 'medium', 'low', 'none'];

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = ref.read(ProviderList.themeProvider);
    return CustomExpansionTile(
      title: 'Priority',
      child: Wrap(
          children: priorities
              .map((priority) => GestureDetector(
                  onTap: () {
                    List<String> priorities = widget.state.filters.priority.toList();
                    if (priorities.contains(priority)) {
                      priorities.remove(priority);
                    } else {
                      priorities.add(priority);
                    }
                    widget.state.filters =
                        widget.state.filters.copyWith(priority: priorities);
                    widget.state.setState();
                  },
                  child: RectangularChip(
                      ref: ref,
                      icon: priorityIcon(priority),
                      text: priority,
                      color: widget.state.filters.priority.contains(priority)
                          ? themeProvider.themeManager.primaryColour
                          : themeProvider
                              .themeManager.secondaryBackgroundDefaultColor,
                      selected:
                          widget.state.filters.priority.contains(priority))))
              .toList()),
    );
  }
}
