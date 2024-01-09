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
    final ThemeProvider themeProvider = ref.read(ProviderList.themeProvider);
    final IssuesProvider issuesProvider =
        ref.watch(ProviderList.issuesProvider);
    final MyIssuesProvider myIssuesProvider =
        ref.watch(ProviderList.myIssuesProvider);
    return CustomExpansionTile(
      title: 'Labels',
      child: (widget.state.issueCategory == IssueCategory.myIssues
                  ? myIssuesProvider.labels
                  : issuesProvider.labels)
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
                      ? myIssuesProvider.labels
                      : issuesProvider.labels)
                  .map((e) => GestureDetector(
                        onTap: () {
                          if (widget.state.filters.labels.contains(e['id'])) {
                            widget.state.filters.labels.remove(e['id']);
                          } else {
                            widget.state.filters.labels.add(e['id']);
                          }
                          widget.state.setState();
                        },
                        child: RectangularChip(
                          ref: ref,
                          icon: CircleAvatar(
                              radius: 5,
                              backgroundColor: e['color'].toString().toColor()),
                          text: e['name'],
                          selected:
                              widget.state.filters.labels.contains(e['id']),
                          color: widget.state.filters.labels.contains(e['id'])
                              ? themeProvider.themeManager.primaryColour
                              : themeProvider
                                  .themeManager.secondaryBackgroundDefaultColor,
                        ),
                      ))
                  .toList()),
    );
  }
}
