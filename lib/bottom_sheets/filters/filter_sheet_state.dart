part of './filter_sheet.dart';

class _FilterState {
  final bool fromCreateView;
  final bool fromViews;
  final bool isArchived;
  final dynamic filtersData;
  final IssueCategory issueCategory;
  final WidgetRef ref;

  _FilterState({
    required this.fromCreateView,
    required this.fromViews,
    required this.isArchived,
    required this.filtersData,
    required this.issueCategory,
    required this.ref,
  }) {
    if (!fromCreateView) {
      if (issueCategory == IssueCategory.myIssues) {
        filters = ref.read(ProviderList.myIssuesProvider).issues.filters;
      } else {
        filters = ref.read(ProviderList.issuesProvider).issues.filters;
      }
    } else {
      filters = Filters.fromJson(filtersData["Filters"]);
    }
    if (filters.startDate.isNotEmpty) {
      log(filters.startDate.toString());
      startDatesEnabled();
    }
    if (filters.targetDate.isNotEmpty) {
      targetDatesEnabled();
    }
  }

  List priorities = [
    {'icon': Icons.error_outline_rounded, 'text': 'urgent', 'color': '#EF4444'},
    {'icon': Icons.signal_cellular_alt, 'text': 'high', 'color': '#F59E0B'},
    {
      'icon': Icons.signal_cellular_alt_2_bar,
      'text': 'medium',
      'color': '#F59E0B'
    },
    {
      'icon': Icons.signal_cellular_alt_1_bar,
      'text': 'low',
      'color': '#22C55E'
    },
    {'icon': Icons.do_disturb_alt_outlined, 'text': 'none', 'color': '#A3A3A3'}
  ];

  List states = [
    {'id': 'backlog', 'name': 'Backlog', 'color': '#5e6ad2'},
    {'id': 'unstarted', 'name': 'Unstarted', 'color': '#eb5757'},
    {'id': 'started', 'name': 'Started', 'color': '#26b5ce'},
    {'id': 'completed', 'name': 'Completed', 'color': '#f2c94c'},
    {'id': 'cancelled', 'name': 'Cancelled', 'color': '#4cb782'}
  ];

  Filters filters = Filters(
    priorities: [],
    states: [],
    assignees: [],
    createdBy: [],
    labels: [],
    targetDate: [],
    startDate: [],
    stateGroup: [],
    subscriber: [],
  );

  bool isFilterEmpty() {
    return filters.priorities.isEmpty &&
        filters.states.isEmpty &&
        filters.assignees.isEmpty &&
        filters.createdBy.isEmpty &&
        filters.labels.isEmpty &&
        filters.targetDate.isEmpty &&
        filters.startDate.isEmpty &&
        filters.stateGroup.isEmpty &&
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

  targetDatesEnabled() {
    targetLastWeek = filters.targetDate.contains(
            '${DateTime.now().subtract(const Duration(days: 7)).toString().split(' ')[0]};after') &&
        filters.targetDate
            .contains('${DateTime.now().toString().split(' ')[0]};before');

    targetTwoWeeks = filters.targetDate
            .contains('${DateTime.now().toString().split(' ')[0]};after') &&
        filters.targetDate.contains(
            '${DateTime.now().add(const Duration(days: 14)).toString().split(' ')[0]};before');

    targetOneMonth = filters.targetDate
            .contains('${DateTime.now().toString().split(' ')[0]};after') &&
        filters.targetDate.contains(
            '${DateTime.now().add(const Duration(days: 30)).toString().split(' ')[0]};before');

    targetTwoMonths = filters.targetDate
            .contains('${DateTime.now().toString().split(' ')[0]};after') &&
        filters.targetDate.contains(
            '${DateTime.now().add(const Duration(days: 60)).toString().split(' ')[0]};before');

    targetCustomDate =
        (targetLastWeek || targetTwoWeeks || targetOneMonth || targetTwoMonths)
            ? false
            : filters.targetDate.isEmpty
                ? false
                : true;

    if (targetCustomDate) {
      _targetRangeDatePickerValueWithDefaultValue = [
        DateTime.parse(filters.targetDate[0].split(';')[0]),
        DateTime.parse(filters.targetDate[1].split(';')[0])
      ];
    }
  }

  startDatesEnabled() {
    startLastWeek = filters.startDate.contains(
            '${DateTime.now().subtract(const Duration(days: 7)).toString().split(' ')[0]};after') &&
        filters.startDate
            .contains('${DateTime.now().toString().split(' ')[0]};before');

    startTwoWeeks = filters.startDate
            .contains('${DateTime.now().toString().split(' ')[0]};after') &&
        filters.startDate.contains(
            '${DateTime.now().add(const Duration(days: 14)).toString().split(' ')[0]};before');

    startOneMonth = filters.startDate
            .contains('${DateTime.now().toString().split(' ')[0]};after') &&
        filters.startDate.contains(
            '${DateTime.now().add(const Duration(days: 30)).toString().split(' ')[0]};before');

    startTwoMonths = filters.startDate
            .contains('${DateTime.now().toString().split(' ')[0]};after') &&
        filters.startDate.contains(
            '${DateTime.now().add(const Duration(days: 60)).toString().split(' ')[0]};before');

    startCustomDate =
        (startLastWeek || startTwoWeeks || startOneMonth || startTwoMonths)
            ? false
            : filters.startDate.isEmpty
                ? false
                : true;

    if (startCustomDate) {
      _startRangeDatePickerValueWithDefaultValue = [
        DateTime.parse(filters.startDate[0].split(';')[0]),
        DateTime.parse(filters.startDate[1].split(';')[0])
      ];
    }
  }

  void _applyFilters(BuildContext context) {
    MyIssuesProvider myIssuesProvider = ref.read(ProviderList.myIssuesProvider);
    IssuesProvider issuesProvider = ref.read(ProviderList.issuesProvider);
    CyclesProvider cyclesProvider = ref.read(ProviderList.cyclesProvider);
    ModuleProvider modulesProvider = ref.read(ProviderList.modulesProvider);
    String projID =
        ref.read(ProviderList.projectProvider).currentProject["id"] ?? '';
    String slug = ref
        .read(ProviderList.workspaceProvider)
        .selectedWorkspace
        .workspaceSlug;

    if (fromCreateView) {
      filtersData["Filters"] = Filters.toJson(filters);

      Navigator.pop(context);
      return;
    }
    issueCategory == IssueCategory.myIssues
        ? myIssuesProvider.issues.filters = filters
        : issuesProvider.issues.filters = filters;
    if (issueCategory == IssueCategory.cycleIssues) {
      cyclesProvider
          .filterCycleIssues(
            slug: slug,
            projectId: projID,
          )
          .then((value) => cyclesProvider.initializeBoard());
    } else if (issueCategory == IssueCategory.moduleIssues) {
      modulesProvider
          .filterModuleIssues(
            slug: slug,
            projectId: projID,
          )
          .then((value) => modulesProvider.initializeBoard());
    } else if (issueCategory == IssueCategory.myIssues) {
      myIssuesProvider.updateMyIssueView();
      myIssuesProvider.filterIssues();
    } else {
      if (issueCategory == IssueCategory.issues) {
        issuesProvider.updateProjectView(
          isArchive: isArchived,
        );
      }
      issuesProvider.filterIssues(
        fromViews: fromViews,
        slug: slug,
        projID: projID,
        isArchived: isArchived,
      );
    }
    Navigator.of(context).pop();
  }
}
