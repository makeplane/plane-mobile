// // ignore_for_file: use_build_context_synchronously

// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:plane/provider/provider_list.dart';
// import 'package:plane/utils/constants.dart';
// import 'package:plane/utils/custom_toast.dart';
// import 'package:plane/utils/enums.dart';
// import 'package:plane/utils/random_colors.dart';
// import 'package:plane/widgets/custom_app_bar.dart';
// import 'package:plane/widgets/custom_button.dart';
// import 'package:plane/widgets/custom_text.dart';
// import 'package:plane/widgets/loading_widget.dart';

// class WorkspaceInviteScreen extends ConsumerStatefulWidget {
//   const WorkspaceInviteScreen({super.key});

//   @override
//   ConsumerState<WorkspaceInviteScreen> createState() =>
//       _WorkspaceInviteScreenState();
// }

// class _WorkspaceInviteScreenState extends ConsumerState<WorkspaceInviteScreen> {
//   @override
//   void initState() {
//     ref.read(ProviderList.workspaceProvider).getWorkspaceInvitations();
//     super.initState();
//   }

//   List selectedWorkspaces = [];
//   @override
//   Widget build(BuildContext context) {
//     var prov = ref.watch(ProviderList.workspaceProvider);

//     //print('SABI : workspaceProvider : ${prov.workspaceInvitations} ');

//     var themeProvider = ref.watch(ProviderList.themeProvider);
//     return Scaffold(
//       appBar: CustomAppBar(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           text: 'Workspace Invites'),
//       body: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.only(left: 16, right: 16),
//             height: 1,
//             width: MediaQuery.of(context).size.width,
//             color: themeProvider.isDarkThemeEnabled
//                 ? darkThemeBorder
//                 : Colors.grey[300],
//           ),
//           Expanded(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: LoadingWidget(
//                 loading: prov.workspaceInvitationState == StateEnum.loading,
//                 widgetClass: prov.workspaceInvitations.isEmpty
//                     ? Center(
//                         child: SizedBox(
//                           width: MediaQuery.of(context).size.width * 0.6,
//                           child: const CustomText(
//                             'Currently you have no invited workspaces to join.',
//                             type: FontStyle.Medium,
//                             color: greyColor,
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       )
//                     : Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const SizedBox(
//                             height: 20,
//                           ),
//                           Expanded(
//                             child: ListView.builder(
//                               itemCount: prov.workspaceInvitations.length,
//                               shrinkWrap: true,
//                               itemBuilder: (ctx, index) {
//                                 return GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       if (selectedWorkspaces.contains(index)) {
//                                         selectedWorkspaces.removeAt(index);
//                                       } else {
//                                         selectedWorkspaces.add(index);
//                                       }
//                                     });
//                                   },
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(bottom: 10),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       children: [
//                                         Row(
//                                           children: [
//                                             Container(
//                                               height: 40,
//                                               width: 40,
//                                               decoration: BoxDecoration(
//                                                   color: RandomColors()
//                                                       .getRandomColor(),
//                                                   borderRadius:
//                                                       BorderRadius.circular(7)),
//                                               child: prov.workspaceInvitations[
//                                                                   index]
//                                                               ['workspace']
//                                                           ['logo'] ==
//                                                       null
//                                                   ? Center(
//                                                       child: CustomText(
//                                                         prov.workspaceInvitations[
//                                                                 index]
//                                                                 ['workspace']
//                                                                 ['name']
//                                                             .toString()
//                                                             .toUpperCase()
//                                                             .substring(0, 1),
//                                                         type: FontStyle.Small,
//                                                         color: Colors.white,
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                       ),
//                                                     )
//                                                   : ClipRRect(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               7),
//                                                       child: Image.network(
//                                                         prov.workspaceInvitations[
//                                                                 index]
//                                                                 ['workspace']
//                                                                 ['logo']
//                                                             .toString(),
//                                                         fit: BoxFit.cover,
//                                                       ),
//                                                     ),
//                                             ),
//                                             const SizedBox(
//                                               width: 10,
//                                             ),
//                                             Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 CustomText(
//                                                   prov.workspaceInvitations[
//                                                           index]['workspace']
//                                                       ['name'],
//                                                   type: FontStyle.Small,
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                                 const SizedBox(
//                                                   height: 3,
//                                                 ),
//                                                 const CustomText(
//                                                   'Invited',
//                                                   type: FontStyle.Medium,
//                                                   color: greyColor,
//                                                 ),
//                                               ],
//                                             )
//                                           ],
//                                         ),
//                                         selectedWorkspaces.contains(index)
//                                             ? const Icon(
//                                                 Icons.done,
//                                                 size: 24,
//                                                 color: Color.fromRGBO(
//                                                     9, 169, 83, 1),
//                                               )
//                                             : Container()
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                           selectedWorkspaces.isEmpty
//                               ? Container()
//                               : Button(
//                                   ontap: () async {
//                                     var data = [];
//                                     for (var element in selectedWorkspaces) {
//                                       data.add(prov
//                                           .workspaceInvitations[element]['id']);
//                                     }
//                                     log(data.toString());
//                                     await prov.joinWorkspaces(data: data);
//                                     CustomToast.showToast(context,
//                                         'Joined Workspace Successfully');

//                                     for (var element in selectedWorkspaces) {
//                                       prov.workspaceInvitations
//                                           .removeAt(element);
//                                     }
//                                     selectedWorkspaces.clear();
//                                     ref
//                                         .watch(ProviderList.workspaceProvider)
//                                         .getWorkspaces();
//                                     Navigator.of(context).pop();
//                                   },
//                                   text: 'Join',
//                                 ),
//                           const SizedBox(
//                             height: 20,
//                           )
//                         ],
//                       ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
