import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/utils/enums.dart';

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
  final String issueId;
  final Ref ref;
  final PreviousScreen from;
  String appBarTitle;
  final String? projID;
  final String? workspaceSlug;
  final bool isArchive;
  IssueDetail(
      {required this.from,
      required this.appBarTitle,
      required this.ref,
      this.projID,
      this.workspaceSlug,
      this.isArchive = false,
      required this.issueId,
      super.key});

  @override
  ConsumerState<IssueDetail> createState() => _IssueDetailState();
}

class _IssueDetailState extends ConsumerState<IssueDetail> {
  late String workspaceSlug;
  late String projID;

  void reloadPreviousScreen() {
    switch (widget.from) {
      case PreviousScreen.myIssues:
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          widget.ref.read(ProviderList.myIssuesProvider).filterIssues();
        });
        break;
      case PreviousScreen.activity:
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          var activityProv = widget.ref.read(ProviderList.activityProvider);
          activityProv.getActivityState = StateEnum.loading;
          activityProv.setState();
          activityProv.getAcivity(slug: workspaceSlug);
        });
        break;
      case PreviousScreen.projectDetail:
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          widget.ref.read(ProviderList.issuesProvider).filterIssues(
              slug: workspaceSlug,
              projID: projID,
              isArchived: widget.isArchive);
        });
        break;
      case PreviousScreen.cycles:
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          widget.ref
              .read(ProviderList.cyclesProvider)
              .filterCycleIssues(slug: workspaceSlug, projectId: projID);
        });
        break;
      case PreviousScreen.modules:
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          widget.ref
              .read(ProviderList.modulesProvider)
              .filterModuleIssues(slug: workspaceSlug, projectId: projID);
        });
        break;
      case PreviousScreen.views:
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          widget.ref
              .read(ProviderList.issuesProvider)
              .filterIssues(slug: workspaceSlug, projID: projID);
        });
        break;
      default:
        break;
    }
  }

  @override
  initState() {
    super.initState();
    workspaceSlug = widget.workspaceSlug ??
        ref
            .read(ProviderList.workspaceProvider)
            .selectedWorkspace
            .workspaceSlug;
    projID = widget.projID ??
        ref.read(ProviderList.projectProvider).currentProject['id'];
  }

  @override
  void dispose() async {
    reloadPreviousScreen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EDITOR(
        url:
            '${dotenv.env['EDITOR_URL']}m/$workspaceSlug/projects/$projID/issues/${widget.issueId}',
        title: widget.appBarTitle,
      ),
    );
  }
}
