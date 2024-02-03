/// TODO: Create SelectProjectMembers Widget

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:loading_indicator/loading_indicator.dart';
// import 'package:plane/utils/constants.dart';
// import 'package:plane/provider/provider_list.dart';
// import 'package:plane/utils/enums.dart';
// import 'package:plane/widgets/custom_text.dart';
// import 'package:plane/widgets/member_logo_widget.dart';

// import '../widgets/custom_button.dart';

// class SelectProjectMembers extends ConsumerStatefulWidget {
//   const SelectProjectMembers(
//       {required this.selectedMembers, super.key});
//   final List<String> selectedMembers;

//   @override
//   ConsumerState<SelectProjectMembers> createState() =>
//       _SelectProjectMembersState();
// }

// class _SelectProjectMembersState extends ConsumerState<SelectProjectMembers> {
//   List selectedMembers = [];
//   @override
//   void initState() {
//     selectedMembers = widget.selectedMembers;
//     super.initState();
//   }


//   @override
//   Widget build(BuildContext context) {
//     final issueProvider = ref.watch(ProviderList.issueProvider);
//     final themeProvider = ref.watch(ProviderList.themeProvider);
//     final projectProvider = ref.watch(ProviderList.projectProvider);
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: themeProvider.themeManager.primaryBackgroundDefaultColor,
//         borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(30), topRight: Radius.circular(30)),
//       ),
//       width: double.infinity,
//       child: Column(
//         children: [
//           const SizedBox(height: 15),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const CustomText(
//                 'Select Members',
//                 type: FontStyle.H4,
//                 fontWeight: FontWeightt.Semibold,
//               ),
//               IconButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   icon: Icon(Icons.close,
//                       color: themeProvider.themeManager.placeholderTextColor))
//             ],
//           ),
//           const SizedBox(height: 15),
//           Expanded(
//             child: Stack(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 50),
//                   child: ListView(
//                     children: [
//                       ListView.builder(
//                           itemCount: projectProvider.projectMembers.length,
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           padding: EdgeInsets.zero,
//                           itemBuilder: (context, index) {
//                             return InkWell(
//                               onTap: () {
//                                 if (widget.createIssue) {
//                                   setState(() {
//                                     if (selectedMembers[projectProvider
//                                                 .projectMembers[index]
//                                             ['member']['id']] ==
//                                         null) {
//                                       selectedMembers[projectProvider
//                                               .projectMembers[index]['member']
//                                           ['id']] = {
//                                         "avatar": projectProvider
//                                                 .projectMembers[index]
//                                             ['member']['avatar'],
//                                         "display_name": projectProvider
//                                                 .projectMembers[index]
//                                             ['member']['display_name'],
//                                         "id": projectProvider
//                                                 .projectMembers[index]
//                                             ['member']['id']
//                                       };
//                                     } else {
//                                       selectedMembers.remove(projectProvider
//                                               .projectMembers[index]['member']
//                                           ['id']);
//                                     }
//                                   });
//                                 } else {
//                                   setState(() {
//                                     if (issueDetailSelectedMembers.contains(
//                                         projectProvider.projectMembers[index]
//                                             ['member']['id'])) {
//                                       issueDetailSelectedMembers.remove(
//                                           projectProvider
//                                                   .projectMembers[index]
//                                               ['member']['id']);
//                                     } else {
//                                       issueDetailSelectedMembers.add(
//                                           projectProvider
//                                                   .projectMembers[index]
//                                               ['member']['id']);
//                                     }
//                                   });
//                                 }
//                               },
//                               child: Container(
//                                 //height: 40,
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 10,
//                                 ),
    
//                                 child: Column(
//                                   children: [
//                                     Row(
//                                       children: [
//                                         SizedBox(
//                                           height: 30,
//                                           width: 30,
//                                           child: MemberLogoWidget(
//                                             padding: EdgeInsets.zero,
//                                             imageUrl: projectProvider
//                                                     .projectMembers[index]
//                                                 ['member']['avatar'],
//                                             colorForErrorWidget:
//                                                 const Color.fromRGBO(
//                                                     55, 65, 81, 1),
//                                             memberNameFirstLetterForErrorWidget:
//                                                 projectProvider
//                                                     .projectMembers[index]
//                                                         ['member']
//                                                         ['display_name'][0]
//                                                     .toString()
//                                                     .toUpperCase(),
//                                           ),
//                                         ),
//                                         Container(
//                                           width: 10,
//                                         ),
//                                         SizedBox(
//                                           width: width * 0.7,
//                                           child: CustomText(
//                                             projectProvider
//                                                     .projectMembers[index]
//                                                 ['member']['display_name'],
//                                             type: FontStyle.Medium,
//                                             fontWeight: FontWeightt.Regular,
//                                             color: themeProvider.themeManager
//                                                 .primaryTextColor,
//                                             maxLines: 1,
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ),
//                                         const Spacer(),
//                                         widget.createIssue
//                                             ? createIsseuSelectedMembersWidget(
//                                                 index)
//                                             : issueDetailSelectedMembersWidget(
//                                                 index),
//                                         const SizedBox(
//                                           width: 10,
//                                         )
//                                       ],
//                                     ),
//                                     const SizedBox(height: 20),
//                                     Container(
//                                         width: width,
//                                         height: 1,
//                                         color: themeProvider.themeManager
//                                             .borderDisabledColor),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           }),
//                       Container(height: 30),
//                     ],
//                   ),
//                 ),
//                 projectProvider.projectMembersState == StateEnum.loading
//                     ? Container(
//                         alignment: Alignment.center,
//                         color: themeProvider
//                             .themeManager.primaryBackgroundDefaultColor,
//                         child: Wrap(
//                           children: [
//                             SizedBox(
//                               height: 25,
//                               width: 25,
//                               child: LoadingIndicator(
//                                 indicatorType: Indicator.lineSpinFadeLoader,
//                                 colors: [
//                                   themeProvider.themeManager.primaryTextColor
//                                 ],
//                                 strokeWidth: 1.0,
//                                 backgroundColor: Colors.transparent,
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     : const SizedBox(),
//                 Positioned(
//                   bottom: 20,
//                   left: 0,
//                   right: 0,
//                   child: Container(
//                     alignment: Alignment.bottomCenter,
//                     height: 50,
//                     child: Button(
//                       text: 'Select',
//                       ontap: () {
//                         if (!widget.createIssue) {
//                           issueProvider.upDateIssue(
//                               slug: ref
//                                   .read(ProviderList.workspaceProvider)
//                                   .selectedWorkspace
//                                   .workspaceSlug,
//                               projID: ref
//                                   .read(ProviderList.projectProvider)
//                                   .currentProject['id'],
//                               issueID: widget.issueId!,
//                               refs: ref,
//                               data: {
//                                 "assignees_list": issueDetailSelectedMembers
//                               });
//                           Navigator.of(context).pop();
//                         } else {
//                           issuesProvider.createIssuedata['members'] =
//                               selectedMembers.isEmpty
//                                   ? null
//                                   : selectedMembers;
//                           issuesProvider.setsState();
//                           Navigator.of(context).pop();
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget createIsseuSelectedMembersWidget(int idx) {
//     final projectProvider = ref.watch(ProviderList.projectProvider);
//     return selectedMembers[projectProvider.projectMembers[idx]['member']
//                 ['id']] !=
//             null
//         ? const Icon(
//             Icons.done,
//             color: Color.fromRGBO(8, 171, 34, 1),
//           )
//         : const SizedBox();
//   }

//   Widget issueDetailSelectedMembersWidget(int idx) {
//     final projectProvider = ref.watch(ProviderList.projectProvider);
//     return issueDetailSelectedMembers
//             .contains(projectProvider.projectMembers[idx]['member']['id'])
//         ? const Icon(
//             Icons.done,
//             color: Color.fromRGBO(8, 171, 34, 1),
//           )
//         : const SizedBox();
//   }
// }
