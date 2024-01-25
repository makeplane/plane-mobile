part of '../filter_sheet.dart';

class _StateFilter extends ConsumerStatefulWidget {
  const _StateFilter({required this.state});
  final _FilterState state;

  @override
  ConsumerState<_StateFilter> createState() => __StateFilterState();
}

class __StateFilterState extends ConsumerState<_StateFilter> {
  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = ref.read(ProviderList.themeProvider);
    final statesProvider = ref.read(ProviderList.statesProvider);
    return CustomExpansionTile(
      title: 'State',
      child: Wrap(
          children: (widget.state.issueCategory == IssueCategory.myIssues
                  ? widget.state.states
                  : statesProvider.projectStates.values)
              .map((state) {
        return (widget.state.isArchived &&
                (state.group == 'backlog' ||
                    state.group == 'unstarted' ||
                    state.group == 'started'))
            ? Container()
            : GestureDetector(
                onTap: () {
                  if (widget.state.filters.states.contains(state.group)) {
                    widget.state.filters.states.remove(state.group);
                  } else {
                    widget.state.filters.states.add(state.group);
                  }
                  widget.state.setState();
                },
                child: RectangularChip(
                  ref: ref,
                  icon: SvgPicture.asset(
                    state.group == 'backlog'
                        ? 'assets/svg_images/circle.svg'
                        : state.group == 'cancelled'
                            ? 'assets/svg_images/cancelled.svg'
                            : state.group == 'started'
                                ? 'assets/svg_images/in_progress.svg'
                                : state.group == 'completed'
                                    ? 'assets/svg_images/done.svg'
                                    : 'assets/svg_images/unstarted.svg',
                    colorFilter: ColorFilter.mode(
                        widget.state.filters.states.contains(state.group)
                            ? (Colors.white)
                            : state.color.toColor(),
                        BlendMode.srcIn),
                    height: 20,
                    width: 20,
                  ),
                  text: state.name,
                  color: widget.state.filters.states.contains(state.group)
                      ? themeProvider.themeManager.primaryColour
                      : themeProvider
                          .themeManager.secondaryBackgroundDefaultColor,
                  selected: widget.state.filters.states.contains(state.group),
                ),
              );
      }).toList()),
    );
  }
}
