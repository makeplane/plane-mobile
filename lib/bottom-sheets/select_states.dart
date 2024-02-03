/// TODO: Select States Bottom Sheet

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:loading_indicator/loading_indicator.dart';
// import 'package:plane/provider/issues_provider.dart';
// import 'package:plane/screens/create_state.dart';
// import 'package:plane/provider/provider_list.dart';
// import 'package:plane/utils/constants.dart';
// import 'package:plane/utils/enums.dart';
// import 'package:plane/utils/extensions/string_extensions.dart';
// import 'package:plane/widgets/custom_text.dart';

// class SelectStates extends ConsumerStatefulWidget {
//   const SelectStates({required this.selectedState, super.key});
//   final String selectedState;

//   @override
//   ConsumerState<SelectStates> createState() => _SelectStatesState();
// }

// class _SelectStatesState extends ConsumerState<SelectStates> {
//   String selectedState = '';
//   @override
//   void initState() {
//     final statesNotifier = ref.read(ProviderList.statesProvider.notifier);
//     final statesProvider = ref.read(ProviderList.statesProvider);
//     if (statesProvider.projectStates.isEmpty) {
//       statesNotifier.getStates();
//     }
//     selectedState = widget.selectedState;
//     super.initState();
//   }

//   String issueDetailSelectedState = '';
//   List states = ['backlog', 'unstarted', 'started', 'completed', 'cancelled'];
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = ref.watch(ProviderList.themeProvider);
//     final statesProvider = ref.watch(ProviderList.statesProvider);
//     return Container(
//       padding: bottomSheetConstPadding,
//       decoration: BoxDecoration(
//         color: themeProvider.themeManager.secondaryBackgroundDefaultColor,
//         borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(30), topRight: Radius.circular(30)),
//       ),
//       width: double.infinity,
//       child: Stack(
//         children: [
//           SingleChildScrollView(
//             child: Column(
//               children: [
//                 const SizedBox(
//                   height: 45,
//                 ),
//                 for (final stateGroup in states)
//                   for (final state in statesProvider.stateGroups[stateGroup]!)
//                     InkWell(
//                       onTap: () async {                        
//                         Navigator.of(context).pop();
//                       },
//                       child: Container(
//                         //height: 40,
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 10,
//                         ),
    
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 SizedBox(
//                                   height: 25,
//                                   width: 25,
//                                   child: SvgPicture.asset(
//                                     stateGroup == 'backlog'
//                                         ? 'assets/svg_images/circle.svg'
//                                         : stateGroup == 'cancelled'
//                                             ? 'assets/svg_images/cancelled.svg'
//                                             : stateGroup == 'completed'
//                                                 ? 'assets/svg_images/done.svg'
//                                                 : stateGroup == 'started'
//                                                     ? 'assets/svg_images/in_progress.svg'
//                                                     : 'assets/svg_images/unstarted.svg',
//                                     colorFilter: ColorFilter.mode(
//                                         state.color.toColor(),
//                                         BlendMode.srcIn),
//                                     height: 20,
//                                     width: 20,
//                                   ),
//                                 ),
//                                 Container(
//                                   width: 10,
//                                 ),
//                                 SizedBox(
//                                   width: width * 0.7,
//                                   child: CustomText(
//                                     state.name,
//                                     type: FontStyle.Medium,
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                     fontWeight: FontWeightt.Regular,
//                                     color: themeProvider
//                                         .themeManager.primaryTextColor,
//                                   ),
//                                 ),
//                                 const Spacer(),
//                                 // widget.createIssue
//                                 //     ? createIssueStateSelectionWidget(i, j)
//                                 //     : issueDetailStateSelectionWidget(i, j),
//                                 const SizedBox(
//                                   width: 10,
//                                 )
//                               ],
//                             ),
//                             const SizedBox(height: 20),
//                             Container(
//                                 width: width,
//                                 height: 1,
//                                 color: themeProvider
//                                     .themeManager.borderDisabledColor)
//                           ],
//                         ),
//                       ),
//                     ),
//                 // : Container(),
//                 widget.createIssue
//                     ? GestureDetector(
//                         onTap: () {
//                           Navigator.of(context).push(MaterialPageRoute(
//                               builder: (context) => const CreateState()));
//                         },
//                         child: Container(
//                           margin: const EdgeInsets.only(bottom: 5, top: 15),
//                           child: Row(
//                             children: [
//                               SizedBox(
//                                   height: 25,
//                                   width: 25,
//                                   // decoration: BoxDecoration(
//                                   //   color: Colors.grey,
//                                   //   borderRadius: BorderRadius.circular(5),
//                                   // ),
//                                   child: Icon(
//                                     Icons.add,
//                                     color: themeProvider
//                                         .themeManager.placeholderTextColor,
//                                   )),
//                               Container(
//                                 width: 10,
//                               ),
//                               const CustomText(
//                                 'Create New State',
//                                 type: FontStyle.Small,
//                               )
//                             ],
//                           ),
//                         ),
//                       )
//                     : Container(),
//                 SizedBox(height: bottomSheetConstBottomPadding),
//               ],
//             ),
//           ),
//           Container(
//             color: themeProvider.themeManager.primaryBackgroundDefaultColor,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 CustomText(
//                   'Select State',
//                   type: FontStyle.H4,
//                   fontWeight: FontWeightt.Semibold,
//                   color: themeProvider.themeManager.primaryTextColor,
//                 ),
//                 IconButton(
//                     onPressed: () {
//                       final prov = ref.read(ProviderList.issuesProvider);
//                       final statesProvider =
//                           ref.watch(ProviderList.statesProvider.notifier);
//                       //   if (selectedState.isNotEmpty) {
//                       prov.createIssuedata['state'] = selectedState;
//                       // print('state');
//                       // print(prov.createIssuedata['state'].toString());
//                       statesProvider.getStates(
//                           slug: ref
//                               .read(ProviderList.workspaceProvider)
//                               .selectedWorkspace
//                               .workspaceSlug,
//                           projectId: ref
//                               .read(ProviderList.projectProvider)
//                               .currentProject['id']);
//                       prov.setsState();
//                       Navigator.pop(context);
//                     },
//                     icon: Icon(
//                       Icons.close,
//                       color: themeProvider.themeManager.placeholderTextColor,
//                     ))
//               ],
//             ),
//           ),
//           statesProvider.statesState == StateEnum.loading
//               ? Container(
//                   alignment: Alignment.center,
//                   color: Colors.white.withOpacity(0.7),
//                   // height: 25,
//                   // width: 25,
//                   child: const Wrap(
//                     children: [
//                       SizedBox(
//                         height: 25,
//                         width: 25,
//                         child: LoadingIndicator(
//                           indicatorType: Indicator.lineSpinFadeLoader,
//                           colors: [Colors.black],
//                           strokeWidth: 1.0,
//                           backgroundColor: Colors.transparent,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : const SizedBox(),
//         ],
//       ),
//     );
//   }

//   Widget createIssueStateSelectionWidget(int i, int j) {
//     final issuesProvider = ref.watch(ProviderList.issuesProvider);
//     return selectedState == issuesProvider.statesData[states[j]][i]['id']
//         ? const Icon(
//             Icons.done,
//             color: Color.fromRGBO(8, 171, 34, 1),
//           )
//         : const SizedBox();
//   }

//   Widget issueDetailStateSelectionWidget(int i, int j) {
//     final issueProvider = ref.watch(ProviderList.issueProvider);
//     final issuesProvider = ref.watch(ProviderList.issuesProvider);
//     return issueProvider.issueDetails['state_detail']['id'] ==
//             issuesProvider.statesData[states[j]][i]['id']
//         ? const Icon(
//             Icons.done,
//             color: Color.fromRGBO(8, 171, 34, 1),
//           )
//         : issueProvider.updateIssueState == StateEnum.loading &&
//                 issueDetailSelectedState ==
//                     issuesProvider.statesData[states[j]][i]['name']
//             ? const SizedBox(
//                 height: 20,
//                 width: 20,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                   color: greyColor,
//                 ),
//               )
//             : const SizedBox();
//   }
// }
