part of '../filter_sheet.dart';

class _StateFilter extends ConsumerStatefulWidget {
  const _StateFilter({required this.state});
  final _FilterState state;

  @override
  ConsumerState<_StateFilter> createState() => __StateFilterState();
}

class __StateFilterState extends ConsumerState<_StateFilter> {
  List<StateModel> stateGroups = [
    StateModel.initialize().copyWith(
        group: 'backlog',
        name: 'Backlog',
        color: '#5e6ad2',
        stateIcon: stateGroupIcon('backlog')),
    StateModel.initialize().copyWith(
        group: 'unstarted',
        name: 'Unstarted',
        color: '#eb5757',
        stateIcon: stateGroupIcon('unstarted')),
    StateModel.initialize().copyWith(
        group: 'started',
        name: 'Started',
        color: '#26b5ce',
        stateIcon: stateGroupIcon('started')),
    StateModel.initialize().copyWith(
        group: 'completed',
        name: 'Completed',
        color: '#f2c94c',
        stateIcon: stateGroupIcon('completed')),
    StateModel.initialize().copyWith(
        group: 'cancelled',
        name: 'Cancelled',
        color: '#4cb782',
        stateIcon: stateGroupIcon('cancelled'))
  ];
  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = ref.read(ProviderList.themeProvider);
    final statesProvider = ref.read(ProviderList.statesProvider);
    return CustomExpansionTile(
      title: 'State',
      child: Wrap(

          /// if issue category is archived issues then we will not show [backlog], [unstarted] and [started] states.
          /// if issue category is global-issues then we will show [state-groups] only.
          children: (widget.state.issueCategory == IssueCategory.myIssues
                  ? stateGroups
                  : statesProvider.projectStates.values)
              .map((state) {
        return (widget.state.issueCategory == IssueCategory.archivedIssues &&
                (state.group == 'backlog' ||
                    state.group == 'unstarted' ||
                    state.group == 'started'))
            ? Container()
            : GestureDetector(
                onTap: () {
                  List<String> states = widget.state.filters.state;
                  if (states.contains(state.group)) {
                    states.remove(state.group);
                  } else {
                    states.add(state.group);
                  }
                  widget.state.filters =
                      widget.state.filters.copyWith(state: states);
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
                        widget.state.filters.state.contains(state.group)
                            ? (Colors.white)
                            : state.color.toColor(),
                        BlendMode.srcIn),
                    height: 20,
                    width: 20,
                  ),
                  text: state.name,
                  color: widget.state.filters.state.contains(state.group)
                      ? themeProvider.themeManager.primaryColour
                      : themeProvider
                          .themeManager.secondaryBackgroundDefaultColor,
                  selected: widget.state.filters.state.contains(state.group),
                ),
              );
      }).toList()),
    );
  }
}
