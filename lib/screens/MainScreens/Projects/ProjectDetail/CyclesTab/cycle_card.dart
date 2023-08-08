// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:plane_startup/provider/provider_list.dart';
// import 'package:plane_startup/utils/constants.dart';

// import '../../utils/custom_text.dart';
// import 'cycle_detail.dart';

// class CycleCard extends ConsumerStatefulWidget {
//   const CycleCard({super.key});

//   @override
//   ConsumerState<CycleCard> createState() => _CycleCardState();
// }

// class _CycleCardState extends ConsumerState<CycleCard> {
//   @override
//   Widget build(BuildContext context) {
//     var themeProvider = ref.watch(ProviderList.themeProvider);
//     return GestureDetector(
//       onTap: () {
//         //Navigator.of(context)
//         //    .push(MaterialPageRoute(builder: (ctx) => const CycleDetail()));
//       },
//       child: Container(
//         margin: const EdgeInsets.only(top: 15),
//         decoration: BoxDecoration(
//             color: themeProvider.isDarkThemeEnabled
//                 ? darkBackgroundColor
//                 : lightBackgroundColor,
//             border: Border.all(
//               color: Colors.grey.shade300,
//             ),
//             borderRadius: BorderRadius.circular(10)),
//         child: Wrap(
//           crossAxisAlignment: WrapCrossAlignment.start,
//           children: [
//             Container(
//               padding: const EdgeInsets.only(
//                   left: 15, right: 15, top: 15, bottom: 15),
//               child: CustomText(
//                 'Cycle Name',
//                 type: FontStyle.Small,
//                 // color: themeProvider.primaryTextColor,
//               ),
//             ),
//             const SizedBox(
//               height: 15,
//             ),
//             Container(
//               padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
//               child: Row(
//                 children: [
//                   Icon(
//                     Icons.calendar_month,
//                     // color: themeProvider.secondaryTextColor,
//                     size: 18,
//                   ),
//                   CustomText(
//                     ' Jan 16, 2022',
//                     // color: themeProvider.secondaryTextColor,
//                     type: FontStyle.Medium,
//                   ),
//                   const SizedBox(
//                     width: 40,
//                   ),
//                   Icon(
//                     Icons.calendar_month,
//                     // color: themeProvider.secondaryTextColor,
//                     size: 18,
//                   ),
//                   CustomText(
//                     ' Jan 16, 2022',
//                     // color: themeProvider.secondaryTextColor,
//                     type: FontStyle.Medium,
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.only(
//                   left: 15, right: 15, top: 5, bottom: 15),
//               child: Row(
//                 children: [
//                   Container(
//                     height: 20,
//                     width: 20,
//                     decoration: BoxDecoration(
//                         color: Colors.amber,
//                         borderRadius: BorderRadius.circular(15)),
//                   ),
//                   const SizedBox(
//                     width: 10,
//                   ),
//                   CustomText(
//                     'Vamsi Kurama',
//                     // color: themeProvider.secondaryTextColor,
//                     type: FontStyle.Medium,
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               height: 1,
//               color: Colors.grey.shade300,
//             ),
//             Container(
//               alignment: Alignment.centerLeft,
//               padding: const EdgeInsets.only(left: 15),
//               width: MediaQuery.of(context).size.width,
//               height: 40,
//               decoration: BoxDecoration(
//                 color: themeProvider.isDarkThemeEnabled
//                     ? darkSecondaryBackgroundColor
//                     : lightSecondaryBackgroundColor,
//                 borderRadius: const BorderRadius.only(
//                     bottomLeft: Radius.circular(10),
//                     bottomRight: Radius.circular(10)),
//               ),
//               child: CustomText(
//                 'Progress -10%',
//                 type: FontStyle.Small,
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
