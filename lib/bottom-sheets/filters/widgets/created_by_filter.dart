part of '../filter_sheet.dart';

class _CreatedByFilter extends ConsumerStatefulWidget {
  const _CreatedByFilter({required this.state});
  final _FilterState state;

  @override
  ConsumerState<_CreatedByFilter> createState() => __CreatedByFilterState();
}

class __CreatedByFilterState extends ConsumerState<_CreatedByFilter> {
  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = ref.read(ProviderList.themeProvider);
    final ProjectsProvider projectProvider =
        ref.read(ProviderList.projectProvider);
    return CustomExpansionTile(
      title: 'Created by',
      child: Wrap(
        children: projectProvider.projectMembers
            .map(
              (e) => GestureDetector(
                onTap: () {
                  if (widget.state.filters.createdBy
                      .contains(e['member']['id'])) {
                    widget.state.filters.createdBy.remove(e['member']['id']);
                  } else {
                    widget.state.filters.createdBy.add(e['member']['id']);
                  }
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
                  selected: widget.state.filters.createdBy
                      .contains(e['member']['id']),
                  color:
                      widget.state.filters.createdBy.contains(e['member']['id'])
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
