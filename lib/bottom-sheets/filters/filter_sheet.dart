import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/bottom-sheets/filters/widgets/date_filter.dart';
import 'package:plane/bottom-sheets/filters/widgets/member_filter.dart';
import 'package:plane/models/project/issue-filter-properties-and-view/issue_filter_and_properties.dart';
import 'package:plane/models/project/label/label.model.dart';
import 'package:plane/models/project/state/state_model.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_button.dart';
import 'package:plane/widgets/custom_divider.dart';
import 'package:plane/widgets/custom_text.dart';
import 'widgets/filter_buttons.dart';
import 'widgets/labels_filter.dart';
import 'widgets/priority_filter.dart';
import 'widgets/state_filter.dart';

class SelectFilterSheet extends ConsumerStatefulWidget {
  SelectFilterSheet(
      {required this.appliedFilter,
      required this.applyFilter,
      required this.clearAllFilter,
      this.saveView,
      this.showSaveViewButton = false,
      required this.labels,
      required this.states,
      super.key}) {
    if (showSaveViewButton) assert(saveView != null);
  }
  final FiltersModel appliedFilter;
  final VoidCallback clearAllFilter;
  final Function(FiltersModel filter) applyFilter;
  final VoidCallback? saveView;
  final bool showSaveViewButton;
  final List<StateModel> states;
  final List<LabelModel> labels;
  @override
  ConsumerState<SelectFilterSheet> createState() => _SelectFilterSheetState();
}

class _SelectFilterSheetState extends ConsumerState<SelectFilterSheet> {
  FiltersModel filters = const FiltersModel();
  bool get _isFilterApplied =>
      filters.priority.isNotEmpty ||
      filters.state.isNotEmpty ||
      filters.assignees.isNotEmpty ||
      filters.created_by.isNotEmpty ||
      filters.labels.isNotEmpty ||
      filters.target_date.isNotEmpty ||
      filters.start_date.isNotEmpty ||
      filters.state_group.isNotEmpty ||
      filters.subscriber.isNotEmpty;

  void handleFilterChange(String property, String value) {
    List<String> filter = filters.toJson()[property];
    setState(() {
      if (filter.contains(value)) {
        filter.remove(value);
      } else {
        filter.add(value);
      }
    });
  }

  @override
  void initState() {
    filters = widget.appliedFilter.copyWith();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ref.read(ProviderList.themeProvider).themeManager;
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
                        color: themeManager.placeholderTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              !_isFilterApplied
                  ? Container()
                  : ClearFilterButton(onClick: widget.clearAllFilter, ref: ref)
            ],
          ),
          Container(
            margin:
                EdgeInsets.only(top: _isFilterApplied ? 95 : 50, bottom: 80),
            child: SingleChildScrollView(
              child: Wrap(
                children: [
                  PriorityFilter(
                    filter: filters,
                    onChange: (priority) =>
                        handleFilterChange('priority', priority),
                  ),
                  const CustomDivider(),
                  StateFilter(
                    states: widget.states,
                    onChange: (stateId) => handleFilterChange('state', stateId),
                  ),
                  const CustomDivider(),
                  MemberFilter(
                    filter: filters,
                    title: 'Assignees',
                    onChange: (memberId) =>
                        handleFilterChange('assignees', memberId),
                  ),
                  const CustomDivider(),
                  MemberFilter(
                    filter: filters,
                    title: 'Created by',
                    onChange: (memberId) =>
                        handleFilterChange('created_by', memberId),
                  ),
                  const CustomDivider(),
                  LabelFilter(
                    filter: filters,
                    labels: widget.labels,
                    onChange: (labelId) => handleFilterChange('label', labelId),
                  ),
                  const CustomDivider(),
                  DateFilter(
                    title: 'Start Date',
                    filterDates: filters.start_date,
                    onChange: (date) => handleFilterChange('start_date', date),
                  ),
                  const CustomDivider(),
                  DateFilter(
                    title: 'Target Date',
                    filterDates: filters.target_date,
                    onChange: (date) => handleFilterChange('target_date', date),
                  ),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.showSaveViewButton
                      ? Expanded(
                          child: SaveViewButton(
                              isFilterApplied: _isFilterApplied,
                              onClick: widget.saveView!,
                              ref: ref))
                      : Container(),
                  Expanded(
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.42,
                      margin: const EdgeInsets.only(bottom: 18),
                      child: Button(
                        text: 'Apply Filter',
                        ontap: () => widget.applyFilter(filters),
                        textColor: Colors.white,
                      ),
                    ),
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
