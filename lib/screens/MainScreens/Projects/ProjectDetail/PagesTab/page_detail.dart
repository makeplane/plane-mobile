import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/bottom_sheets/block_sheet.dart';
import 'package:plane_startup/bottom_sheets/label_sheet.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/widgets/custom_app_bar.dart';

import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/widgets/custom_text.dart';

class PageDetail extends ConsumerStatefulWidget {
  const PageDetail({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PageDetailState();
}

class _PageDetailState extends ConsumerState<PageDetail> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Scaffold(
      appBar: CustomAppBar(
        onPressed: () {
          Navigator.pop(context);
        },
        text: 'Page Detail',
      ),
      body: Column(
        children: [
          //contaier containing a text ands four small icons
          Container(
            color: themeProvider.isDarkThemeEnabled
                ? darkSecondaryBGC
                : lightSecondaryBackgroundColor,
            //margin: const EdgeInsets.only(top: 15),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                //container containing a add icon and a text
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        enableDrag: true,
                        constraints: BoxConstraints(
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.8),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        )),
                        context: context,
                        builder: (ctx) {
                          return const LabelSheet();
                        });
                  },
                  child: Container(
                    color: themeProvider.isDarkThemeEnabled
                        ? darkBackgroundColor
                        : lightBackgroundColor,
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        //add icon
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.add,
                            color: themeProvider.isDarkThemeEnabled
                                ? darkPrimaryTextColor
                                : lightPrimaryTextColor,
                            size: 22,
                          ),
                        ),
                        //text
                        // const Text(
                        //   'Add a card',
                        //   style: TextStyle(
                        //     color: greyColor,
                        //     fontSize: 16,
                        //   ),
                        // ),
                        const CustomText(
                          'Add Labels',
                          type: FontStyle.text,
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                //four small icons
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: const Icon(
                    Icons.link,
                    color: greyColor,
                    size: 22,
                  ),
                ),
                //icon 2
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    onPressed: () {
                      //on pressing a wide dropdown opens up containing colors to choose from
                    },
                    icon: const Icon(
                      Icons.color_lens,
                      color: greyColor,
                      size: 22,
                    ),
                  ),
                ),
                //icon 3
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: const Icon(
                    Icons.lock_open_outlined,
                    color: greyColor,
                    size: 22,
                  ),
                ),
                //icon 4
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: const Icon(
                    Icons.star_border,
                    color: greyColor,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          //two containers with rounded corners having text as labels
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                //container 1
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: themeProvider.isDarkThemeEnabled
                        ? darkSecondaryBGC
                        : Colors.grey[350],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const CustomText(
                    'Label 1',
                    type: FontStyle.text,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                //container 2
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: themeProvider.isDarkThemeEnabled
                        ? darkSecondaryBGC
                        : Colors.grey[350],
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const CustomText(
                    'Label 2',
                    type: FontStyle.text,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            alignment: Alignment.centerLeft,
            child: const CustomText(
              'Page Title',
              type: FontStyle.heading,
              textAlign: TextAlign.start,
            ),
          ),
          const SizedBox(
            height: 10,
          ),

          //container containing a add icon and a text
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  enableDrag: true,
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.65),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
                  context: context,
                  builder: (ctx) {
                    return const BlockSheet();
                  });
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: const Row(
                children: [
                  //add icon
                  Icon(
                    Icons.add,
                    color: primaryColor,
                    size: 22,
                  ),

                  //text
                  CustomText(
                    'Add new block',
                    type: FontStyle.text,
                    color: primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
