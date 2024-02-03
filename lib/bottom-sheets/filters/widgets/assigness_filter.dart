part of '../filter_sheet.dart';

class _AssigneesFilter extends ConsumerStatefulWidget {
  const _AssigneesFilter({required this.state});
  final _FilterState state;

  @override
  ConsumerState<_AssigneesFilter> createState() => __AssigneesFilterState();
}

class __AssigneesFilterState extends ConsumerState<_AssigneesFilter> {
  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = ref.read(ProviderList.themeProvider);
    final ProjectsProvider projectProvider =
        ref.read(ProviderList.projectProvider);
    return CustomExpansionTile(
      title: 'Assignees',
      child: Wrap(
        children: projectProvider.projectMembers
            .map(
              (e) => GestureDetector(
                onTap: () {
                  List<String> assignees = widget.state.filters.assignees;
                  if (assignees.contains(e['member']['id'])) {
                    assignees.remove(e['member']['id']);
                  } else {
                    assignees.add(e['member']['id']);
                  }
                  widget.state.filters =
                      widget.state.filters.copyWith(assignees: assignees);
                  widget.state.setState();
                },
                child: RectangularChip(
                  ref: ref,
                  icon: e['member']['avatar'] != '' &&
                          e['member']['avatar'] != null
                      ? CircleAvatar(
                          radius: 10,
                          backgroundImage: NetworkImage(e['member']['avatar']),
                        )
                      : CircleAvatar(
                          radius: 10,
                          backgroundColor: const Color.fromRGBO(55, 65, 81, 1),
                          child: Center(
                              child: CustomText(
                            e['member']['display_name'][0]
                                .toString()
                                .toUpperCase(),
                            color: Colors.white,
                            fontWeight: FontWeightt.Medium,
                            type: FontStyle.overline,
                          )),
                        ),
                  text: e['member']['display_name'] ?? '',
                  selected: widget.state.filters.assignees
                      .contains(e['member']['id']),
                  color:
                      widget.state.filters.assignees.contains(e['member']['id'])
                          ? themeProvider.themeManager.primaryColour
                          : themeProvider
                              .themeManager.secondaryBackgroundDefaultColor,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
