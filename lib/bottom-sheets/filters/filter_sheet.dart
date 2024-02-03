// ignore_for_file: unused_local_variable
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plane/core/icons/priority_icon.dart';
import 'package:plane/core/icons/state_group_icon.dart';
import 'package:plane/models/project/issue-filter-properties-and-view/issue_filter_and_properties.dart';
import 'package:plane/models/project/state/state_model.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/provider/theme_provider.dart';
import 'package:plane/screens/create_view_screen.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/utils/extensions/string_extensions.dart';
import 'package:plane/utils/issues/issues.helper.dart';
import 'package:plane/utils/theme_manager.dart';
import 'package:plane/widgets/custom_button.dart';
import 'package:plane/widgets/custom_divider.dart';
import 'package:plane/widgets/custom_expansion_tile.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/rectangular_chip.dart';
import '../../provider/projects_provider.dart';
part 'filter_sheet_state.dart';
part 'widgets/priority_filter.dart';
part 'widgets/state_filter.dart';
part 'widgets/assigness_filter.dart';
part 'widgets/created_by_filter.dart';
part 'widgets/due_date_filter.dart';
part 'widgets/start_date_filter.dart';
part 'widgets/filter_buttons.dart';
part 'widgets/labels_filter.dart';

// ignore: must_be_immutable
class FilterSheet extends ConsumerStatefulWidget {
  FilterSheet({
    super.key,
    required this.issueCategory,
    this.appliedFilters = const FiltersModel(),
    this.fromCreateView = false,
  });
  final IssueCategory issueCategory;
  final FiltersModel appliedFilters;
  bool fromCreateView = false;
  @override
  ConsumerState<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<FilterSheet> {
  late _FilterState state;

  @override
  void initState() {
    state = _FilterState(
        appliedFilters: widget.appliedFilters,
        issueCategory: widget.issueCategory,
        fromCreateView: widget.fromCreateView,
        setState: () => setState(() {}),
        ref: ref);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Stack(
        children: [
          Wrap(
            children: [
              SizedBox(
                child: Row(
                  children: [
                    const CustomText(
                      'Filter',
                      type: FontStyle.H4,
                      fontWeight: FontWeightt.Semibold,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        size: 27,
                        color: themeProvider.themeManager.placeholderTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              state.isFilterApplied
                  ? Container()
                  : _clearFilterButton(state: state, ref: ref)
            ],
          ),
          Container(
            margin: EdgeInsets.only(
                top: state.isFilterApplied ? 50 : 95, bottom: 80),
            child: SingleChildScrollView(
              child: Wrap(
                children: [
                  _PriorityFilter(state: state),
                  CustomDivider(themeProvider: themeProvider),
                  _StateFilter(state: state),
                  widget.issueCategory == IssueCategory.myIssues
                      ? Container()
                      : CustomDivider(themeProvider: themeProvider),
                  widget.issueCategory == IssueCategory.myIssues
                      ? Container()
                      : _AssigneesFilter(state: state),
                  widget.issueCategory == IssueCategory.myIssues
                      ? Container()
                      : CustomDivider(themeProvider: themeProvider),
                  widget.issueCategory == IssueCategory.myIssues
                      ? Container()
                      : _CreatedByFilter(state: state),
                  CustomDivider(themeProvider: themeProvider),
                  _LabelFilter(state: state),
                  CustomDivider(themeProvider: themeProvider),
                  _DueDateFilter(state: state),
                  CustomDivider(themeProvider: themeProvider),
                  _StartDateFilter(state: state),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                mainAxisAlignment: widget.fromCreateView ||
                        widget.issueCategory == IssueCategory.myIssues
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceBetween,
                children: [
                  widget.fromCreateView ||
                          widget.issueCategory == IssueCategory.myIssues
                      ? Container()
                      : _saveView(state: state, ref: ref),
                  _applyFilterButton(
                    state: state,
                    context: context,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
