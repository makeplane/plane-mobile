part of '../cycle_detail.dart';

class IssuesTAB extends StatefulWidget {
  const IssuesTAB({super.key});

  @override
  State<IssuesTAB> createState() => _IssuesTABState();
}

class _IssuesTABState extends State<IssuesTAB> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(child: CycleIssuesRoot()),
        /// Bottom Actions
      ],
    );
  }
}
