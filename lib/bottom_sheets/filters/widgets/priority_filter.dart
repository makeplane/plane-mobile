part of '../filter_sheet.dart';

class _PriorityFilter extends ConsumerStatefulWidget {
  const _PriorityFilter({required this.state});
  final _FilterState state;

  @override
  ConsumerState<_PriorityFilter> createState() => __PriorityFilterState();
}

class __PriorityFilterState extends ConsumerState<_PriorityFilter> {
  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = ref.read(ProviderList.themeProvider);
    return CustomExpansionTile(
      title: 'Priority',
      child: Wrap(
          children: widget.state.priorities
              .map((e) => GestureDetector(
                  onTap: () {
                    if (widget.state.filters.priorities.contains(e['text'])) {
                      widget.state.filters.priorities.remove(e['text']);
                    } else {
                      widget.state.filters.priorities.add(e['text']);
                    }
                    widget.state.setState();
                  },
                  child: RectangularChip(
                      ref: ref,
                      icon: Icon(
                        e['icon'],
                        size: 15,
                        color: Color(int.parse(
                            "FF${e['color'].replaceAll('#', '')}",
                            radix: 16)),
                      ),
                      text: e['text'],
                      color: widget.state.filters.priorities.contains(e['text'])
                          ? themeProvider.themeManager.primaryColour
                          : themeProvider
                              .themeManager.secondaryBackgroundDefaultColor,
                      selected:
                          widget.state.filters.priorities.contains(e['text']))))
              .toList()),
    );
  }
}
