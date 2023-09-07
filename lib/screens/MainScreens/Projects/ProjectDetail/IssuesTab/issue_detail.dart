import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../../../../provider/provider_list.dart';
import '../../../../../utils/editor.dart';

// ignore: must_be_immutable
class IssueDetail extends ConsumerStatefulWidget {
  final String issueId;
  String appBarTitle;
  final String? projID;
  final String? workspaceSlug;
  IssueDetail(
      {required this.appBarTitle,
      this.projID,
      this.workspaceSlug,
      required this.issueId,
      super.key});

  @override
  ConsumerState<IssueDetail> createState() => _IssueDetailState();
}

class _IssueDetailState extends ConsumerState<IssueDetail> {

  late String workspaceSlug;
  late String projID;

  @override
  initState() {
    super.initState();
    workspaceSlug = widget.workspaceSlug ?? ref.read(ProviderList.workspaceProvider).selectedWorkspace!.workspaceSlug;
    projID = widget.projID ?? ref.read(ProviderList.projectProvider).currentProject['id'];
  } 
  @override
  Widget build(BuildContext context) {
    return EDITOR(
      url : '${dotenv.env['EDITOR_URL']}m/$workspaceSlug/projects/$projID/issues/${widget.issueId}',
      title: widget.appBarTitle,
    );
  }
}
