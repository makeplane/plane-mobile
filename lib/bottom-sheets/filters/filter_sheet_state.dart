part of './filter_sheet.dart';

class _FilterState {
  final FiltersModel appliedFilters;
  final IssueCategory issueCategory;
  final WidgetRef ref;
  final VoidCallback setState;
  final bool fromCreateView;

  _FilterState({
    required this.issueCategory,
    required this.appliedFilters,
    required this.fromCreateView,
    required this.setState,
    required this.ref,
  }) {
    filters = appliedFilters.copyWith();
    isFilterApplied = !isFilterEmpty(paramFilters: filters);
    if (filters.start_date.isNotEmpty) {
      startDatesEnabled();
    }
    if (filters.target_date.isNotEmpty) {
      targetDatesEnabled();
    }
  }

  bool isFilterApplied = false;

  FiltersModel filters = const FiltersModel();
  bool isFilterEmpty({FiltersModel? paramFilters}) {
    FiltersModel filters = paramFilters ?? this.filters;
    return filters.priority.isEmpty &&
        filters.state.isEmpty &&
        (issueCategory == IssueCategory.myIssues ||
            filters.assignees.isEmpty) &&
        (issueCategory == IssueCategory.myIssues ||
            filters.created_by.isEmpty) &&
        filters.labels.isEmpty &&
        filters.target_date.isEmpty &&
        filters.start_date.isEmpty &&
        filters.state_group.isEmpty &&
        filters.subscriber.isEmpty;
  }

  List<DateTime?> _targetRangeDatePickerValueWithDefaultValue = [];
  List<DateTime?> _startRangeDatePickerValueWithDefaultValue = [];
  bool targetLastWeek = false;
  bool targetTwoWeeks = false;
  bool targetOneMonth = false;
  bool targetTwoMonths = false;
  bool targetCustomDate = false;

  bool startLastWeek = false;
  bool startTwoWeeks = false;
  bool startOneMonth = false;
  bool startTwoMonths = false;
  bool startCustomDate = false;

  void targetDatesEnabled() {
    targetLastWeek = filters.target_date.contains(
            '${DateTime.now().subtract(const Duration(days: 7)).toString().split(' ')[0]};after') &&
        filters.target_date
            .contains('${DateTime.now().toString().split(' ')[0]};before');

    targetTwoWeeks = filters.target_date
            .contains('${DateTime.now().toString().split(' ')[0]};after') &&
        filters.target_date.contains(
            '${DateTime.now().add(const Duration(days: 14)).toString().split(' ')[0]};before');

    targetOneMonth = filters.target_date
            .contains('${DateTime.now().toString().split(' ')[0]};after') &&
        filters.target_date.contains(
            '${DateTime.now().add(const Duration(days: 30)).toString().split(' ')[0]};before');

    targetTwoMonths = filters.target_date
            .contains('${DateTime.now().toString().split(' ')[0]};after') &&
        filters.target_date.contains(
            '${DateTime.now().add(const Duration(days: 60)).toString().split(' ')[0]};before');

    targetCustomDate =
        (targetLastWeek || targetTwoWeeks || targetOneMonth || targetTwoMonths)
            ? false
            : filters.target_date.isEmpty
                ? false
                : true;

    if (targetCustomDate) {
      _targetRangeDatePickerValueWithDefaultValue = [
        DateTime.parse(filters.target_date[0].split(';')[0]),
        DateTime.parse(filters.target_date[1].split(';')[0])
      ];
    }
  }

  void startDatesEnabled() {
    startLastWeek = filters.start_date.contains(
            '${DateTime.now().subtract(const Duration(days: 7)).toString().split(' ')[0]};after') &&
        filters.start_date
            .contains('${DateTime.now().toString().split(' ')[0]};before');

    startTwoWeeks = filters.start_date
            .contains('${DateTime.now().toString().split(' ')[0]};after') &&
        filters.start_date.contains(
            '${DateTime.now().add(const Duration(days: 14)).toString().split(' ')[0]};before');

    startOneMonth = filters.start_date
            .contains('${DateTime.now().toString().split(' ')[0]};after') &&
        filters.start_date.contains(
            '${DateTime.now().add(const Duration(days: 30)).toString().split(' ')[0]};before');

    startTwoMonths = filters.start_date
            .contains('${DateTime.now().toString().split(' ')[0]};after') &&
        filters.start_date.contains(
            '${DateTime.now().add(const Duration(days: 60)).toString().split(' ')[0]};before');

    startCustomDate =
        (startLastWeek || startTwoWeeks || startOneMonth || startTwoMonths)
            ? false
            : filters.start_date.isEmpty
                ? false
                : true;

    if (startCustomDate) {
      _startRangeDatePickerValueWithDefaultValue = [
        DateTime.parse(filters.start_date[0].split(';')[0]),
        DateTime.parse(filters.start_date[1].split(';')[0])
      ];
    }
  }

  void _applyFilters({required BuildContext context}) async {
    final issuesNotifier = IssuesHelper.getIssuesProvider(ref, issueCategory);
    final issuesState = IssuesHelper.getIssuesState(ref, issueCategory);

    if (fromCreateView) {
      /// TODO: If the user is creating a new view, then we need to update the create view filters
      Navigator.pop(context);
      return;
    }

    issuesNotifier
        .updateLayoutProperties(issuesState.layoutProperties);
    issuesNotifier.fetchIssues();

    Navigator.of(context).pop();
  }
}
