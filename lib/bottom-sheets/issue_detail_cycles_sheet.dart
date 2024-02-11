//TODO : issue detail cycle sheet
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:plane/provider/provider_list.dart';
// import 'package:plane/widgets/custom_text.dart';
// import '../utils/enums.dart';

// class IssueDetailCyclesList extends ConsumerStatefulWidget {
//   const IssueDetailCyclesList(
//       {required this.cycleId,
//       required this.issueId,
//       required this.cycleIssueId,
//       super.key});
//   final String cycleId;
//   final String issueId;
//   final String cycleIssueId;

//   @override
//   ConsumerState<IssueDetailCyclesList> createState() =>
//       _IssueDetailCyclesListState();
// }

// class _IssueDetailCyclesListState extends ConsumerState<IssueDetailCyclesList> {
//   Future<void> handleCycleSelection() async {
//     (issueProvider.cyclesList[index]['name'] == 'None'
//             ? cyclesProvider.deleteCycleIssue(
//                 slug: ref
//                     .watch(ProviderList.workspaceProvider)
//                     .selectedWorkspace
//                     .workspaceSlug,
//                 projId:
//                     ref.read(ProviderList.projectProvider).currentProject['id'],
//                 issueId: widget.cycleIssueId,
//                 cycleId: widget.cycleId)
//             : cyclesProvider.createCycleIssues(
//                 slug: ref
//                     .watch(ProviderList.workspaceProvider)
//                     .selectedWorkspace
//                     .workspaceSlug,
//                 projId:
//                     ref.read(ProviderList.projectProvider).currentProject['id'],
//                 issues: [widget.issueId],
//                 cycleId: issueProvider.cyclesList[index]['id']))
//         .then((value) {
//       issueProvider.getIssueDetails(
//         slug: workspaceProvider.selectedWorkspace.workspaceSlug,
//         projID: projectProvider.currentProject['id'],
//         issueID: widget.issueId,
//       );
//       cyclesProvider.filterCycleIssues(
//           slug: workspaceProvider.selectedWorkspace.workspaceSlug,
//           projectId: projectProvider.currentProject['id'],
//           ref: ref);
//     });
//     Navigator.of(context).pop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final issueProvider = ref.watch(ProviderList.issueProvider);
//     final themeProvider = ref.watch(ProviderList.themeProvider);
//     final workspaceProvider = ref.read(ProviderList.workspaceProvider);
//     final projectProvider = ref.read(ProviderList.projectProvider);

//     return Container(
//       decoration: BoxDecoration(
//         color: themeProvider.themeManager.secondaryBackgroundDefaultColor,
//         borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(30), topRight: Radius.circular(30)),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
//       child: Wrap(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               CustomText(
//                 'Select Cycle',
//                 type: FontStyle.H4,
//                 fontWeight: FontWeightt.Semibold,
//                 color: themeProvider.themeManager.primaryTextColor,
//               ),
//               IconButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 icon: Icon(Icons.close,
//                     color: themeProvider.themeManager.placeholderTextColor),
//               )
//             ],
//           ),
//           Container(
//             height: 15,
//           ),
//           ListView.builder(
//               shrinkWrap: true,
//               itemCount: issueProvider.cyclesList.length,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 15),
//                   child: InkWell(
//                     onTap: () {},
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             CustomText(
//                               issueProvider.cyclesList[index]['name'],
//                               type: FontStyle.Medium,
//                               fontWeight: FontWeightt.Regular,
//                               color:
//                                   themeProvider.themeManager.primaryTextColor,
//                             ),
//                             widget.cycleId != '' &&
//                                     widget.cycleId ==
//                                         issueProvider.cyclesList[index]['id']
//                                 ? Icon(
//                                     Icons.check,
//                                     color: themeProvider
//                                         .themeManager.placeholderTextColor,
//                                   )
//                                 : Container()
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Container(
//                             height: 1,
//                             margin: const EdgeInsets.only(top: 10, bottom: 5),
//                             color:
//                                 themeProvider.themeManager.borderDisabledColor)
//                       ],
//                     ),
//                   ),
//                 );
//               }),
//         ],
//       ),
//     );
//   }
// }
