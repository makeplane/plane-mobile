import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/screens/integrations.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/widgets/custom_app_bar.dart';
import 'package:plane_startup/widgets/custom_text.dart';


class BillingPlans extends ConsumerStatefulWidget {
  const BillingPlans({super.key});

  @override
  ConsumerState<BillingPlans> createState() => _BillingPlansState();
}

class _BillingPlansState extends ConsumerState<BillingPlans> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Scaffold(
      // backgroundColor: themeProvider.isDarkThemeEnabled
      //     ? darkSecondaryBackgroundColor
      //     : lightSecondaryBackgroundColor,
      // appBar: AppBar(
      //   title: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       CustomText(
      //         'Billings & Plans',
      //         type: FontStyle.appbarTitle,
      //       ),
      //       Container(
      //         child: Row(
      //           children: [
      //             const Icon(
      //               Icons.add,
      //               color: Color.fromRGBO(63, 118, 255, 1),
      //             ),
      //             CustomText('Add',
      //                 type: FontStyle.title,
      //                 color: const Color.fromRGBO(63, 118, 255, 1)),
      //           ],
      //         ),
      //       )
      //     ],
      //   ),
      //   centerTitle: true,
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      //   leading: IconButton(
      //       onPressed: () => Navigator.of(context).pop(),
      //       icon: const Icon(
      //         Icons.close,
      //         color: Colors.blacklack,
      //       )),
      // ),
      appBar: CustomAppBar(
        onPressed: () {
          Navigator.of(context).pop();
        },
        text: 'Billings & Plans',
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.add,
                  color: Color.fromRGBO(63, 118, 255, 1),
                ),
                CustomText('Add',
                    type: FontStyle.title,
                    color: Color.fromRGBO(63, 118, 255, 1)),
              ],
            ),
          )
        ],
      ),

      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            height: 1,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[300],
          ),
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
            padding: const EdgeInsets.only(
              left: 16,
            ),
            height: 45,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                gradient: const LinearGradient(colors: [
                  Color.fromRGBO(69, 69, 69, 1),
                  Color.fromRGBO(143, 143, 147, 1),
                ])),
            child: Row(
              children: [
                SvgPicture.asset("assets/svg_images/stars.svg"),
                const SizedBox(
                  width: 15,
                ),
                const CustomText(
                  'Free launch Pro Plan',
                  type: FontStyle.buttonText,
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
            padding: const EdgeInsets.only(left: 16, top: 16),
            height: 100,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: themeProvider.isDarkThemeEnabled
                  ? darkSecondaryBGC
                  : lightSecondaryBackgroundColor,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  'Payment Due',
                  type: FontStyle.title,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomText(
                  '__',
                  type: FontStyle.title,
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child: const CustomText(
              'Current Plan',
              textAlign: TextAlign.left,
              type: FontStyle.heading,
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: themeProvider.isDarkThemeEnabled
                    ? darkSecondaryBGC
                    : lightSecondaryBackgroundColor,
                border: Border.all(color: Colors.grey.shade300)),
            child: Column(
              children: [
                const CustomText(
                  'You are currently using free plan. ',
                  textAlign: TextAlign.center,
                  type: FontStyle.title,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Integrations()));
                  },
                  child: Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      margin:
                          const EdgeInsets.only(top: 20, left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(63, 118, 255, 1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Center(
                          child: CustomText(
                        'View plans & Upgrade',
                        color: Colors.white,
                        type: FontStyle.buttonText,
                      ))),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 16, right: 16, top: 25),
            child: const CustomText(
              'Billing History',
              textAlign: TextAlign.left,
              type: FontStyle.heading,
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 40, bottom: 40),
            margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
            decoration: BoxDecoration(
                color: themeProvider.isDarkThemeEnabled
                    ? darkSecondaryBGC
                    : lightSecondaryBackgroundColor,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey.shade300)),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long,
                  size: 50,
                  color: Color.fromRGBO(133, 142, 150, 1),
                ),
                SizedBox(
                  height: 30,
                ),
                CustomText(
                  'There are no invoices to display',
                  textAlign: TextAlign.center,
                  type: FontStyle.title,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
