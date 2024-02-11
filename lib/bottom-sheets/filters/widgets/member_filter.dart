import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/models/project/issue-filter-properties-and-view/issue_filter_and_properties.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/provider/theme_provider.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_expansion_tile.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/rectangular_chip.dart';

class MemberFilter extends ConsumerStatefulWidget {
  const MemberFilter(
      {required this.title, required this.filter, required this.onChange});
  final FiltersModel filter;
  final String title;
  final Function(String memberId) onChange;
  @override
  ConsumerState<MemberFilter> createState() => _MemberFilterState();
}

class _MemberFilterState extends ConsumerState<MemberFilter> {
  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = ref.read(ProviderList.themeProvider);
    final members =
        ref.read(ProviderList.workspaceProvider).workspaceMembers;
    return CustomExpansionTile(
      title: widget.title,
      child: Wrap(
        children: members
            .map(
              (member) => GestureDetector(
                onTap: () => widget.onChange(member['member']['id']),
                child: RectangularChip(
                  ref: ref,
                  icon: member['member']['avatar'] != '' &&
                          member['member']['avatar'] != null
                      ? CircleAvatar(
                          radius: 10,
                          backgroundImage:
                              NetworkImage(member['member']['avatar']),
                        )
                      : CircleAvatar(
                          radius: 10,
                          backgroundColor: const Color.fromRGBO(55, 65, 81, 1),
                          child: Center(
                              child: CustomText(
                            member['member']['display_name'][0]
                                .toString()
                                .toUpperCase(),
                            color: Colors.white,
                            fontWeight: FontWeightt.Medium,
                            type: FontStyle.overline,
                          )),
                        ),
                  text: member['member']['display_name'] ?? '',
                  selected:
                      widget.filter.assignees.contains(member['member']['id']),
                  color:
                      widget.filter.assignees.contains(member['member']['id'])
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
