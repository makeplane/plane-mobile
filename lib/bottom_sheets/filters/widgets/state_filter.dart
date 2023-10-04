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
    final IssuesProvider issuesProvider = ref.read(ProviderList.issuesProvider);
    return CustomExpansionTile(
      title: 'State',
      child: Wrap(
          children: (widget.state.issueCategory == IssueCategory.myIssues
                  ? widget.state.states
                  : issuesProvider.states.values)
              .map((e) {
        final String key = widget.state.issueCategory == IssueCategory.myIssues
            ? 'id'
            : 'group';
        return (widget.state.isArchived &&
                (e[key] == 'backlog' ||
                    e[key] == 'unstarted' ||
                    e[key] == 'started'))
            ? Container()
            : GestureDetector(
                onTap: () {
                  if (widget.state.filters.states.contains(e['id'])) {
                    widget.state.filters.states.remove(e['id']);
                  } else {
                    widget.state.filters.states.add(e['id']);
                  }
                  widget.state.setState();
                },
                child: RectangularChip(
                  ref: ref,
                  icon: SvgPicture.asset(
                    e[key] == 'backlog'
                        ? 'assets/svg_images/circle.svg'
                        : e[key] == 'cancelled'
                            ? 'assets/svg_images/cancelled.svg'
                            : e[key] == 'started'
                                ? 'assets/svg_images/in_progress.svg'
                                : e[key] == 'completed'
                                    ? 'assets/svg_images/done.svg'
                                    : 'assets/svg_images/unstarted.svg',
                    colorFilter: ColorFilter.mode(
                        widget.state.filters.states.contains(e['id'])
                            ? (Colors.white)
                            : e['color'].toString().toColor(),
                        BlendMode.srcIn),
                    height: 20,
                    width: 20,
                  ),
                  text: e['name'],
                  color: widget.state.filters.states.contains(e['id'])
                      ? themeProvider.themeManager.primaryColour
                      : themeProvider
                          .themeManager.secondaryBackgroundDefaultColor,
                  selected: widget.state.filters.states.contains(e['id']),
                ),
              );
      }).toList()),
    );
  }
}
