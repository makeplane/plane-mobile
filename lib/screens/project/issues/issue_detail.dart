import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  const IssueDetail({super.key});

  @override
  ConsumerState<IssueDetail> createState() => _IssueDetailState();
}

class _IssueDetailState extends ConsumerState<IssueDetail> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Issue Detail'),
      ),
    );
  }
}
