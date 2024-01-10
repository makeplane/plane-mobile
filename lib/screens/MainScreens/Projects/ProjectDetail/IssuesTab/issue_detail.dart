import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/config/config_variables.dart';
import 'package:plane/provider/issues_provider.dart';
import 'package:plane/provider/my_issues_provider.dart';
import 'package:plane/utils/enums.dart';

import '../../../../../provider/cycles_provider.dart';
import '../../../../../provider/modules_provider.dart';
import '../../../../../provider/provider_list.dart';
import '../../../../../utils/editor.dart';

enum PreviousScreen {
  myIssues,
  globalSearch,
  activity,
  notification,
  projectDetail,
  cycles,
  modules,
  views,
  userProfile,
  profileCreatedIssues,
  profileSubscribedIssues,
  profileAssingedIssues
}

// ignore: must_be_immutable
class IssueDetail extends ConsumerStatefulWidget {
  IssueDetail(
      {required this.from,
      required this.appBarTitle,
      this.projID,
      this.workspaceSlug,
      this.isArchive = false,
      required this.issueId,
      super.key});
  final String issueId;
  final PreviousScreen? from;
  String appBarTitle;
  final String? projID;
  final String? workspaceSlug;
  final bool isArchive;

  @override
  ConsumerState<IssueDetail> createState() => _IssueDetailState();
}

class _IssueDetailState extends ConsumerState<IssueDetail> {
  late String workspaceSlug;
  late String projID;
  late Ref reff;

  void _reloadPreviousScreen() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      switch (widget.from) {
        case PreviousScreen.myIssues:
          final MyIssuesProvider myIssuesProvider =
              ref.read(ProviderList.myIssuesProvider);
          myIssuesProvider.myIssuesFilterState = StateEnum.loading;
          myIssuesProvider.setState();
          break;
        case PreviousScreen.activity:
          final activityProv = ref.read(ProviderList.activityProvider);
          activityProv.getActivityState = StateEnum.loading;
          activityProv.setState();
          break;
        case PreviousScreen.projectDetail:
          final IssuesProvider issuesProvider =
              ref.read(ProviderList.issuesProvider);
          issuesProvider.orderByState = StateEnum.loading;
          issuesProvider.setsState();
          break;
        case PreviousScreen.cycles:
          final CyclesProvider cycleProvider =
              ref.read(ProviderList.cyclesProvider);
          cycleProvider.cyclesIssueState = StateEnum.loading;
          cycleProvider.setState();

          break;
        case PreviousScreen.modules:
          final ModuleProvider modulesProvider =
              ref.read(ProviderList.modulesProvider);
          modulesProvider.moduleIssueState = StateEnum.loading;
          modulesProvider.setState();
          break;
        case PreviousScreen.views:
          final IssuesProvider issuesProvider =
              ref.read(ProviderList.issuesProvider);
          issuesProvider.orderByState = StateEnum.loading;
          issuesProvider.setsState();
          break;
        default:
          break;
      }
    });
  }

  void _updatePreviousScreen() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      switch (widget.from) {
        case PreviousScreen.myIssues:
          reff.read(ProviderList.myIssuesProvider).filterIssues();
          break;
        case PreviousScreen.activity:
          final activityProv = reff.read(ProviderList.activityProvider);
          activityProv.getActivityState = StateEnum.loading;
          activityProv.setState();
          activityProv.getAcivity(slug: workspaceSlug);
          break;
        case PreviousScreen.projectDetail:
          reff.read(ProviderList.issuesProvider).filterIssues(
              slug: workspaceSlug,
              projID: projID,
              isArchived: widget.isArchive);
          break;
        case PreviousScreen.cycles:
          reff
              .read(ProviderList.cyclesProvider)
              .filterCycleIssues(slug: workspaceSlug, projectId: projID);
          break;
        case PreviousScreen.modules:
          reff
              .read(ProviderList.modulesProvider)
              .filterModuleIssues(slug: workspaceSlug, projectId: projID);
          break;
        case PreviousScreen.views:
          reff
              .read(ProviderList.issuesProvider)
              .filterIssues(slug: workspaceSlug, projID: projID);
          break;
        default:
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    reff = ref.read(ProviderList.workspaceProvider).ref!;
    workspaceSlug = widget.workspaceSlug ??
        ref
            .read(ProviderList.workspaceProvider)
            .selectedWorkspace
            .workspaceSlug;
    projID = widget.projID ??
        ref.read(ProviderList.projectProvider).currentProject['id'];
    _reloadPreviousScreen();
  }

  @override
  void dispose() async {
    _updatePreviousScreen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EDITOR(
        from: widget.from,
        url:
            '${Config.webUrl}m/$workspaceSlug/projects/$projID/issues/${widget.issueId}${widget.isArchive ? '?archive=true' : ''}',
        title: widget.appBarTitle,
      ),
    );
  }
}
